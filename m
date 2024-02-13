Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDD65F54E;
	Tue, 13 Feb 2024 17:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845357; cv=none; b=Ystg54vaAxYyq0xoT2CWca9jmrGp5M3j5qYUMHAuTs5jg7LL+9D1cUtpcyycNNrlBq9ncDo59qF6DgYSuSHuDtsozf47DUvyRnJ02bsdqUnJb54Kwkuk4/cCa88B0V9QX7oz7HnWYAYCy0gkAuP5jjj0F/qgan3YQl6MIXlVCew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845357; c=relaxed/simple;
	bh=HGRMdyOj6VLTFhu/2SQGWLzV6PWbC7sbLR/hZ9dvhhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brFLr45FGYv9OizUr4fY6GcUP2gvT759IQPmBbgJEjlZG+ZIvVjokhRqEyYakKvthIVGct+AghuTRw3wrM/HJWPAG9y+vGoOCKn30t67bC+Upec6Q15O8EE1OUUFdhL93JXT8FyZ0DbJatfF38+7iKVwIZ9QYiiIFqPl+oCB52w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBJKx3u3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBJKx3u3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FE7C433C7;
	Tue, 13 Feb 2024 17:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845357;
	bh=HGRMdyOj6VLTFhu/2SQGWLzV6PWbC7sbLR/hZ9dvhhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBJKx3u3sXZPwWGFmGj+c/xFVBp8tkDa9NGccPBNoAIhQ9U8Wquh34fohMJimhI3y
	 9UOTC0FZm+uv7zf0BzcikPvGz268BsKWr4QrJ9yemMzt8hf8PO6r2VlOLoAKvG8F4j
	 xzJsYbpfKp6eDD3y8oD5I4Z451DNq+tZQWgSIq3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/121] tsnep: Fix mapping for zero copy XDP_TX action
Date: Tue, 13 Feb 2024 18:21:05 +0100
Message-ID: <20240213171854.630841428@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit d7f5fb33cf77247b7bf9a871aaeea72ca4f51ad7 ]

For XDP_TX action xdp_buff is converted to xdp_frame. The conversion is
done by xdp_convert_buff_to_frame(). The memory type of the resulting
xdp_frame depends on the memory type of the xdp_buff. For page pool
based xdp_buff it produces xdp_frame with memory type
MEM_TYPE_PAGE_POOL. For zero copy XSK pool based xdp_buff it produces
xdp_frame with memory type MEM_TYPE_PAGE_ORDER0.

tsnep_xdp_xmit_back() is not prepared for that and uses always the page
pool buffer type TSNEP_TX_TYPE_XDP_TX. This leads to invalid mappings
and the transmission of undefined data.

Improve tsnep_xdp_xmit_back() to use the generic buffer type
TSNEP_TX_TYPE_XDP_NDO for zero copy XDP_TX.

Fixes: 3fc2333933fd ("tsnep: Add XDP socket zero-copy RX support")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 08e113e785a7..4f36b29d66c8 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -668,17 +668,25 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
 
 static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
 				struct xdp_buff *xdp,
-				struct netdev_queue *tx_nq, struct tsnep_tx *tx)
+				struct netdev_queue *tx_nq, struct tsnep_tx *tx,
+				bool zc)
 {
 	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
 	bool xmit;
+	u32 type;
 
 	if (unlikely(!xdpf))
 		return false;
 
+	/* no page pool for zero copy */
+	if (zc)
+		type = TSNEP_TX_TYPE_XDP_NDO;
+	else
+		type = TSNEP_TX_TYPE_XDP_TX;
+
 	__netif_tx_lock(tx_nq, smp_processor_id());
 
-	xmit = tsnep_xdp_xmit_frame_ring(xdpf, tx, TSNEP_TX_TYPE_XDP_TX);
+	xmit = tsnep_xdp_xmit_frame_ring(xdpf, tx, type);
 
 	/* Avoid transmit queue timeout since we share it with the slow path */
 	if (xmit)
@@ -1222,7 +1230,7 @@ static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
 	case XDP_PASS:
 		return false;
 	case XDP_TX:
-		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx))
+		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx, false))
 			goto out_failure;
 		*status |= TSNEP_XDP_TX;
 		return true;
@@ -1272,7 +1280,7 @@ static bool tsnep_xdp_run_prog_zc(struct tsnep_rx *rx, struct bpf_prog *prog,
 	case XDP_PASS:
 		return false;
 	case XDP_TX:
-		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx))
+		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx, true))
 			goto out_failure;
 		*status |= TSNEP_XDP_TX;
 		return true;
-- 
2.43.0



