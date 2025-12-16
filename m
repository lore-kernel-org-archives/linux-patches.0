Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A372266B6B;
	Tue, 16 Dec 2025 12:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888479; cv=none; b=L2DUFUABTG92k1w25MwKFeXyT32eHpdOs7dP1yFMjZKidlOtNp/yrWW6gUSOvVLm1VYUcbQtq3wOIfOSuqHKW33KiivY+3C1VtzTHK7GmzHHaRnPOznBypWPjXDYDVv3GxKB4FYVbYMx4tU/lCY3xrQIT7jiOSq6mEyAmdRx97k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888479; c=relaxed/simple;
	bh=Ez9qjHFSGntU3OwXy49vNKoNnrNZfUatPyeV/KBgCXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJABuz/4y1QguvUXUCsxSAxR+FfZI0fz4kUc2AY5UFhqkfIIu0Us8F7gd9E2ZCDhtduet3A4vd4BKwO8YcdP8pw938EHwqwQBz8aGA4wwoa40QJRiCilHblKRYx/4aNQgU//+lp4N23pyQ+w7jJQmpLCztOi8iO2IxoCOAjICqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bK50gAvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bK50gAvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F36AC4CEF1;
	Tue, 16 Dec 2025 12:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888479;
	bh=Ez9qjHFSGntU3OwXy49vNKoNnrNZfUatPyeV/KBgCXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bK50gAvKZYSl4z6bO4uq0AOlm1L++s0QKVDNLvbtAMZlLiVC1VS5U8IOLoGFKGpg5
	 w4klR9wIfG2zUYZJ8jgOZeY6ZqTqPwjXthWn9FuZ4FyxvBcOrejeUydUoDT/YKxc2I
	 qDB4rGkINd+WgeDadw6hIJcl/B1rzgnrPR/I+cUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Akash Goel <akash.goel@arm.com>,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 546/614] drm/panthor: Prevent potential UAF in group creation
Date: Tue, 16 Dec 2025 12:15:13 +0100
Message-ID: <20251216111421.162590606@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Goel <akash.goel@arm.com>

[ Upstream commit eec7e23d848d2194dd8791fcd0f4a54d4378eecd ]

This commit prevents the possibility of a use after free issue in the
GROUP_CREATE ioctl function, which arose as pointer to the group is
accessed in that ioctl function after storing it in the Xarray.
A malicious userspace can second guess the handle of a group and try
to call GROUP_DESTROY ioctl from another thread around the same time
as GROUP_CREATE ioctl.

To prevent the use after free exploit, this commit uses a mark on an
entry of group pool Xarray which is added just before returning from
the GROUP_CREATE ioctl function. The mark is checked for all ioctls
that specify the group handle and so userspace won't be abe to delete
a group that isn't marked yet.

v2: Add R-bs and fixes tags

Fixes: de85488138247 ("drm/panthor: Add the scheduler logical block")
Co-developed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Akash Goel <akash.goel@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: https://patch.msgid.link/20251127164912.3788155-1-akash.goel@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 0279e19aadae9..881a07ffbabc8 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -772,6 +772,12 @@ struct panthor_job_profiling_data {
  */
 #define MAX_GROUPS_PER_POOL 128
 
+/*
+ * Mark added on an entry of group pool Xarray to identify if the group has
+ * been fully initialized and can be accessed elsewhere in the driver code.
+ */
+#define GROUP_REGISTERED XA_MARK_1
+
 /**
  * struct panthor_group_pool - Group pool
  *
@@ -2900,7 +2906,7 @@ void panthor_fdinfo_gather_group_samples(struct panthor_file *pfile)
 		return;
 
 	xa_lock(&gpool->xa);
-	xa_for_each(&gpool->xa, i, group) {
+	xa_for_each_marked(&gpool->xa, i, group, GROUP_REGISTERED) {
 		guard(spinlock)(&group->fdinfo.lock);
 		pfile->stats.cycles += group->fdinfo.data.cycles;
 		pfile->stats.time += group->fdinfo.data.time;
@@ -3575,6 +3581,8 @@ int panthor_group_create(struct panthor_file *pfile,
 
 	group_init_task_info(group);
 
+	xa_set_mark(&gpool->xa, gid, GROUP_REGISTERED);
+
 	return gid;
 
 err_put_group:
@@ -3589,6 +3597,9 @@ int panthor_group_destroy(struct panthor_file *pfile, u32 group_handle)
 	struct panthor_scheduler *sched = ptdev->scheduler;
 	struct panthor_group *group;
 
+	if (!xa_get_mark(&gpool->xa, group_handle, GROUP_REGISTERED))
+		return -EINVAL;
+
 	group = xa_erase(&gpool->xa, group_handle);
 	if (!group)
 		return -EINVAL;
@@ -3614,12 +3625,12 @@ int panthor_group_destroy(struct panthor_file *pfile, u32 group_handle)
 }
 
 static struct panthor_group *group_from_handle(struct panthor_group_pool *pool,
-					       u32 group_handle)
+					       unsigned long group_handle)
 {
 	struct panthor_group *group;
 
 	xa_lock(&pool->xa);
-	group = group_get(xa_load(&pool->xa, group_handle));
+	group = group_get(xa_find(&pool->xa, &group_handle, group_handle, GROUP_REGISTERED));
 	xa_unlock(&pool->xa);
 
 	return group;
@@ -3706,7 +3717,7 @@ panthor_fdinfo_gather_group_mem_info(struct panthor_file *pfile,
 		return;
 
 	xa_lock(&gpool->xa);
-	xa_for_each(&gpool->xa, i, group) {
+	xa_for_each_marked(&gpool->xa, i, group, GROUP_REGISTERED) {
 		stats->resident += group->fdinfo.kbo_sizes;
 		if (group->csg_id >= 0)
 			stats->active += group->fdinfo.kbo_sizes;
-- 
2.51.0



