Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614EE2DFF39;
	Tue, 17 Jun 2025 16:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177376; cv=none; b=uK96D0m8hEZJ/Yz+jibyZ0w9HS/1/5iw+EeNiKcAom1vTQnbN0ice/Ncx6jTblzaKMA9CJZU1yUtE1SlCnwvjiG+nZib6LZSdIUtd+8PMbGt0OmCdBxQJQS22Qjp/Ya0EcTyHpZAQH7eePLHKuQyij2BsW90s1RtxmRvzlQKIrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177376; c=relaxed/simple;
	bh=HDJ0jO1ccC9foagzA//Bn4ylTulhCDcvzxcxYkF03qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezKA4+7Zgljx2QjxifMWzpI+n3/iBmWoptzIAynCaL3SynUuDbLyUe4yDeVBAYqck+Pl178CgTNK5rxfKSft7LZ/vPO1hfMIkvM+We+4BbTkHxour+RuFFiklopBxtum0GG8FIy1QerNOdldYyZMC609sVxwt3YhJkeU3PailmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ze99fWbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ze99fWbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F77C4CEE3;
	Tue, 17 Jun 2025 16:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177376;
	bh=HDJ0jO1ccC9foagzA//Bn4ylTulhCDcvzxcxYkF03qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ze99fWbiPd5SqjTHhwaamEDtCvGE8FjwH511HFbQX/35MBOJHfdHLZJr+Z6hJU9KC
	 NN2skdQDdksmzct4cw8lJDGbx3FknacZJCqZ7TfjZoUcfEl+u5MAhd+5u0ztPm0CSy
	 RBiliZXTQ/M0u7NbR8fFmZ9TiioaORChIUWxogaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 297/780] wifi: mt76: mt7915: Fix null-ptr-deref in mt7915_mmio_wed_init()
Date: Tue, 17 Jun 2025 17:20:05 +0200
Message-ID: <20250617152503.561591550@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit efb95439c1477bbc955cacd0179c35e7861b437c ]

devm_ioremap() returns NULL on error. Currently, mt7915_mmio_wed_init()
does not check for this case, which results in a NULL pointer
dereference.

Prevent null pointer dereference in mt7915_mmio_wed_init().

Fixes: 4f831d18d12d ("wifi: mt76: mt7915: enable WED RX support")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://patch.msgid.link/20250407061900.85317-1-bsdhenrymartin@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index 876f0692850a2..9c4d5cea0c42e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -651,6 +651,9 @@ int mt7915_mmio_wed_init(struct mt7915_dev *dev, void *pdev_ptr,
 		wed->wlan.base = devm_ioremap(dev->mt76.dev,
 					      pci_resource_start(pci_dev, 0),
 					      pci_resource_len(pci_dev, 0));
+		if (!wed->wlan.base)
+			return -ENOMEM;
+
 		wed->wlan.phy_base = pci_resource_start(pci_dev, 0);
 		wed->wlan.wpdma_int = pci_resource_start(pci_dev, 0) +
 				      MT_INT_WED_SOURCE_CSR;
@@ -678,6 +681,9 @@ int mt7915_mmio_wed_init(struct mt7915_dev *dev, void *pdev_ptr,
 		wed->wlan.bus_type = MTK_WED_BUS_AXI;
 		wed->wlan.base = devm_ioremap(dev->mt76.dev, res->start,
 					      resource_size(res));
+		if (!wed->wlan.base)
+			return -ENOMEM;
+
 		wed->wlan.phy_base = res->start;
 		wed->wlan.wpdma_int = res->start + MT_INT_SOURCE_CSR;
 		wed->wlan.wpdma_mask = res->start + MT_INT_MASK_CSR;
-- 
2.39.5



