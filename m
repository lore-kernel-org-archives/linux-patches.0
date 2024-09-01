Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D546143C6E;
	Sun,  1 Sep 2024 16:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207895; cv=none; b=gYXPEotM5ZJI0ZAt/uue3ImGfALWmqbTKrQTV6Xch5G/+xarqTdEoWBmlJvSlxezgL7UiLEUPe8sJNQHM71fprVphnRJNif3NT2O/vs9mKy8Fc5T8QRtuj1RzjBil+iPPNaToveXzXhvKWo67BopbJ50IrlRODT/aVpgNghXAxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207895; c=relaxed/simple;
	bh=uKM08atJL8wsPMKjDNH6kbIQjYHLJIKCpJvC+C1Z1wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6SHVm1bBvUHB/azuwGtqZWXyYgL3oAeP/mSA5ZAtn2FSnIWT3kVj1/j6RWfc5RMiVBINrLtlkSc9amIl2KBFFAq9BAUPlJWd0eHKZ3ATsVfHvPNwrNM4pm1vzuUTlzArt1KSy8qu1Qu8ZIwwRctcwClkz2ggZ6HZC7Kutu8pV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOeWDh43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOeWDh43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02570C4CEC3;
	Sun,  1 Sep 2024 16:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207895;
	bh=uKM08atJL8wsPMKjDNH6kbIQjYHLJIKCpJvC+C1Z1wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOeWDh43C1aJdf4VEDaagC8q6jqg/rlCwZJtPbv3qop3uBQA4bk7ZNRD7LddoJXUd
	 TzaGAwCsZw52+9Zpoy666GiHDgz4IJ+uqX5jOgKT0UE2ds9xVcL5GB+DBTLZNu4BXN
	 vlvxxUaz4l3GItGfPT9SEe/60EJW2nSHwe1VsvGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 11/93] net: mana: Fix race of mana_hwc_post_rx_wqe and new hwc response
Date: Sun,  1 Sep 2024 18:15:58 +0200
Message-ID: <20240901160807.783232069@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 8af174ea863c72f25ce31cee3baad8a301c0cf0f upstream.

The mana_hwc_rx_event_handler() / mana_hwc_handle_resp() calls
complete(&ctx->comp_event) before posting the wqe back. It's
possible that other callers, like mana_create_txq(), start the
next round of mana_hwc_send_request() before the posting of wqe.
And if the HW is fast enough to respond, it can hit no_wqe error
on the HW channel, then the response message is lost. The mana
driver may fail to create queues and open, because of waiting for
the HW response and timed out.
Sample dmesg:
[  528.610840] mana 39d4:00:02.0: HWC: Request timed out!
[  528.614452] mana 39d4:00:02.0: Failed to send mana message: -110, 0x0
[  528.618326] mana 39d4:00:02.0 enP14804s2: Failed to create WQ object: -110

To fix it, move posting of rx wqe before complete(&ctx->comp_event).

Cc: stable@vger.kernel.org
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c |   62 ++++++++++++-----------
 1 file changed, 34 insertions(+), 28 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -51,9 +51,33 @@ static int mana_hwc_verify_resp_msg(cons
 	return 0;
 }
 
+static int mana_hwc_post_rx_wqe(const struct hwc_wq *hwc_rxq,
+				struct hwc_work_request *req)
+{
+	struct device *dev = hwc_rxq->hwc->dev;
+	struct gdma_sge *sge;
+	int err;
+
+	sge = &req->sge;
+	sge->address = (u64)req->buf_sge_addr;
+	sge->mem_key = hwc_rxq->msg_buf->gpa_mkey;
+	sge->size = req->buf_len;
+
+	memset(&req->wqe_req, 0, sizeof(struct gdma_wqe_request));
+	req->wqe_req.sgl = sge;
+	req->wqe_req.num_sge = 1;
+	req->wqe_req.client_data_unit = 0;
+
+	err = mana_gd_post_and_ring(hwc_rxq->gdma_wq, &req->wqe_req, NULL);
+	if (err)
+		dev_err(dev, "Failed to post WQE on HWC RQ: %d\n", err);
+	return err;
+}
+
 static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
-				 const struct gdma_resp_hdr *resp_msg)
+				 struct hwc_work_request *rx_req)
 {
+	const struct gdma_resp_hdr *resp_msg = rx_req->buf_va;
 	struct hwc_caller_ctx *ctx;
 	int err;
 
@@ -61,6 +85,7 @@ static void mana_hwc_handle_resp(struct
 		      hwc->inflight_msg_res.map)) {
 		dev_err(hwc->dev, "hwc_rx: invalid msg_id = %u\n",
 			resp_msg->response.hwc_msg_id);
+		mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
 		return;
 	}
 
@@ -74,30 +99,13 @@ static void mana_hwc_handle_resp(struct
 	memcpy(ctx->output_buf, resp_msg, resp_len);
 out:
 	ctx->error = err;
-	complete(&ctx->comp_event);
-}
-
-static int mana_hwc_post_rx_wqe(const struct hwc_wq *hwc_rxq,
-				struct hwc_work_request *req)
-{
-	struct device *dev = hwc_rxq->hwc->dev;
-	struct gdma_sge *sge;
-	int err;
-
-	sge = &req->sge;
-	sge->address = (u64)req->buf_sge_addr;
-	sge->mem_key = hwc_rxq->msg_buf->gpa_mkey;
-	sge->size = req->buf_len;
 
-	memset(&req->wqe_req, 0, sizeof(struct gdma_wqe_request));
-	req->wqe_req.sgl = sge;
-	req->wqe_req.num_sge = 1;
-	req->wqe_req.client_data_unit = 0;
+	/* Must post rx wqe before complete(), otherwise the next rx may
+	 * hit no_wqe error.
+	 */
+	mana_hwc_post_rx_wqe(hwc->rxq, rx_req);
 
-	err = mana_gd_post_and_ring(hwc_rxq->gdma_wq, &req->wqe_req, NULL);
-	if (err)
-		dev_err(dev, "Failed to post WQE on HWC RQ: %d\n", err);
-	return err;
+	complete(&ctx->comp_event);
 }
 
 static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
@@ -234,14 +242,12 @@ static void mana_hwc_rx_event_handler(vo
 		return;
 	}
 
-	mana_hwc_handle_resp(hwc, rx_oob->tx_oob_data_size, resp);
+	mana_hwc_handle_resp(hwc, rx_oob->tx_oob_data_size, rx_req);
 
-	/* Do no longer use 'resp', because the buffer is posted to the HW
-	 * in the below mana_hwc_post_rx_wqe().
+	/* Can no longer use 'resp', because the buffer is posted to the HW
+	 * in mana_hwc_handle_resp() above.
 	 */
 	resp = NULL;
-
-	mana_hwc_post_rx_wqe(hwc_rxq, rx_req);
 }
 
 static void mana_hwc_tx_event_handler(void *ctx, u32 gdma_txq_id,


