Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E2C2F5E;
	Tue, 12 Aug 2025 18:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023930; cv=none; b=A865Q8lRZS2p86+koZtObcYXFrao1cUokXvHdLjmSeN31Jcq+KARL+hmVDG+dzEx97khYskHJLWXX9PResHsLC0HYdvd5rqF4Y0ZaCFlaSv1bM8kQatOC81nNSnG9QxLZ8QHHz3InjZJx64H+rwWQD7motfCqETt0FKxyjPlxoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023930; c=relaxed/simple;
	bh=bERJcUwDk8Mwue2APiS7DcJxXenJk+40Ficp9hnQqFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iocuHKEy7XgFOMqdavrh4R6mFFBsLKOHrkl6Qs/qWO7YCwc+J1e4urKbLjFbg+Y8L8DUxwVguwUewL0oBpI2u2lrMS+YZpkpza+dK8vXBkP/d4goEWhJ/Hn26HN1q3pMHvDpTE8loDl8Zqmi1ceCIC37VHqjqBE2pyePQnRCS2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BU5tKk+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BU5tKk+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D23C4CEF0;
	Tue, 12 Aug 2025 18:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023929;
	bh=bERJcUwDk8Mwue2APiS7DcJxXenJk+40Ficp9hnQqFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BU5tKk+wD00xmVk1LEMCKjreZRRDUVMpU94FnE2pRyxfMBPwjZ9QiZC8Ij+TVVyw9
	 VtBvnnN5ywSVnBHkv1PsNoDS9/amyAybt3p0wCQ44SbOyOjY6uXa6cP4Viuk2EDPaP
	 g0G8HmW1YMU58rj33NAvEGikvhkGwL21AMAYYXv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 223/627] wifi: rtw88: Fix macid assigned to TDLS station
Date: Tue, 12 Aug 2025 19:28:38 +0200
Message-ID: <20250812173427.760107043@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 526b000991b557c40ea53e64ba24bb9e0fff0071 ]

When working in station mode, TDLS peers are assigned macid 0, even
though 0 was already assigned to the AP. This causes the connection
with the AP to stop working after the TDLS connection is torn down.

Assign the next available macid to TDLS peers, same as client stations
in AP mode.

Fixes: 902cb7b11f9a ("wifi: rtw88: assign mac_id for vif/sta and update to TX desc")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/58648c09-8553-4bcc-a977-9dc9afd63780@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index c4de5d114eda..8be6e70d92d1 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -349,7 +349,7 @@ int rtw_sta_add(struct rtw_dev *rtwdev, struct ieee80211_sta *sta,
 	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
 	int i;
 
-	if (vif->type == NL80211_IFTYPE_STATION) {
+	if (vif->type == NL80211_IFTYPE_STATION && !sta->tdls) {
 		si->mac_id = rtwvif->mac_id;
 	} else {
 		si->mac_id = rtw_acquire_macid(rtwdev);
@@ -386,7 +386,7 @@ void rtw_sta_remove(struct rtw_dev *rtwdev, struct ieee80211_sta *sta,
 
 	cancel_work_sync(&si->rc_work);
 
-	if (vif->type != NL80211_IFTYPE_STATION)
+	if (vif->type != NL80211_IFTYPE_STATION || sta->tdls)
 		rtw_release_macid(rtwdev, si->mac_id);
 	if (fw_exist)
 		rtw_fw_media_status_report(rtwdev, si->mac_id, false);
-- 
2.39.5



