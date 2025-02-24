Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E5418B46C;
	Mon, 24 Feb 2025 14:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407913; cv=none; b=gGZdLFg3ZXF5F8aPbJ+/G1Fz0QdZPVm+8skqbVVONSdLcU+WQXlfbVpmeBy/PBh6KwOJQ0VnDq9yCma96qgMeN/nhVMorZpUyCHhQrC9hPgW8t7ov6l8tNh6+wQWO+xWyMulPLdbA1syjWI6Lh6xj3BVrXPOyZQgIyhlQk1ojqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407913; c=relaxed/simple;
	bh=pZNULoOEY3xNjpLHL77Ld/cQQE+egcUD9rEkDQmKjw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebjUAL8uXPUN6UNLXNR1N3+UBsvhUKEztG8fKt/tcQxtrVDtgfuJRBtWX0W1m5NlO4GT8E2tWRO6gSrZxXxf/dVbku3+wud33JLtyFNQlEIiNGGVAI6rEWfpaCxOlwdq39I/GsFpbitaoCXbXfdJ9t0v1fF1A+2uN9l+qmoMIfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpXPLNcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpXPLNcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBF5C4CED6;
	Mon, 24 Feb 2025 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407913;
	bh=pZNULoOEY3xNjpLHL77Ld/cQQE+egcUD9rEkDQmKjw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpXPLNcTdiDcHxQQ5PIAxUWoVhP4UJ3DXHBRbP5HtI6WEXUFbNiUCUZRnstJv3rLI
	 n3sc3CgijtYTRJ1OA3COdwWo4vbFm4gmJzEfwACsky3cnYabDgGjI/Bvgyw8x8LP1I
	 rviQ3EHscOeH38w5s8T3It9yXIyZNX5dQ2rbzh7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/140] md: use separate work_struct for md_start_sync()
Date: Mon, 24 Feb 2025 15:33:47 +0100
Message-ID: <20250224142604.115413211@linuxfoundation.org>
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
index 9bc19a5a4119b..342407ea87d83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -648,13 +648,13 @@ void mddev_put(struct mddev *mddev)
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
@@ -679,6 +679,9 @@ void mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
+
+	INIT_WORK(&mddev->sync_work, md_start_sync);
+	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
 }
 EXPORT_SYMBOL_GPL(mddev_init);
 
@@ -9333,7 +9336,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 
 static void md_start_sync(struct work_struct *ws)
 {
-	struct mddev *mddev = container_of(ws, struct mddev, del_work);
+	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
 
 	rcu_assign_pointer(mddev->sync_thread,
 			   md_register_thread(md_do_sync, mddev, "resync"));
@@ -9546,8 +9549,7 @@ void md_check_recovery(struct mddev *mddev)
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
index f29fa8650cd0f..46995558d3bd9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -453,7 +453,10 @@ struct mddev {
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



