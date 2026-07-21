Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFDE364959;
	Tue, 21 Jul 2026 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659954; cv=none; b=SQfi+M+X3fNHfsdNOqsR3CawAWXtenZxl4X32EW/1Wv7wC52AGMzhbmDhog+6etBkiZoC31BKHOGK63NADUKyxhANN2gbtQqDcR13b+noblkrZfZKNakK+zDXsA78TyCW4/ny4oa8+LI+VepOTvwgQOumXxHRa9RjhxxP++Vp94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659954; c=relaxed/simple;
	bh=si/8HhxmJIRbcLAlTRyYKG6VNeQF47PwTqUpLz2fjLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbP+v3F7zAk3P95xEIp7oiRGPE6SWxEZmr8JI19F5msVgYvK0U6QTd97AKL2rVxgRXByC+8Jv6uO96kAVwmUxs15TNLpcpT4YTrINXpEBmlAEQgqlttGmZGpKFXVs9/seLywWQ80X2F3TWI4wZpHWBIpH/YUq5bodvQWCH0RdwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NVVrNei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NVVrNei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DBE1F000E9;
	Tue, 21 Jul 2026 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659953;
	bh=P1EmgDqTcDwjeCm0XA4ujd/SaJITIiTV2/vvP2qNiR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NVVrNeigklCeZqsDaga2/8k27G1oWzwh1yTSjtY30X7cOqd/zdv976WSN35BkSby
	 UNkYae2sib9p38b/SqDl+Ojr5uFIJ/ElcqdI0YzhsAeqzLxuho9F5Tt03k+Fs29sin
	 GeaDC+Oefwk8vsqX/QuqxYPCxOb9ggwfgfdvIEl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0797/2077] net: ti: icssg: Use undirected TX tag for native XDP in HSR offload mode
Date: Tue, 21 Jul 2026 17:07:50 +0200
Message-ID: <20260721152611.591855886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit bcbf73d98195577a89e788179843f6d0c66244a5 ]

emac_xmit_xdp_frame() always sets the CPPI5 descriptor destination
tag to emac->port_id, which directs the PRU firmware to transmit
the frame on that specific slave port only.  In HSR offload mode
this bypasses the firmware's HSR duplication logic: the frame goes
out on one ring leg and never appears on the other, breaking HSR
redundancy for XDP_TX paths.

icssg_ndo_start_xmit() already handles this correctly: when HSR
offload mode is active and NETIF_F_HW_HSR_DUP is set it substitutes
PRUETH_UNDIRECTED_PKT_DST_TAG (port 0) so the PRU duplicates the
frame to both slave ports.  It also sets PRUETH_UNDIRECTED_PKT_TAG_INS
in epib[1] when NETIF_F_HW_HSR_TAG_INS is set so the PRU inserts the
HSR sequence tag, which XDP_TX frames lack (the tag is stripped by
the PRU on RX before the frame reaches the XDP program).

Apply the same logic in emac_xmit_xdp_frame() so XDP_TX frames in
HSR mode are treated identically to skb TX via hsr0.

Fixes: 62aa3246f462 ("net: ti: icssg-prueth: Add XDP support")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Link: https://patch.msgid.link/20260611185744.2498070-3-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c | 21 ++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index 55a696912811f6..ede32f266729ee 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -696,6 +696,7 @@ u32 emac_xmit_xdp_frame(struct prueth_emac *emac,
 	dma_addr_t desc_dma, buf_dma;
 	struct prueth_swdata *swdata;
 	struct page *page;
+	u32 dst_tag_id;
 	u32 *epib;
 	int ret;
 
@@ -737,9 +738,25 @@ u32 emac_xmit_xdp_frame(struct prueth_emac *emac,
 
 	/* set dst tag to indicate internal qid at the firmware which is at
 	 * bit8..bit15. bit0..bit7 indicates port num for directed
-	 * packets in case of switch mode operation
+	 * packets in case of switch mode operation and port num 0
+	 * for undirected packets in case of HSR offload mode.
+	 *
+	 * XDP_TX frames arrive on a slave port with the HSR tag already
+	 * stripped by the PRU firmware.  Like skb TX via hsr0, they must
+	 * be sent as undirected so the PRU duplicates them to both ports
+	 * and re-inserts the HSR sequence tag.
 	 */
-	cppi5_desc_set_tags_ids(&first_desc->hdr, 0, (emac->port_id | (q_idx << 8)));
+	dst_tag_id = emac->port_id | (q_idx << 8);
+
+	if (emac->prueth->is_hsr_offload_mode &&
+	    (ndev->features & NETIF_F_HW_HSR_DUP))
+		dst_tag_id = PRUETH_UNDIRECTED_PKT_DST_TAG;
+
+	if (emac->prueth->is_hsr_offload_mode &&
+	    (ndev->features & NETIF_F_HW_HSR_TAG_INS))
+		epib[1] |= PRUETH_UNDIRECTED_PKT_TAG_INS;
+
+	cppi5_desc_set_tags_ids(&first_desc->hdr, 0, dst_tag_id);
 	k3_udma_glue_tx_dma_to_cppi5_addr(tx_chn->tx_chn, &buf_dma);
 	cppi5_hdesc_attach_buf(first_desc, buf_dma, xdpf->len, buf_dma, xdpf->len);
 	swdata = cppi5_hdesc_get_swdata(first_desc);
-- 
2.53.0



