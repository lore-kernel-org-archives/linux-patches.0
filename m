Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662162561DA;
	Thu, 17 Apr 2025 18:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913255; cv=none; b=F+z2cBksaDsHh43ud60JDJTRYaDJ3p4966hzeYT22Po7w1WYUh1izr4TBuW3UhnAQqfMKV60cfgoqotdvOKt3WzHgoQEL81lu3zkSRUUl04i4h9YkR3nsriMD6lieBzPaj/UfsSvA08abGBm+CQrsqCchshI2hkiASe/NK9P1es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913255; c=relaxed/simple;
	bh=aDKtB1Yt7J31a3TmgFNWNv3gENugMK0Ha0a0NMCwIj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEuZVPPeNISAhKPwotA3vwGu4CY5MHM/Ul9Uapjap743X4aikSDSXJ9XRKBGl72+c2Gq4NXbSl6sJZEj8wJWKOk9N4CzdFAOPybN1ddBDGh5NWfXzl5R5r7lq4EVddoE5VyR24tGeh3k/MCSlXDgFf2xt1YXzpm/ypAkWul4VM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7WHnqHT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7WHnqHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4AFC4CEE4;
	Thu, 17 Apr 2025 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913255;
	bh=aDKtB1Yt7J31a3TmgFNWNv3gENugMK0Ha0a0NMCwIj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7WHnqHTajPQWoBhmNTBKqwrdJ97lYn2SDbCLEpOfVFKgndn6SW4IhRSO5JuHJvmU
	 qQ2DyVjwyvLJ0bZqPNa1sf/Q5LaLv4VgjuqSlrCuTZ7WOl7n7Qa1wuO1SBv27W8Gv9
	 Nn//cU0Pl7/ggMjODYYWRGSZbYNyPZLWMjARi1zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.14 279/449] wifi: mt76: mt792x: re-register CHANCTX_STA_CSA only for the mt7921 series
Date: Thu, 17 Apr 2025 19:49:27 +0200
Message-ID: <20250417175129.295008672@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 06e70003d88218675c566584dd76867fcb39706d upstream.

CSA is currently not supported on mt7925, so CSA is only registered for
the mt7921 series

Cc: stable@vger.kernel.org
Fixes: 8aa2f59260eb ("wifi: mt76: mt7921: introduce CSA support")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250313054044.2638837-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -665,7 +665,8 @@ int mt792x_init_wiphy(struct ieee80211_h
 	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
 	ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
 	ieee80211_hw_set(hw, CONNECTION_MONITOR);
-	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
+	if (is_mt7921(&dev->mt76))
+		ieee80211_hw_set(hw, CHANCTX_STA_CSA);
 
 	if (dev->pm.enable)
 		ieee80211_hw_set(hw, CONNECTION_MONITOR);


