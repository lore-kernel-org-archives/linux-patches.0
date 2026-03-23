Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB271DA0E1;
	Mon, 23 Mar 2026 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282879; cv=none; b=ZF85FBsbHoQhvTASLebcGsXu5OWditES3Te0FXXNvXgUQJoa2ybfUyAczb65avcphDNBOhy5fOZo0LZI3H/a2iIcdziOYIdRS5KAMdR3HwdSgQFXhERUH9lo1TWrH4mBqRDROFYRg0/waVxjmiPN+Z3s24g1h5NtpujI/Gno1ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282879; c=relaxed/simple;
	bh=Pl+O3Gw2Mnle4RlwgednxSQqGN/+l7KmYvKIULLgUc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFs/PTsNWHe9kk4R5sKojZhdDEm9D1C81L1Ory91maY7I2evjKsSN85qQcKXOzCRtvRI1caBmK2oMp1YUv+e5O4PSo98qO2aComdjCnwgCOMv4EtaAuJf/npUr2nLIbW1MwRO3sVCIjasKjEBcP1zxuE9rWTPi6cvY0zkMkVsDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxKZsehj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxKZsehj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429D9C2BCB3;
	Mon, 23 Mar 2026 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282879;
	bh=Pl+O3Gw2Mnle4RlwgednxSQqGN/+l7KmYvKIULLgUc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxKZsehj8vB8KXGoUx9lSwRl1eSj6jhOHoE6gbrPPeVgktDFOOgsS1C0ncvpV90VL
	 zVn0m7oSv21+byKfBcaXL8ZAGs2I/KAilCsAElpQGA7TfTPAKpue7IosQprU792GBj
	 LViUQrnFzFxbM45lvHMlXvN4L0lJocJgqXVGyC7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 318/481] wifi: cfg80211: move scan done work to wiphy work
Date: Mon, 23 Mar 2026 14:45:00 +0100
Message-ID: <20260323134532.849347427@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit fe0af9fe54d0ff53aa49eef390c8962355b274e2 ]

Move the scan done work to the new wiphy work to
simplify the code a bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 767d23ade706 ("wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    3 +--
 net/wireless/core.h |    4 ++--
 net/wireless/scan.c |   14 ++++----------
 3 files changed, 7 insertions(+), 14 deletions(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -525,7 +525,7 @@ use_default_name:
 	spin_lock_init(&rdev->bss_lock);
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_LIST_HEAD(&rdev->sched_scan_req_list);
-	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
+	wiphy_work_init(&rdev->scan_done_wk, __cfg80211_scan_done);
 	INIT_DELAYED_WORK(&rdev->dfs_update_channels_wk,
 			  cfg80211_dfs_channels_update_work);
 #ifdef CONFIG_CFG80211_WEXT
@@ -1125,7 +1125,6 @@ void wiphy_unregister(struct wiphy *wiph
 	/* this has nothing to do now but make sure it's gone */
 	cancel_work_sync(&rdev->wiphy_work);
 
-	flush_work(&rdev->scan_done_wk);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -75,7 +75,7 @@ struct cfg80211_registered_device {
 	struct sk_buff *scan_msg;
 	struct list_head sched_scan_req_list;
 	time64_t suspend_at;
-	struct work_struct scan_done_wk;
+	struct wiphy_work scan_done_wk;
 
 	struct genl_info *cur_cmd_info;
 
@@ -447,7 +447,7 @@ bool cfg80211_valid_key_idx(struct cfg80
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr);
-void __cfg80211_scan_done(struct work_struct *wk);
+void __cfg80211_scan_done(struct wiphy *wiphy, struct wiphy_work *wk);
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 			   bool send_message);
 void cfg80211_add_sched_scan_req(struct cfg80211_registered_device *rdev,
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1096,16 +1096,9 @@ void ___cfg80211_scan_done(struct cfg802
 		nl80211_send_scan_msg(rdev, msg);
 }
 
-void __cfg80211_scan_done(struct work_struct *wk)
+void __cfg80211_scan_done(struct wiphy *wiphy, struct wiphy_work *wk)
 {
-	struct cfg80211_registered_device *rdev;
-
-	rdev = container_of(wk, struct cfg80211_registered_device,
-			    scan_done_wk);
-
-	wiphy_lock(&rdev->wiphy);
-	___cfg80211_scan_done(rdev, true);
-	wiphy_unlock(&rdev->wiphy);
+	___cfg80211_scan_done(wiphy_to_rdev(wiphy), true);
 }
 
 void cfg80211_scan_done(struct cfg80211_scan_request *request,
@@ -1131,7 +1124,8 @@ void cfg80211_scan_done(struct cfg80211_
 	}
 
 	request->notified = true;
-	queue_work(cfg80211_wq, &wiphy_to_rdev(request->wiphy)->scan_done_wk);
+	wiphy_work_queue(request->wiphy,
+			 &wiphy_to_rdev(request->wiphy)->scan_done_wk);
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
 


