Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CDD36E494;
	Sat, 12 Sep 2026 08:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200899; cv=none; b=NaSV/TguMW1r8mgA6pKTmC2We7rYOgXhcnmwubUcu53Y7KEf6G8A7OZJqq36kl6YqDc479MLA++oIOmtORs3xhiQ55j/GmUAABj9LtGxnh9I5iQI2S7gMWYJdYxHCg2xEry4VgMSRv4RiH28OCZf2GaBYLSyFjg4EsGIUjz1CFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200899; c=relaxed/simple;
	bh=FeeGiVBwcKthpqfPN2Jt/8GMKY5VLmFFjHzmBj4LrYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUYQJ0UNjTBCmlU45PDoF+uUWzOD9SrnmBiLv/S0Jv1IagYjDQyHKsVlpvzOOfIp2EGVQp0s6XrV4cu5P/kAKS9z1UW+JUn/LLcrRMpQbaOKnMn1CsS3JPIJAAIqTmfGzkI2SMsfhUPb9dd/8DmRc6xJ7lsWeyGW82pk9HyGkKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGrAOzO0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGrAOzO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE07F1F00893;
	Sat, 12 Sep 2026 08:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200898;
	bh=huiVEDcWBFEGYHU6EfW1V7vyUpDcjEzx7FW98G55tg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGrAOzO0N17UMl5jISKv70jE11Gq0aIoypUKN3fkaMaFKSEn020kHy1qnS34a0fOQ
	 jt50GDStNpKe/kl7nE5tPpZ4ANo/gpQs1vLYUdJ3R4aisA+ZPXs+NJSuIOqEx9+hdK
	 KO1DQHr2op0QU+ykcKFUMoldavWJJVutKi2RBO+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0885/1815] wifi: mt76: mt7915: write RX header translation bit to the correct register
Date: Sat, 12 Sep 2026 08:43:55 +0200
Message-ID: <20260912065709.695836104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c5eeafef3a903..4ed3d808654fe 100644
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



