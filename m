Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A1237E5D1;
	Sat, 12 Sep 2026 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216750; cv=none; b=KTM1JAG4skAOUbFIlKR2xHvrs6pTw07ATIYsM/hLlYc4DDrlRVXPXZuL/6Tw9V942nYztqmnh7DwB+9QR5Olyx7El4uaWmyb7JsEhq6+nMttCGK7CpcGLrZmHB0sCJ94+AfWjkTx+n3oOrFd9oYIIl1g8+ZnUzdXmfJfh+hHDUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216750; c=relaxed/simple;
	bh=eoQuDJWslsswwTs0r5MBMcb9upExMXOgJ+CjZ02FLSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ih/TLGziEuSd1NDolEV4wnQGdbjA+9AaMt0m+tNnxCmwrw1GzaT28t73w9PmXu/ily4Mrv5F36zbIV4JPXbEq9uIcWBhjynvXETQFeBcwp9KaJtzW+WpEj2wWuQcawcFBJswpqdKIZFvWWVsm3hTzwO5Uk7NS/v+/It1lMrI+gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfDVxJCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfDVxJCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DFA1F000FF;
	Sat, 12 Sep 2026 12:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216749;
	bh=AARH1yJp/YjkdaU8y9PkkKleW9kYzKbePZF/t1FMt0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZfDVxJCJ8fn2O6HBA90brdXgbXk5sF7X2Wgki1J27Gh9z8ipSj4VtKhmKx7gvPAI6
	 2m/ywHzzvRTF+CtnHYz7Z5QhdhY/jJh628YFq+A0s5X6FufELlxQsJs8CN23PyNZfz
	 DFyO5es8VH939U0DhVd3pTjiXP5YYr6x6d2gt46k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Zhi-Jun You <hujy652@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0801/1376] wifi: mt76: mt7915: fix net_fill_forward_path for non-DBDC mt7986
Date: Sat, 12 Sep 2026 08:53:47 +0200
Message-ID: <20260912065625.386497639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit bade0d238b60c29dafcc7da17501fa489495d6ae ]

Current implementation assumes that the hardware supports DBDC or single
band and binds to band0.

This causes net_fill_forward_path to select the wrong queue for non-DBDC
mt7986 because it binds to band1 and getting the following in dmesg:

ieee80211 phy2: WA: --> drop by reaseon:1, msdu id = 0xc002 but failed!
mtk_wed1: error status=00000002
ieee80211 phy2: WA: txblk
10324e00
len = 128
DW0 : 10 00 00 00
DW1 : 00 00 00 00
DW2 : 00 00 00 00
DW3 : 72 0f 94 68
DW4 : 00 00 00 00
DW5 : ff 03 00 00
DW6 : 00 00 3c 40
DW7 : 00 17 dd 14
DW8 : 79 6f 00 00
DW9 : 02 c0 00 00
DW10 : 58 c5 34 10
DW11 : 00 00 00 00
DW12 : 00 06 3e 00
DW13 : 00 00 00 80
DW14 : 10 8c 00 00
DW15 : 00 00 00 00
DW16 : 00 00 00 00
DW17 : 00 00 00 00
DW18 : 00 00 00 00
DW19 : 00 00 00 00
DW20 : 00 00 00 00
DW21 : 00 00 00 00
DW22 : 00 00 00 00
DW23 : 00 00 00 00
DW24 : 00 00 00 00
DW25 : 00 00 00 00
DW26 : 00 00 00 00
DW27 : 00 00 00 00
DW28 : 00 00 00 00
DW29 : 00 00 00 00
DW30 : 00 00 00 00
DW31 : 00 00 00 00

Fix it by using phy->mt76->band_idx for queue which works for both
non-DBDC and DBDC devices.

Fixes: f68d67623dec ("mt76: mt7915: add Wireless Ethernet Dispatch support")
Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20260715152113.553-2-hujy652@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index f49dcdde3f2c6..9b0fde73b8945 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1676,7 +1676,7 @@ mt7915_net_fill_forward_path(struct ieee80211_hw *hw,
 	path->mtk_wdma.wdma_idx = wed->wdma_idx;
 	path->mtk_wdma.bss = mvif->mt76.idx;
 	path->mtk_wdma.wcid = is_mt7915(&dev->mt76) ? msta->wcid.idx : 0x3ff;
-	path->mtk_wdma.queue = phy != &dev->phy;
+	path->mtk_wdma.queue = phy->mt76->band_idx;
 
 	ctx->dev = NULL;
 
-- 
2.53.0



