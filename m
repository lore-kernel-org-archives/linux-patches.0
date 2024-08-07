Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3936382D66;
	Wed,  7 Aug 2024 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043130; cv=none; b=VxhmhCihlFnt7CLlZqZXgo1cRX54b+Cumy3O1O7u4IuewItrtOb6MBW66/gKkM5jS3+xvt+ybj0n2RcRSx3TtYqLerpXJDfWJ2lIdTAu9n4BwF/QdCE8NJovHrT9n0cGyFTiOwUB59o6UjrKjimOEV/Cz271ZAnHXCOs+Ew9AxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043130; c=relaxed/simple;
	bh=fPJEuRCCoc22XZ007aWaPU0BwMX8nAnmW7zirphrcwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zl3bCXqI62If+qfiZeqE5KB/+xtUEmnIJj9/aTtitWlessUvCaELB8Kc1fHsn+zGcph0eHrDezriI9jJaRX3Ri2RyAUwewlXtOcx8GSLWoOqc+cVBx97ItIJ256vOcnHGW2hhiVi1KHj6kwLrxIqEl94Lbb13qIueYQGtt4zCKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gnz/8QvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gnz/8QvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF350C32781;
	Wed,  7 Aug 2024 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043130;
	bh=fPJEuRCCoc22XZ007aWaPU0BwMX8nAnmW7zirphrcwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gnz/8QvBuEH6aGgStq9Hy6LlQ4tprmfo8EF6pYAFpvSX8RQ8J/J0nv+hNJj63XRIa
	 kUBvTM5DSyHnd/qTzd/d53UtPg3cplSnFqdciQ6YgTCqs5VUUa9uqSi5cLtw7OBBqX
	 qkun5T1ay0SYV6JPoALpMT9VejVzKNmGJHeSE3pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.10 100/123] drm/v3d: Fix potential memory leak in the performance extension
Date: Wed,  7 Aug 2024 17:00:19 +0200
Message-ID: <20240807150024.081765465@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 32df4abc44f24dbec239d43e2b26d5768c5d1a78 upstream.

If fetching of userspace memory fails during the main loop, all drm sync
objs looked up until that point will be leaked because of the missing
drm_syncobj_put.

Fix it by exporting and using a common cleanup helper.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: bae7cb5d6800 ("drm/v3d: Create a CPU job extension for the reset performance query job")
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Iago Toral Quiroga <itoral@igalia.com>
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240711135340.84617-4-tursulin@igalia.com
(cherry picked from commit 484de39fa5f5b7bd0c5f2e2c5265167250ef7501)
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_drv.h    |  2 ++
 drivers/gpu/drm/v3d/v3d_sched.c  | 22 ++++++++++----
 drivers/gpu/drm/v3d/v3d_submit.c | 52 ++++++++++++++++++++------------
 3 files changed, 50 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index c46eed35d26b..1d535abedc57 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -558,6 +558,8 @@ void v3d_mmu_remove_ptes(struct v3d_bo *bo);
 /* v3d_sched.c */
 void v3d_timestamp_query_info_free(struct v3d_timestamp_query_info *query_info,
 				   unsigned int count);
+void v3d_performance_query_info_free(struct v3d_performance_query_info *query_info,
+				     unsigned int count);
 void v3d_job_update_stats(struct v3d_job *job, enum v3d_queue queue);
 int v3d_sched_init(struct v3d_dev *v3d);
 void v3d_sched_fini(struct v3d_dev *v3d);
diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index 3da4fa49552b..30d5366d6288 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -87,20 +87,30 @@ v3d_timestamp_query_info_free(struct v3d_timestamp_query_info *query_info,
 	}
 }
 
+void
+v3d_performance_query_info_free(struct v3d_performance_query_info *query_info,
+				unsigned int count)
+{
+	if (query_info->queries) {
+		unsigned int i;
+
+		for (i = 0; i < count; i++)
+			drm_syncobj_put(query_info->queries[i].syncobj);
+
+		kvfree(query_info->queries);
+	}
+}
+
 static void
 v3d_cpu_job_free(struct drm_sched_job *sched_job)
 {
 	struct v3d_cpu_job *job = to_cpu_job(sched_job);
-	struct v3d_performance_query_info *performance_query = &job->performance_query;
 
 	v3d_timestamp_query_info_free(&job->timestamp_query,
 				      job->timestamp_query.count);
 
-	if (performance_query->queries) {
-		for (int i = 0; i < performance_query->count; i++)
-			drm_syncobj_put(performance_query->queries[i].syncobj);
-		kvfree(performance_query->queries);
-	}
+	v3d_performance_query_info_free(&job->performance_query,
+					job->performance_query.count);
 
 	v3d_job_cleanup(&job->base);
 }
diff --git a/drivers/gpu/drm/v3d/v3d_submit.c b/drivers/gpu/drm/v3d/v3d_submit.c
index 121bf1314b80..50be4e8a7512 100644
--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -640,6 +640,8 @@ v3d_get_cpu_reset_performance_params(struct drm_file *file_priv,
 	u32 __user *syncs;
 	u64 __user *kperfmon_ids;
 	struct drm_v3d_reset_performance_query reset;
+	unsigned int i, j;
+	int err;
 
 	if (!job) {
 		DRM_DEBUG("CPU job extension was attached to a GPU job.\n");
@@ -668,39 +670,43 @@ v3d_get_cpu_reset_performance_params(struct drm_file *file_priv,
 	syncs = u64_to_user_ptr(reset.syncs);
 	kperfmon_ids = u64_to_user_ptr(reset.kperfmon_ids);
 
-	for (int i = 0; i < reset.count; i++) {
+	for (i = 0; i < reset.count; i++) {
 		u32 sync;
 		u64 ids;
 		u32 __user *ids_pointer;
 		u32 id;
 
 		if (copy_from_user(&sync, syncs++, sizeof(sync))) {
-			kvfree(job->performance_query.queries);
-			return -EFAULT;
+			err = -EFAULT;
+			goto error;
 		}
 
-		job->performance_query.queries[i].syncobj = drm_syncobj_find(file_priv, sync);
-
 		if (copy_from_user(&ids, kperfmon_ids++, sizeof(ids))) {
-			kvfree(job->performance_query.queries);
-			return -EFAULT;
+			err = -EFAULT;
+			goto error;
 		}
 
 		ids_pointer = u64_to_user_ptr(ids);
 
-		for (int j = 0; j < reset.nperfmons; j++) {
+		for (j = 0; j < reset.nperfmons; j++) {
 			if (copy_from_user(&id, ids_pointer++, sizeof(id))) {
-				kvfree(job->performance_query.queries);
-				return -EFAULT;
+				err = -EFAULT;
+				goto error;
 			}
 
 			job->performance_query.queries[i].kperfmon_ids[j] = id;
 		}
+
+		job->performance_query.queries[i].syncobj = drm_syncobj_find(file_priv, sync);
 	}
 	job->performance_query.count = reset.count;
 	job->performance_query.nperfmons = reset.nperfmons;
 
 	return 0;
+
+error:
+	v3d_performance_query_info_free(&job->performance_query, i);
+	return err;
 }
 
 static int
@@ -711,6 +717,8 @@ v3d_get_cpu_copy_performance_query_params(struct drm_file *file_priv,
 	u32 __user *syncs;
 	u64 __user *kperfmon_ids;
 	struct drm_v3d_copy_performance_query copy;
+	unsigned int i, j;
+	int err;
 
 	if (!job) {
 		DRM_DEBUG("CPU job extension was attached to a GPU job.\n");
@@ -742,34 +750,34 @@ v3d_get_cpu_copy_performance_query_params(struct drm_file *file_priv,
 	syncs = u64_to_user_ptr(copy.syncs);
 	kperfmon_ids = u64_to_user_ptr(copy.kperfmon_ids);
 
-	for (int i = 0; i < copy.count; i++) {
+	for (i = 0; i < copy.count; i++) {
 		u32 sync;
 		u64 ids;
 		u32 __user *ids_pointer;
 		u32 id;
 
 		if (copy_from_user(&sync, syncs++, sizeof(sync))) {
-			kvfree(job->performance_query.queries);
-			return -EFAULT;
+			err = -EFAULT;
+			goto error;
 		}
 
-		job->performance_query.queries[i].syncobj = drm_syncobj_find(file_priv, sync);
-
 		if (copy_from_user(&ids, kperfmon_ids++, sizeof(ids))) {
-			kvfree(job->performance_query.queries);
-			return -EFAULT;
+			err = -EFAULT;
+			goto error;
 		}
 
 		ids_pointer = u64_to_user_ptr(ids);
 
-		for (int j = 0; j < copy.nperfmons; j++) {
+		for (j = 0; j < copy.nperfmons; j++) {
 			if (copy_from_user(&id, ids_pointer++, sizeof(id))) {
-				kvfree(job->performance_query.queries);
-				return -EFAULT;
+				err = -EFAULT;
+				goto error;
 			}
 
 			job->performance_query.queries[i].kperfmon_ids[j] = id;
 		}
+
+		job->performance_query.queries[i].syncobj = drm_syncobj_find(file_priv, sync);
 	}
 	job->performance_query.count = copy.count;
 	job->performance_query.nperfmons = copy.nperfmons;
@@ -782,6 +790,10 @@ v3d_get_cpu_copy_performance_query_params(struct drm_file *file_priv,
 	job->copy.stride = copy.stride;
 
 	return 0;
+
+error:
+	v3d_performance_query_info_free(&job->performance_query, i);
+	return err;
 }
 
 /* Whenever userspace sets ioctl extensions, v3d_get_extensions parses data
-- 
2.46.0



