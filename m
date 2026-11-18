Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041086;
	b=c4Z8O/4F9wXerWLgpYnFZtnYHgf5RnfdhiLPU0hguJZjfHryrsqeLe71ilXI2I7eIx5d
	 YDOAAMQufvkofJcFtpTwXYlLuJA2TSwxThq9/E6dZU5OmPJjTrNM7w0u1IqUj2nDDvMn+
	 5GSzMyXF9z7EdTNGL8Se5CBo5nEJOlQfvsRs2b+MhCF/jXOPWxf0Uh43Rapig+AQsTV7B
	 ZGe9zyMHFgIpgrkNkhhxe2olqzWxBXsmY5O/fvWQGCMW7go9SsllZZ3RZACFvvsScXC7f
	 4LXqCv7D6vjFATwOtfa/Bqa9zt0L7zm7I+V+44Y1HbG7AnP4gRdmqDp/ExmIhAYOw/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XW0PtkrY6LX8V7eIVHSrjTgwZja0Sq6JgPYhA3ZejJU=;
	b=vPf3rqh3Euf4UVZUhE7T1CiwwIY6CiXRm/FQXDhQecWPTUuJOHeAKVANwLk7oz4jOKqI
	 t42D5Udt/mhulhl7llfuDYa1Ij/vHsDxNPTQrhBeIYeTnl6Vd2QaKF4q92IziL21mcfwV
	 OS8qin23C3BttGuv8p4nHDqyQtg/Al/u5/0MGadT/ViNtNr/eqJ9uP7Ky8MXQYt993IVS
	 1/UVzkiJF7IqEa5GeJDdLxCVThZpyn8eZnXJGMtH3F7wRfJEDDbVJ5bVUHyTshEb7SQhS
	 y2nOQLq5KpoWy44Vo4jc7YsidbOyLkuLCu6IqP7fWhHS82NUbB/Hqj7hPi6jea/L/iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o7jzETjV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD0C606A320;
	Wed, 18 Nov 2026 22:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o7jzETjV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7F11F000C4;
	Wed, 18 Nov 2026 22:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041086;
	bh=XW0PtkrY6LX8V7eIVHSrjTgwZja0Sq6JgPYhA3ZejJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7jzETjVuv2P0w8ie1rM8Zztir7x8ng4U6Cs0bXFDyPJut3QvRAaS9Qfy1nxVqTPK
	 Qsys+73k08zFMcL9D73HjGVNUBvaed3BLMhV5PqjRHzVykFC/UMxpDAqGgjTHKSU6t
	 +hJHGJjZBM9iQbLhJ2oo3bHUaMbn7i16UYahbPCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2671/3318] wifi: mt76: fix wcid->pktid corruption in mt76_wcid_cleanup()
Date: Wed, 18 Nov 2026 15:54:53 +0100
Message-ID: <20261118150441.137378364@linuxfoundation.org>
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
index 2d99b1c382bd0..1d28d26a45ad3 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1561,9 +1561,8 @@ void mt76_wcid_cleanup(struct mt76_dev *dev, struct mt76_wcid *wcid)
 
 	mt76_tx_status_lock(dev, &list);
 	mt76_tx_status_skb_get(dev, wcid, -1, &list);
-	mt76_tx_status_unlock(dev, &list);
-
 	idr_destroy(&wcid->pktid);
+	mt76_tx_status_unlock(dev, &list);
 
 	spin_lock_bh(&phy->tx_lock);
 
-- 
2.53.0



