Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661984FECCF;
	Wed, 30 Sep 2026 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787076; cv=none; b=R/6hnpPid+2bwhIg1NdY+KoNTqwesK1I5hE9cqQaGPh+P0r1hKgqFQCMixnk3z7ijF595iYx6TeTkEChUOI2J5DBTV6JCRe+s3O/QD8jdMpOX6aFVgR4EjMwqv+K8RndeypjafQ2MvGCIv1p61Aa0d37J0dDhHfUj4qwDi5yszI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787076; c=relaxed/simple;
	bh=4lqxnAtgONYmS/uwE9gvNkUICOi5Uy5li9qDivIfRq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/D/bCbDZ36UlGJr+Ta8/h9SY5t+3cvxwpkbqnrbkbpKVa5TbFfwm4FIAW2myuL2J1ZVlLU1nDsNlAiNcdtwYo3ly5Utjbhl4CCSvBmdH26mLCvENL05Y9hz6cpLewe2mItUV+UEvNsI7G9nwnV6uVMCYOhQtbrfqW4hZ8ZiaTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXvwDCVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXvwDCVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B368E1F000FF;
	Wed, 30 Sep 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787075;
	bh=umgvyADFW3uaH1nhk2UC6nHhOCuZQUe4/kW/MCS8p4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXvwDCVOAt/0s4P2m2lFaN7bv0AhORvnYtEY+jIaFoshGfDf/i7E+S/T7ZmnmfDYs
	 PtNfQpcWmx9JiwQRru52PCjEU2BG3Utf08BDsv/wi4oI/6gEiVu3g7hF3UuNV6o/bo
	 7QYjnu14QQh6pv3WpGo2039aEIvW/0rO/yhYq9cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 101/457] eth: fbnic: Handle FW mailbox completions flagged with an error
Date: Wed, 30 Sep 2026 17:23:26 +0200
Message-ID: <20260930152348.231123331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit 1b97a269a5bdde20d4e69511f27649c9cb82b7c7 ]

The firmware can complete a mailbox descriptor while also setting FW_ERR
to indicate it could not process the request, for example on a mailbox
DMA error. The completion carries no valid data.

The driver did not check FW_ERR. On the Rx mailbox it would sync and
parse the stale page as a normal message, and on the Tx mailbox it
silently freed the request. If the initial capabilities exchange in
fbnic_mbx_poll_tx_ready() hit FW_ERR -- on the Tx request or on the Rx
response descriptor -- no response was parsed and the poll spun until it
timed out even though the ring was healthy.

Check FW_ERR on both mailboxes. Count it per-mailbox in
fbnic_fw_mbx.resp_error, which is also shown in debugfs, warn (rate
limited, since the bit is firmware controlled), and drop the Rx page
instead of parsing it.

In fbnic_mbx_poll_tx_ready() re-issue the capabilities request when
either the Tx or the Rx resp_error counter advances, so a FW_ERR on the
request or on its response triggers a retry rather than a timeout. A
valid capabilities response is honored before the retry check, so a
response parsed in the same poll as an unrelated FW_ERR is not discarded.
The counters are mailbox-wide rather than keyed to the capabilities
request; that is sufficient here because the exchange runs during
bring-up before any other mailbox traffic, and any spurious retry is
bounded by the existing 10s timeout.

Fixes: da3cde08209e ("eth: fbnic: Add FW communication mechanism")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/178942023343.7700.9423398932961964439.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h   |  4 ++
 .../net/ethernet/meta/fbnic/fbnic_debugfs.c   |  4 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c    | 38 ++++++++++++++++++-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.h    |  1 +
 4 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
index 14af30e189d6c..baba3471bf5a4 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
@@ -1216,6 +1216,10 @@ enum {
 #define FBNIC_IPC_MBX_DESC_LEN_MASK	DESC_GENMASK(63, 48)
 #define FBNIC_IPC_MBX_DESC_EOM		DESC_BIT(46)
 #define FBNIC_IPC_MBX_DESC_ADDR_MASK	DESC_GENMASK(45, 3)
+/* Set with FW_CMPL when the FW completed a descriptor without successfully
+ * processing it (e.g. a mailbox DMA error); the completion has no valid data.
+ */
+#define FBNIC_IPC_MBX_DESC_FW_ERR	DESC_BIT(2)
 #define FBNIC_IPC_MBX_DESC_FW_CMPL	DESC_BIT(1)
 #define FBNIC_IPC_MBX_DESC_HOST_CMPL	DESC_BIT(0)
 
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_debugfs.c b/drivers/net/ethernet/meta/fbnic/fbnic_debugfs.c
index 3c4563c8f403f..6edfa0aa69f11 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_debugfs.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_debugfs.c
@@ -539,8 +539,8 @@ static void fbnic_dbg_fw_mbx_display(struct seq_file *s,
 	/* Generate header */
 	seq_puts(s, mbx_idx == FBNIC_IPC_MBX_RX_IDX ? "Rx\n" : "Tx\n");
 
-	seq_printf(s, "Rdy: %d Head: %d Tail: %d\n",
-		   mbx->ready, mbx->head, mbx->tail);
+	seq_printf(s, "Rdy: %d Head: %d Tail: %d resp_error: %llu\n",
+		   mbx->ready, mbx->head, mbx->tail, mbx->resp_error);
 
 	snprintf(hdr, sizeof(hdr), "%3s %-4s %s %-12s %s %-3s %-16s\n",
 		 "Idx", "Len", "E", "Addr", "F", "H", "Raw");
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 59aa879798b9f..6d7eb8479edf4 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -292,6 +292,12 @@ static void fbnic_mbx_process_tx_msgs(struct fbnic_dev *fbd)
 		if (!(desc & FBNIC_IPC_MBX_DESC_FW_CMPL))
 			break;
 
+		if (desc & FBNIC_IPC_MBX_DESC_FW_ERR) {
+			tx_mbx->resp_error++;
+			dev_warn_ratelimited(fbd->dev,
+					     "FW completed a Tx mailbox request with an error\n");
+		}
+
 		fbnic_mbx_unmap_and_free_msg(fbd, FBNIC_IPC_MBX_TX_IDX, head);
 
 		head++;
@@ -1673,6 +1679,13 @@ static void fbnic_mbx_process_rx_msgs(struct fbnic_dev *fbd)
 		if (!(desc & FBNIC_IPC_MBX_DESC_FW_CMPL))
 			break;
 
+		if (desc & FBNIC_IPC_MBX_DESC_FW_ERR) {
+			rx_mbx->resp_error++;
+			dev_warn_ratelimited(fbd->dev,
+					     "FW reported an error on an Rx mailbox message; dropping\n");
+			goto next_page;
+		}
+
 		dma_sync_single_for_cpu(fbd->dev, rx_mbx->buf_info[head].addr,
 					FBNIC_RX_PAGE_SIZE, DMA_FROM_DEVICE);
 
@@ -1740,7 +1753,9 @@ void fbnic_mbx_poll(struct fbnic_dev *fbd)
 int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 {
 	struct fbnic_fw_mbx *tx_mbx = &fbd->mbx[FBNIC_IPC_MBX_TX_IDX];
+	struct fbnic_fw_mbx *rx_mbx = &fbd->mbx[FBNIC_IPC_MBX_RX_IDX];
 	unsigned long timeout = jiffies + 10 * HZ + 1;
+	u64 tx_resp_error, rx_resp_error;
 	int err, i;
 
 	do {
@@ -1771,6 +1786,9 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 	 * mgmt.version once we get the actual version from the firmware
 	 * in the capabilities request message.
 	 */
+send_cap_req:
+	tx_resp_error = tx_mbx->resp_error;
+	rx_resp_error = rx_mbx->resp_error;
 	err = fbnic_fw_xmit_simple_msg(fbd, FBNIC_TLV_MSG_ID_HOST_CAP_REQ);
 	if (err)
 		goto clean_mbx;
@@ -1788,9 +1806,27 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 		msleep(20);
 		fbnic_mbx_poll(fbd);
 
+		/* A valid capabilities response ends the poll. Check it
+		 * before the FW_ERR retry below so a response parsed in the
+		 * same poll as an unrelated FW_ERR is not discarded.
+		 */
+		if (fbd->fw_cap.running.mgmt.version >= MIN_FW_VER_CODE)
+			break;
+
 		/* set err, but wait till mgmt.version check to report it */
-		if (!time_is_after_jiffies(timeout))
+		if (!time_is_after_jiffies(timeout)) {
 			err = -ETIMEDOUT;
+			continue;
+		}
+
+		/* The FW can flag our capabilities request (Tx) or its
+		 * response (Rx) with FW_ERR, in which case it produced no
+		 * usable response. The ring is not wedged, so re-issue the
+		 * request instead of spinning until the timeout.
+		 */
+		if (tx_mbx->resp_error != tx_resp_error ||
+		    rx_mbx->resp_error != rx_resp_error)
+			goto send_cap_req;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.h b/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
index d84723e4cfa36..5f9969247e305 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
@@ -13,6 +13,7 @@ struct fbnic_tlv_msg;
 
 struct fbnic_fw_mbx {
 	u8 ready, head, tail;
+	u64 resp_error;
 	struct {
 		struct fbnic_tlv_msg	*msg;
 		dma_addr_t		addr;
-- 
2.53.0



