Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAE22417E0;
	Wed,  4 Feb 2026 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218921; cv=none; b=Cy+KC9J0n7cLLDYA2qoKiJ+ljLdP6GnSSXU8o21+8mniN0eGzY9imGtOjc7MjwIagXSawXH7733R38kkcp3Lx8c2iHT/JHeXQjcSDuy97UctnWr3f/JTjEyA6KsTmG9CnIvQUp+cAPptFHe3Y/VFPT0kN79EUeneRqxKA/rUQME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218921; c=relaxed/simple;
	bh=zKhwJ1V3chboRiTIy7EQE6Zmgr3fU3bS3FLtlHy2a9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9mHVhSNrC0vhBZgumXS510YFvfr0n6CAHRrbfKPF2FwLeFyB9TRGx2VM3MPQ0dceg/rVWMIu6WysamWFX42jQfIZJadNtY0hlG7jGAe/SASx6/P9QO56RFVuMGpu5hG4yHK/vLdmeNdKiOCX1Dv2Zvb6AdtUyFCNUrMT6sXxog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxmAQsbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxmAQsbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521F1C4CEF7;
	Wed,  4 Feb 2026 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218921;
	bh=zKhwJ1V3chboRiTIy7EQE6Zmgr3fU3bS3FLtlHy2a9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxmAQsbLpv9OpqWmvoh5406HlKAUz8Zeaveb9nK0rde+Eg4LF2Yzyb7QS+YaRlr1k
	 atfO6EjV/1l5NPRNXT+2Rz70s4UBDMrOFcsc8tmMzD1PJmd9R2qWxaiFCoS3YceXAT
	 RkaMxO6qPm6w8tmbmdKJ6aKym91YvSZjMKXhqxmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/122] net: wwan: t7xx: fix potential skb->frags overflow in RX path
Date: Wed,  4 Feb 2026 15:39:56 +0100
Message-ID: <20260204143852.379776197@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2310493203d3c..d9f10df03a5db 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -395,6 +395,7 @@ static int t7xx_dpmaif_set_frag_to_skb(const struct dpmaif_rx_queue *rxq,
 				       struct sk_buff *skb)
 {
 	unsigned long long data_bus_addr, data_base_addr;
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	struct device *dev = rxq->dpmaif_ctrl->dev;
 	struct dpmaif_bat_page *page_info;
 	unsigned int data_len;
@@ -402,18 +403,22 @@ static int t7xx_dpmaif_set_frag_to_skb(const struct dpmaif_rx_queue *rxq,
 
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



