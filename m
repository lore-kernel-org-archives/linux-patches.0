Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816CE39CD16;
	Fri,  7 Aug 2026 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114126; cv=none; b=ooO1wI5b3RhEb1PJDt46QZ+OLVjEhhQHisSo8dEjPUKOFmDKTDVrAXnd5K7cjyrSQR/ZI0GooRZ8tSmHr82nmPyAsGB6mme18OePN1crsW/18yjGIa0NLS5MYodcIbD7YupR7nF7U55fjmkJgD7ljBYpaumhStzoajSgd6euXk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114126; c=relaxed/simple;
	bh=LBiMfh95oCPAJGrnsrIncfczwdyRHTRiILUEgqra9fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuVvpFDtAkn3GKbCG/mZx8UJp6ldMSy/4KjpWPS+ocXP/90wGRI1y1glUseVqVcM8KyZa2GGV4wJlcDOI0E0YEysY4dfR1qmL5+Vm+exo4pBpgjsvCSyq1Rpay7O0NcYUKN7LTe9ROoqrxNGdLu8xqiS9WalDCFHd7P7eFoAIQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQCNqiJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQCNqiJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E181F000E9;
	Fri,  7 Aug 2026 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114122;
	bh=NBZGAwWaWN6WROklyHT53vqsR4qaeyaUJZ3pfLB27ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQCNqiJ1Y8E4AH3uD1LJr+AzPpyXe0dL1mGQAUkfIHuKVtpWvdipvHZFzPO12P3jc
	 csn24cQ3XeEgQUDbTK65GZ+R6FFAFYGq7hxq5IleKX0HvTjEsp/5pMTl69jjP/Muid
	 OsaZSiRMoSQ8IueM7KM3RadB5P0+6epiET9QkB1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis V. Lunev" <den@openvz.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/337] qede: sync udp_tunnel ports outside qede_lock in the recovery path
Date: Fri,  7 Aug 2026 16:35:28 +0200
Message-ID: <20260807143421.242130171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis V. Lunev <den@openvz.org>

[ Upstream commit 451c9075d6c53f2438d110addbeeeea6fac18567 ]

A TX timeout on a qede NIC that has VXLAN/GENEVE tunnel ports
configured wedges the rtnetlink control plane of the whole machine:

  NETDEV WATCHDOG: ens6f1 (qede): transmit queue 2 timed out 10226 ms
  [qede_tx_timeout:586(ens6f1)]TX timeout on queue 2!
  [qede_recovery_handler:2665(ens6f0)]Starting a recovery process

The recovery path deadlocks on the driver's own mutex:

  qede_sp_task
   rtnl_lock()
   mutex_lock(&edev->qede_lock)        <- taken
   qede_recovery_handler
    qede_load
    udp_tunnel_nic_reset_ntf
     __udp_tunnel_nic_device_sync
      info->sync_table == qede_udp_tunnel_sync
       mutex_lock(&edev->qede_lock)    <- same task: deadlock

The mutex is not recursive, so the kworker blocks on itself with
rtnl_lock held, and neither lock is ever released. Every task that
calls rtnl_lock() afterwards (ip, ovs-vswitchd, lldpad, IPv6
addrconf, sshd) blocks forever while the node still answers ping.
In a vmcore from an affected production node rtnl_mutex.owner
decodes to the very kworker blocked at the innermost mutex_lock()
above.

Re-sync the tunnel ports from qede_sp_task() after the internal lock
is dropped, still under rtnl_lock as the udp_tunnel API requires.
This mirrors qede_open(), which calls udp_tunnel_nic_reset_ntf()
under rtnl without the internal lock.

qede_recovery_handler() now returns whether it has successfully
reloaded an open device, and the caller re-syncs the ports only in
that case. This keeps the old gating exactly: a device that was down
or a failed recovery returns false, as those paths never reached the
udp_tunnel_nic_reset_ntf() call before either.

This was the only user of the qede_lock()/qede_unlock() helpers, so
remove them.

Fixes: 8cd160a29415 ("qede: convert to new udp_tunnel_nic infra")
Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Andrew Lunn <andrew+netdev@lunn.ch>
CC: "David S. Miller" <davem@davemloft.net>
CC: Eric Dumazet <edumazet@google.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260726104311.1782900-1-den@openvz.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 44 ++++++++++----------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index b5d744d2586f7..59a80f7193723 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -107,7 +107,7 @@ static void qede_remove(struct pci_dev *pdev);
 static void qede_shutdown(struct pci_dev *pdev);
 static void qede_link_update(void *dev, struct qed_link_output *link);
 static void qede_schedule_recovery_handler(void *dev);
-static void qede_recovery_handler(struct qede_dev *edev);
+static bool qede_recovery_handler(struct qede_dev *edev);
 static void qede_schedule_hw_err_handler(void *dev,
 					 enum qed_hw_err_type err_type);
 static void qede_get_eth_tlv_data(void *edev, void *data);
@@ -1065,21 +1065,6 @@ void __qede_unlock(struct qede_dev *edev)
 	mutex_unlock(&edev->qede_lock);
 }
 
-/* This version of the lock should be used when acquiring the RTNL lock is also
- * needed in addition to the internal qede lock.
- */
-static void qede_lock(struct qede_dev *edev)
-{
-	rtnl_lock();
-	__qede_lock(edev);
-}
-
-static void qede_unlock(struct qede_dev *edev)
-{
-	__qede_unlock(edev);
-	rtnl_unlock();
-}
-
 static void qede_periodic_task(struct work_struct *work)
 {
 	struct qede_dev *edev = container_of(work, struct qede_dev,
@@ -1116,6 +1101,8 @@ static void qede_sp_task(struct work_struct *work)
 	 */
 
 	if (test_and_clear_bit(QEDE_SP_RECOVERY, &edev->sp_flags)) {
+		bool reloaded;
+
 		cancel_delayed_work_sync(&edev->periodic_task);
 #ifdef CONFIG_QED_SRIOV
 		/* SRIOV must be disabled outside the lock to avoid a deadlock.
@@ -1124,9 +1111,17 @@ static void qede_sp_task(struct work_struct *work)
 		if (pci_num_vf(edev->pdev))
 			qede_sriov_configure(edev->pdev, 0);
 #endif
-		qede_lock(edev);
-		qede_recovery_handler(edev);
-		qede_unlock(edev);
+		rtnl_lock();
+		__qede_lock(edev);
+		reloaded = qede_recovery_handler(edev);
+		__qede_unlock(edev);
+
+		/* The udp_tunnel core synchronously calls back into
+		 * qede_udp_tunnel_sync(), which takes the qede lock.
+		 */
+		if (reloaded)
+			udp_tunnel_nic_reset_ntf(edev->ndev);
+		rtnl_unlock();
 	}
 
 	__qede_lock(edev);
@@ -2667,9 +2662,13 @@ static void qede_recovery_failed(struct qede_dev *edev)
 		edev->ops->common->set_power_state(edev->cdev, PCI_D3hot);
 }
 
-static void qede_recovery_handler(struct qede_dev *edev)
+/* Returns true if an open device was successfully reloaded and its
+ * udp_tunnel ports need to be re-synced by the caller.
+ */
+static bool qede_recovery_handler(struct qede_dev *edev)
 {
 	u32 curr_state = edev->state;
+	bool reloaded = false;
 	int rc;
 
 	DP_NOTICE(edev, "Starting a recovery process\n");
@@ -2699,17 +2698,18 @@ static void qede_recovery_handler(struct qede_dev *edev)
 			goto err;
 
 		qede_config_rx_mode(edev->ndev);
-		udp_tunnel_nic_reset_ntf(edev->ndev);
+		reloaded = true;
 	}
 
 	edev->state = curr_state;
 
 	DP_NOTICE(edev, "Recovery handling is done\n");
 
-	return;
+	return reloaded;
 
 err:
 	qede_recovery_failed(edev);
+	return false;
 }
 
 static void qede_atomic_hw_err_handler(struct qede_dev *edev)
-- 
2.53.0



