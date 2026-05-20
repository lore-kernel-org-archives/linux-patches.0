Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C690369999;
	Wed, 20 May 2026 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297570; cv=none; b=UGbCzJRd3kdB8tUEstC/Sj/DP89yY5UCmwLEAfx3R1IHELsNvN2+RWGzL8Shn0kc1O4d9ZlcvfpYNtqlzI0RvmVQo4UJhXkBgofAGs0fmOa5MA+kzbvfWvUDQJ/UEKKJfZtVW1iIte4ZYnYSQozfgT5UnlN/+SqkjpXk+jfAT4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297570; c=relaxed/simple;
	bh=MW3y+LLSdEJAntZsFNfDHcb/gpPhHv/joqDy20IIlb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLXFQkKhPa/WIMfF+iorRbnXwEMPeTaV9KIDsk4Y0QROFJS3ocxjXVlkjagI26gJVDnFb9HzstiP9N47xQlT5ICYwK0BypssNMvKGSl9MKs+h+l3jywazaVquH5KjDnfpVe8jj3YMrcazbqf3qNMLkBu3HZeWngYLVqKP3DexW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOyoCtof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOyoCtof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30861F000E9;
	Wed, 20 May 2026 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297569;
	bh=YZVvpcNm+qOba6sh45FRu4MprCcxHM9ivJGgtRLtfPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOyoCtofoIawcxsyzBgdPJwlpZHXKG4Xz/tJabQZFwXLhDcBpmPk0fmawVCzGONYT
	 NMSRvkUBQ6f4auqHIn/IZuFBtffFyIXi0nLdYdYlZQkC0J7FmhlAXsO8rWaxnjM58/
	 MK01ZJtTNe+73mmFHyo/QpUvMeBL1qsmCDycHhSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/957] wifi: mt76: mt7996: Reset ampdu_state state in case of failure in mt7996_tx_check_aggr()
Date: Wed, 20 May 2026 18:09:22 +0200
Message-ID: <20260520162136.275247230@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 24b404f35409b..15d796702a589 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1243,8 +1243,9 @@ mt7996_tx_check_aggr(struct ieee80211_link_sta *link_sta,
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



