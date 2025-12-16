Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F1836CDFA;
	Tue, 16 Dec 2025 12:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887963; cv=none; b=nMN/67bda9IZkg0QnNnaDfVJeYWfvTqEAAPXXRMZ83QRT16DcED7eHoe7u2aFSaBfYBuDkPO/lKd3WbL7e0Xbh+xgoWscmaCV6aIwyFsKCc538jUkuSZC5uz1IHFEWzx2SdLYgyGgftYhslD3dcunJNtYqMqlzjIuRdn1EO5ago=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887963; c=relaxed/simple;
	bh=YI58U6olesAR1YqwGa3MC7P0ORY46LyqXApz4Os1d6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAhbcpucYrrQlYPej+/zXdnRs2O9SqYitKR9LZiYR3pwuN6Gs3Dnhoa8kxorKb7waIFrXbNRU21Ijpuo8LSdVx4F7pHoyicT2GSf3iidXJAWK3igQNWt45Ch7gGBBofllsbQXbJo8PgygwCEh+o+0RRWJubSx7/AtWStX2ZdhhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdXYCA4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdXYCA4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5FDC4CEF1;
	Tue, 16 Dec 2025 12:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887962;
	bh=YI58U6olesAR1YqwGa3MC7P0ORY46LyqXApz4Os1d6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdXYCA4zcTpwsQmOG6f+n/w4VwueqIpU7nqTlZkY/iTALt78stqyEGcEWNKuS3mbY
	 yvqN1txJUaLAxQq5K9lZpfcaMSo9ZJTyxqBN3JLlQZwSnwv+RIzwOANKhtFgp31nbL
	 3kDgxO7WXhKXcS1/pmFSAD9IGpGU1MmTsWtnzn4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 391/614] wifi: mt76: mt7996: fix teardown command for an MLD peer
Date: Tue, 16 Dec 2025 12:12:38 +0100
Message-ID: <20251216111415.538788103@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit e077071e7ac48d5453072f615d51629891c5b90d ]

For an MLD peer, we only need to call the teardown command when removing
the last link, and there's no need to call mt7996_mcu_add_sta() for the
earlier links.

Fixes: c1d6dd5d03eb ("wifi: mt76: mt7996: Add mt7996_mcu_teardown_mld_sta rouine")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251106064203.1000505-6-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 2b52d057287a1..aa46ea707b406 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1206,13 +1206,13 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 				mt7996_mac_twt_teardown_flow(dev, link,
 							     msta_link, i);
 
-			if (sta->mlo && links == BIT(link_id)) /* last link */
-				mt7996_mcu_teardown_mld_sta(dev, link,
-							    msta_link);
-			else
+			if (!sta->mlo)
 				mt7996_mcu_add_sta(dev, link_conf, link_sta,
 						   link, msta_link,
 						   CONN_STATE_DISCONNECT, false);
+			else if (sta->mlo && links == BIT(link_id)) /* last link */
+				mt7996_mcu_teardown_mld_sta(dev, link,
+							    msta_link);
 			msta_link->wcid.sta_disabled = 1;
 			msta_link->wcid.sta = 0;
 			links = links & ~BIT(link_id);
-- 
2.51.0



