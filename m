Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6137537D101;
	Wed, 20 May 2026 16:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294596; cv=none; b=Knup86h4yaH8Jk+f0svtCMEUZY004uHO7I4oskPlmztk9vWZ/PrQhIfXzS28p0AtubBEQklpZ+Ri4CHDNNIGj9TQjLE9XL+zVT6uENt9WhW0L5sQjn6aoxyQ40ZMpVCm8acVOrhxjLYX/Zu7a4PUudKijvcuiSq1nMhCh7Qgajw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294596; c=relaxed/simple;
	bh=X0CRVXQicRXox4z1L26XcnQ8Ybjky1wxrhtZ/T2Ls5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeNsUIQl2hg/BXbo7kLcard5yvXrRHb7bnHJUQpusrY1W+I9J87pWu2QTxK1ybX8RNoy8h23rCNmAM1b0Mwqp/4wtg+ZkOpC+W6qGKH9JJtO0ffdQRH4T6P8oVHkch3xxMQOvCGUAsFJXT/KPlETxTfeb+9++LXpJeg9slA8YQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4XbScnb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4XbScnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85531F000E9;
	Wed, 20 May 2026 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294595;
	bh=wbTV1iPiOt+SniDxEAEELlBBZIGFa9Wc9oOPFl9ZTNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4XbScnbnZpBp16BZzSIEeCZZoTpDCptTB9G9k0ifqvz1oLVDAAHJw7HIxtJiCN+p
	 La+2gvX5S4BYTBNHrd8H/UlEYbfm4ZqM8CZ48gGTXif6zRt4St456A3J2EHoAqtUbb
	 AyUwxWhfon95ug3BIjOQRxfab8lkjpuv66lYx7k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0099/1146] wifi: mt76: mt7996: Reset ampdu_state state in case of failure in mt7996_tx_check_aggr()
Date: Wed, 20 May 2026 18:05:49 +0200
Message-ID: <20260520162150.586140122@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c0747db7c10c2dfbdcff0e8e97021e3df1f1e362 ]

Reset the ampdu_state configured state if ieee80211_start_tx_ba_session
routine fails in mt7996_tx_check_aggr()

Fixes: 98686cd21624c ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251214-mt7996-aggr-check-fix-v1-1-33a8b62ec0fc@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 5e0c85066803d..d6ef2f8003269 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1270,8 +1270,9 @@ mt7996_tx_check_aggr(struct ieee80211_link_sta *link_sta,
 	if (unlikely(fc != (IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_DATA)))
 		return;
 
-	if (!test_and_set_bit(tid, &wcid->ampdu_state))
-		ieee80211_start_tx_ba_session(link_sta->sta, tid, 0);
+	if (!test_and_set_bit(tid, &wcid->ampdu_state) &&
+	    ieee80211_start_tx_ba_session(link_sta->sta, tid, 0))
+		clear_bit(tid, &wcid->ampdu_state);
 }
 
 static void
-- 
2.53.0



