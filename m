Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5ED42B735;
	Wed,  4 Feb 2026 15:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217401; cv=none; b=O5Lq8FtRcrsIXJoARY3udtV1GkafQ3BFXmaohti/TCUySvoXUafxEGTlHYBxb0ZeWmaLdDCDkj46x7sw7oAgLDn+ph9aPScYUf2nIT8XX/22AxmIkh5zk7jQw+yIo5+iUcjLhpGMmpq5uUbIUrPd3ereAXC8Kab3tUXGfKkN6UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217401; c=relaxed/simple;
	bh=a3lfsgVaJeKZk8cTGDQH3U5uqWkhx1qygnrfhvDEUIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STcT3CpVK1g8ysk349NXFaW5aMA4evmpVvxVsRT/Xr+j6UH2JLyRPs6HkYFeLgFjns7MVhtMm9k44pEVQEFGk/If2oBp+fDwTJL33+JxsaYTC2mnGV6/yPLnewq3aUPKpZGz7aMrhOCWeQB9QeIEWIyWxA5TJ3/GZqdUo6yw69k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNXMpoGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNXMpoGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA45C19423;
	Wed,  4 Feb 2026 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217401;
	bh=a3lfsgVaJeKZk8cTGDQH3U5uqWkhx1qygnrfhvDEUIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNXMpoGrAAc+DOgphuDEIIYTgPYKOfu0ch4UMDMKM7IxtcgTTRqHmhwb9AzPk/US6
	 4NjTcA2vLtgu1eJrbku0Fg1VKdXoHTd1xH6qIXDvo9lQ4lo/arOrjtoXKLdWKQxiPT
	 jpjoAepDVvAAVJdVwuObtOJwxmXRJ7CFtHOl1Hdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 205/206] wifi: cfg80211: fully move wiphy work to unbound workqueue
Date: Wed,  4 Feb 2026 15:40:36 +0100
Message-ID: <20260204143905.611974642@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit e296c95eac655008d5a709b8cf54d0018da1c916 upstream.

Previously I had moved the wiphy work to the unbound
system workqueue, but missed that when it restarts and
during resume it was still using the normal system
workqueue. Fix that.

Fixes: 91d20ab9d9ca ("wifi: cfg80211: use system_unbound_wq for wiphy work")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240522124126.7ca959f2cbd3.I3e2a71ef445d167b84000ccf934ea245aef8d395@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c  |    2 +-
 net/wireless/sysfs.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -427,7 +427,7 @@ static void cfg80211_wiphy_work(struct w
 	if (wk) {
 		list_del_init(&wk->entry);
 		if (!list_empty(&rdev->wiphy_work_list))
-			schedule_work(work);
+			queue_work(system_unbound_wq, work);
 		spin_unlock_irq(&rdev->wiphy_work_lock);
 
 		wk->func(&rdev->wiphy, wk);
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
@@ -137,7 +137,7 @@ static int wiphy_resume(struct device *d
 	if (rdev->wiphy.registered && rdev->ops->resume)
 		ret = rdev_resume(rdev);
 	rdev->suspended = false;
-	schedule_work(&rdev->wiphy_work);
+	queue_work(system_unbound_wq, &rdev->wiphy_work);
 	wiphy_unlock(&rdev->wiphy);
 
 	if (ret)


