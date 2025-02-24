Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C9424888F;
	Mon, 24 Feb 2025 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407952; cv=none; b=N+EXNLRkojevEOPMsNZiglEn10m42dtzUA9mpnAZD2RJRXtfu/bPKTt8LQJkMZ866cTj0diH99/2Yu+xqSc0oKJmJQ7eX5FUwqkcZSUXWV32NphBUquPLDL1TyAWvvybzSXXNlISFydn7gnhYNTjzUVUNM4uitWmNQ1cxi1937w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407952; c=relaxed/simple;
	bh=gOPDnb3XL/itIGZwoZDQrL3Y6QT+iZqINQDbnZ2rQ8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCh4oR4Sh3Ba0teHhTZXgBmW17HHwICIY1qd6DrmYH3I1GV8RatX6tw11o0N1KgreTVi3YOYBIV0Ozrepeqq55U41saKWTOeqNPTq/9ZNn4O1RxzuSaOnAbiNtqx2Z6gKqaCTztkTtOtMtIYQvF46JU/luoDAiNK8GMluoXBL1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMdZ7/TA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMdZ7/TA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1594FC4CEEC;
	Mon, 24 Feb 2025 14:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407951;
	bh=gOPDnb3XL/itIGZwoZDQrL3Y6QT+iZqINQDbnZ2rQ8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMdZ7/TA56a1CFTGWbvw+bOfbbdMJLf0ekSTaWDaBqwM+0oUUY9pZAVLO0+PnaQBm
	 H1Zfpk34v/DZ3Q3Vo9V8ykMpyA0ZwtRF35eDUl7rEYInoW4ZKyaLLOD5etzMFZkNnZ
	 uG38alEBdaXAvI4/t6UeWfQc5GeG96rCOM/S/fxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/140] md: factor out a helper from mddev_put()
Date: Mon, 24 Feb 2025 15:33:48 +0100
Message-ID: <20250224142604.153963124@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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
index 342407ea87d83..836e8ed58c8ad 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -633,23 +633,28 @@ static inline struct mddev *mddev_get(struct mddev *mddev)
 
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



