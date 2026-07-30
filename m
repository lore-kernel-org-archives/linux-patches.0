Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840337C92C;
	Thu, 30 Jul 2026 15:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425841; cv=none; b=G7c+vnNgDdx78blkyVCQzHly+Ldnpru8p125Z+VBDXJhv6XP9J87rCaJfAva84JofFnIStLnkq5rMPbhmwyb/CjpBM/fpO981+Q0EXLjcsVwppZ/mSjzZ0cqQYlm8ZjOdGxx/QmIU+pKPrd0pA+z8dU+sI0cSfR5wk6qZJHGLJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425841; c=relaxed/simple;
	bh=n5/VU7fjQCA7kwtBG/Mr/g/MobI8r02/cOWHZIYibkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMJ9YiFs+rJHxpgdD1BhaHjM9rHmDHwrebBxLyVJapt5rDiF3CTy+AfsGdblQ/XRLq5WY278TrNQ3L1W3A8ArZcfuT8bx8lsm+4MsFeH9pYxY20dW/1Yi3mArq5+z4v+l58pOOtVUxLHPKIHga1Piw04GhDHRNLwdRBiLPaZveo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3JUQVrB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3JUQVrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142EF1F000E9;
	Thu, 30 Jul 2026 15:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425840;
	bh=CMt4FwStlHLCvh74rEnjlHhKFRIYnH1azDB0pqaqFxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3JUQVrB8ukpWZYedhqkYq9ksE3yrz4XEIkWSqGEfCmV1zhXoqETmlScwJW/SuzB5
	 RL47WD8NSy6D9oNTczpNvxbbUR6VKMnqAccsumaqWt5sqsWEtze8NR1Tj8abi5yIQT
	 MsIbV/1lctsTnBK6fl5TqT4ReA1e758WbEI6iCDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/602] wifi: mt76: mt7925: fix crash in reset link replay
Date: Thu, 30 Jul 2026 16:10:02 +0200
Message-ID: <20260730141440.368114931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit bd8b2ec838184236c3fcbf738a926328836adf12 ]

During reset recovery, mt7925_vif_connect_iter() replays firmware state
for links tracked in mvif->valid_links. After MLO link changes or MCU
timeout recovery, the driver bitmap can temporarily contain a link whose
mac80211 bss_conf has already gone away.

This can pass a NULL bss_conf to mt76_connac_mcu_uni_add_dev(), matching
the crash where x1, the second argument, is NULL:

pc : mt76_connac_mcu_uni_add_dev+0x8c/0x1f8 [mt76_connac_lib]
lr : mt7925_vif_connect_iter+0x9c/0x168 [mt7925_common]
x2 : ffffff80a77f6018 x1 : 0000000000000000 x0 : ffffff8099402080
Call trace:
mt76_connac_mcu_uni_add_dev+0x8c/0x1f8 [mt76_connac_lib]
mt7925_vif_connect_iter+0x9c/0x168 [mt7925_common]
mt7925_mac_reset_work+0x264/0x2f8 [mt7925_common]

Skip missing bss_conf entries before replaying the link. Non-MLO AP/STA
reset replay is unchanged because the helper still returns &vif->bss_conf
for the legacy link.

Fixes: 14061994184d ("wifi: mt76: mt7925: add link handling in mt7925_vif_connect_iter")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20260616161016.19346-1-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index f01dbca6e9b9ca..9ed0c2655037a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1285,6 +1285,9 @@ mt7925_vif_connect_iter(void *priv, u8 *mac,
 
 	for_each_set_bit(i, &valid, IEEE80211_MLD_MAX_NUM_LINKS) {
 		bss_conf = mt792x_vif_to_bss_conf(vif, i);
+		if (!bss_conf)
+			continue;
+
 		mconf = mt792x_vif_to_link(mvif, i);
 
 		mt76_connac_mcu_uni_add_dev(&dev->mphy, bss_conf, &mconf->mt76,
-- 
2.53.0



