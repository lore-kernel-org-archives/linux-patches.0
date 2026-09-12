Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD8D3803C3;
	Sat, 12 Sep 2026 08:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201207; cv=none; b=bg+YrgU1L355aOD+UUs88Z9QvxLOl0400B/Z82R/RWSV6driLg6WokivUcNfeVzLPNg+JfvQ/wAVSUuo488+So8u92GJ70MdYewjMBvW1yp6viKsmB9k4LxzK+dm8pJC3aeZu6MptFElyms/A988lNqJD+30jq+kUY+ZuWfI/ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201207; c=relaxed/simple;
	bh=++Xn7dAoXM6g4VEFVZtZwC0fa0K/PvMIOppco8Maq3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sN4GDB3cppZhO/2Vrn4J1J7pE0mnRW+2XiYRwR+2KzzYfv9TCa2tHAw0dJ0hKrG9jboP1aRXVATh0MXmvRjOgvw6uwuTenPdgLsaFbe7Uhp4Ho3U8iqI4uGV1snGGQq7dL09F8E8L9rpQ1B/4VMoyP0ZvHlMk648Eswzxn2uXSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AP6uoOEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AP6uoOEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5429C1F000FF;
	Sat, 12 Sep 2026 08:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201206;
	bh=uLYCE2IXuNExUxUVhUW30WTEHRuLRpYXgRYSChaXOV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AP6uoOEHwQi73qFHvj5q6pH2RktUuJwUCbb+jiiFsMsCzBN3fiPAqopmJq1dEw++Y
	 7AUKxv+kyOEYNJ5N1dPQc8bvSxmZqMoM9K5s/GytUEtELS6fycNtT0n5TIOC7cidBM
	 d1BR5gqBdgvMutMSo43fB6EDbCp7lKrek5H7g69w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0948/1815] wifi: mt76: mt7915: report RX chain signal for all RX paths
Date: Sat, 12 Sep 2026 08:44:58 +0200
Message-ID: <20260912065711.213314468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit b53c44fe65792608f58028c7b0953e610ad652ee ]

status->chains was set from the antenna mask, which is derived from the
number of spatial streams, while the chain_signal array is filled from
all RCPI fields. On boards where the number of RX paths exceeds the
stream count, e.g. the 3T3R mt7916/mt7981 variant with 2 streams on the
5 GHz band, the RSSI of the extra chains was never reported.

Use the band local RX path chainmask instead.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Link: https://patch.msgid.link/20260727150434.1778520-9-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 31d231a033e75..0ea0261f2a29d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -437,7 +437,7 @@ mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb,
 		if (v0 & MT_PRXV_HT_AD_CODE)
 			status->enc_flags |= RX_ENC_FLAG_LDPC;
 
-		status->chains = mphy->antenna_mask;
+		status->chains = mt7915_band_chainmask(phy);
 		status->chain_signal[0] = to_rssi(MT_PRXV_RCPI0, v1);
 		status->chain_signal[1] = to_rssi(MT_PRXV_RCPI1, v1);
 		status->chain_signal[2] = to_rssi(MT_PRXV_RCPI2, v1);
-- 
2.53.0



