Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDAF3101C1;
	Mon, 13 Oct 2025 15:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369759; cv=none; b=WkCEvr9gJgoioadi4E50xbsAJ90UnCl4qc1HcR7kirRXNVes6i0Yyik0LAdDzrz7+g+UsqWC7j3q6YEtj6kTbyQ0ndsNN/zWUr2Wjn/06DO0nMXPRv35WxV5Ffn7u7mGU+fmCsnPZcMAo1dQW2hLpj1B5IVPRvxEmrkIJicAouM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369759; c=relaxed/simple;
	bh=PNIly1AwGLKjcVoQ0OPaj6pLyIdVImNZb7g8K69QqD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlBdswY2743cJauqScmGZqvF2SqOeMc7SdvXEBrETxhe/n76DdyiIaaw9UJyshe/Jf5rLOGRB20Yzltjr/ntiNoCAb880e7AJXcGv+ezbr0xqsT7yj08Om3Nv77EvFBTe2Y0PHHeVF0Gf6ES+M91SvmI4MNOh7g22YhQRzENcQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pN36fEDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pN36fEDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84AAC16AAE;
	Mon, 13 Oct 2025 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369759;
	bh=PNIly1AwGLKjcVoQ0OPaj6pLyIdVImNZb7g8K69QqD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pN36fEDKpegaIYsmGELD6TMgrfmmJqr8DA2t2JdINRTu5ryCHGfAzptEid8ycFDXC
	 09HVRs6+P21/O02mlVjyxfQLhR2b4rQ98xiiJ3Ln56+LgnhzLbC0qxlJulsDsCj9mu
	 eopObsIjbB2vf0s9qa3JhXNLCqX67xuTvdik0J14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 359/563] wifi: mt76: mt7996: Fix RX packets configuration for primary WED device
Date: Mon, 13 Oct 2025 16:43:40 +0200
Message-ID: <20251013144424.283337899@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit cffed52dbf0ddd0db11f9df63f9976fe58ac9628 ]

In order to properly set the number of rx packets for primary WED device
if hif device is available, move hif pointer initialization before
running mt7996_mmio_wed_init routine.

Fixes: 83eafc9251d6d ("wifi: mt76: mt7996: add wed tx support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250909-mt7996-rro-rework-v5-9-7d66f6eb7795@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index 19e99bc1c6c41..f5ce50056ee94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -137,6 +137,7 @@ static int mt7996_pci_probe(struct pci_dev *pdev,
 	mdev = &dev->mt76;
 	mt7996_wfsys_reset(dev);
 	hif2 = mt7996_pci_init_hif2(pdev);
+	dev->hif2 = hif2;
 
 	ret = mt7996_mmio_wed_init(dev, pdev, false, &irq);
 	if (ret < 0)
@@ -161,7 +162,6 @@ static int mt7996_pci_probe(struct pci_dev *pdev,
 
 	if (hif2) {
 		hif2_dev = container_of(hif2->dev, struct pci_dev, dev);
-		dev->hif2 = hif2;
 
 		ret = mt7996_mmio_wed_init(dev, hif2_dev, true, &hif2_irq);
 		if (ret < 0)
-- 
2.51.0



