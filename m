Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532682417D9;
	Tue, 21 Jul 2026 18:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659957; cv=none; b=isJNPYiLAkzdI+23YqEarFn8F92/DalGMOqhmdbzQVNosW5h0vjxwRMOqM50mSLs1ffaiEDMSeGLq5Aji2IMxd9t5UDdi3r4OREUY7MMzSWtcEHnqAEMgx6giiyqplSuP+lYSlC6vrxXqdv1+RxigPwDyvwtIT9OQvpBKhoZQ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659957; c=relaxed/simple;
	bh=20xrYy3psYvi4/0t1LwgfN/RRRldm4qcWf6oXIWSU9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMfkIxx1HikaMBCGY1XI196HcshoOBpGwzDB4+ecyiinS+/B4Ick41QfJLzBHYDdXsO48zzkYG9NeVe9AphWdld1mVP1GzbDNycdIyb5qCCKOT1ek2Cb4PIChHyC5kLFrZHz7WIoTLcQSn1ttswo144saXmcRnEkJNxSkCa+7cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1kmrCyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1kmrCyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FEB1F000E9;
	Tue, 21 Jul 2026 18:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659956;
	bh=FlbvkacsP2V+HqpDvjLBLbiKa21/RbtGqNfUntNjWTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1kmrCyfheAe5m5fkqbFH7Cp3NBJJcRVtGd9nAYOR83M+H70LNP0rE4mgvR+8FF71
	 DipjxU+U+YchPk92s3at27v2M75+sRBoO/lQQrlPpWxt973n9rbGj4Z9PG1fIQpsYt
	 txaZgjXr0l5nKwLqCSQk/q8/Ca8DqnXmgmQqdVBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0798/2077] net: ti: icssg: Use undirected TX tag for XDP zero copy in HSR offload mode
Date: Tue, 21 Jul 2026 17:07:51 +0200
Message-ID: <20260721152611.615081875@linuxfoundation.org>
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

[ Upstream commit f9691288413ceb4fc72f3ccc4d8e42adf66eb28d ]

emac_xsk_xmit_zc() has the same issue as the fixed emac_xmit_xdp_frame():
it always sets the CPPI5 descriptor destination tag to emac->port_id,
which directs the PRU firmware to transmit on only one slave port in HSR
mode, breaking redundancy.

Apply the same fix: in HSR offload mode when NETIF_F_HW_HSR_DUP is set,
use PRUETH_UNDIRECTED_PKT_DST_TAG (port 0) so the PRU duplicates frames
to both ports. Also set PRUETH_UNDIRECTED_PKT_TAG_INS when
NETIF_F_HW_HSR_TAG_INS is set so the PRU re-inserts the HSR sequence tag
that was stripped by the PRU on RX before the XDP program saw the frame.

This ensures XSK XDP_TX frames in HSR mode are treated identically to
skb TX via hsr0.

Fixes: 8756ef2eb078 ("net: ti: icssg-prueth: Add AF_XDP zero copy for TX")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Link: https://patch.msgid.link/20260611185744.2498070-4-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index ede32f266729ee..82ddef9c17d54e 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -105,6 +105,7 @@ static int emac_xsk_xmit_zc(struct prueth_emac *emac,
 	struct xdp_desc xdp_desc;
 	int num_tx = 0, pkt_len;
 	int descs_avail, ret;
+	u32 dst_tag_id;
 	u32 *epib;
 	int i;
 
@@ -137,9 +138,17 @@ static int emac_xsk_xmit_zc(struct prueth_emac *emac,
 		epib[0] = 0;
 		epib[1] = 0;
 		cppi5_hdesc_set_pktlen(host_desc, pkt_len);
-		cppi5_desc_set_tags_ids(&host_desc->hdr, 0,
-					(emac->port_id | (q_idx << 8)));
+		dst_tag_id = emac->port_id | (q_idx << 8);
+
+		if (emac->prueth->is_hsr_offload_mode &&
+		    (ndev->features & NETIF_F_HW_HSR_DUP))
+			dst_tag_id = PRUETH_UNDIRECTED_PKT_DST_TAG;
+
+		if (emac->prueth->is_hsr_offload_mode &&
+		    (ndev->features & NETIF_F_HW_HSR_TAG_INS))
+			epib[1] |= PRUETH_UNDIRECTED_PKT_TAG_INS;
 
+		cppi5_desc_set_tags_ids(&host_desc->hdr, 0, dst_tag_id);
 		k3_udma_glue_tx_dma_to_cppi5_addr(tx_chn->tx_chn, &dma_buf);
 		cppi5_hdesc_attach_buf(host_desc, dma_buf, pkt_len, dma_buf,
 				       pkt_len);
-- 
2.53.0



