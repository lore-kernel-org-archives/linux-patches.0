Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C0A1A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdNQfZzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AEBC433C8;
	Mon,  9 Oct 2023 13:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857623;
	bh=WjkXogRhDhMrm1fs1c9Dq/uELjQDUxALI3Yl9ZdViJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdNQfZzJ54PsiHXnCrCKrmx4O71/pyuYWanLLjBLaEepQJmNxQtmCXPYvts89gSDy
	 t6GgBPVuFpaptYtXa9A+WdV9pEDLjVzfBNPJCDjrrHZhX6K0M/ugudCFt8c33yHhJg
	 dzLdkCcXlVMK/IyDc6Aj3MhnN2zH5WsYHnX/euE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/162] wifi: cfg80211: move wowlan disable under locks
Date: Mon,  9 Oct 2023 15:00:59 +0200
Message-ID: <20231009130125.069545118@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit a993df0f9143e63eca38c96a30daf08db99a98a3 ]

This is a driver callback, and the driver should be able
to assume that it's called with the wiphy lock held. Move
the call up so that's true, it has no other effect since
the device is already unregistering and we cannot reach
this function through other paths.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 37c20b2effe9 ("wifi: cfg80211: fix cqm_config access race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9ac7c54379cf3..28ae86c62f805 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1049,6 +1049,10 @@ void wiphy_unregister(struct wiphy *wiphy)
 	cfg80211_rdev_list_generation++;
 	device_del(&rdev->wiphy.dev);
 
+#ifdef CONFIG_PM
+	if (rdev->wiphy.wowlan_config && rdev->ops->set_wakeup)
+		rdev_set_wakeup(rdev, false);
+#endif
 	wiphy_unlock(&rdev->wiphy);
 	rtnl_unlock();
 
@@ -1064,10 +1068,6 @@ void wiphy_unregister(struct wiphy *wiphy)
 	flush_work(&rdev->mgmt_registrations_update_wk);
 	flush_work(&rdev->background_cac_abort_wk);
 
-#ifdef CONFIG_PM
-	if (rdev->wiphy.wowlan_config && rdev->ops->set_wakeup)
-		rdev_set_wakeup(rdev, false);
-#endif
 	cfg80211_rdev_free_wowlan(rdev);
 	cfg80211_rdev_free_coalesce(rdev);
 }
-- 
2.40.1



