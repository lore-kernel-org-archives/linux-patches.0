Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F31843C7A2;
	Thu, 30 Jul 2026 14:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422004; cv=none; b=RZ9O+DKErnvziR7b9C9O7E7nU6DBr7QL1wFjCEItm5vaJnwC/gUkTd342hsHQfzbzZsLhPANO2wy0eK0VgdUfrrh7s16+H1jgUZARlb+q4r6VUyMqi7kYDuyJD9QHL6+LyovaZ+QZQNybrG5yGGLAR5ml2DU5g+1/9md6Ha9rQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422004; c=relaxed/simple;
	bh=u4YbMeaWmAP4iXg+fkJjATAXuU4rI2PWnifwWaX0Qok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9m+FX4XgPEcCA+axUt665E6/hAbPOVzN8zcc4nF0X45yxwgB6FhFX6+WScGUNIPeh4H0WT1SWrTkYEEeDVJERlMUQcZnqsSOc5NNmBHKc0mmpBDEGEtugunN91NRbPnJE6aJqbTv4j/UjbwoIKdk7eODSbyUHkApGg0sryLwOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMOZuyQ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMOZuyQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5CC1F00A3D;
	Thu, 30 Jul 2026 14:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422002;
	bh=bGcjvaaMmw41O7uEnjkWzBqDJDPukziUzZspdjzp8Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMOZuyQ5SuaC1gYc2l7KCbT/bLFaA0rafeiuwGm56/Q6RCY9UQE5YQDS0WQ4kpwBB
	 jBkwV/WfL6CLkbCwpAVLE4Qrm9FVKmXOO9oGC8sJJgpbjsbM4boCo2aFpw0CCfAo1a
	 rOlJzk3wupWuILV53UPQbMCXuXSDv3ebF0wi8EZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 292/744] wifi: mt76: mt7925: fix possible NULL-pointer deref in mt7925_mcu_bss_he_tlv()
Date: Thu, 30 Jul 2026 16:09:25 +0200
Message-ID: <20260730141450.498253690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 8d1b6738c1ab48c086b17e7994034aca94258931 ]

mt76_connac_get_he_phy_cap routine can theoretically return NULL so
check cap pointer before dereferencing it.

Fixes: c948b5da6bbec ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260621-mt76_connac_get_he_phy_cap-fix-v1-2-ed4ccf7a0363@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 37cdf3e8a06706..4f20f62fb70a3c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2694,6 +2694,8 @@ mt7925_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_bss_conf *link_conf,
 	struct tlv *tlv;
 
 	cap = mt76_connac_get_he_phy_cap(phy->mt76, link_conf->vif);
+	if (!cap)
+		return;
 
 	tlv = mt76_connac_mcu_add_tlv(skb, UNI_BSS_INFO_HE_BASIC, sizeof(*he));
 
-- 
2.53.0



