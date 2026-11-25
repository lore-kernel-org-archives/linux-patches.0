Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625135;
	b=AopJbaTvXOCz1EhH0K+306GM/26+ckOG7K1T3GBs12u4jlfq7HHg4G1UlosHDPIqcWAd
	 9nYd9C3Yz4Te1Hjo8jxXeOx0EzcsfQHIQZWgZ7pKMn9nruDbMBLAlMSRN+uD5x12arILN
	 0J0rP2uPjE0ScMnKD3dnTJ6JWVa/2tCVRz0kj9J9Cv6QYJoGP7dvHAAcFCdj7IizH5YhH
	 PydenE11hxPJH45faLT4fiD78vZYQq/bUv0G4b4D+r21ydXChYM1cFbsMlGhIW0WBR6Ed
	 fj+fbSQg84sVs+BLRY8Ac5JmkTiqnGRGixne4PDeGtWdRS1jNT3SM3yIlLezIJVC+xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Knb856X/DjSnNNXJdFLRn8K+/axHBBUXQYJswen2hDw=;
	b=xjXTVGRq8qy4LIgwockVA8hlrjAGx74kSbkwKJDUXkZGotv7qgALqLkwWDtWd4zwXwDD
	 GV6NVVCkIDhdzuDNGTayo8vVpLk9VsvmzoY2c+8he5arfKVWZ7xBk7QXrkdZE7czQqAjn
	 alQ3Yp3QJ6kkVwZoKGvO/yxUJ3/Abdu3by8u/2zcycw0WQnP0ZZkpwmpn3wfwKm5PabZb
	 kNX0s9xuw/sGa6xACrJx/GWUHtXZlvvIzytaaLz4vq/zeF8uaMczWWxwjFAuzGVfOKAuC
	 IUFHVu44C40Ygye5qz4+eYxRf2jYyOrtiX/LBwjNaSgBKDaJE4Q2aw/K0pe0FuN0QQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iO7cbM6K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5567606A321;
	Wed, 25 Nov 2026 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iO7cbM6K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408EF1F000C4;
	Wed, 25 Nov 2026 16:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625134;
	bh=Knb856X/DjSnNNXJdFLRn8K+/axHBBUXQYJswen2hDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iO7cbM6Kl+IEoTwLmsMSefG5MiGCI5XsY7f13yr0LF68L2zjk6KpIlGcQAUJ1kuhV
	 CuFaIYPSvAxX1gnHiFymzLhRgB305kBYVXCPKROkSXLTT+G9dqsPlNumaCt+zfihsS
	 zCi6nP6JyQd9L7qmq3AvQcnvrLVA6drUPvoFuYlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 373/816] wifi: mt76: take rcu_read_lock in the USB/SDIO tx completion path
Date: Wed, 25 Nov 2026 15:32:01 +0100
Message-ID: <20261125143857.830620707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit a7871a7ae5a8625f0ba0a89454ac734c383dd538 ]

The USB and SDIO completion path reads a station pointer that RCU
protects, without holding the read lock. Lockdep catches it on the
first association:

  mt76.h:1305 suspicious rcu_dereference_check() usage!
  no locks held by mt76-usb-status/1254.
   mt7925_usb_sdio_tx_complete_skb+0x119/0x130 [mt7925_common]
   mt76_queue_tx_complete+0x27/0x60 [mt76]
   mt76u_status_worker+0xed/0x1e0 [mt76_usb]

  mt7925/mac.c:856 suspicious rcu_dereference_check() usage!
   mt7925_tx_check_aggr.part.0+0xc2/0xe0 [mt7925_common]
   mt7925_usb_sdio_tx_complete_skb+0xa0/0x130 [mt7925_common]

mt7921 does the same, and warns once instead of twice because its
aggregation check reads the default link directly. The DMA path makes
the same reads but completes from softirq, so it stays quiet.

Take the read lock around the lookup and the check.

Tested on 7.2-rc5 with lockdep, fresh module load per arm, 4000
packets each and no change to the link:

                             splats before   after
    MT7925  Netgear A9000          2           0
    MT7921  Alfa                   1           0
    mt7921e same kernel            0           0

Fixes: dc66a129adf1 ("wifi: mt76: add a wrapper for wcid access with validation")
Fixes: c22769de2509 ("wifi: mt76: mt7925u: use connac3 tx aggr check in tx complete")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20261003233056.94497-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 3 +++
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 6da67054e521d..89df72e20598b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -832,11 +832,14 @@ void mt7921_usb_sdio_tx_complete_skb(struct mt76_dev *mdev,
 	u16 idx;
 
 	idx = le32_get_bits(txwi[1], MT_TXD1_WLAN_IDX);
+
+	rcu_read_lock();
 	wcid = rcu_dereference(mdev->wcid[idx]);
 	sta = wcid_to_sta(wcid);
 
 	if (sta && likely(e->skb->protocol != cpu_to_be16(ETH_P_PAE)))
 		mt76_connac2_tx_check_aggr(sta, txwi);
+	rcu_read_unlock();
 
 	skb_pull(e->skb, headroom);
 	mt76_tx_complete_skb(mdev, e->wcid, e->skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index a8d0cd09184e3..876236888519f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1482,11 +1482,14 @@ void mt7925_usb_sdio_tx_complete_skb(struct mt76_dev *mdev,
 	u16 idx;
 
 	idx = le32_get_bits(txwi[1], MT_TXD1_WLAN_IDX);
+
+	rcu_read_lock();
 	wcid = rcu_dereference(mdev->wcid[idx]);
 	sta = wcid_to_sta(wcid);
 
 	if (sta && likely(e->skb->protocol != cpu_to_be16(ETH_P_PAE)))
 		mt7925_tx_check_aggr(sta, e->skb, wcid);
+	rcu_read_unlock();
 
 	skb_pull(e->skb, headroom);
 	mt76_tx_complete_skb(mdev, e->wcid, e->skb);
-- 
2.53.0



