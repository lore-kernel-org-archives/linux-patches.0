Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05934C142
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A32C433C8;
	Mon, 19 Jun 2023 10:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172338;
	bh=rdiy3boReURjM9Iv+4izQiLvwjRJOGrJcui7kNF4eds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YC1UdJEsEBnUptwA5C6YiDmdx8Lh80GKyuxKmyXUnzKK5eQlyuEfIZhYM7YxsWwP2
	 aS8q/EYsnYsegO60x9hc0WSIsYk05DzACEc8DfEgAh9K50KaKzLPAwwcAbjfap5FpK
	 AvAOSc532b/7S6mzP18kCCHH+Ka+3xMhLuFLbd7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 033/107] wifi: cfg80211: fix locking in regulatory disconnect
Date: Mon, 19 Jun 2023 12:30:17 +0200
Message-ID: <20230619102143.089186322@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
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

commit f7e60032c6618dfd643c7210d5cba2789e2de2e2 upstream.

This should use wiphy_lock() now instead of requiring the
RTNL, since __cfg80211_leave() via cfg80211_leave() is now
requiring that lock to be held.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/reg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2423,11 +2423,11 @@ static void reg_leave_invalid_chans(stru
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


