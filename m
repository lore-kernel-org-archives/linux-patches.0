Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8A93603DB;
	Sat, 12 Sep 2026 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230464; cv=none; b=XA3mOrAQid7p+XrxeGl7+iIvGtKsJN5UKi1yZxpH1VV6lXK62Ipneanahi1hTsL2bOa/mvDjMQ1UNV2KV6keSK7jxu4A45DMCIQ9JOJxGW4EzOrlwiLKjr2r0moffaC5hnVCRMc2P8v53f2Xe8DPGhqXnYRAP9LKaRocv2O7Zjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230464; c=relaxed/simple;
	bh=58WCWrfthsmFWuFUHdkOdmvP+ETEIKRcLofi6yUvAeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLMJaLSePTsqRHEBzr4DM2Jd0vNHORkmrmX4xp7wMkLwI91tYRCPjgkdiOnNhbJFUlE5j9jtRAt3pET3VVa8wr/Fun9UIpB7z9SWJcpjlvuCv+RR0tMfLLiWE0xewAb96JP4j1IdoJWy52zkV4T3JHHqbbNUcRVb2fOcHMKgCOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyNOn863; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyNOn863"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC181F000FF;
	Sat, 12 Sep 2026 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230462;
	bh=EgjtXUVx8m9VUImioI3gUqF6/54UmqwRglFeLYlWvgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyNOn8636IuhhzUSwPHvcwAMNR/n/TwxNOXzf1tgSOm4BA5t4Ut9teymx3xaAgwEm
	 SyZ+qbCwqHs98NFQmqfUxBJ0N6BovyGW90Vqrt1mFN3kTh4BXJ9uFE9WEIdZmvIAU5
	 V0JOFhbGaSdPMtpYZ+0ZjsWIHrw1xxUb47pj96Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Zhi-Jun You <hujy652@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0800/1191] wifi: mt76: mt7915: fix net_fill_forward_path for non-DBDC mt7986
Date: Sat, 12 Sep 2026 08:58:48 +0200
Message-ID: <20260912065606.241593910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 24ea37c20e877..4ba7988298e2f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1437,7 +1437,7 @@ mt7915_net_fill_forward_path(struct ieee80211_hw *hw,
 	path->mtk_wdma.wdma_idx = wed->wdma_idx;
 	path->mtk_wdma.bss = mvif->mt76.idx;
 	path->mtk_wdma.wcid = is_mt7915(&dev->mt76) ? msta->wcid.idx : 0x3ff;
-	path->mtk_wdma.queue = phy != &dev->phy;
+	path->mtk_wdma.queue = phy->mt76->band_idx;
 
 	ctx->dev = NULL;
 
-- 
2.53.0



