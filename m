Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124DA3002B3;
	Sat, 12 Sep 2026 10:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209267; cv=none; b=QxfDEBKYSrLwxZU+D/JGgGjDKF3MlnNaxQ6ey8fM69ZAIejw5UCbQBcpAmhWPIqGDp39iwpwo+6g4akEPII/UT8q0+DBUyoGRI27Hnqdq4nfEiGOOVWkrvorWZ+WK2fMzGxJ4u2R5q6SvXIx60e38qCj6KCmAZDDwdMq5yM4GiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209267; c=relaxed/simple;
	bh=e2g6pH5w/+U95uwRcdMzoFPfRZDQ8ILlerJQI9H/hr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkfnUgQts+JfjFhrSbu6qD+lFyM7dJ29ocvH0PCRJPjcRudp1qKiLaPoFHmESmk7NHOCHM1NxdKi3r/hMz/g+y471GGl1gsSjOBM/tnlTkOv18gFxmbLkn6eJPdFLUcpvfKE2q7w1HKxBmaSUnOIkCfEqSFM8yRX6Ydq40dPb/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iROINtHR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iROINtHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9DE1F00898;
	Sat, 12 Sep 2026 10:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209266;
	bh=y9JJUnEivhRb5GNRyOGw4wwVStGWkwCzAcuUExNH3Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iROINtHR+8nNaxiMLcjdXqFJeE8OgH/1WsFmQDG+12aH7xDFtP9BmV3+wXHyrahRj
	 M7UuDb+9Jc9t+g2KTvQQjMOB2IQHDGTHQ+QtlasT+qzQuy9e3BQbUxjZXhnc361TWl
	 oxvnRFs3dl3yBegi/9ha89esML2RMIilLor/Lars=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0743/1518] wifi: mt76: fix non-AQL packet accounting for MLO stations
Date: Sat, 12 Sep 2026 08:48:32 +0200
Message-ID: <20260912065640.240278635@linuxfoundation.org>
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
index 9fb0cca5524a4..ac6c0ca092931 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -311,10 +311,6 @@ __mt76_tx_queue_skb(struct mt76_phy *phy, int qid, struct sk_buff *skb,
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



