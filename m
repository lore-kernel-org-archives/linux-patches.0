Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951AA34AB12;
	Mon, 18 Aug 2025 14:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525695; cv=none; b=gKGf56mzgR3tDD/0nqAGa5rHSnpoq0vOwGJsUb3vUFQ4r7YnQQuaxM24SMk/VxrYEz3vSNqPsYPQIfhvFvY3II2tdVPMhUEOPCjmFaeEJrJNyoVAOSYlj5HdzcgH4ZjBZTN6U8+6nzxCbrCTCT9a209q8KzKEwNmdDncv/QNYJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525695; c=relaxed/simple;
	bh=WkRRGDmkLZK1ilduUGRJHOiRU6aNt22/CJmFAsTZ6bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3fM7AeZu4Ab1bRMKL5qcBEeGya+wmvqkN0eNBEqestZ2aqfqUdz0IBymYZuJ29w4fc7LP4JSEFbG/mDuziCuy7i/oh+V5Eas3GAhRgA5GI69kyuOYHLEaRXMuDcKe6B66PoRk96XkRw1txbWZRrwMGEhRcJyZysIXsSj2RLaME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+r6FB/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+r6FB/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D9AC4CEEB;
	Mon, 18 Aug 2025 14:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525695;
	bh=WkRRGDmkLZK1ilduUGRJHOiRU6aNt22/CJmFAsTZ6bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+r6FB/vQakjFPASWQUvLVzQz1a0Bd4xB00ab/HBfJ7l7Te77Y7yzli5HP1eq9eLn
	 O4LaDeDhVmZJBnGDWWbwR7pAt1kZ3seBx+ds/exat69thtUDZm9R4HqPBMMxcLzFhJ
	 2M5Davtrs2CLXCIr0ajup7UQJ5uGVenXRMrgzO1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 338/570] wifi: rtlwifi: fix possible skb memory leak in _rtl_pci_init_one_rxdesc()
Date: Mon, 18 Aug 2025 14:45:25 +0200
Message-ID: <20250818124518.878424894@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



