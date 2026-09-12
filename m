Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04C37F31F;
	Sat, 12 Sep 2026 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216816; cv=none; b=YIqYTjzHwStogsy2wYVJJltH/r20+FMXpFH6Dq2kfyh54suL61R64RWv+phDZTRa13fT/5C8DE4cj/EKvafXNqP3zw2AdPyWUhN8jZj/wEjpjxRkuGpVNEMBbdulQbjQQdELWbX7l0niteo8Y6RA1xhjlsbL9cvHlCRB+OA2Ppc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216816; c=relaxed/simple;
	bh=iFy2QhqN6yTOy3zcySG4FxK7Cs+nrOeeL1hKTt1l7EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFqyegDhOhKEidi/yhwAWXOFzh1AThvsEE6CNu6zVgcV3XRDpwKDf0inYiTvvtK7RbaLgoaf8+TBSsym56RDIYbzsqoIgodFzRN7mNd3g2cfGEOZxLgK+2jWwjlUmx6TL6YjlHMjc3uhniGLOmra+zkw6JFe6TwMHDTW1tQP/yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crfC4a8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crfC4a8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32401F000FF;
	Sat, 12 Sep 2026 12:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216813;
	bh=TEKcpB8+kcMW3JYPxdvtpYRd1YF6jbTQvoIYDg9FqAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crfC4a8Gas1CTRPk+Cw1/9SZC48uN9dp3oY36ovdPzLX+5gol+AxUDhXZqDSWBot/
	 E/x5JjQo133/A3mfAXRboBdVCPTj4Yj1xhqJgIDKsriL++DveMyQNVGYMcBzuGAlRv
	 LjThrms3a1cdvO0E4L4TeszRZBjhLELke4sk9vh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0813/1376] wifi: mt76: mt7915: write RX header translation bit to the correct register
Date: Sat, 12 Sep 2026 08:53:59 +0200
Message-ID: <20260912065625.662034334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4875f51472ed8..529926c287bce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -490,7 +490,7 @@ static int mt7915_config(struct ieee80211_hw *hw, u32 changed)
 
 		mt76_rmw_field(dev, MT_DMA_DCR0(band), MT_DMA_DCR0_RXD_G5_EN,
 			       enabled);
-		mt76_rmw_field(dev, MT_DMA_DCR0(band), MT_MDP_DCR0_RX_HDR_TRANS_EN,
+		mt76_rmw_field(dev, MT_MDP_DCR0, MT_MDP_DCR0_RX_HDR_TRANS_EN,
 			       !dev->monitor_mask);
 		mt76_testmode_reset(phy->mt76, true);
 		mt76_wr(dev, MT_WF_RFCR(band), rxfilter);
-- 
2.53.0



