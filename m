Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E41C34DCD4;
	Tue, 26 Aug 2025 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216316; cv=none; b=r4jX291PCmmPV0i/wpP2mxY45RY+ds6cf65h301w1M1Ew8keThwVjPM0pyy/iWrKHFMPbdvDsSN179ohaCcOBag07Wwz/Tv1/Ee2cvhHyRzTRg1Kz57yHYtAwB1HDvoIAjMgwbb2HJisU/gpriGCd3JrhTmuABu6+ts7UKB5FYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216316; c=relaxed/simple;
	bh=LZ6qn3vuk76ZdLBwel7cFDqfnEZWWP8BqwoxZcURafs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJOi0q3JLMxtc54MnA2j5x4S0YtdKj3dQBPrqKAX5tnsSFfQBy31ckElGsqGJ4vjjj16DzH2HOqerbhNOivpO8kiETwXGhdfR0GlCdX+9WRVqon6YqiEIXtWQ/nrE4YGWoZu+6GqWtw7+DajQzXaLrNzv7AFdRQGwXMzdsWp8CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNjXMjZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNjXMjZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E9BC19421;
	Tue, 26 Aug 2025 13:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216315;
	bh=LZ6qn3vuk76ZdLBwel7cFDqfnEZWWP8BqwoxZcURafs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNjXMjZGWrYqYdmuSTq99z9yexEzrp/McBdNDknq10gZTlYJ8RYwxNkypJRKfsmaA
	 UUEXs8PDlGNFC4mPKug9HHsBCfICbEjT4+kjq8ipHoYPgisNZ+R5qk30eZxG6iyq//
	 3kRxNkx8RbmI4Bz0II8/sE68PFctSPxX2pVvSFoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 365/644] wifi: rtlwifi: fix possible skb memory leak in `_rtl_pci_rx_interrupt()`.
Date: Tue, 26 Aug 2025 13:07:36 +0200
Message-ID: <20250826110955.459602694@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



