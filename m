Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5052E3FF1AE;
	Sat, 12 Sep 2026 12:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216961; cv=none; b=lkC/9ir0+PK13hbSXrkylnXJZjUYqrhhIKg0mW59vu9SRabG/1LNSTykggc5eK2RVQHVqFeJ0UH06FVKoQ25YecjIXuPSx4+4BvMWLgmXIfNqoA1Yh09m1lhVJRKwEbu51012w+V/e9eSZT88MeqE2qDpWE5BuTgrFIL84P7WXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216961; c=relaxed/simple;
	bh=6NO6xj6dJB/1/D/nvmnKKOPyEHUtM+2Hnytr08o2TyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1boZmWmn9E2DvBkfDXWxA4lkWbMPPSbpUFM80DmuQke/3Odj4Az3jXJxpgH8+eJjoR+x1vdTsLeADjY2zQgCsssD859JUjApPHQbxMbYFGS6eTfb8xwxGas3+qi7POAMIpfsJvZXctfH2he8pusFz4y/qZXGyoYbXMPYDWgaOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itiOxYra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itiOxYra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080AE1F000FF;
	Sat, 12 Sep 2026 12:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216959;
	bh=e/1wWURHvREdyx1QgC3l5DJgV/6XoLIJXYEl9B78SHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itiOxYraEfYLApMw8s9aUMN1w5nCgnIJx21N44s4SVQK23VKcLuYImmPpekg6HgGq
	 AMZz8PYury8gU0IfksgaYgpuEsMnXMYA8oK3Yqq4EBaRG0sMCt0fyRyFt9nHKlaaQJ
	 Eem7Q0r7wEmTaJiOnfxZQPvUZ1T23w9aPgRTNnXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0844/1376] wifi: mt76: mt7915: report RX chain signal for all RX paths
Date: Sat, 12 Sep 2026 08:54:30 +0200
Message-ID: <20260912065626.360433473@linuxfoundation.org>
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
index bd8bd74f0336d..f165e61ed28f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -444,7 +444,7 @@ mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb,
 		if (v0 & MT_PRXV_HT_AD_CODE)
 			status->enc_flags |= RX_ENC_FLAG_LDPC;
 
-		status->chains = mphy->antenna_mask;
+		status->chains = mt7915_band_chainmask(phy);
 		status->chain_signal[0] = to_rssi(MT_PRXV_RCPI0, v1);
 		status->chain_signal[1] = to_rssi(MT_PRXV_RCPI1, v1);
 		status->chain_signal[2] = to_rssi(MT_PRXV_RCPI2, v1);
-- 
2.53.0



