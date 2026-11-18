Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031173;
	b=JI5yiWa5WxQBdmRZsqIcm4t/+d5+S79afYr7LkZA9dbFwTjhxh/X+nynZ7zFUp+Q2/QI
	 YZr7f+t00EB1XJ+zh0Y9J6DAp2UTp58Ksbgh3C3bd0l4M03sy2ZMXur6nut3vMtrHqIvb
	 LvLjEgZGa3Xf3zCLb1zJ4v15iFzNI46Hm8EPv8QMTpf+hBrmXjKBC03Knkg9CffOEXfd+
	 xN/lDzTMbYa0Z5yHGnyvFuubQHxGtRp1NAYXHKpPTOexqYVxiMwahsYsh/xEDBm6PGVHM
	 Q1eWc8ehZ8RpMERhoGdV5ADaeWmsfJIQcVbJaablQE9/vPYW4qdjCGji40mDxOYus4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y8rf3GI/F96YJPwMWVg5k7cv91ZR2TUnGeDjMP047hI=;
	b=WrxjNdeep9uEJBTQUMyd17eyq1JfKudH5kqbSmLSzj9kj9HVlJRRg7BT6nwbalGdubx8
	 yxD5i9qYaCL9Cl9csBvUiUN6rABxu2PTFh9YQaV4ZHofAD7Aa1CDZQy4dcm4XtXp7B974
	 +HruzkQmgiRGRZYDJPx4RVKPsKJB84lFnjbD0/RfOEIuJgoqtPXcniReCGosS2GQMnp2p
	 c4FsbMaJGRfvKY6SwZ24hqpwR/HRurSl3O04S2WokitQ8u6Sz7yLQA3nEcGi/VSWUp98a
	 lVBQVScL2jqZqcBRD0kD1F/Mk5Lom3BQ640kaU0b4wzGNfOM08YK26JWNCWXaJ4KMeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Yh03/AfB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9410D606A31C;
	Wed, 18 Nov 2026 19:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yh03/AfB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1D71F000C7;
	Wed, 18 Nov 2026 19:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031173;
	bh=Y8rf3GI/F96YJPwMWVg5k7cv91ZR2TUnGeDjMP047hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yh03/AfBpmenwxe+dr4i8s+cFfG9cl5I+zYbB0lwNWV5fNLTzHmUfkr9AoNHdKw1v
	 nYh0dwWNz63KQxuwuZAzefq9RnnlFnG1NqyKEdnbebzWG4HP8qR0WtcaDNOgoKwFsh
	 9gGEYtXacr+7LC0LL8+1BMUur+TWljNsWlxE7mjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0963/1756] wifi: mt76: fix wcid teardown ordering in mt76_reset_device()
Date: Wed, 18 Nov 2026 15:51:30 +0100
Message-ID: <20261118150048.420463168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit 5cebbd7a87df834efe002c8e54211e6adc99703a ]

mt76_reset_device() tears down each wcid's pktid idr before clearing
dev->wcid[i], which is the reverse of the ordering used on the
sta removal path. Until the pointer is cleared, a concurrent lookup
under status_lock can still find the wcid and access its
already destroyed idr.

Clear dev->wcid[i] before calling mt76_wcid_cleanup(), reproducing
the ordering mac80211 already enforces for normal sta removal (where
mt76_sta_pre_rcu_remove() clears dev->wcid[idx] before
mt76_wcid_cleanup() runs via the .sta_state callback).

Fixes: 065c79df595a ("wifi: mt76: mt7915: fix list corruption after hardware restart")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20260821-mt76-wcid-null-before-cleanup-v1-1-0e364d9062d6@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 13e6594945180..289c1a2815560 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -812,8 +812,8 @@ void mt76_reset_device(struct mt76_dev *dev)
 			continue;
 
 		wcid->sta = 0;
-		mt76_wcid_cleanup(dev, wcid);
 		rcu_assign_pointer(dev->wcid[i], NULL);
+		mt76_wcid_cleanup(dev, wcid);
 	}
 	rcu_read_unlock();
 
-- 
2.53.0



