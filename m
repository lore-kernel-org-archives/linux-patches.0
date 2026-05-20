Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3CC33A6F2;
	Wed, 20 May 2026 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294612; cv=none; b=JH9NCbnj25b5XvteFIjHS0Obk4MTlA9iMhh3U8EOwFY61p2A1FtLE0shCy7bXjBFRLQ0phN90J/Knf/j4K4vahwKe5n1P10SdeWFoapr3vqYhC0kIwSK/4+OZTKKsLXigEPPsTO8GKZx5ZYfN3xD2R6fc9WPslXOxI+LJ4Lg50w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294612; c=relaxed/simple;
	bh=6xglFkWIGb46B8wXO+YpV24VXeQkzBF91Z0Bp22Kxkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLuZ4xfcDSLFtR04mn3iiQugSur0fUhsJniiXHk7PjtzzejK+gLe1kbm0bcy+tkm3yc65AE+6rn95eoSuizWlic7uyHjZoX52QAKEjZB903iCl/Piauq16NSgzI96viAFKom7s7HbLZ/rTryiDKr0HLdsTtrfMsmXmoj66UNYCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6Jj6D+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6Jj6D+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0B81F000E9;
	Wed, 20 May 2026 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294611;
	bh=HI3URE6mF6C9qKxCc7klNLuhBAJg5XiJa/7XfdBCwRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6Jj6D+u9Y0UJ1xZhTHxh9pO++eBe2LhyuUNoV6Ow69ql8BIgJiVdSXkhQf7dAEnd
	 dP2flEHzLtZPGwg3mz3O/vFZC7mcc+6vOB3NVEEU7oKuFGPedaw+tNOCwI0DRKqwu4
	 N6QqsfjKOwaK/wHkuV6nH5SQZDUZQBn0pC4DESMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0105/1146] wifi: mt76: mt7925: prevent NULL vif dereference in mt7925_mac_write_txwi
Date: Wed, 20 May 2026 18:05:55 +0200
Message-ID: <20260520162150.717475150@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 962eb04e67552be406c906c83099c1d736aae3b6 ]

Check for a NULL `vif` before accessing `ieee80211_vif_is_mld(vif)` to
avoid a potential kernel panic in scenarios where `vif` might not be
initialized.

Fixes: ebb1406813c6 ("wifi: mt76: mt7925: add link handling to txwi")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250904030649.655436-3-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 711daa5f07fab..82eedd80f694d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -804,8 +804,8 @@ mt7925_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 	txwi[5] = cpu_to_le32(val);
 
 	val = MT_TXD6_DAS | FIELD_PREP(MT_TXD6_MSDU_CNT, 1);
-	if (!ieee80211_vif_is_mld(vif) ||
-	    (q_idx >= MT_LMAC_ALTX0 && q_idx <= MT_LMAC_BCN0))
+	if (vif && (!ieee80211_vif_is_mld(vif) ||
+	    (q_idx >= MT_LMAC_ALTX0 && q_idx <= MT_LMAC_BCN0)))
 		val |= MT_TXD6_DIS_MAT;
 	txwi[6] = cpu_to_le32(val);
 	txwi[7] = 0;
-- 
2.53.0



