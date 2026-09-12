Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2F9399352;
	Sat, 12 Sep 2026 10:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209134; cv=none; b=nzqXJ/su9lHCM+1FcP692NoqOnAkZyf0/hEFXwop9ZN1J2RF30SleXqvQiRmtOYyvtIzwFyE1pYSgB1Fy3/5R/k4S75EvHWTuoU2uQC8xlmfDCAOIiUqjDwLSPbzwplcc9zkGV6cr4fs4K9D/4q4EgyZB4TJVrrpNzvSaN9d3SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209134; c=relaxed/simple;
	bh=Tj6axfNoYZHxT73mV5iQDsDvqgLGGBrHBoK+bP1cHdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYB5u9zzs6VoBcI0ZYhalOssd9dud4ScwWHS97p0b1KoXniEf8I9Rqqi27rFJI0I+ysVS2oWye3CxviJ1m0pn27Hkvf3dbXvvqC7k2RQx3ul9cVaOxv3sVM5CXEbv7bNT92r7tBRu8ZcVrTzje25239a2jvgkvg7BKs5i8ju2Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkU1AMOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkU1AMOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5591A1F000FF;
	Sat, 12 Sep 2026 10:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209132;
	bh=6bg6l+gkMcUZWwhggRl2G0F0zaNa8kY+8/zAOc93LUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkU1AMOUaVQOxLv8kXZ76K1rpx6eZoPuj4ZKVWxzGVGIdzIgTug9kc/MQUzse8axS
	 3Jl/B/3+MzFCkwTfh6Og2k1iSQX1RoEE9ZV3G08XlPMLqa/kSm7/8/3UZBsFEB42cG
	 3XLAWM5r2R4q8YKv5xmyxJReh3UmlgK0obdE5+yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0759/1518] wifi: mt76: mt7996: reserve space for the CSA-abort countdown TLV
Date: Sat, 12 Sep 2026 08:48:48 +0200
Message-ID: <20260912065640.600633925@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 50c66bab321140c49aa2ed779a3ec9d2f085b458 ]

When a CSA countdown is active, mt7996_mcu_beacon_cntdwn() emits two
bss_bcn_cntdwn_tlv entries (the CSA countdown and the CCA-abort BCC), but
MT7996_BEACON_UPDATE_SIZE only reserved one. With MBSSID enabled and a
near-maximum beacon template the extra 8 bytes could push the offload
command past MT7996_MAX_BSS_OFFLOAD_SIZE and trigger skb_over_panic().
Reserve room for both countdown TLVs.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20260724124813.3961474-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 7b51d7346bcaa..848c6c5751155 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -828,7 +828,7 @@ enum {
 #define MT7996_BEACON_UPDATE_SIZE	(sizeof(struct bss_req_hdr) +		\
 					 sizeof(struct bss_bcn_content_tlv) +	\
 					 4 + MT_TXD_SIZE +			\
-					 sizeof(struct bss_bcn_cntdwn_tlv) +	\
+					 sizeof(struct bss_bcn_cntdwn_tlv) * 2 +	\
 					 sizeof(struct bss_bcn_mbss_tlv))
 #define MT7996_MAX_BSS_OFFLOAD_SIZE	2048
 #define MT7996_MAX_BEACON_SIZE		(MT7996_MAX_BSS_OFFLOAD_SIZE - \
-- 
2.53.0



