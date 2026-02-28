Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93910340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301074; cv=none; b=J7RLiBLiNUEhNknITTTzJLAfrltv8tGXnYfSlFDqXURZETm7EaJvjVd17MEs0VnRypRoSof6g8Tz3LoEOQ6no12blCLYB/jGWAC5ewOGeHgzfP3oj7jzWx/D+WqH2I5MVEPcEqG2doOI4w7R6PQoxhm5bnSC1QZaFEKHVZhGP7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301074; c=relaxed/simple;
	bh=TjMq3JlWOB7SkfmZ4Bw8pLvN7zg2RmVsVluWLyJiJb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSyYczU7a6J5QKqffyQqvgVeXiLQkL+ECHK7leYiCV131Ya364hjRvPEEol3OORCji+Ldevx3ArJslzkSLMffJiCLplG/LGiVNecOysYmlt36/oUDyMfnlurOcEYzku7OnUGusuXuykExrk+qvvVG/VZbybnF6zC+jZusRH4FK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wa131OZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wa131OZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B9BC116D0;
	Sat, 28 Feb 2026 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301074;
	bh=TjMq3JlWOB7SkfmZ4Bw8pLvN7zg2RmVsVluWLyJiJb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wa131OZPhXQ4E/WXSsabjY00urO8SO01ZRympsLWaW4XoZwLQHjkZ5jxX5YYeVbgt
	 nvLIb2KlhchcTxA2C+trqF0BzBQ9pGBmiJnhHtwuuRHGGcTSEGleD7Z2ovX4SY+zFD
	 i69I7HgtcRxcnBdjvBHROd3ziqVKxsjyF3pqb6Nrx4MtwAYCpHh+bUw5D5EQkt/nRa
	 GFSex5Z3ke3cfzZF62pCSIQALS3dXWlZjVZ4jf2tKfWQuDgkhooRBf42rNB5+NiHAN
	 mMEl1rmBziTn9Qmk47V1kps0P/pYmMJQKeXBf1hFRC73py0pivQCKv+SFk9On+aNuF
	 NdK6wXFW22xQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 220/752] wifi: rtw89: mcc: reset probe counter when receiving beacon
Date: Sat, 28 Feb 2026 12:38:51 -0500
Message-ID: <20260228174750.1542406-220-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 1b40c1c7571fcf926095ed92f25bd87900bdc8ed ]

For BE chips, needs to transmit QoS null data periodically to ensure
the connection with AP in GC+STA mode. However, in environments
with interference, the Qos null data might fail to transmit
successfully. Therefore, when receive the beacon from AP will
reset the QoS null data failure counter to avoid unnecessary
disconnection.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251223030651.480633-13-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/chan.c     | 5 ++++-
 drivers/net/wireless/realtek/rtw89/mac80211.c | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index 86f1b39a967fe..8fe6a7ef738f7 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -2608,17 +2608,20 @@ bool rtw89_mcc_detect_go_bcn(struct rtw89_dev *rtwdev,
 static void rtw89_mcc_detect_connection(struct rtw89_dev *rtwdev,
 					struct rtw89_mcc_role *role)
 {
+	struct rtw89_vif_link *rtwvif_link = role->rtwvif_link;
 	struct ieee80211_vif *vif;
 	bool start_detect;
 	int ret;
 
 	ret = rtw89_core_send_nullfunc(rtwdev, role->rtwvif_link, true, false,
 				       RTW89_MCC_PROBE_TIMEOUT);
-	if (ret)
+	if (ret &&
+	    READ_ONCE(rtwvif_link->sync_bcn_tsf) == rtwvif_link->last_sync_bcn_tsf)
 		role->probe_count++;
 	else
 		role->probe_count = 0;
 
+	rtwvif_link->last_sync_bcn_tsf = READ_ONCE(rtwvif_link->sync_bcn_tsf);
 	if (role->probe_count < RTW89_MCC_PROBE_MAX_TRIES)
 		return;
 
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 7b04183a3a5dd..474be7a5e49c7 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -127,6 +127,7 @@ static int __rtw89_ops_add_iface_link(struct rtw89_dev *rtwdev,
 	rtwvif_link->reg_6ghz_power = RTW89_REG_6GHZ_POWER_DFLT;
 	rtwvif_link->rand_tsf_done = false;
 	rtwvif_link->detect_bcn_count = 0;
+	rtwvif_link->last_sync_bcn_tsf = 0;
 
 	rcu_read_lock();
 
-- 
2.51.0

