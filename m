Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173B79446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F85EC433C8;
	Sun, 13 Aug 2023 21:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962702;
	bh=PTKV+75czZjcKa0EFHYTVr68rry7wU5VoEW8Hhzs0Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOqQso04MK6Lo1qE2yuw5byFwPNdF3kHXE5sCA+ZThCv47Bk4eGNWUmDrI4VQgPOa
	 PcGSfotJxV8zPwqlmll4yoIbk6GWTlqxTL9LpIZq+8DCad2PpiFegDxK49BfKBoKZs
	 StNo3CZ4gjhrLH8/nO46dYQqz+89xH58CNRfb4To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 124/149] ibmvnic: Ensure login failure recovery is safe from other resets
Date: Sun, 13 Aug 2023 23:19:29 +0200
Message-ID: <20230813211722.439795777@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nick Child <nnac123@linux.ibm.com>

commit 6db541ae279bd4e76dbd939e5fbf298396166242 upstream.

If a login request fails, the recovery process should be protected
against parallel resets. It is a known issue that freeing and
registering CRQ's in quick succession can result in a failover CRQ from
the VIOS. Processing a failover during login recovery is dangerous for
two reasons:
 1. This will result in two parallel initialization processes, this can
 cause serious issues during login.
 2. It is possible that the failover CRQ is received but never executed.
 We get notified of a pending failover through a transport event CRQ.
 The reset is not performed until a INIT CRQ request is received.
 Previously, if CRQ init fails during login recovery, then the ibmvnic
 irq is freed and the login process returned error. If failover_pending
 is true (a transport event was received), then the ibmvnic device
 would never be able to process the reset since it cannot receive the
 CRQ_INIT request due to the irq being freed. This leaved the device
 in a inoperable state.

Therefore, the login failure recovery process must be hardened against
these possible issues. Possible failovers (due to quick CRQ free and
init) must be avoided and any issues during re-initialization should be
dealt with instead of being propagated up the stack. This logic is
similar to that of ibmvnic_probe().

Fixes: dff515a3e71d ("ibmvnic: Harden device login requests")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230809221038.51296-5-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |   70 +++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 22 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -115,6 +115,7 @@ static void ibmvnic_tx_scrq_clean_buffer
 static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 				struct ibmvnic_long_term_buff *ltb);
 static void ibmvnic_disable_irqs(struct ibmvnic_adapter *adapter);
+static void flush_reset_queue(struct ibmvnic_adapter *adapter);
 
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -1316,8 +1317,8 @@ static const char *adapter_state_to_stri
 
 static int ibmvnic_login(struct net_device *netdev)
 {
+	unsigned long flags, timeout = msecs_to_jiffies(20000);
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	unsigned long timeout = msecs_to_jiffies(20000);
 	int retry_count = 0;
 	int retries = 10;
 	bool retry;
@@ -1382,6 +1383,7 @@ static int ibmvnic_login(struct net_devi
 					    "SCRQ irq initialization failed\n");
 				return rc;
 			}
+		/* Default/timeout error handling, reset and start fresh */
 		} else if (adapter->init_done_rc) {
 			netdev_warn(netdev, "Adapter login failed, init_done_rc = %d\n",
 				    adapter->init_done_rc);
@@ -1397,29 +1399,53 @@ partial_reset:
 				    "Freeing and re-registering CRQs before attempting to login again\n");
 			retry = true;
 			adapter->init_done_rc = 0;
-			retry_count++;
 			release_sub_crqs(adapter, true);
-			reinit_init_done(adapter);
-			release_crq_queue(adapter);
-			/* If we don't sleep here then we risk an unnecessary
-			 * failover event from the VIOS. This is a known VIOS
-			 * issue caused by a vnic device freeing and registering
-			 * a CRQ too quickly.
+			/* Much of this is similar logic as ibmvnic_probe(),
+			 * we are essentially re-initializing communication
+			 * with the server. We really should not run any
+			 * resets/failovers here because this is already a form
+			 * of reset and we do not want parallel resets occurring
 			 */
-			msleep(1500);
-			rc = init_crq_queue(adapter);
-			if (rc) {
-				netdev_err(netdev, "login recovery: init CRQ failed %d\n",
-					   rc);
-				return -EIO;
-			}
-
-			rc = ibmvnic_reset_init(adapter, false);
-			if (rc) {
-				netdev_err(netdev, "login recovery: Reset init failed %d\n",
-					   rc);
-				return -EIO;
-			}
+			do {
+				reinit_init_done(adapter);
+				/* Clear any failovers we got in the previous
+				 * pass since we are re-initializing the CRQ
+				 */
+				adapter->failover_pending = false;
+				release_crq_queue(adapter);
+				/* If we don't sleep here then we risk an
+				 * unnecessary failover event from the VIOS.
+				 * This is a known VIOS issue caused by a vnic
+				 * device freeing and registering a CRQ too
+				 * quickly.
+				 */
+				msleep(1500);
+				/* Avoid any resets, since we are currently
+				 * resetting.
+				 */
+				spin_lock_irqsave(&adapter->rwi_lock, flags);
+				flush_reset_queue(adapter);
+				spin_unlock_irqrestore(&adapter->rwi_lock,
+						       flags);
+
+				rc = init_crq_queue(adapter);
+				if (rc) {
+					netdev_err(netdev, "login recovery: init CRQ failed %d\n",
+						   rc);
+					return -EIO;
+				}
+
+				rc = ibmvnic_reset_init(adapter, false);
+				if (rc)
+					netdev_err(netdev, "login recovery: Reset init failed %d\n",
+						   rc);
+				/* IBMVNIC_CRQ_INIT will return EAGAIN if it
+				 * fails, since ibmvnic_reset_init will free
+				 * irq's in failure, we won't be able to receive
+				 * new CRQs so we need to keep trying. probe()
+				 * handles this similarly.
+				 */
+			} while (rc == -EAGAIN && retry_count++ < retries);
 		}
 	} while (retry);
 


