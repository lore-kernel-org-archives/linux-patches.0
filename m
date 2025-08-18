Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EEE31E0F2;
	Mon, 18 Aug 2025 13:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522328; cv=none; b=J95sA9EmVQNNb9/9gdqMIVu63RvFD3BOnW3xlyhtzWiB0GA6boRFCCJ8nhNi8WFTm0w3jWWiAU6onzZ7fT0wVfBxtAefxDimJk/1BUVViyXtb8yAfJO7rb2fO6Eu0BUFMPPzlkwx5WDAZj5htQEWb/Ajr5Z6vKSytZLx0iAFBKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522328; c=relaxed/simple;
	bh=jyFzuMAG6WmVNF0BPNRguU1BqccO17jNULPynGhTiek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjGxtfsQw2ITjomJ40l68vHK8yrNg7v7FfI8cYw9kGLdcHxQ/s/vBHSaYD0xf6xep1nX0u4TBuoP3exCgJ8jBgZnrzoYV7k2XW/Gmay8G+GWwfOqZMUv+dBvJ9RFKiZ+LF4DQesVhl3lrluiQu15MPLCse9z6qDTTILX55nEurk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLQJqGH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLQJqGH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A729C4CEEB;
	Mon, 18 Aug 2025 13:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522328;
	bh=jyFzuMAG6WmVNF0BPNRguU1BqccO17jNULPynGhTiek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLQJqGH/QB9PS4rpPPdMoesBuhjGDgN46czV6YTkn0OtKrTxZFbi5UuTylvUPbMtr
	 yeZK2I8RyPqIc/oYZaNJOJ9L2AlxwcxrGFIyyPBbmdrJCm5AMuhUUtrlSwTv7loEOf
	 gpm7FNDVPiCt2LPZxC+72VWO6eCQzi03h0Fwc/mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/444] wifi: rtlwifi: fix possible skb memory leak in _rtl_pci_init_one_rxdesc()
Date: Mon, 18 Aug 2025 14:44:42 +0200
Message-ID: <20250818124458.429571005@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2741c3beac4c..d080469264cf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -572,8 +572,11 @@ static int _rtl_pci_init_one_rxdesc(struct ieee80211_hw *hw,
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



