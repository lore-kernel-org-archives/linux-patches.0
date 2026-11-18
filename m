Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025835;
	b=Az9okMncYZAsD+/k4fdiuGD4Vc50M137vTkB/Mh/+4SrcLXF5A/ypT3okZ4X/iC3xSz/
	 ugZGqZRGLDVUSjY84VyiWoV1yO+dTSc9/aIRuAtxss0D+R/Oac6390ev4eW/sx8QH7a+3
	 dq0ae6TcfiTMdDXzteqNcvOsUHCeHdGamB+HfNxwTeFS4bvWa0qbViZrXYI+OO/g4Dafq
	 qBzegiRoI+lbqDiV+flpk9a62qfkUrc4ywueGMNS/JCMfNyhxShCO2SFsX7iCYJv/SwgZ
	 YZnhxCV4lydn99RVkk/8NQmKk781D3s7/OhI+WLJShdGX+KE+tOfvej0mFJrGqxOtmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BwC54fNmwaB0WjhakPCmIbALWRzRFHL3avtDL/yYaFc=;
	b=NSStr6ozvWIwVHzXEEU6fbYu2SDWEFT3Ur5RM4ORQS05CZc/lgDHsb37Tuvz1Of+pQBF
	 LXpgJQdQOSsU8qTPdlEIiZn7GNf32YJdLsboZFbHOXCG0lvjBP1sO4GDhOqRZT+zhO5Hc
	 GmbL7OSpc90nXCfcnMYyN21JG26myQp4ZR9hrBCLEX/58fdrlh1+gdqhZH5jXzkyBqyq5
	 a85YZbDfR7rzsT1SOhOwbII7VkDgT7MeBRsRKwpLK8Ww6Ae4MBMiq15aRxWyupHoz/9Sv
	 syKXszF5S84jgjDoPjwwBlN6zpaeKDqRn7cBhP/RYW8FwqrIdoxBF8oygxG0xFjjbbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zYsvske7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE396606A32F;
	Wed, 18 Nov 2026 18:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zYsvske7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5162B1F000C9;
	Wed, 18 Nov 2026 18:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025834;
	bh=BwC54fNmwaB0WjhakPCmIbALWRzRFHL3avtDL/yYaFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zYsvske7fTC97lsJHehntDDaU5UhtbgolS1R5KXuXXb4A3AAy/yLdwkrIJvl354kR
	 NP8i0CLaUh2kHSPr5zirjedD8tZWUprpS4SLLaIkrile9S3NQNMO2sc1HPULOQPiqH
	 QDcug6lV9eDcDW9fpjhZO4OOoZSaR717qaCyw6W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1220/2151] wifi: mt76: fix wcid->pktid corruption in mt76_wcid_cleanup()
Date: Wed, 18 Nov 2026 15:49:15 +0100
Message-ID: <20261118150206.640023286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit 158c1145fe7ddd82914011a00de7cc3262616b16 ]

mt76_wcid_cleanup() releases dev->status_lock before calling
idr_destroy(&wcid->pktid) to tear down the pktid idr. Meanwhile,
mt76_tx_status_skb_add() from tx.c can concurrently insert into
that same idr during tx completion handling:

	spin_lock_bh(&dev->status_lock);

	pid = idr_alloc(&wcid->pktid, skb, MT_PACKET_ID_FIRST,
			MT_PACKET_ID_MASK, GFP_ATOMIC);

Since idr_destroy() runs outside the lock, it can execute concurrently
with idr_alloc() on the same idr, corrupting its internal data
structures. Because idr nodes are freed through the generic slab
allocator, this corruption can resurface later as an unrelated-looking
crash anywhere in the kernel that happens to reuse the same freed
memory.

Fix this by calling idr_destroy() before releasing dev->status_lock,
so that the table teardown and any concurrent insertion are mutually
exclusive.

Closes: https://github.com/openwrt/openwrt/issues/24594
Fixes: bd1e3e7b693c ("mt76: introduce packet_id idr")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20260820-mt76-pktid-idr-race-v1-1-451f176a6495@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 9f70bef1749fa..668767029599b 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1746,9 +1746,8 @@ void mt76_wcid_cleanup(struct mt76_dev *dev, struct mt76_wcid *wcid)
 
 	mt76_tx_status_lock(dev, &list);
 	mt76_tx_status_skb_get(dev, wcid, -1, &list);
-	mt76_tx_status_unlock(dev, &list);
-
 	idr_destroy(&wcid->pktid);
+	mt76_tx_status_unlock(dev, &list);
 
 	spin_lock_bh(&phy->tx_lock);
 
-- 
2.53.0



