Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD97352FF5;
	Tue, 26 Aug 2025 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217793; cv=none; b=tcaq53YYXCcNDPeG4M2cB30IKo3vhI9IIGt3H4MAA+K344Y/52vf5yxFFPReN48PDsNnnyVt9YhJmi4/dfouGwY9M6xmq9ZmBN7K+sXbLZ/KX/1XKUQhRfj/oQ/rkYFH4z5MkJWdbsuUt5YGojQ6r8tPmbdD/+8BPzlpUcG0m2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217793; c=relaxed/simple;
	bh=DP90hkTW9h6/BM2hqPob8D3oL2GagNmwoK+GCQVBGa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4Eemt6ulcGMZ2ukIMgX1CFGXKoztfQ/cmjCRYeNCNC9Wc6JSry+3krcKfdS2Q0c0Hegsw4JwuBUVC+u8qPWF4Y15fWMFRsH9xfoQKRIRPPGJNpWoRVwy/AHJOq6O7pDqaCRAgcongoZAUVRJcoVYr41Iqmt2VWTNEcoziOt5M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3hOlvSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3hOlvSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44CDC4CEF1;
	Tue, 26 Aug 2025 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217793;
	bh=DP90hkTW9h6/BM2hqPob8D3oL2GagNmwoK+GCQVBGa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3hOlvSloYFTPiWHevbw4sjJC+POmeZs0p4kADWC2+WXye1lrglSZ/wYByvuYuIrB
	 nAvt0bHt2Fr/mCgBGqRN2SWKKq6fZMu9rw/P3Uz3MG8oU0Cr+FgoUsuX2wG/oEKyoo
	 wt1kN5uvL9I6LlJYnQO3psmnWgm+nqGanG7Jmhp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/523] wifi: rtlwifi: fix possible skb memory leak in `_rtl_pci_rx_interrupt()`.
Date: Tue, 26 Aug 2025 13:08:07 +0200
Message-ID: <20250826110931.264091236@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 44c0e191004f0e3aa1bdee3be248be14dbe5b020 ]

The function `_rtl_pci_init_one_rxdesc()` can fail even when the new
`skb` is passed because of a DMA mapping error.  If it fails, the `skb`
is not saved in the rx ringbuffer and thus lost.

Compile tested only

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250616105631.444309-4-fourier.thomas@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index f024533d34a9..bccb959d8210 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -803,13 +803,19 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		skb = new_skb;
 no_new:
 		if (rtlpriv->use_new_trx_flow) {
-			_rtl_pci_init_one_rxdesc(hw, skb, (u8 *)buffer_desc,
-						 rxring_idx,
-						 rtlpci->rx_ring[rxring_idx].idx);
+			if (!_rtl_pci_init_one_rxdesc(hw, skb, (u8 *)buffer_desc,
+						      rxring_idx,
+						      rtlpci->rx_ring[rxring_idx].idx)) {
+				if (new_skb)
+					dev_kfree_skb_any(skb);
+			}
 		} else {
-			_rtl_pci_init_one_rxdesc(hw, skb, (u8 *)pdesc,
-						 rxring_idx,
-						 rtlpci->rx_ring[rxring_idx].idx);
+			if (!_rtl_pci_init_one_rxdesc(hw, skb, (u8 *)pdesc,
+						      rxring_idx,
+						      rtlpci->rx_ring[rxring_idx].idx)) {
+				if (new_skb)
+					dev_kfree_skb_any(skb);
+			}
 			if (rtlpci->rx_ring[rxring_idx].idx ==
 			    rtlpci->rxringcount - 1)
 				rtlpriv->cfg->ops->set_desc(hw, (u8 *)pdesc,
-- 
2.39.5



