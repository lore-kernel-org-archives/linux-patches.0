Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C702F34AB14;
	Sat, 12 Sep 2026 10:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209085; cv=none; b=SVejEVKdJ6JjJBL34TU7fzRTovb+giMQbZfe/BCFABjchdW/CRd5mzVICXm9GqFX+uqZmifbW1L7IE+pLR0BTDGpLnxwORrNkcBBmYO0D5PhD0ulblRORmxtwNX3v7KFLOmPHGzwbDhIE52wH0EnRzp0QB+w4aNV6sdC/KOuE3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209085; c=relaxed/simple;
	bh=oYAhfMykFKBKxMdBh3fgWVie9UUEFqF4h1/LOuwJryE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnReoiI2GCTayF26Bnq7sjNwXWMRWOlY8YhgDFPBVP5EG+kPNusToTNFzSwYnmTCP1oz6pY4yA7eUBMqb9xZ+0EnKWWPlhq8X4rlp49awu76Zoks+BnrNoWPSvHEe2wyGiR31HFQV9wv+BhDS0R5tBn9ScODv62GBaLmB4gfouc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7VH/3CW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7VH/3CW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DCA1F000FF;
	Sat, 12 Sep 2026 10:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209084;
	bh=HFJDLEsKt1hesTQES7HMYqHLXbKDN0rVP+/toZVdiUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7VH/3CWLKnhfHpPktvCYUt9lUvia3bqb6ye2iYpN/Ymw2Udb0Y8qG4MhCMiVjpz2
	 nkeZg/RhvRmXnjilf3S30/50hZDV7ms1RMAYeKY8YvG29YU+oP8J8QOsoPC4zAnsS2
	 B5RUHNDRZ8Cz4N45dxe9kkcHjrqvHySZjTNIYz5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0750/1518] wifi: mt76: mt7915: write RX header translation bit to the correct register
Date: Sat, 12 Sep 2026 08:48:39 +0200
Message-ID: <20260912065640.397805191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 236145737480c4c0c515e09061d0d5f77cf52d3f ]

MT_MDP_DCR0_RX_HDR_TRANS_EN is a field of MT_MDP_DCR0, but monitor-mode
handling applied it to the per-band MT_DMA_DCR0 register instead. As a
result RX header translation was never disabled in the MDP when entering
monitor mode, and an undocumented bit of MT_DMA_DCR0 was toggled. Target
MT_MDP_DCR0, matching the mt7996 driver.

Fixes: b2491018587a ("wifi: mt76: mt7915: fix monitor mode issues")
Link: https://patch.msgid.link/20260722082610.2699628-11-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index d6d90d305ab91..4b11e0845f568 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -493,7 +493,7 @@ static int mt7915_config(struct ieee80211_hw *hw, int radio_idx,
 
 		mt76_rmw_field(dev, MT_DMA_DCR0(band), MT_DMA_DCR0_RXD_G5_EN,
 			       enabled);
-		mt76_rmw_field(dev, MT_DMA_DCR0(band), MT_MDP_DCR0_RX_HDR_TRANS_EN,
+		mt76_rmw_field(dev, MT_MDP_DCR0, MT_MDP_DCR0_RX_HDR_TRANS_EN,
 			       !dev->monitor_mask);
 		mt76_testmode_reset(phy->mt76, true);
 		mt76_wr(dev, MT_WF_RFCR(band), rxfilter);
-- 
2.53.0



