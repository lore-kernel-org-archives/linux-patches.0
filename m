Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4192512F2;
	Wed,  5 Mar 2025 17:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197043; cv=none; b=ZdJLqhDPeLYeYH+wGNXnDV0vUgJkJkWkfSYewGflfl+Qd1j+NvLQ0bTgt5uIcT2tvSdz+kMq+YTRGA2CpZyLxO54u2/TIdC05UWIMk+EqEdQdG0bzbC6NQ6gfBLkMYbpSVFjBmUM4Yzp0OTbEL3We+CBEqlWFwPPfwaEGKETDV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197043; c=relaxed/simple;
	bh=6CW8eLCN2oynefm4AM6NK3P0o6L9e07o1kW42x1MRc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ti0P/5bHeQw+IIWB432O+JZa9wTEYvzxBhRTyGwKLFDwP06oB0I0tqGouScSX/Hbl6xjiLq2vlKmV945oUez+dmWLrEtdyppP/P6T5hXyiTFl7XX6aqjSyAtzqW9oNvMvcQ/03AipOpXiTD9w0KZgZDmfmpZkIK2urUjM3ieYh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJPmYXOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJPmYXOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9693C4CED1;
	Wed,  5 Mar 2025 17:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197043;
	bh=6CW8eLCN2oynefm4AM6NK3P0o6L9e07o1kW42x1MRc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJPmYXOf/1u7GO9plMxq7wh1RMKOlyQlXKxoa4/axCGkohU3r39HFpORdwqpjaweq
	 +PlHn99QwwL8xvjRSlyJK1u+wV7r2lgwVK4rKZcVRHm6iLrykTStAa3sNIqdQmU+IP
	 7jZIuypVtR3YNxPHKP+eVRBOS/GuvMuno32BYqww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/176] md: use separate work_struct for md_start_sync()
Date: Wed,  5 Mar 2025 18:46:11 +0100
Message-ID: <20250305174505.543020625@linuxfoundation.org>
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

[ Upstream commit ac619781967bd5663c29606246b50dbebd8b3473 ]

It's a little weird to borrow 'del_work' for md_start_sync(), declare
a new work_struct 'sync_work' for md_start_sync().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230825031622.1530464-2-yukuai1@huaweicloud.com
Stable-dep-of: 8d28d0ddb986 ("md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 10 ++++++----
 drivers/md/md.h |  5 ++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 297c86f5c70b5..4b629b7a540f7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -682,13 +682,13 @@ void mddev_put(struct mddev *mddev)
 		 * flush_workqueue() after mddev_find will succeed in waiting
 		 * for the work to be done.
 		 */
-		INIT_WORK(&mddev->del_work, mddev_delayed_delete);
 		queue_work(md_misc_wq, &mddev->del_work);
 	}
 	spin_unlock(&all_mddevs_lock);
 }
 
 static void md_safemode_timeout(struct timer_list *t);
+static void md_start_sync(struct work_struct *ws);
 
 void mddev_init(struct mddev *mddev)
 {
@@ -710,6 +710,9 @@ void mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
+
+	INIT_WORK(&mddev->sync_work, md_start_sync);
+	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
 }
 EXPORT_SYMBOL_GPL(mddev_init);
 
@@ -9308,7 +9311,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 
 static void md_start_sync(struct work_struct *ws)
 {
-	struct mddev *mddev = container_of(ws, struct mddev, del_work);
+	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
 
 	mddev->sync_thread = md_register_thread(md_do_sync,
 						mddev,
@@ -9516,8 +9519,7 @@ void md_check_recovery(struct mddev *mddev)
 				 */
 				md_bitmap_write_all(mddev->bitmap);
 			}
-			INIT_WORK(&mddev->del_work, md_start_sync);
-			queue_work(md_misc_wq, &mddev->del_work);
+			queue_work(md_misc_wq, &mddev->sync_work);
 			goto unlock;
 		}
 	not_running:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4f0b480974552..c1258c94216ac 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -452,7 +452,10 @@ struct mddev {
 	struct kernfs_node		*sysfs_degraded;	/*handle for 'degraded' */
 	struct kernfs_node		*sysfs_level;		/*handle for 'level' */
 
-	struct work_struct del_work;	/* used for delayed sysfs removal */
+	/* used for delayed sysfs removal */
+	struct work_struct del_work;
+	/* used for register new sync thread */
+	struct work_struct sync_work;
 
 	/* "lock" protects:
 	 *   flush_bio transition from NULL to !NULL
-- 
2.39.5



