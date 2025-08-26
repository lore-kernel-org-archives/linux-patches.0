Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D770733EAF9;
	Tue, 26 Aug 2025 13:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214503; cv=none; b=TD2cUNrfaIIIeWdtHWKQo9+8mOWyD5fJJLYZ+Y/DT8NY9ZHU0pfYFO+Y1IwYTjvFAbAssxJD1tiPbd9qd4xyyp/NpQfinheo9oPtmrQlq2UKWjvx0zn76HwFA3AuXiTHeWLcHV+AZLYTy9QDT3dLLJjiTqYns2GF9uaa82fFxrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214503; c=relaxed/simple;
	bh=r2KeabzwCcFLy1g+XYz71rGoyZy6jej7D/bc0q3uFng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLhCC3yxH+pxZI8of6e9XIUpC6HGLtMzSzj8ZvEqx/2ZtutoenAPPAFwDaztI/Kot3Hw9Mqf8uW1h8V/Q2DMivxs0iNhJxddQeK7AqjWfghdY2VEMXw0qLdDilmoEdxmDkyJqhIRrjb+rOxlwm5wCdgjbedRSmM9R5H7LTtcKt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19/zS+ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19/zS+ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A21FC4CEF1;
	Tue, 26 Aug 2025 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214503;
	bh=r2KeabzwCcFLy1g+XYz71rGoyZy6jej7D/bc0q3uFng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19/zS+ba6gbdp1DzcpFnbgSvLMhQnw2HXjymz+C1k1MfIutjuPnrxry7PNhh7ypv4
	 Bi9vqnXkJ+mlnuT7HaribfAjmoBb+vGkgSyWqNaH2F1tnOhi9nee1jWanY015njS+h
	 /CdQgxq4Azo8iweu2W5VrYMBFDy+mj4bhmvHbvqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/482] wifi: rtlwifi: fix possible skb memory leak in _rtl_pci_init_one_rxdesc()
Date: Tue, 26 Aug 2025 13:06:56 +0200
Message-ID: <20250826110934.838822896@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f796b16eac53..4029e4e590fa 100644
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



