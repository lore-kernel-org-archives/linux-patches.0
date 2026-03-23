Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB42274B5F;
	Mon, 23 Mar 2026 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282349; cv=none; b=WvjKoY98rC5t9FvzG7ChA67mwcs2WxkFbtd4IQgXVZXWoKxTMOqnJeVRO1jpDi01ILXenaMPhUvro7kWkSCy7t5KZQ6lBzlRmw6DMRmFMACdcMsnVWOguAUNSALF5HXfD7u0de/cweJBIwTeISVShSpTHhKPQ3lVSlxvLcgcNOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282349; c=relaxed/simple;
	bh=VoyiJlB+FdiWN6zOhV5hKmN/m/LDVSAzJnfN7kxLkfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oftv31zVNlGNVcmG4TffEBmebVqkdzYmdh4NbvnQeBXgEEBLBwaQzerDuboY2VkOIfQmsZBx2Uk4AxOecfInhryQMj8E/kzWN1LNLyVY6uTH6LeS3Fye4wfc8VWB1L3E3ibyOhShr6JzylNZTVEw/NFJJHGPAfswxhuOsCfCUX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3jeVIsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3jeVIsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C30C4CEF7;
	Mon, 23 Mar 2026 16:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282349;
	bh=VoyiJlB+FdiWN6zOhV5hKmN/m/LDVSAzJnfN7kxLkfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3jeVIsCEVhqyvogc676SBSXy+XKhiYxP8vx/Um88JMUJX5ncZw+18rkos+Sejbrq
	 cRsZ/846b/goXcZXrVB6Pq8tj896v2yks+6p1n76aWN252WTgABIYZNwAFQ1lgE/sS
	 yR+ijMh2x6AfE59DopRSOuDyS1Gz2BYC3AgdBEig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/481] wifi: mt76: Fix possible oob access in mt76_connac2_mac_write_txwi_80211()
Date: Mon, 23 Mar 2026 14:41:45 +0100
Message-ID: <20260323134528.281391127@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 4e10a730d1b511ff49723371ed6d694dd1b2c785 ]

Check frame length before accessing the mgmt fields in
mt76_connac2_mac_write_txwi_80211 in order to avoid a possible oob
access.

Fixes: 577dbc6c656d ("mt76: mt7915: enable offloading of sequence number assignment")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260226-mt76-addba-req-oob-access-v1-3-b0f6d1ad4850@kernel.org
[fix check to also cover mgmt->u.action.u.addba_req.capab,
correct Fixes tag]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index f7d392fce8c28..f69cb83adcca9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -375,6 +375,7 @@ mt76_connac2_mac_write_txwi_80211(struct mt76_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 + 1 + 2 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ) {
 		u16 capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
-- 
2.51.0



