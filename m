Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590141;
	b=rXz26lbv8wzP991TvzMr8Wfb5I03o3BZqg+F8AsvkVZvwnfkjuJxJAQLRAwqdvVlsx4Z
	 rnCMiHSSNHbxe9tEYI3fJsuCR4me/paFT977jRsNoFZYgTbBRVymxcFxV0PsYH3hUGjzy
	 YHChkKyx8qXmnrbgWOKZG0PLs6efXsye8CNWhajSvEmXWwMNLAiWl+9T3dE6GTedZEFJ7
	 yRlyn1gKDJsJrkqEQneXiYHych3cjQgiVEh08u/dOczQOO/tEq949Qyc27D1itxKCJBDp
	 AUFQlCiTu2PqAtE1R7oZXflg36tqog1DJurlTzu2ivHrQSxMzPLIuAEeDQifqkYiaqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pZJSxCNL4z46/qB0AqiWbHr3qVgYy62FD+ctHGJ6NH4=;
	b=I398bYnkxmYMNgTdqlHv7E0GKiGsFL84Sj9tTI643QHh4HlK7D1ytZioccw/9l/qEaHT
	 7f2Rgg5XamBeWSni6XQPEkv/iHBom1xESc8mos+AMXL4Q2xMChm/yuVE9pKewZcOh5cUy
	 m8GIgGnA70zeJBw3HVo6zDhilGwuTW/aS36r+pUIkzrcnSXWcA9Pgrls9P/ynzyhNVULb
	 w8n9K0cdV6lf6FLulhpuS95vYh8oaoZh/zUIuTIFKQApuSztg8dnrQONX4C9Y3yXu1lIP
	 37fqbLL7LikTwwfIJAJI84om+oY0EYwhBDokFt4HHlZpv5LwJ6rh31trvvlKywfJVLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kssr1gcE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C137B60A6F5B;
	Fri, 13 Nov 2026 17:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kssr1gcE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD381F000C4;
	Fri, 13 Nov 2026 17:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590141;
	bh=pZJSxCNL4z46/qB0AqiWbHr3qVgYy62FD+ctHGJ6NH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kssr1gcE/ST/AX5fStDBgNALRKaNIsScImUN9I8Q7yBisqkfouulSfX+7ZpYCrgQk
	 yYnB/XUT8oAdMb3Kuub07ZILlR67ZN3Uuc0OsqYCa8Wp3pKPsVzS/OJJPcCLtuL39c
	 P5Gva4rOn3oZhP8hsr1MZgliisItIxHqw9+gZfzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 158/686] wifi: mt76: take rcu_read_lock in the USB/SDIO tx completion path
Date: Fri, 13 Nov 2026 10:44:51 -0500
Message-ID: <20261113153826.145668173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 0d48dbb2354f3..2af061a987f20 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -826,11 +826,14 @@ void mt7921_usb_sdio_tx_complete_skb(struct mt76_dev *mdev,
 	u16 idx;
 
 	idx = le32_get_bits(txwi[1], MT_TXD1_WLAN_IDX);
+
+	rcu_read_lock();
 	wcid = __mt76_wcid_ptr(mdev, idx);
 	sta = wcid_to_sta(wcid);
 
 	if (sta && likely(e->skb->protocol != cpu_to_be16(ETH_P_PAE)))
 		mt76_connac2_tx_check_aggr(sta, txwi);
+	rcu_read_unlock();
 
 	skb_pull(e->skb, headroom);
 	mt76_tx_complete_skb(mdev, e->wcid, e->skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index ce81ac1c2c635..4e41ef92d6239 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1476,11 +1476,14 @@ void mt7925_usb_sdio_tx_complete_skb(struct mt76_dev *mdev,
 	u16 idx;
 
 	idx = le32_get_bits(txwi[1], MT_TXD1_WLAN_IDX);
+
+	rcu_read_lock();
 	wcid = __mt76_wcid_ptr(mdev, idx);
 	sta = wcid_to_sta(wcid);
 
 	if (sta && likely(e->skb->protocol != cpu_to_be16(ETH_P_PAE)))
 		mt7925_tx_check_aggr(sta, e->skb, wcid);
+	rcu_read_unlock();
 
 	skb_pull(e->skb, headroom);
 	mt76_tx_complete_skb(mdev, e->wcid, e->skb);
-- 
2.53.0



