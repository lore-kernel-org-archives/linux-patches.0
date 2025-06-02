Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8762F15CD55;
	Mon,  2 Jun 2025 15:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877330; cv=none; b=TmlrrKzfvIQWyXR89vXWyQeg/+wuqTcQDDZeS4APM56+3n1PtRCSS/yNjdptVC+qkonVx5s7YpkiGTvFdxkkxvBPUjLHrqknCJNhV81mYMBiU4pXLRH1CzCWqpm4EqZvhj99cwcGgmSmh+GrnDq0cjAvia3lF+J/C/ibAuiJcXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877330; c=relaxed/simple;
	bh=QlHdtWePQza0JGb0ej+ixaKr0W9ddjyaXXsQ489sR1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoW2Np31feM9z9EHUwhdc8XP0N1eaZCTdYfTOCDnrCyHF5VXNZyBGPeAtPObIPdYhDJCPKORtMVq/QCy4X8P0FnPcrzKDw9pG9dobz5GJE94hjp6b/fAaHrZbUUaNJKXkODgzRHSjPbN69TvWTWToXVfhlyFW5HQvbvCDD+pu68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tD//uAo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tD//uAo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FECEC4CEEE;
	Mon,  2 Jun 2025 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877330;
	bh=QlHdtWePQza0JGb0ej+ixaKr0W9ddjyaXXsQ489sR1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tD//uAo14gLH14NHsBfODfTaIM90n7Lchb4+g4jJwRkQHlz6+Z2Nw6fB9nQ/RMb/y
	 vT5cyrY38d9tFX5u1299o3lS+7PUo1jpyttsXyf+Ds1Gq+z2xhBcQjNwi1X70uHecj
	 6l504WaUMMgl4rsvH+01z5vy3kEpVPc+LKHVfgbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/325] wifi: rtw89: add wiphy_lock() to work that isnt held wiphy_lock() yet
Date: Mon,  2 Jun 2025 15:48:09 +0200
Message-ID: <20250602134328.453390738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6e5a740b128f0..2d31193fcc87d 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -334,6 +334,7 @@ void rtw89_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct rtw89_dev *rtwdev = hw->priv;
 
+	wiphy_lock(wiphy);
 	mutex_lock(&rtwdev->mutex);
 	rtw89_leave_ps_mode(rtwdev);
 
@@ -350,4 +351,5 @@ void rtw89_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request
 
 exit:
 	mutex_unlock(&rtwdev->mutex);
+	wiphy_unlock(wiphy);
 }
diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index afb1b41e1a9a5..f5dacdc4d11ab 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -153,9 +153,11 @@ static void ser_state_run(struct rtw89_ser *ser, u8 evt)
 	rtw89_debug(rtwdev, RTW89_DBG_SER, "ser: %s receive %s\n",
 		    ser_st_name(ser), ser_ev_name(ser, evt));
 
+	wiphy_lock(rtwdev->hw->wiphy);
 	mutex_lock(&rtwdev->mutex);
 	rtw89_leave_lps(rtwdev);
 	mutex_unlock(&rtwdev->mutex);
+	wiphy_unlock(rtwdev->hw->wiphy);
 
 	ser->st_tbl[ser->state].st_func(ser, evt);
 }
@@ -624,9 +626,11 @@ static void ser_l2_reset_st_hdl(struct rtw89_ser *ser, u8 evt)
 
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



