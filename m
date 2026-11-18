Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018941;
	b=xPPBLuZg656svDySbm9v0AcfayLL90dCt2OcMz0FjF2YoN05SBxaLPNt0BHjqATRl+ip
	 1T71KsyHGKsColZIM6bbkvFfZP4UL9VLZ+Dg0POsWZuk3z4GcL8ucOML++mo5d3l509DB
	 LwnJboz0XoTgD+OWRnMO6tIbywzFHS+4x0AGIv3tUpBvmubGX6XXgjkeBnEk4q1/vMrcs
	 yRIF8FEFz9poN//Lz7lwalvcVsTKAQpbffzMTbPiIJ17qgsc09jPFwNKusmNYxCNR7aYD
	 nMO15CdzP+Kgfx2z9/K/5AWFZicpY3sdJ5zrUwtV/pIYL+irHQaFLnT9NA781W5eRcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X+0IcI1vsUylm5APMAl1vpGp+6e1d+km/HLdPwYptFM=;
	b=Fo+ovtmFjCIVZ1CWV1k5fhdLjOud4LV569SOYrwE+OhJpep19B2CWteQ9XzCzfyXtPVp
	 4zo87YT3GpPL5UuE8Dr8vzgiJNPXLokH56Jg7+vPNyChPkZetvjmVv6r8nxEkVzyzR3kV
	 MYsArGXaFqGu7wEw1Toogq5m/JRy/DXlG1H1+ZkZfO/aYD/GMB+gTMdY+eCWqPVP/ut7P
	 nLF22Kz3L3gaCxv2KC5sJGzm7p3gjgxFnUfmhdqcaHx5rui+RgpfEcyuqG71hM5qgRuaO
	 RbDQxgL4d3oMnysfZaNj/ohcGNpCe7Z+2MQaGBhMaCw8mxnz/wBTtW22bamlj+BiUew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8gKuqz4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECA0606A31C;
	Wed, 18 Nov 2026 16:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8gKuqz4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825D41F000C4;
	Wed, 18 Nov 2026 16:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018941;
	bh=X+0IcI1vsUylm5APMAl1vpGp+6e1d+km/HLdPwYptFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8gKuqz49fL88eMZAsohhNYzwud6iPOGp32PzMbtURvrmCYLyTDYNn2p9SQJal709
	 KrB95J/oIksVrbaqPGDeO5aHGWRWigwM4Wa+sdujODsx55mdcxbzunBs0XxoqgKtHe
	 VTnmjkXeUMzwTpOVUk5g7YKLsa5m2BaLxozUNgRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1419/2651] wifi: mt76: mt7925: fix NAN start failure
Date: Wed, 18 Nov 2026 15:44:19 +0100
Message-ID: <20261118150339.116657598@linuxfoundation.org>
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

From: Stella Liu <yu-ching.liu@mediatek.com>

[ Upstream commit e2f7c78a764c41f231e86533257ab623d4b4fed9 ]

mt7925_start_nan() called mt7925_nan_set_nmi_addr(), which makes NAN
start fail. The NMI address is not managed here, so drop the call.

Also track dev->nan_vif only in add/remove_interface and fold the
single BSS rollback into an inline error check.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-3-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 17 +---------
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 32 -------------------
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  2 --
 3 files changed, 1 insertion(+), 50 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index e3e9e0be558e2..be416244108e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2606,21 +2606,9 @@ static int mt7925_start_nan(struct ieee80211_hw *hw,
 	if (err < 0)
 		goto out;
 
-	dev->nan_vif = vif;
-
-	err = mt7925_nan_set_nmi_addr(dev, vif->addr);
-	if (err)
-		goto rollback_bss;
-
 	err = mt7925_nan_enable(vif, dev, conf);
 	if (err)
-		goto rollback_bss;
-
-	goto out;
-
-rollback_bss:
-	dev->nan_vif = NULL;
-	mt7925_mcu_add_bss_info(&dev->phy, NULL, link_conf, NULL, false);
+		mt7925_mcu_add_bss_info(&dev->phy, NULL, link_conf, NULL, false);
 
 out:
 	mt792x_mutex_release(dev);
@@ -2644,9 +2632,6 @@ static int mt7925_stop_nan(struct ieee80211_hw *hw,
 	if (!err)
 		err = ret;
 
-	if (dev->nan_vif == vif)
-		dev->nan_vif = NULL;
-
 	mt792x_mutex_release(dev);
 
 	return err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 2c03ad9c452cc..51aab5cad4bde 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -144,38 +144,6 @@ mt7925_nan_update_conf(struct mt792x_vif *mvif,
 	memcpy(mvif->nan.conf.cluster_id, conf->cluster_id, ETH_ALEN);
 }
 
-int mt7925_nan_set_nmi_addr(struct mt792x_dev *dev, const u8 *addr)
-{
-	struct mt76_dev *mdev;
-	struct {
-		u8 rsv[4];
-		struct mt7925_nan_nmi_addr_tlv nmi_addr_tlv;
-	} nmi_cmd = {
-		.rsv = { 0 },
-		.nmi_addr_tlv = {
-			.tag = cpu_to_le16(NAN_UNI_CMD_CHANGE_NMI_ADDRESS),
-			.len = cpu_to_le16(sizeof(struct mt7925_nan_nmi_addr_tlv)),
-		},
-	};
-	int ret;
-
-	if (!dev || !addr)
-		return -EINVAL;
-
-	if (is_zero_ether_addr(addr) || is_multicast_ether_addr(addr)) {
-		dev_err(dev->mt76.dev, "NAN: invalid NMI address %pM\n", addr);
-		return -EINVAL;
-	}
-
-	mdev = &dev->mt76;
-	memcpy(nmi_cmd.nmi_addr_tlv.nmi_addr, addr, ETH_ALEN);
-
-	ret = mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nmi_cmd,
-				sizeof(nmi_cmd), true);
-
-	return ret;
-}
-
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 1dcc888d98f9b..91f4e999711e6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -405,8 +405,6 @@ int mt7925_nan_change_configure(struct ieee80211_vif *vif,
 
 void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb);
 
-int mt7925_nan_set_nmi_addr(struct mt792x_dev *dev, const u8 *addr);
-
 void mt7925_nan_local_sched_changed(struct mt792x_dev *dev,
 				    struct ieee80211_vif *vif);
 
-- 
2.53.0



