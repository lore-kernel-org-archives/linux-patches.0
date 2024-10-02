Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2491CFEB3;
	Wed,  2 Oct 2024 14:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879221; cv=none; b=R/d+0UCd1uhqeSoVUnK3azxt7ykwTzNl/z3/f2ZoX0W2IXJLjzC3TYLbCRJiLLdZ48Pv1mjhuGDpxhC6/frgoDtNDRqYA0KIhIIa0yq+3bVApRK4xT183z6y68wZD3dM7ep92Ti8JAGB17j+zmDpXAxIGX89py6mvCaPsWpuAok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879221; c=relaxed/simple;
	bh=uiGVLCyzWKN4QIUETHx6/SojEHYQi01VG49MMlvpzWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkxhK59txOm9g5GwKPkz6JC9QPcqLHLMLe+/epIehl28q0R48XBoEioC4NCW0yYS0SPSnJXjXnfV1GtdGPe3OR+38gTBvm6LEObEKKeAR8ceNwSVRu9io4NHzzIGipo/gxxAGRqaobFHMJuD8bnv8L9vnA7pHDyScn2t5cS6pUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhxYfl+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhxYfl+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B60DC4CEC2;
	Wed,  2 Oct 2024 14:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879221;
	bh=uiGVLCyzWKN4QIUETHx6/SojEHYQi01VG49MMlvpzWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhxYfl+A4DWSKDoJDwrIeS843Zs5jnPltnhFXwt1XsJOsbrZd5BIO8+hbWa/7Jt0z
	 WKKaUp16TCFN0FjlpdJSPmCZVCFWHEJu0wd1j31tZkne/np1/4pn16giHtRHfMM/pk
	 bSeKK9S2CbnNloMgcTMt8iXNV/6uNEuYueQm2HAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/538] wifi: mt76: mt7996: use hweight16 to get correct tx antenna
Date: Wed,  2 Oct 2024 14:54:43 +0200
Message-ID: <20241002125753.769583753@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit f98c3de92bb05dac4a4969df8a4595ed380b4604 ]

The chainmask is u16 so using hweight8 cannot get correct tx_ant.
Without this patch, the tx_ant of band 2 would be -1 and lead to the
following issue:
BUG: KASAN: stack-out-of-bounds in mt7996_mcu_add_sta+0x12e0/0x16e0 [mt7996e]

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20240816094635.2391-1-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index b66f712e1b17b..1c3eec84892c2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1412,7 +1412,7 @@ mt7996_mcu_sta_bfer_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 {
 	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
 	struct mt7996_phy *phy = mvif->phy;
-	int tx_ant = hweight8(phy->mt76->chainmask) - 1;
+	int tx_ant = hweight16(phy->mt76->chainmask) - 1;
 	struct sta_rec_bf *bf;
 	struct tlv *tlv;
 	const u8 matrix[4][4] = {
-- 
2.43.0



