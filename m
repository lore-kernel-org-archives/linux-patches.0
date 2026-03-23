Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B200242D7F;
	Mon, 23 Mar 2026 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277949; cv=none; b=e4awBCI0X8r9kV7A3vYTmqH4/1bS+mxBqZ4lTFGjJb12Een7uz5uQa3C7aI3hvi4vNj2e25RPAvN0W71sIDfW+gWN6MwM1tuc4+8pJKhxQ5kkKzL42ixERK4/iZe2vJB5mL2ffLzFvRIJi32BhPUzjZl/d+VgIgBaUbKt0ynnzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277949; c=relaxed/simple;
	bh=WIsZykr7d2NVP44/nVnHCpCXeBvV9858KrBQHwq1oHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aH3nM9Rn9w0y03i6KJoKudNMddv+4b4+mBeM+/m7k3HspQYfUPhc4fSZwML2Ia8BMJkEQiXIrctail1HPrlilKJLLBwECxUpad2bu+ff+T/XbJVtMBZFWOyTIij3LeTdsYR+bizP3oir4DavRZhtpR8UCNpDr4AS3sawCOT9iTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNLFO6rs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNLFO6rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8103FC2BCB1;
	Mon, 23 Mar 2026 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277948;
	bh=WIsZykr7d2NVP44/nVnHCpCXeBvV9858KrBQHwq1oHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNLFO6rsjwVEw4cmfqpoQF8AZEPA97WpkvPIuccmBYhE3ly6DI//9V4EpenmJBGDH
	 l8Ja71JehcYGlpuhNoGpp10nY695S3hI6ixMuAih8IqKqlwjcoE5khwS4KiHJwqSQ5
	 WKfksdFvyLINil4mKjtUCzlHLAs9njuEGk14dmQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/567] wifi: mt76: Fix possible oob access in mt76_connac2_mac_write_txwi_80211()
Date: Mon, 23 Mar 2026 14:41:14 +0100
Message-ID: <20260323134537.641746520@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 87479c6c2b505..570c9dcbc505e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -394,6 +394,7 @@ mt76_connac2_mac_write_txwi_80211(struct mt76_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 + 1 + 2 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ) {
 		u16 capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
-- 
2.51.0



