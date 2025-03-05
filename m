Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A56198A0D;
	Wed,  5 Mar 2025 17:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197074; cv=none; b=CIH79mmUCRnTYfxwz//LYFCup+K98plfhB1IEg7n2i3NaDJtdWo2k6o+ikrGK/+4NocBLcNde2yx27xJIrDbdbNKQHAgC+9MxOdlwSezFXennWOAqxcuT6SX7bDcvIyOdkMt1KdG44oOrk9uksU5ZhOs46IfNjTtRoE8BoytLUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197074; c=relaxed/simple;
	bh=t+1KIkb/chcv1EKPjtFDBcUN/H5YSovWiI+IUKE2Jfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVqxw72S+8EW6Hggx7AePJHEmZ//A62+oGpTFut8D1P5qLtDSpxlyT0pn3Oo/Zfq16l2FLFriuQ4qe5iaSw6GQlKdWwho4kB6mIGQZEqRf/vbV+3cL4p5NXWBDEPq9dLoBrKhCn76SIqoNWKNXibv6Sk1a/74YroUrgD4YYgv+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRIVe9Ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRIVe9Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCDBC4CED1;
	Wed,  5 Mar 2025 17:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197074;
	bh=t+1KIkb/chcv1EKPjtFDBcUN/H5YSovWiI+IUKE2Jfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRIVe9OxQc6nRe5tAnm/zn8B1icXmUOceTnQ/ZBgNFpRoW5+4lcLoNX8Fi1/53rDL
	 drwMvlxYeqjpgjkpDG2EIYJDNGjulm90Efv23WzI+2Uan9ro+nKa7zGroq/k+ZW9RY
	 II739xU1xIFzIIKuMsUemmOQWZkUQge38q4YMQyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/176] md: factor out a helper from mddev_put()
Date: Wed,  5 Mar 2025 18:46:12 +0100
Message-ID: <20250305174505.584755957@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 3d8d32873c7b6d9cec5b40c2ddb8c7c55961694f ]

There are no functional changes, prepare to simplify md_seq_ops in next
patch.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230927061241.1552837-2-yukuai1@huaweicloud.com
Stable-dep-of: 8d28d0ddb986 ("md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4b629b7a540f7..44bac1e7d47e2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -667,23 +667,28 @@ static inline struct mddev *mddev_get(struct mddev *mddev)
 
 static void mddev_delayed_delete(struct work_struct *ws);
 
+static void __mddev_put(struct mddev *mddev)
+{
+	if (mddev->raid_disks || !list_empty(&mddev->disks) ||
+	    mddev->ctime || mddev->hold_active)
+		return;
+
+	/* Array is not configured at all, and not held active, so destroy it */
+	set_bit(MD_DELETED, &mddev->flags);
+
+	/*
+	 * Call queue_work inside the spinlock so that flush_workqueue() after
+	 * mddev_find will succeed in waiting for the work to be done.
+	 */
+	queue_work(md_misc_wq, &mddev->del_work);
+}
+
 void mddev_put(struct mddev *mddev)
 {
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
-	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
-	    mddev->ctime == 0 && !mddev->hold_active) {
-		/* Array is not configured at all, and not held active,
-		 * so destroy it */
-		set_bit(MD_DELETED, &mddev->flags);
 
-		/*
-		 * Call queue_work inside the spinlock so that
-		 * flush_workqueue() after mddev_find will succeed in waiting
-		 * for the work to be done.
-		 */
-		queue_work(md_misc_wq, &mddev->del_work);
-	}
+	__mddev_put(mddev);
 	spin_unlock(&all_mddevs_lock);
 }
 
-- 
2.39.5



