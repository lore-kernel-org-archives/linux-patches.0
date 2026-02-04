Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349294218AB;
	Wed,  4 Feb 2026 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218619; cv=none; b=dnLu/Nfgqbjr+EJpMXRzWgUjeL0EOqbsFF8I0F4a+X//WIjmYdyAcUfhsoHdltE369Lnk9BuixiVfdfVKXuQClthmLFEfX0niFdyU+6eGEkIUy86QNxLc1k7JSf7SZzZrX6EBnrWqMOeQvc/DDYZo5zVYX7oXKntJeCkal+DoLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218619; c=relaxed/simple;
	bh=4h670GeaaOa2gaXJIEDuiDGxm5BeVr4B6NIBKEXTBdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONSn8VcPMr9LfrqQQ5aR5CW295ayWhmdWiLv7jatYZfo+8OBSu87sZ5nsVcx2VKEnBxthOaXF+VEhZdLKnGlXcNQhW514+7y6XotSP56irDHTBv5jQxa5Ha61IgbXXZcQzzpT15BPbWNbV7c71lirP8tPpyMnAjcREZ5inP4Amg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqdS01xC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqdS01xC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99599C4CEF7;
	Wed,  4 Feb 2026 15:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218619;
	bh=4h670GeaaOa2gaXJIEDuiDGxm5BeVr4B6NIBKEXTBdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqdS01xCpQ2/cwEjy2bNju2JZ1AU8qruCU2G6nqzRtm4gj+JN3paIebJ1zU+p6o2x
	 IAJY3Iw0/73ESEt7hnhuFqFrJ3epAgfA9Z6QaXRCTgfDmonYKorfho7QDvBlV8yOX6
	 xIrPwJAR9C8H3E0Th8gVrOr6aDI/FhMShbQpxBM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 11/87] net: wwan: t7xx: fix potential skb->frags overflow in RX path
Date: Wed,  4 Feb 2026 15:40:09 +0100
Message-ID: <20260204143847.319238338@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit f0813bcd2d9d97fdbdf2efb9532ab03ae92e99e6 ]

When receiving data in the DPMAIF RX path,
the t7xx_dpmaif_set_frag_to_skb() function adds
page fragments to an skb without checking if the number of
fragments has exceeded MAX_SKB_FRAGS. This could lead to a buffer overflow
in skb_shinfo(skb)->frags[] array, corrupting adjacent memory and
potentially causing kernel crashes or other undefined behavior.

This issue was identified through static code analysis by comparing with a
similar vulnerability fixed in the mt76 driver commit b102f0c522cf ("mt76:
fix array overflow on receiving too many fragments for a packet").

The vulnerability could be triggered if the modem firmware sends packets
with excessive fragments. While under normal protocol conditions (MTU 3080
bytes, BAT buffer 3584 bytes),
a single packet should not require additional
fragments, the kernel should not blindly trust firmware behavior.
Malicious, buggy, or compromised firmware could potentially craft packets
with more fragments than the kernel expects.

Fix this by adding a bounds check before calling skb_add_rx_frag() to
ensure nr_frags does not exceed MAX_SKB_FRAGS.

The check must be performed before unmapping to avoid a page leak
and double DMA unmap during device teardown.

Fixes: d642b012df70a ("net: wwan: t7xx: Add data path interface")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Link: https://patch.msgid.link/20260122170401.1986-2-qikeyu2017@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
index 7a9c09cd4fdcf..6b0df637afeb8 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -394,6 +394,7 @@ static int t7xx_dpmaif_set_frag_to_skb(const struct dpmaif_rx_queue *rxq,
 				       struct sk_buff *skb)
 {
 	unsigned long long data_bus_addr, data_base_addr;
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	struct device *dev = rxq->dpmaif_ctrl->dev;
 	struct dpmaif_bat_page *page_info;
 	unsigned int data_len;
@@ -401,18 +402,22 @@ static int t7xx_dpmaif_set_frag_to_skb(const struct dpmaif_rx_queue *rxq,
 
 	page_info = rxq->bat_frag->bat_skb;
 	page_info += t7xx_normal_pit_bid(pkt_info);
-	dma_unmap_page(dev, page_info->data_bus_addr, page_info->data_len, DMA_FROM_DEVICE);
 
 	if (!page_info->page)
 		return -EINVAL;
 
+	if (shinfo->nr_frags >= MAX_SKB_FRAGS)
+		return -EINVAL;
+
+	dma_unmap_page(dev, page_info->data_bus_addr, page_info->data_len, DMA_FROM_DEVICE);
+
 	data_bus_addr = le32_to_cpu(pkt_info->pd.data_addr_h);
 	data_bus_addr = (data_bus_addr << 32) + le32_to_cpu(pkt_info->pd.data_addr_l);
 	data_base_addr = page_info->data_bus_addr;
 	data_offset = data_bus_addr - data_base_addr;
 	data_offset += page_info->offset;
 	data_len = FIELD_GET(PD_PIT_DATA_LEN, le32_to_cpu(pkt_info->header));
-	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page_info->page,
+	skb_add_rx_frag(skb, shinfo->nr_frags, page_info->page,
 			data_offset, data_len, page_info->data_len);
 
 	page_info->page = NULL;
-- 
2.51.0



