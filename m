Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60BA248F49;
	Mon, 12 May 2025 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072762; cv=none; b=NBuem3HD9SYKtc+ze1mLkoX+uP/F0Qy4R7tasA1aNajz8ECtwUWG80QW3Z/sl6GarQGpbFLSTsJk1e3ccljL88L8rmWHZ7OzhHGfhX6rfUbs27xRCbr/J17kzj5hYFaP+IdkV7frY+qET56NBXs5y+BFLrilTDnn2BGhN3W90uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072762; c=relaxed/simple;
	bh=VrtHjBvs/Qbwe5Axyo+78Y03H2/y3ZuVKc4ptGOnzL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xhzh8K5Wl0UogC2A84DyXaiesnoGWA0FG8Yt1Us8y2OkPI+wJmPX7GG/J5Yjd9fLiCAVCagnXYsu90LAo7WfbYUxNm6EVi4EWH4DxJXGHJiKPJGtTr+Qp2l8C3X6m1LDLko0ohFDBl9qCgNf0Mpqk1f6iJVjSbDRyI42Je/o13Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4hKn+g7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4hKn+g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D885C4CEEF;
	Mon, 12 May 2025 17:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072761;
	bh=VrtHjBvs/Qbwe5Axyo+78Y03H2/y3ZuVKc4ptGOnzL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4hKn+g7beZBZZCif65sqlBqI+HZEdaEYBhxM7oOCxNcW28KxXCfcbLgvyeMGz2q/
	 AxD1IR6qNKALWF8sNZoy2lrwNq/AEBpB6MJLv4qPGF10/41doSgbTuZ71f9or4OYOg
	 36Xh4rthyJsUbz0yjQqiCh3jHa1VH7GG3X9eVDjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/184] fbnic: Actually flush_tx instead of stalling out
Date: Mon, 12 May 2025 19:44:09 +0200
Message-ID: <20250512172043.693346007@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit 0f9a959a0addd9bbc47e5d16c36b3a7f97981915 ]

The fbnic_mbx_flush_tx function had a number of issues.

First, we were waiting 200ms for the firmware to process the packets. We
can drop this to 20ms and in almost all cases this should be more than
enough time. So by changing this we can significantly reduce shutdown time.

Second, we were not making sure that the Tx path was actually shut off. As
such we could still have packets added while we were flushing the mailbox.
To prevent that we can now clear the ready flag for the Tx side and it
should stay down since the interrupt is disabled.

Third, we kept re-reading the tail due to the second issue. The tail should
not move after we have started the flush so we can just read it once while
we are holding the mailbox Tx lock. By doing that we are guaranteed that
the value should be consistent.

Fourth, we were keeping a count of descriptors cleaned due to the second
and third issues called out. That count is not a valid reason to be exiting
the cleanup, and with the tail only being read once we shouldn't see any
cases where the tail moves after the disable so the tracking of count can
be dropped.

Fifth, we were using attempts * sleep time to determine how long we would
wait in our polling loop to flush out the Tx. This can be very imprecise.
In order to tighten up the timing we are shifting over to using a jiffies
value of jiffies + 10 * HZ + 1 to determine the jiffies value we should
stop polling at as this should be accurate within once sleep cycle for the
total amount of time spent polling.

Fixes: da3cde08209e ("eth: fbnic: Add FW communication mechanism")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/174654719929.499179.16406653096197423749.stgit@ahduyck-xeon-server.home.arpa
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 31 +++++++++++-----------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 7db68fe7df940..dd30f0cb02506 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -797,35 +797,36 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 
 void fbnic_mbx_flush_tx(struct fbnic_dev *fbd)
 {
+	unsigned long timeout = jiffies + 10 * HZ + 1;
 	struct fbnic_fw_mbx *tx_mbx;
-	int attempts = 50;
-	u8 count = 0;
-
-	/* Nothing to do if there is no mailbox */
-	if (!fbnic_fw_present(fbd))
-		return;
+	u8 tail;
 
 	/* Record current Rx stats */
 	tx_mbx = &fbd->mbx[FBNIC_IPC_MBX_TX_IDX];
 
-	/* Nothing to do if mailbox never got to ready */
-	if (!tx_mbx->ready)
-		return;
+	spin_lock_irq(&fbd->fw_tx_lock);
+
+	/* Clear ready to prevent any further attempts to transmit */
+	tx_mbx->ready = false;
+
+	/* Read tail to determine the last tail state for the ring */
+	tail = tx_mbx->tail;
+
+	spin_unlock_irq(&fbd->fw_tx_lock);
 
 	/* Give firmware time to process packet,
-	 * we will wait up to 10 seconds which is 50 waits of 200ms.
+	 * we will wait up to 10 seconds which is 500 waits of 20ms.
 	 */
 	do {
 		u8 head = tx_mbx->head;
 
-		if (head == tx_mbx->tail)
+		/* Tx ring is empty once head == tail */
+		if (head == tail)
 			break;
 
-		msleep(200);
+		msleep(20);
 		fbnic_mbx_process_tx_msgs(fbd);
-
-		count += (tx_mbx->head - head) % FBNIC_IPC_MBX_DESC_LEN;
-	} while (count < FBNIC_IPC_MBX_DESC_LEN && --attempts);
+	} while (time_is_after_jiffies(timeout));
 }
 
 void fbnic_get_fw_ver_commit_str(struct fbnic_dev *fbd, char *fw_version,
-- 
2.39.5



