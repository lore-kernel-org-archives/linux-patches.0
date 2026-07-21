Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF746AA68;
	Tue, 21 Jul 2026 15:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648183; cv=none; b=ej+vyr+r5EatxVNl0GpuXwxYPjThJClQY6tTXCm2tpupElgNcUPkIP+k63gkIn1ETawfb8/c0Aw53IjTwyRVYJy9XQ1vvPXlogIZqT1s5NIgRxSfU/0tT9RFGhNeKEKcJFNdH1yQKc3yVtP0eIHBXi6un03VveEs6m+ydoKol5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648183; c=relaxed/simple;
	bh=HP874yAPEgbE9Hf1OuxvygjGexGYEz5uTxrFPjLewUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/uK4pyQAeBwsO+0J4SyTvaZCnTdsIf0PLq9DRzlshwbrirjk8710NDlSvVIUQNXA5E5D5MFbDexCfnZCu4LeJRikBiryvxXGr60DE46nneGcRkzs70S/bgdfBJZbX45xAveZECypxcB+M4w67kTjYD3pGCcp3v10/75WGqJuZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eY0CT36H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eY0CT36H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254061F000E9;
	Tue, 21 Jul 2026 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648182;
	bh=dyJ45g4wpJrLiKVIsScFQ5LcaHc1x8O1zWRKfaMA8HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eY0CT36HfAf43CylsVof3vsi+0oHWqhKGQbQ4VkocPRe7rn428D/MsvO85xCfnT1U
	 YNGI33DuosbDOepKt/lG4Vvlcn2NMoSIhB/Ygu4yHPMvyHihgRlayN5ZVQ56BB9gel
	 D4u5KWMf9AKU49fF/mgah0u7AxceGdrX2X6rcL+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0103/2077] wifi: rtw88: fix OOB read from firmware RX descriptor exceeding DMA buffer
Date: Tue, 21 Jul 2026 16:56:16 +0200
Message-ID: <20260721152555.123777499@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 6e76e9ed273dfb4b3333a5ebbb94958cc5752ab6 ]

In rtw_pci_rx_napi(), new_len is computed as the sum of pkt_len (14-bit
descriptor field, max 16383) and pkt_offset (drv_info_sz + shift, both
firmware-controlled). The result can exceed RTK_PCI_RX_BUF_SIZE (11478),
causing an out-of-bounds read from the pre-allocated DMA buffer when
skb_put_data copies new_len bytes. The USB transport already validates
this (rtw_usb_rx_data_put checks against RTW_USB_MAX_RECVBUF_SZ); the
PCIe path does not.

Add a check that new_len does not exceed the DMA buffer size.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260421111434.3389674-1-tristmd@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index c56beacbb1b03f..c2bf44e880cf2d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1077,6 +1077,11 @@ static u32 rtw_pci_rx_napi(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		 * discard the frame if none available
 		 */
 		new_len = pkt_stat.pkt_len + pkt_offset;
+		if (unlikely(new_len > RTK_PCI_RX_BUF_SIZE)) {
+			rtw_dbg(rtwdev, RTW_DBG_RX,
+				"oversized RX packet: %u\n", new_len);
+			goto next_rp;
+		}
 		new = dev_alloc_skb(new_len);
 		if (WARN_ONCE(!new, "rx routine starvation\n"))
 			goto next_rp;
-- 
2.53.0



