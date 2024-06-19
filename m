Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B932C4D9EA;
	Wed, 19 Jun 2024 13:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803571; cv=none; b=raC+8RMXG8Jpe9eZLZlsJXzIVQGrJ0mDj6NcQPDVg/a8nUs6C3D0WJiTXJ3EA+LuvuF2Sa8LB2GRuAtkV9AmC+gCmcuIsXcExdXMnhUFsS3M8cMXmUJ/I8IQ21ZYJxExE/Jk7eISkqTYlIuxdcZ5t4JPazkQsm5zFIGTKws5Rmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803571; c=relaxed/simple;
	bh=J/VLXPQx6rysQgfXPhz312uAbUlKT8fLfcCx2oobwYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFuhmdOCCsofn47Xk5xwPzhjJhRB+qCGTJQN7+DhFVE+a6e7tZYqd8hKZSSHY28TOnbk2ErBc6EIAE8hcqHnc831Rd8K66PvuiEblsVaczvbNec+E4Zxxyp89niyhcGz70KBtuIcSJKomTs6lzhCNi+O1twCdaS02i0tq27WMuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyUfblts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyUfblts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34072C2BBFC;
	Wed, 19 Jun 2024 13:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803571;
	bh=J/VLXPQx6rysQgfXPhz312uAbUlKT8fLfcCx2oobwYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyUfblts6qb+S6a8BKN6QwlkhWy/6A9YnFilpAfDrhh8nngUR1TyTNcjvNaL57gFE
	 4kGdVju+vFRDhcX2oD88s/qBpEO8fbDFBnrWSFlGZ7rIEvIZaursuE6DabWUsB+U8h
	 UPLPWg1tpBOdReefehLnPs0+Ehoyi+wM7/A6kAVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/217] wifi: cfg80211: fully move wiphy work to unbound workqueue
Date: Wed, 19 Jun 2024 14:54:06 +0200
Message-ID: <20240619125556.628441941@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

[ Upstream commit e296c95eac655008d5a709b8cf54d0018da1c916 ]

Previously I had moved the wiphy work to the unbound
system workqueue, but missed that when it restarts and
during resume it was still using the normal system
workqueue. Fix that.

Fixes: 91d20ab9d9ca ("wifi: cfg80211: use system_unbound_wq for wiphy work")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240522124126.7ca959f2cbd3.I3e2a71ef445d167b84000ccf934ea245aef8d395@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c  | 2 +-
 net/wireless/sysfs.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3fcddc8687ed4..22f67b64135d2 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -427,7 +427,7 @@ static void cfg80211_wiphy_work(struct work_struct *work)
 	if (wk) {
 		list_del_init(&wk->entry);
 		if (!list_empty(&rdev->wiphy_work_list))
-			schedule_work(work);
+			queue_work(system_unbound_wq, work);
 		spin_unlock_irq(&rdev->wiphy_work_lock);
 
 		wk->func(&rdev->wiphy, wk);
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index a88f338c61d31..17ccb9c6091e8 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -5,7 +5,7 @@
  *
  * Copyright 2005-2006	Jiri Benc <jbenc@suse.cz>
  * Copyright 2006	Johannes Berg <johannes@sipsolutions.net>
- * Copyright (C) 2020-2021, 2023 Intel Corporation
+ * Copyright (C) 2020-2021, 2023-2024 Intel Corporation
  */
 
 #include <linux/device.h>
@@ -137,7 +137,7 @@ static int wiphy_resume(struct device *dev)
 	if (rdev->wiphy.registered && rdev->ops->resume)
 		ret = rdev_resume(rdev);
 	rdev->suspended = false;
-	schedule_work(&rdev->wiphy_work);
+	queue_work(system_unbound_wq, &rdev->wiphy_work);
 	wiphy_unlock(&rdev->wiphy);
 
 	if (ret)
-- 
2.43.0



