Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2550637AA97;
	Sat, 12 Sep 2026 08:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200861; cv=none; b=itKK7yqOphxicJBswfoesKXtMJoHUrb/CBJRSrbb1OoP7DFdfF9fwp/2lqALX1GtbrJWVsBiJ9AxdoRxb6wkm/lbyi2WLku12PD/4qw0jD7gCGNXevXec9uWNYpef1pdtSH6QOR9R3WrE1+lZb5PyjP+tAGF4kXbOISqhu+I4Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200861; c=relaxed/simple;
	bh=JarGNWNZm7m4NXSqKKiRJIfAS4dEURdo1gOtGP6wihE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wn9MaZddJ4ptcFLmTO8EAiWhYdK1IrA8vmHdkzs7oqlVJBCQiHJ0/ImqjOSNnt/Xop5LEN5go3YW7I0U+In8iAgwAmI9Tyj1ISV1zvepLDvYGo1ejV2WwdMqlFvAvjk1MWt4sgrbV/d01CAHQ+ho5iCdRqhayslnmwFVA3qb4t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwJyU230; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwJyU230"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204451F000FF;
	Sat, 12 Sep 2026 08:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200860;
	bh=KrpaAe1jMgfTh2/jfpShA4oU/IJmCH9NadFKbwFpgFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xwJyU230zP6GZjhugj0iXCLW4ZN5Uupzg2y1j96dpwRAGc5/v61KnkGDjaRsYO3QA
	 la2FcniaPXq97NA7oawtRM0LXycb6D2LFiOFRRYMg82fCDO9YPllRRML08bYDHya6o
	 RyWkEVnIvt5pj6K/O1vSJxPHyijDKYUTolZP8Y7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0878/1815] wifi: mt76: fix non-AQL packet accounting for MLO stations
Date: Sat, 12 Sep 2026 08:43:48 +0200
Message-ID: <20260912065709.533774884@linuxfoundation.org>
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
index f96d9c4718535..de8af32f15e5a 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -324,10 +324,6 @@ __mt76_tx_queue_skb(struct mt76_phy *phy, int qid, struct sk_buff *skb,
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



