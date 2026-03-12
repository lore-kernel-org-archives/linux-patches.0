Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4C93242AC;
	Thu, 12 Mar 2026 20:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347116; cv=none; b=YZ3TeOqDNucTGPSzGZrb17zf6hbESQimn6Q1QrNJyZp6rfm90d7t4mz8+7XSRTbdBx8DyjmwWLgJ6JP7xNMyJ5YHRbC2gTwgmbjo6jDCwnTKbEnqVw9Dka8OtZo2T+fL0iZXu12oKggz/lmfKckHCKcJ/p2FXKlKkpzDB8NFC2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347116; c=relaxed/simple;
	bh=5zkaRzVzSyVTQBgvIRVfIW1vWPrcVHWO42pl+ZUFEJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGxxMp5ggC8lQsSrU2aiD7U48s4Qlslfarb3ISXLY5paR3LjByT5M6oEaiSV79qp9Xm9yInxkQSbo4JRN/9LVZlIpEtoPyzspMfj5+ygpz2UVX5s/MP3SIAnXlUeGQd/NS52+y/eTiV5wQFcaNIqD8ofbcEKZubyqCA8csT803s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzYyVBeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzYyVBeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFF0C4CEF7;
	Thu, 12 Mar 2026 20:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347116;
	bh=5zkaRzVzSyVTQBgvIRVfIW1vWPrcVHWO42pl+ZUFEJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzYyVBePePl6dmm4X7+z4sayTW7aOaCvAjJ4NJ7ViWo3FpY19IpsjiQ3yQ0/UN3ax
	 bQC4f9hXSI22CoOMz8kJiR1e/dH9G9bMDiE3r7YJy9Ftp1+j0Gv1jsCPyUIkWTm3TI
	 W9Vih9YbtcDp5X7JTBOAkXhhlN9yi68poeJtMjkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/265] wifi: mt76: mt7996: Fix possible oob access in mt7996_mac_write_txwi_80211()
Date: Thu, 12 Mar 2026 21:09:54 +0100
Message-ID: <20260312201025.798762702@linuxfoundation.org>
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

[ Upstream commit 60862846308627e9e15546bb647a00de44deb27b ]

Check frame length before accessing the mgmt fields in
mt7996_mac_write_txwi_80211 in order to avoid a possible oob access.

Fixes: 98686cd21624c ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260226-mt76-addba-req-oob-access-v1-1-b0f6d1ad4850@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 0990a3d481f2d..b7a5426c933d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -759,6 +759,7 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ)
 		tid = MT_TX_ADDBA;
-- 
2.51.0



