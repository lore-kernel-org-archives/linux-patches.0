Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670C6804
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D4CC433EF;
	Mon, 12 Jun 2023 10:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566184;
	bh=LybuK3fQkzPL+DBGEg0lwc+NxKSAbUJznWG6acJXeBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ak8gJ2Hw15U/Kv7QS/4N2ft+O+1bxFRoW+DhX5fvEr/wCJ1LDmnZNNI9OmWsMHXAd
	 IYsm2Kiih98wyeib3mnyWbmuhe2lZxwEwLnQCz/KmwaMQ6GH1QmOQe/hAi6UxwfVgP
	 mjVOnjU651T9BMc8bcGCfxBsjsAvb+KWZWuKmoAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/91] wifi: cfg80211: fix locking in sched scan stop work
Date: Mon, 12 Jun 2023 12:26:16 +0200
Message-ID: <20230612101703.238942070@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
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

[ Upstream commit 3e54ed8247c94c8bdf370bd872bd9dfe72b1b12b ]

This should use wiphy_lock() now instead of acquiring the
RTNL, since cfg80211_stop_sched_scan_req() now needs that.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 441136646f89a..d10686f4bf153 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -368,12 +368,12 @@ static void cfg80211_sched_scan_stop_wk(struct work_struct *work)
 	rdev = container_of(work, struct cfg80211_registered_device,
 			   sched_scan_stop_wk);
 
-	rtnl_lock();
+	wiphy_lock(&rdev->wiphy);
 	list_for_each_entry_safe(req, tmp, &rdev->sched_scan_req_list, list) {
 		if (req->nl_owner_dead)
 			cfg80211_stop_sched_scan_req(rdev, req, false);
 	}
-	rtnl_unlock();
+	wiphy_unlock(&rdev->wiphy);
 }
 
 static void cfg80211_propagate_radar_detect_wk(struct work_struct *work)
-- 
2.39.2



