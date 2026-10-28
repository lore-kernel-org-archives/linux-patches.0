Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215105;
	b=3Bw07gwHe04uOqjAk4ll92Yx90YGV2OXJS1QJ0dYYJmJ/3jycFiRemzbBlnMyqnDulQ6
	 +2RK65+0CfgFM62WXZI4jNwGuctARmOvVioutJ6Ou8XS/nV2ZQYf7/wubmxkZRREGUwap
	 tB9ycjdGG3UerJev888yLOfMCQCBs6S1H77d0q/hu0wOMtj8p2WrSUAavgXtjHpymocDx
	 YzImJ/AwOebbdq/yslHla9WeCN87GPntMzxWtHM91yXKKgZtLbuXv9A+2fyiIYaE5XL5G
	 NzVdxFzAREIJ8vlCALvrpV6C1I5mqq6JWvVRsJu0xiKaOKjRzSNiyayZBu9r7vtPBgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=etvnE9l2YaDGAL9jc6RoVIRig0OrGR4Q2dGGfUejQU0=;
	b=mjEJhenrYhNVQWkIuxBV+2/rt+kkqtOnfwMeJHyCMkyE/bvfBlwSRMoaB9+IarV3jUq8
	 J+3GqYkkzuYiQF0aPkHsSSPj6WdhrQZTvUdNOWUWFCVf6kTOcSZdJwoKaHsWcXx/z5zPU
	 elaOP31SHwpjW0EI3yUr6zJvsslKBWiCIGDygzlO3DYpp1LUjpbvOz6AuQxMkbilUg9dj
	 VYiOc1no0pIR+6Ghzsa3DcRpft0wuJhyG0YHdRFelOfJo9xVcZC8i6ED+ohM8jIpPkeNN
	 WUK/M2Q1FwKZoHOZC2grxYro6kOM/UYdZpEZOKYUVdCLCU4CwdKTlDEdITNZoLWB/JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1FfSf5Qn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EEE606A31D;
	Wed, 28 Oct 2026 19:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1FfSf5Qn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACD81F01825;
	Wed, 28 Oct 2026 19:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215105;
	bh=etvnE9l2YaDGAL9jc6RoVIRig0OrGR4Q2dGGfUejQU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1FfSf5Qnz6OI103ZEaqfP5+iwv4IgS4cowvhxV10yx6RJNBfEEdyRyC8wB5fPNUV7
	 lbZzewlkr/4O7if14qA0fZCd76bCXQrwvC9ATBujuVNLGeVK8RKBB/klTnaeB6eS7a
	 wmflT4Y9CuuN2rdc9+JJ343Vvd2+ak49OiiBMODQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1087/1887] wifi: mt76: Fix memory leak after mt76_connac_mcu_alloc_sta_req()
Date: Wed, 28 Oct 2026 17:53:03 +0100
Message-ID: <20261028170524.140989901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit c41075ce8cf05ed8c0e7b7efef000dce548ffc42 ]

mt76_connac_mcu_alloc_sta_req() allocates an skb which is expected to
be freed eventually by mt76_mcu_skb_send_msg(). However, currently if
an intermediate function fails before sending, the allocated skb is
leaked.

Specifically, mt76_connac_mcu_sta_wed_update() and
mt76_connac_mcu_sta_key_tlv() may fail, leading to an immediate memory
leak in the error path.

Fix this by explicitly freeing the skb in these error paths.
Commit 7c0f63fe37a5 ("wifi: mt76: mt7996: fix memory leak on
mt7996_mcu_sta_key_tlv error") made a similar change.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: d1369e515efe ("wifi: mt76: connac: introduce mt76_connac_mcu_sta_wed_update utility routine")
Fixes: 6683d988089c ("mt76: connac: move mt76_connac_mcu_add_key in connac module")
Fixes: 4f831d18d12d ("wifi: mt76: mt7915: enable WED RX support")
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20260116144919.1482558-1-zilin@seu.edu.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 6f4b1a784a078..e6ca72363e0f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2652,8 +2652,10 @@ int mt76_connac_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
 		return PTR_ERR(skb);
 
 	ret = mt76_connac_mcu_sta_key_tlv(sta_key_conf, skb, key, cmd);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	return mt76_mcu_skb_send_msg(dev, skb, mcu_cmd, true);
 }
-- 
2.53.0



