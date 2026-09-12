Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817EC426EAD;
	Sat, 12 Sep 2026 10:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209149; cv=none; b=nLTA3YSuak3OezZSrxTADXTFNaqCQlSh1bfq5R2YZgSuYdg8w3e8ZwX4xziNvG4oO44eyhZ11uo8gZzX88RCJ2u/Ht2jErFGaXdpxqa3SJd9rHPvinreWDF26NZVXn4ulG3FVTzGthEkBvCUK2NCKjtZkck3M1vQXIfKBwandNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209149; c=relaxed/simple;
	bh=g8RAOHhAIFIN0cbJ7/fVtax4JamuDWlmZjscV+Eb3LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeMYQXGS29V3fVY8G5+jo17GrY+sBN10yzd6RMpeSfevc9/rPQfELgAQciQvG6ZiFAo/lOOFrLWIALNDuCaOwzCHdjFQcLvACMNPYgtXKFfHvKpU9HHgLLH4NRacpn+J0xNL2dXXgmC10+YtQ1MH72lGs6gDxZs1kRX3WDp7Z4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sikBLHn1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sikBLHn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311031F000FF;
	Sat, 12 Sep 2026 10:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209147;
	bh=uEfo5ZqtDEtsylY+kgKfRjcOEjwAdyEC9fXkwG5vlI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sikBLHn1WqaTCiJmzWKuMplB+IYF/xRD64/0rWa/dXXThuP594NJCJXFG/d9xAgu0
	 j7UzhWjZY6dV3XFdOlhkkoMVnIuqXbkIq1iJ/PMybusFP8TpPPYVL7u+kBlvR11dGE
	 oufO0oEJ608mlE/gMN8b8ulYYgCBup9w0ZmvGrUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0762/1518] wifi: mt76: mt7996: add missing rdd_idx check when enabling background radar
Date: Sat, 12 Sep 2026 08:48:51 +0200
Message-ID: <20260912065640.669719821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit dbca5c4d29826cecd3185fb1ae2746205ab55127 ]

Add the missing rdd idx check (< 0) in
mt7996_mcu_rdd_background_enable(). mt7996_get_rdd_idx() returns -1
for phys without 5 GHz support, and the negative index was passed to
the RDD MCU command unchecked.

Fixes: 1529e335f93d ("wifi: mt76: mt7996: rework radar HWRDD idx")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Link: https://patch.msgid.link/20260724124813.3961474-13-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 95c2a2a5f5bcf..92f8a28cd4a51 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3735,6 +3735,9 @@ int mt7996_mcu_rdd_background_enable(struct mt7996_phy *phy,
 	struct mt7996_dev *dev = phy->dev;
 	int err, region, rdd_idx = mt7996_get_rdd_idx(phy, true);
 
+	if (rdd_idx < 0)
+		return -EINVAL;
+
 	if (!chandef) { /* disable offchain */
 		err = mt7996_mcu_rdd_cmd(dev, RDD_STOP, rdd_idx, 0);
 		if (err)
-- 
2.53.0



