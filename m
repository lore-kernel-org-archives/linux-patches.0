Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6DB22FE18;
	Mon,  2 Jun 2025 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873936; cv=none; b=LdgGvnU99rM8sUNkQw/Ll6s4mopyHEbBklS7mmvG57RCndnt1jSqc2v/A6e5RPQ5n2vmtd7A9y3DVvEEm2nMvItJa0Kz8+H9Aj5Wj/15E4EZHMiyxnf1oyDFTELPAtzHUJdtvUQtT2Ltt8MfpnnUvDDZNrLdyXvHxpJjp6ddys0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873936; c=relaxed/simple;
	bh=OmL3dStt52ykJAybcyxroLCHavHbI5W3ZC6z4/wXzrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gbch4dmV0UGmizZR+STTT5lqOsZNuCUSmDVcZiLAgCDVtMShKeX4x1JdB30mjsHvMLmyDRoGvUeayOj7Yz98bZCC0DhEqX8LDt1ool+j+vc4jfnixBIKricQg8sacU8vAx6E2dH5wIxoBREWcgxLMC9iDOf+qHaH4F5Upf0DPok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4DeK88T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4DeK88T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2122C4CEEB;
	Mon,  2 Jun 2025 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873936;
	bh=OmL3dStt52ykJAybcyxroLCHavHbI5W3ZC6z4/wXzrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4DeK88TJB57EnxuWXZ5TT+Mt6trh3HxG1NYiVzqYwEPpAwCUVjqtIhv5abfgtwbt
	 mAVwB9V8vrTOjLuEIkkqP/FUQXb3ku9aN8IPoU2NYmp5vZF4eAmKKj7uK0EHbkVeEH
	 NJfsp7WwyYzJNQiZEXijcs/hO2D2yQQhHrGXaCNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/444] wifi: rtw89: add wiphy_lock() to work that isnt held wiphy_lock() yet
Date: Mon,  2 Jun 2025 15:46:05 +0200
Message-ID: <20250602134353.159959929@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit ebfc9199df05d37b67f4d1b7ee997193f3d2e7c8 ]

To ensure where are protected by driver mutex can also be protected by
wiphy_lock(), so afterward we can remove driver mutex safely.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250122060310.31976-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/regd.c | 2 ++
 drivers/net/wireless/realtek/rtw89/ser.c  | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/regd.c b/drivers/net/wireless/realtek/rtw89/regd.c
index 9e2328db18656..91f0895d9f540 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -451,6 +451,7 @@ void rtw89_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct rtw89_dev *rtwdev = hw->priv;
 
+	wiphy_lock(wiphy);
 	mutex_lock(&rtwdev->mutex);
 	rtw89_leave_ps_mode(rtwdev);
 
@@ -468,6 +469,7 @@ void rtw89_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request
 
 exit:
 	mutex_unlock(&rtwdev->mutex);
+	wiphy_unlock(wiphy);
 }
 
 static void __rtw89_reg_6ghz_power_recalc(struct rtw89_dev *rtwdev)
diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index 01b17b8f4ff9d..45165cf3e824e 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -156,9 +156,11 @@ static void ser_state_run(struct rtw89_ser *ser, u8 evt)
 	rtw89_debug(rtwdev, RTW89_DBG_SER, "ser: %s receive %s\n",
 		    ser_st_name(ser), ser_ev_name(ser, evt));
 
+	wiphy_lock(rtwdev->hw->wiphy);
 	mutex_lock(&rtwdev->mutex);
 	rtw89_leave_lps(rtwdev);
 	mutex_unlock(&rtwdev->mutex);
+	wiphy_unlock(rtwdev->hw->wiphy);
 
 	ser->st_tbl[ser->state].st_func(ser, evt);
 }
@@ -676,9 +678,11 @@ static void ser_l2_reset_st_hdl(struct rtw89_ser *ser, u8 evt)
 
 	switch (evt) {
 	case SER_EV_STATE_IN:
+		wiphy_lock(rtwdev->hw->wiphy);
 		mutex_lock(&rtwdev->mutex);
 		ser_l2_reset_st_pre_hdl(ser);
 		mutex_unlock(&rtwdev->mutex);
+		wiphy_unlock(rtwdev->hw->wiphy);
 
 		ieee80211_restart_hw(rtwdev->hw);
 		ser_set_alarm(ser, SER_RECFG_TIMEOUT, SER_EV_L2_RECFG_TIMEOUT);
-- 
2.39.5



