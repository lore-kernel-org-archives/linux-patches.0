Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019116;
	b=fFKojCW6LZsofqTdyKOhJvO0X4p6G20rajd2XZ0tu7RF5IK+8g3X+nnswqa3XZt2kWO3
	 ikU6Lsir1wlqQfKVkCuQ9nszYZEVFZwjywwNCUFYYeOkTxo6QlL3g+bKSVIObZw+OpYFa
	 jVOTdXkSlZsa6Z5zxLXSnC+AYX9w028Kt2mYXACj27eJIOKy7rX2aHmyGHYpI1ioUtNrg
	 4vxqox++wlRXRiPQv7LMbtg8B5InpnMIclG64f0I5mcwOgcp5MMdd9xNs++LGduLIpihj
	 BnQAcHg0bJifOhnHx1wv+9sXpyyJo/aqUnyWF+IgAJsUzB44Y8SLf+1u2P47/vEoJfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J53+pkuMAE3yabyMGeYp9BI26SIXX4EFtw975M2m4VY=;
	b=YgJ/jnusex3uqtQsIU7L8MDgteyJWXErbewwjTETlNfLr6pZD2bWEVb7KPuBbj9+JJtz
	 tvcWVGvdH4YzJgs8ZwhnDIXM4OSjbiGN6hkoqVt/ALUNUDSKMV1GUcVWANX30KoMGorIh
	 swJrsX4HjhrY4uqAdN5U57kXgRWwBO8s8v+D00vtjaXtRBAK0ar0ewToEgw5xIkoI6GQ9
	 KjNECeXZtQWLYjTT6liFgYmXiSjcMJN9wpt8gyf/azMumuuy7K/7MAj3G30jkJBqBW0td
	 7NQoS+A2P0GWOG82AMYtrV726jWRD0Aa219+WbUjhvzCDOvO6Eo0ugWffVVLwubK2ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bnm+bddY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DB7606A331;
	Wed, 18 Nov 2026 16:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bnm+bddY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707901F000C4;
	Wed, 18 Nov 2026 16:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019116;
	bh=J53+pkuMAE3yabyMGeYp9BI26SIXX4EFtw975M2m4VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bnm+bddYt88c4GqJ5zNK2/wB/B0S317uoNjoRxXCbOxM9BUldxvc52PvRPq5Qo0qp
	 y3/EphynQc7YbTDjP+kRbFa6R6Ojxi04dMY6WN1p0JzEiCPfhuG/c3dCLgY2bhS1gC
	 EPKO840ByFt/Or18VS8gC1apx94fVigc+k0wt98U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1479/2651] wifi: mt76: mt7996: keep a returning link when adding station links fails
Date: Wed, 18 Nov 2026 15:45:19 +0100
Message-ID: <20261118150341.274015338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 6541956cadc484eeed719e7a8e9e7d27e5900289 ]

mt7996_mac_sta_add_links() removes all links that it was asked to add,
with flush set, when one of them fails. A link that comes back after
a removal kept its msta_link and may still have a firmware entry. The
flush frees its msta_link and returns its WTBL index to wcid_mask, so a
later station can be given an index whose entry still belongs to this
station.

Flush only the links that this call created, and remove a returning
link again without flush.

Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Link: https://patch.msgid.link/20261006205936.669125-15-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index acd2d15649df5..8a00ab49d90dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1362,6 +1362,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta, unsigned long new_links)
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	unsigned long created = 0, returned = 0;
 	unsigned int link_id;
 	int err = 0;
 
@@ -1379,6 +1380,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 				mt7996_sta_deflink_set(sta, link_id,
 						       msta_link->wcid.idx);
 			msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
+			returned |= BIT(link_id);
 			continue;
 		}
 
@@ -1412,12 +1414,14 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			goto error_unlink;
 
 		mphy->num_sta++;
+		created |= BIT(link_id);
 	}
 
 	return 0;
 
 error_unlink:
-	mt7996_mac_sta_remove_links(dev, vif, sta, new_links, true);
+	mt7996_mac_sta_remove_links(dev, vif, sta, created, true);
+	mt7996_mac_sta_remove_links(dev, vif, sta, returned, false);
 
 	return err;
 }
-- 
2.53.0



