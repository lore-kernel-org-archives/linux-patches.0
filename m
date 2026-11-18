Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041025;
	b=EgZGXL/2IqVfNuaIGmfUwN7W6L5lFg8H0/k44lCbjKvLLFCHsjKyMn/3NQFYj7d0NUOe
	 3xNNxF+IkMiLJBiioqTDou1BXORCJzsATNNZmRPOmsPrQgOZmy06wcLUTskuZQCepz1yD
	 JpeWmXk8cAVXUQz5OPwmGWmcIIjd7n20PII2+W8F64azhQ2LWLYCGU9yuHG3G6V2BFPjg
	 yEnjeazhvovazoosk4i/Q87EKCMoA3cuXLL2AAl6W0cTq0mhpq9YahAJLXzPP3x57wGIV
	 8vCWAgCuyIBf2WvjzaPBIYs1K8urcTsqY+gIWDhyQ9Crmzfhq8UXA1rZnyTSkacG7+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NYMwQ6AvQHU9q62ZZmXu0QdnIIDWuTQgtO5w7Jm3NII=;
	b=F7Lo1VuM75E8ehrtNIIaYHD04sjjdsL6NAm27485l83zQEMtl5YFX1WOOADSrDDRtNN8
	 jZabZaHIPO1GzZg0G45QM+cwaZWK83tQUzKdD/3jNUrzntQUrvXg4gq1dKdZ7h2Cm2aUM
	 +hn+MQZcQZhTHSKqSqJcY1DRuhreIB/KPE/HFR6zzYGPHQp3GDVq5lQdy4p9eefYWh+Xx
	 mKw03ulSmEocF4X/sltY/+EiNVVK3Vxdc08xLofPYasq9kpjZQVZgwK1gMETdNhbmAztm
	 nPTKRD8IXU70dH94fGI3/L48C38g3+AFQ8KO3c5GWeAa48YY2uG/uBAPZQtoF2VDxeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsgAEOnu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF92606A320;
	Wed, 18 Nov 2026 22:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsgAEOnu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11051F000C4;
	Wed, 18 Nov 2026 22:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041025;
	bh=NYMwQ6AvQHU9q62ZZmXu0QdnIIDWuTQgtO5w7Jm3NII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsgAEOnuII7JpvcKqhZQmxqG/HVkn41UNglaYpwv/8gwsVMpVxudbi11WqHLgJb+C
	 z1x8NpExE+24Y4WPVKE2arAWk+UT0hrqqAMTVNQM/aGNZj4T3tXxnc7ULO7LePy1t6
	 8YZqNYgAJ01pJGfY53B1XVEL7hKfQwyvqgvRoTK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2665/3318] wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()
Date: Wed, 18 Nov 2026 15:54:47 +0100
Message-ID: <20261118150440.968277360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit cfb05250ded4d6de09dfd273c2a72092f48b55a3 ]

mt76_tx_status_skb_add() checks rcu_access_pointer(dev->wcid[wcid->idx])
before taking dev->status_lock, then allocates a pktid afterwards. A
concurrent mt76_wcid_cleanup() can run between the check and the lock,
letting a stale wcid be re-added to dev->wcid_list after teardown.
Worse, the check only tests for a non-NULL slot, so it also passes if a
different wcid has since been published at the same idx.

Move the check under status_lock, alongside idr_alloc(), and compare
identity (rcu_access_pointer(dev->wcid[wcid->idx]) != wcid) instead of
just testing for non-NULL, so that a reused index is correctly rejected.

Fixes: fcfe1b5e162b ("mt76: fix tx status related use-after-free race on station removal")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20260821-mt76-stale-wcid-race-v2-1-8f41ee96fb73@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 873d2f2bd840f..99df35fdd3a9c 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -129,7 +129,7 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 
 	memset(cb, 0, sizeof(*cb));
 
-	if (!wcid || !rcu_access_pointer(dev->wcid[wcid->idx]))
+	if (!wcid)
 		return MT_PACKET_ID_NO_ACK;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
@@ -147,6 +147,11 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 
 	spin_lock_bh(&dev->status_lock);
 
+	if (rcu_access_pointer(dev->wcid[wcid->idx]) != wcid) {
+		pid = MT_PACKET_ID_NO_ACK;
+		goto out;
+	}
+
 	pid = idr_alloc(&wcid->pktid, skb, MT_PACKET_ID_FIRST,
 			MT_PACKET_ID_MASK, GFP_ATOMIC);
 	if (pid < 0) {
-- 
2.53.0



