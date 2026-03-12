Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4112D2491;
	Thu, 12 Mar 2026 20:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347120; cv=none; b=WzridtyBHQwtU/7fCRS5TBcmayJp5eUXOeqsaIjaBSiMG5X5aTjyJf14bDeG+FLt4c77lu4HK6wuzyyqY9IkGAzTpOsAO73Xg1I/qQQOEs/mGpNEJENh9B2k4dk44SaSVH6Qu1LtgGQMQz3+jz/FpT2uXrGCGTepAVgi7hL8to0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347120; c=relaxed/simple;
	bh=M4epUMq3MkDMRx8D07MbTv+JzwPibdtRVn405I/qum0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwZf5nfXHvC1xSXheWoWhXUhKpIKpkyPpEnb+IrM+ZpWZKLhZnw2+pSTN1jiZEypil1IPMyx1GRe6pJYpz6zTDx97XuyNWhSuZcn8AQuzqf+FchBBYrpQdmu8ZfP81vFWfMpK9W4r73gpyD3V5yZcBzVD9XNa8k/61KZdn7KRbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hE4gBY1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hE4gBY1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEDAC4CEF7;
	Thu, 12 Mar 2026 20:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347119;
	bh=M4epUMq3MkDMRx8D07MbTv+JzwPibdtRVn405I/qum0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hE4gBY1WLnnOjMlm90XjvgYeaxqvpMvoYjzYpDje24zOSK/MsGCxLJ4OY/cBOYLQ6
	 2qtUjANjTbz0MKz8NSOEbK5xDIHMS/YMwWgkte1ErZdIT8cah1VVDHIWQbRDz2m37Q
	 FelHFuxeHwKZgb4sAADHriMPlJ2Nkb1kfP67W6IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/265] wifi: mt76: mt7925: Fix possible oob access in mt7925_mac_write_txwi_80211()
Date: Thu, 12 Mar 2026 21:09:55 +0100
Message-ID: <20260312201025.834536619@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c41a9abd6ae31d130e8f332e7c8800c4c866234b ]

Check frame length before accessing the mgmt fields in
mt7925_mac_write_txwi_80211 in order to avoid a possible oob access.

Fixes: c948b5da6bbec ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260226-mt76-addba-req-oob-access-v1-2-b0f6d1ad4850@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index f1bd0c174acf4..2ab439f28e16f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -671,6 +671,7 @@ mt7925_mac_write_txwi_80211(struct mt76_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ)
 		tid = MT_TX_ADDBA;
-- 
2.51.0



