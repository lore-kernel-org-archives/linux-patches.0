Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F75134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF08EC433D2;
	Mon, 12 Jun 2023 10:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566806;
	bh=9sHuu3R+X8TzQQXU4igDfk+2EX7hIwz9RjZO06KtObo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkXo9BRe3Rn/WoQgTkSXKqLaXsusdL+UBm6EqAO09Q8lAMOTqv2tQWyElbkbchU3P
	 AV+XAiMuLOR5pzeJLMgbik5PCAl6ib4ZGhfoGUpSssWbWBkMjgeGEHZG9S/XjvDUd5
	 8Z8/+crdS00PiaUWU1NOQq2h6q94+XipdUQEcRNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 038/160] wifi: cfg80211: fix locking in regulatory disconnect
Date: Mon, 12 Jun 2023 12:26:10 +0200
Message-ID: <20230612101716.793331479@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f7e60032c6618dfd643c7210d5cba2789e2de2e2 ]

This should use wiphy_lock() now instead of requiring the
RTNL, since __cfg80211_leave() via cfg80211_leave() is now
requiring that lock to be held.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0d40d6af7e10a..949e1fb3bec67 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2440,11 +2440,11 @@ static void reg_leave_invalid_chans(struct wiphy *wiphy)
 	struct wireless_dev *wdev;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
-	ASSERT_RTNL();
-
+	wiphy_lock(wiphy);
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list)
 		if (!reg_wdev_chan_valid(wiphy, wdev))
 			cfg80211_leave(rdev, wdev);
+	wiphy_unlock(wiphy);
 }
 
 static void reg_check_chans_work(struct work_struct *work)
-- 
2.39.2



