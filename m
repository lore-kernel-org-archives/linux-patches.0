Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B98D82D66;
	Wed,  7 Aug 2024 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043127; cv=none; b=kbGCPM7ZElJN6NK81Xllm0JUmtlUh+LM+FzPXJxFZyLWBttLoZW8XwBW+wQCaPx3xZeNyzSG2DWdVZaO5UU6UExGoEEDaj7fVuTYg7MZxRufdXLBn27aPs5n3GH2YjroGFTTr9L3bTledI+aG62SXRep1MvherxouAI8U7Pk6YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043127; c=relaxed/simple;
	bh=Sy45+pfM2bmzFF/u4GI61eluvW8GsRZK0kjrKJ25jKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q+N6XqyLO46EkfpzVwCSVWYoIZ8FM5p6zy2o0p5JanKyKkMQBZZfU0K44iFnEjkylW3Jmdx3B4wU3OIrCGD8nzpydlnf2ZFXdua+ksrykQYQw6KusOrU/wpWouwysstfL/C0sDrg9FhOReL3JMnBmVGYEUrdTUNDN0mIMddRBII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYM1APUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYM1APUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9C4C32781;
	Wed,  7 Aug 2024 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043127;
	bh=Sy45+pfM2bmzFF/u4GI61eluvW8GsRZK0kjrKJ25jKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYM1APUcDizPPkHlB/G53WOu66KENHNL7BNf5VjHoZBWWUDOEUFdVYy/zvlHElMx9
	 yVHx7r29V3ukGG021G4UDNDu97AXtrYzZDC5yoGIzn4wbqINRV5RYonJxArV3aN4S9
	 8+TwOKiHFmuVwBjXIsvU1Pz7vPDZW9Q1HHwtiKmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.10 099/123] drm/v3d: Fix potential memory leak in the timestamp extension
Date: Wed,  7 Aug 2024 17:00:18 +0200
Message-ID: <20240807150024.048100297@linuxfoundation.org>
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

commit 0e50fcc20bd87584840266e8004f9064a8985b4f upstream.

If fetching of userspace memory fails during the main loop, all drm sync
objs looked up until that point will be leaked because of the missing
drm_syncobj_put.

Fix it by exporting and using a common cleanup helper.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: 9ba0ff3e083f ("drm/v3d: Create a CPU job extension for the timestamp query job")
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Iago Toral Quiroga <itoral@igalia.com>
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240711135340.84617-3-tursulin@igalia.com
(cherry picked from commit 753ce4fea62182c77e1691ab4f9022008f25b62e)
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_drv.h    |  2 ++
 drivers/gpu/drm/v3d/v3d_sched.c  | 22 +++++++++++-----
 drivers/gpu/drm/v3d/v3d_submit.c | 43 ++++++++++++++++++++++----------
 3 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index a2c516fe6d79..c46eed35d26b 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -556,6 +556,8 @@ void v3d_mmu_insert_ptes(struct v3d_bo *bo);
 void v3d_mmu_remove_ptes(struct v3d_bo *bo);
 
 /* v3d_sched.c */
+void v3d_timestamp_query_info_free(struct v3d_timestamp_query_info *query_info,
+				   unsigned int count);
 void v3d_job_update_stats(struct v3d_job *job, enum v3d_queue queue);
 int v3d_sched_init(struct v3d_dev *v3d);
 void v3d_sched_fini(struct v3d_dev *v3d);
diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index 7cd8c335cd9b..3da4fa49552b 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -73,18 +73,28 @@ v3d_sched_job_free(struct drm_sched_job *sched_job)
 	v3d_job_cleanup(job);
 }
 
+void
+v3d_timestamp_query_info_free(struct v3d_timestamp_query_info *query_info,
+			      unsigned int count)
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
-	struct v3d_timestamp_query_info *timestamp_query = &job->timestamp_query;
 	struct v3d_performance_query_info *performance_query = &job->performance_query;
 
-	if (timestamp_query->queries) {
-		for (int i = 0; i < timestamp_query->count; i++)
-			drm_syncobj_put(timestamp_query->queries[i].syncobj);
-		kvfree(timestamp_query->queries);
-	}
+	v3d_timestamp_query_info_free(&job->timestamp_query,
+				      job->timestamp_query.count);
 
 	if (performance_query->queries) {
 		for (int i = 0; i < performance_query->count; i++)
diff --git a/drivers/gpu/drm/v3d/v3d_submit.c b/drivers/gpu/drm/v3d/v3d_submit.c
index 263fefc1d04f..121bf1314b80 100644
--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -452,6 +452,8 @@ v3d_get_cpu_timestamp_query_params(struct drm_file *file_priv,
 {
 	u32 __user *offsets, *syncs;
 	struct drm_v3d_timestamp_query timestamp;
+	unsigned int i;
+	int err;
 
 	if (!job) {
 		DRM_DEBUG("CPU job extension was attached to a GPU job.\n");
@@ -480,19 +482,19 @@ v3d_get_cpu_timestamp_query_params(struct drm_file *file_priv,
 	offsets = u64_to_user_ptr(timestamp.offsets);
 	syncs = u64_to_user_ptr(timestamp.syncs);
 
-	for (int i = 0; i < timestamp.count; i++) {
+	for (i = 0; i < timestamp.count; i++) {
 		u32 offset, sync;
 
 		if (copy_from_user(&offset, offsets++, sizeof(offset))) {
-			kvfree(job->timestamp_query.queries);
-			return -EFAULT;
+			err = -EFAULT;
+			goto error;
 		}
 
 		job->timestamp_query.queries[i].offset = offset;
 
 		if (copy_from_user(&sync, syncs++, sizeof(sync))) {
-			kvfree(job->timestamp_query.queries);
-			return -EFAULT;
+			err = -EFAULT;
+			goto error;
 		}
 
 		job->timestamp_query.queries[i].syncobj = drm_syncobj_find(file_priv, sync);
@@ -500,6 +502,10 @@ v3d_get_cpu_timestamp_query_params(struct drm_file *file_priv,
 	job->timestamp_query.count = timestamp.count;
 
 	return 0;
+
+error:
+	v3d_timestamp_query_info_free(&job->timestamp_query, i);
+	return err;
 }
 
 static int
@@ -509,6 +515,8 @@ v3d_get_cpu_reset_timestamp_params(struct drm_file *file_priv,
 {
 	u32 __user *syncs;
 	struct drm_v3d_reset_timestamp_query reset;
+	unsigned int i;
+	int err;
 
 	if (!job) {
 		DRM_DEBUG("CPU job extension was attached to a GPU job.\n");
@@ -533,14 +541,14 @@ v3d_get_cpu_reset_timestamp_params(struct drm_file *file_priv,
 
 	syncs = u64_to_user_ptr(reset.syncs);
 
-	for (int i = 0; i < reset.count; i++) {
+	for (i = 0; i < reset.count; i++) {
 		u32 sync;
 
 		job->timestamp_query.queries[i].offset = reset.offset + 8 * i;
 
 		if (copy_from_user(&sync, syncs++, sizeof(sync))) {
-			kvfree(job->timestamp_query.queries);
-			return -EFAULT;
+			err = -EFAULT;
+			goto error;
 		}
 
 		job->timestamp_query.queries[i].syncobj = drm_syncobj_find(file_priv, sync);
@@ -548,6 +556,10 @@ v3d_get_cpu_reset_timestamp_params(struct drm_file *file_priv,
 	job->timestamp_query.count = reset.count;
 
 	return 0;
+
+error:
+	v3d_timestamp_query_info_free(&job->timestamp_query, i);
+	return err;
 }
 
 /* Get data for the copy timestamp query results job submission. */
@@ -558,7 +570,8 @@ v3d_get_cpu_copy_query_results_params(struct drm_file *file_priv,
 {
 	u32 __user *offsets, *syncs;
 	struct drm_v3d_copy_timestamp_query copy;
-	int i;
+	unsigned int i;
+	int err;
 
 	if (!job) {
 		DRM_DEBUG("CPU job extension was attached to a GPU job.\n");
@@ -591,15 +604,15 @@ v3d_get_cpu_copy_query_results_params(struct drm_file *file_priv,
 		u32 offset, sync;
 
 		if (copy_from_user(&offset, offsets++, sizeof(offset))) {
-			kvfree(job->timestamp_query.queries);
-			return -EFAULT;
+			err = -EFAULT;
+			goto error;
 		}
 
 		job->timestamp_query.queries[i].offset = offset;
 
 		if (copy_from_user(&sync, syncs++, sizeof(sync))) {
-			kvfree(job->timestamp_query.queries);
-			return -EFAULT;
+			err = -EFAULT;
+			goto error;
 		}
 
 		job->timestamp_query.queries[i].syncobj = drm_syncobj_find(file_priv, sync);
@@ -613,6 +626,10 @@ v3d_get_cpu_copy_query_results_params(struct drm_file *file_priv,
 	job->copy.stride = copy.stride;
 
 	return 0;
+
+error:
+	v3d_timestamp_query_info_free(&job->timestamp_query, i);
+	return err;
 }
 
 static int
-- 
2.46.0



