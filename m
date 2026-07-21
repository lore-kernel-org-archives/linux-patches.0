Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B120833A9FC;
	Tue, 21 Jul 2026 22:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673607; cv=none; b=i4mz8VMUo4Kh0/43pZbONS4HyC3fzOcneA4bziGt0xnX1gryvXTLVVBUi5Ymn4J9AwzCTBlx7FVFq5zF3LcSiHuA6L+6TkXaSuobGT9LjVoUts3RbXAeF+D2pLl1mldVrYf+E6A8CIGAk433X73hCFxNBYJJL4bLIuxmHK6ymcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673607; c=relaxed/simple;
	bh=rNnmnXkoTYC7TaNlQ6jxOhYIkJDUVR/Rst4J9VliDA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipJd5mqmD0yvIfb93xgqyNSDXRvBI0Ye/1CnZlwe9z69KqLecwgswqFon7dvESSz7zUKLnu2DnBMpzxb1+3S4cfyhPp+PQ+P5v8k5Oaab5UJd3fMy+GGxLRTa8q2vCSQK7Mr/cTaabffbn1hLPPBjjUe3/8SayRXdblaIiucZSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7/965Gc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7/965Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AE01F000E9;
	Tue, 21 Jul 2026 22:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673606;
	bh=fTN05kI8xmyPakPE3fAcKsGGEjgEFBP+79vkcLrUBEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7/965Gc+RI3e1sK9JokQl4x5zXvt4R4TrJoS6rl3NQU43cw4w+an2PkSl3T4Sdhl
	 C67eSEr8PWxfpD3UYoMKUee8dCY9xr/I3Ci+EqIqw7GcoWX4fuBs8/YaRobwS03VfQ
	 hrginuxlBFN+CAjz9kvAOo0b1pDmW5rLmmBWHFtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/699] wifi: rtw88: fix OOB read from firmware RX descriptor exceeding DMA buffer
Date: Tue, 21 Jul 2026 17:18:51 +0200
Message-ID: <20260721152359.581967773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 676d861aaf9971..bc09e0225e44e0 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -980,6 +980,11 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
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



