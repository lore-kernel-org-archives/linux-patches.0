Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F5714ABE;
	Thu, 28 May 2026 20:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001052; cv=none; b=AiqFbLfWAofGuED6LuyUd6Qm8xb/sh8/xgZeJ/tzargVjlMHioyJur2SFsYqzS82fXHOqq/mOosejVmxC4/2V2Vt8ipH1KuW/eyePQcraT0CYI5vbF5IpYwh9L5FmYhOSHZrDPPZGRJk0szvty/ZicChbI8gD5dq4n2WcbqOUlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001052; c=relaxed/simple;
	bh=pYSuzyWi5Rl6qxQSfhLW6iTnHwTrgUNiw/i0HHteH9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdHStSzS9CgnraoNo9J2jOlxU/19L+yVvyDKErBJFYwimZVKTVcEaMnPUDwCg95A5N01DvQRVq/HfnPN86iNPtRmAXY6RYdAU3Cag6UmQs3moiA7IZEB0KQ3dLYQhXJL2XyYf8m6C8fkXHOTj4Y8U+fnPMN8OAYjn8TJjR3wFQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dz3EQnn6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dz3EQnn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62091F000E9;
	Thu, 28 May 2026 20:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001051;
	bh=tT525u0XOlK1tBzz9ABzc4Akkhi2s3pM51wKoamnAQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dz3EQnn6dajoxfRH+3jfGolpkgDjQD3bRSHVqwsDfYeQGdfLeEvkh1d6MP1AuuG9E
	 T5fAS4RQUIrlVp4qk4a2KkwZdvlQD/T/v3aQyIYN4sVpIezqDyhnouaghlrdQoStBZ
	 8gi/WGjo8PX13MBl3kl86sOqrIW2gyb4j8pgAaPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/272] net: mana: Fix TOCTOU double-fetch of hwc_msg_id from DMA buffer
Date: Thu, 28 May 2026 21:50:20 +0200
Message-ID: <20260528194636.020474257@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 35f0f0a2536a4d604b4dbad92c85c4a8fdebb870 ]

In mana_hwc_rx_event_handler(), resp->response.hwc_msg_id is read from
DMA-coherent memory and bounds-checked, then mana_hwc_handle_resp()
re-reads the same field from the same DMA buffer for test_bit() and
pointer arithmetic.

DMA-coherent memory is mapped uncacheable on x86 and is shared,
unencrypted, in Confidential VMs (SEV-SNP/TDX), so each load goes
directly to host-visible memory. A H/W can modify the value
between the check and the use, bypassing the bounds validation.

Fix this by reading hwc_msg_id exactly once using READ_ONCE() into a
stack-local variable in mana_hwc_rx_event_handler(), and passing the
validated value as a parameter to mana_hwc_handle_resp().

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260514194156.466823-1-ernis@linux.microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index e07d0a9529782..f8971844e6d8e 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -76,21 +76,19 @@ static int mana_hwc_post_rx_wqe(const struct hwc_wq *hwc_rxq,
 }
 
 static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
-				 struct hwc_work_request *rx_req)
+				 struct hwc_work_request *rx_req, u16 msg_id)
 {
 	const struct gdma_resp_hdr *resp_msg = rx_req->buf_va;
 	struct hwc_caller_ctx *ctx;
 	int err;
 
-	if (!test_bit(resp_msg->response.hwc_msg_id,
-		      hwc->inflight_msg_res.map)) {
-		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n",
-			resp_msg->response.hwc_msg_id);
+	if (!test_bit(msg_id, hwc->inflight_msg_res.map)) {
+		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n", msg_id);
 		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
 		return;
 	}
 
-	ctx = hwc->caller_ctx + resp_msg->response.hwc_msg_id;
+	ctx = hwc->caller_ctx + msg_id;
 	err = mana_hwc_verify_resp_msg(ctx, resp_msg, resp_len);
 	if (err)
 		goto out;
@@ -219,6 +217,7 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 	struct gdma_sge *sge;
 	u64 rq_base_addr;
 	u64 rx_req_idx;
+	u16 msg_id;
 	u8 *wqe;
 
 	if (WARN_ON_ONCE(hwc_rxq->gdma_wq->id != gdma_rxq_id))
@@ -237,13 +236,17 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 	rx_req = &hwc_rxq->msg_buf->reqs[rx_req_idx];
 	resp = (struct gdma_resp_hdr *)rx_req->buf_va;
 
-	if (resp->response.hwc_msg_id >= hwc->num_inflight_msg) {
-		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n",
-			resp->response.hwc_msg_id);
+	/* Read msg_id once from DMA buffer to prevent TOCTOU:
+	 * DMA memory is shared/unencrypted in CVMs - host can
+	 * modify it between reads.
+	 */
+	msg_id = READ_ONCE(resp->response.hwc_msg_id);
+	if (msg_id >= hwc->num_inflight_msg) {
+		dev_err(hwc->dev, "HWC RX: wrong msg_id=%u\n", msg_id);
 		return;
 	}
 
-	mana_hwc_handle_resp(hwc, rx_oob->tx_oob_data_size, rx_req);
+	mana_hwc_handle_resp(hwc, rx_oob->tx_oob_data_size, rx_req, msg_id);
 
 	/* Can no longer use 'resp', because the buffer is posted to the HW
 	 * in mana_hwc_handle_resp() above.
-- 
2.53.0



