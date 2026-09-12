Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E003FF1AE;
	Sat, 12 Sep 2026 12:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216786; cv=none; b=AygME8j5pZAalI71AobNbOStM2Yl8KZte/dHWfmojN7Q1F/PrMQ32csYO4oZkZ3fPDZAEq+bZe7HDWL2zyAaZsT92I++nngd904vnLnQYoW4l+0DVBl0wpmPZd/AQL56OfqSoygYz85bg6rdy10I38mk90APu3PQYy57L3pkOxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216786; c=relaxed/simple;
	bh=Fwm1tCOAsEi77zL4qFXpyVRGyraSi6wz+DKm58SfjHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8uzaseZzro+Q0bByyYRmZ5lEyxSVWy/uzx3oJ1Vg5PmSQiMtgfPh6otfzj5NkEr9WrdRYiYiqFf8XC69v6GNeoRnbIjK3vtW3hXZUhlRIoAoimZLfq/FRI579BD2+rjNtRPuecyGO0sM/oa4Z7LRwZUBXPtI4UC8LTsm9OWrTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnKEdZ0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnKEdZ0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3EB1F000FF;
	Sat, 12 Sep 2026 12:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216784;
	bh=Q2buD6jQMpAd3duRjTh0cJ+tXiBJWPbFyZUMh/oyUpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnKEdZ0ohZ5qbHVppxMZ27tTZ8tTmaBamacIRYkNTgChQ/gAQtAZfzCTFT+DQ8TIS
	 JThAbH5YZEk8ocusx8a7AMgfe8IIBDw2zmNHa76qh14X700fOArSoMERk3raXU2Wb0
	 ffNZQGa1OWpZI6BWQ/G8og2J87TsZkGDzWYDF784=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0807/1376] wifi: mt76: fix non-AQL packet accounting for MLO stations
Date: Sat, 12 Sep 2026 08:53:53 +0200
Message-ID: <20260912065625.524535090@linuxfoundation.org>
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

From: Michael-CY Lee <michael-cy.lee@mediatek.com>

[ Upstream commit 8ae659743ba936b22ecb4620815887728e2820d6 ]

__mt76_tx_queue_skb() overrides the wcid passed by the driver with
sta->drv_priv, so the wcid might incorrectly be changed after TX,
causing wcid->non_aql_packets to be counted on the wrong wcid. For
example, on the AP side, if a station's setup link is the 5G link and
the station uses 2G to transmit a frame, the value of non_aql_packets
is increased on the 5G wcid but decreased on the 2G wcid. Once the
inflated counter exceeds MT_MAX_NON_AQL_PKT, the TX scheduler
permanently refuses to service the station.

Drop the reassignment and account on the wcid used for transmission.
This also records the actual wcid in the queue entry.

Fixes: e1378e5228aa ("mt76: rely on AQL for burst size limits on tx queueing")
Signed-off-by: Michael-CY Lee <michael-cy.lee@mediatek.com>
Link: https://patch.msgid.link/20260722082610.2699628-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 634b6dacd1e0d..1184357d933d2 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -313,10 +313,6 @@ __mt76_tx_queue_skb(struct mt76_phy *phy, int qid, struct sk_buff *skb,
 	if (idx < 0 || !sta)
 		return idx;
 
-	wcid = (struct mt76_wcid *)sta->drv_priv;
-	if (!wcid->sta)
-		return idx;
-
 	q->entry[idx].wcid = wcid->idx;
 
 	if (!non_aql)
-- 
2.53.0



