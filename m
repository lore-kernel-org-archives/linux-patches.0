Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A203314DF;
	Tue, 26 Aug 2025 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217814; cv=none; b=hQ/Ho9w4WtV2QIAwtJodGkqg1wkMuplWsc87bn//PhZ0qfsL23m3OiwIoWQnOuWcYult51U0FCAkOlTPTOkBUcAGqkLwQS8A/pPZBGFRRM21LawhmXkFqujLNmS1UKTBkxiKGsocuaEfN7M2yt3+zTzWQl5uDJ0HPaLSh3SiO/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217814; c=relaxed/simple;
	bh=daceeWO+Jdr6U7/rLJ7cncT4A0wccqMMwgcFjMADs54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkQj+scDozSGmyTd3CwX1+lUbMm1oofgNcFbdkDM2scia+Z//N22rby4PjefQy5VbalXPcJkwaQ/QPoTHkvuyp5D4Y1KMjYxKB6NWBlChE+m2xRDZ/62o19vr+dkhuVP153+Hhdmg7ekefvUNue+ZNsflo9z/hxHl3MVEQ7Lhjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOYNAOK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOYNAOK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397C4C4CEF1;
	Tue, 26 Aug 2025 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217813;
	bh=daceeWO+Jdr6U7/rLJ7cncT4A0wccqMMwgcFjMADs54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOYNAOK6T3RDVs+7fRGmP/nqL/E1p74mKKi7335FJ5cG5H4kf4RdYEHSgUc/7zlv/
	 Yj4l9KteplF8e0pw3UjLcGiKitIV21mezFf4by9lbREtKczOr2YLp2H3OlXBdFz/w9
	 FmeQBlaehUIEzCcyU/jAwEz9vuf5jSiGiQHUaCZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/523] wifi: rtlwifi: fix possible skb memory leak in _rtl_pci_init_one_rxdesc()
Date: Tue, 26 Aug 2025 13:08:15 +0200
Message-ID: <20250826110931.470103649@linuxfoundation.org>
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

[ Upstream commit 76b3e5078d76f0eeadb7aacf9845399f8473da0d ]

When `dma_mapping_error()` is true, if a new `skb` has been allocated,
then it must be de-allocated.

Compile tested only

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250613074014.69856-2-fourier.thomas@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index bccb959d8210..02821588673e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -573,8 +573,11 @@ static int _rtl_pci_init_one_rxdesc(struct ieee80211_hw *hw,
 		dma_map_single(&rtlpci->pdev->dev, skb_tail_pointer(skb),
 			       rtlpci->rxbuffersize, DMA_FROM_DEVICE);
 	bufferaddress = *((dma_addr_t *)skb->cb);
-	if (dma_mapping_error(&rtlpci->pdev->dev, bufferaddress))
+	if (dma_mapping_error(&rtlpci->pdev->dev, bufferaddress)) {
+		if (!new_skb)
+			kfree_skb(skb);
 		return 0;
+	}
 	rtlpci->rx_ring[rxring_idx].rx_buf[desc_idx] = skb;
 	if (rtlpriv->use_new_trx_flow) {
 		/* skb->cb may be 64 bit address */
-- 
2.39.5



