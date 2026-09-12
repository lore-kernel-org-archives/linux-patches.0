Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AE1326928;
	Sat, 12 Sep 2026 07:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199091; cv=none; b=Iv9SnFpj6ebt/ja9eXCaasM0Qec3AuKxEaJP2w/Itp4GDeh9IztDJY2WuQfgo2FOkS9wm9cLirwruAgyB/BGPoPFJWUzwlKUTZwSSQKiPqWH1Wez3/rCcnTYdOvnzPHnYntDSFwKCZlzZMSLPGllFtN04bZv22Tf8vluv73kqW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199091; c=relaxed/simple;
	bh=7X0ikCynx7lLtPQ35GGU/hmVC+vEVJcxtt+AfAZ0Dfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KgURoatq9EmI+bCFdvQ52Oe8iVtEIcNrRMf5z7iiNAFabm99VDh6alg5e2QxSdB0Sv6YkVJK6v3QMy1JgQ1uJxxtjuCcUAnmssc7LNvlYa0g3UDUbQiIdLEewGztR/CU/dlWT0+m2ESXzyOTZwTeDR8i8AE0I4t3zqMgelRD3iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBL11RKT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBL11RKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A121F000FF;
	Sat, 12 Sep 2026 07:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199090;
	bh=eml6ipW2Vt4gKiNsoEy09nRWi9VlLsmKi8rasfIzBPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBL11RKToj8icma5fZOq5GKTs6Ixf+fM3ypLr4f8+/1XSZ+IdQFZ5LYgo5Jcaka4c
	 6DRkkcEGU/o3LMzCiI9LV5Dq8UQilnsYqAzElReHUTkQW89zVRQBpv1QCWANFR+Ikt
	 FyRTEX746TzhVhCFl+MnxZ2m/BORElXvoon2zSZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0515/1815] drm/v3d: Extract v3d_job_add_syncobjs() helper
Date: Sat, 12 Sep 2026 08:37:45 +0200
Message-ID: <20260912065700.978800941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 57d78cbc16c930f698616d4db16aa85a49a356f7 ]

Move the syncobj dependency setup out of v3d_job_init() into its own
v3d_job_add_syncobjs() helper and make the queue that the job was
submitted a variable in struct v3d_job, so that v3d_job_add_syncobjs()
can use it. No functional change.

This prepares for the next commit which changes the error handling, and
for a later consolidation that separates job allocation from syncobj
attachment.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Link: https://patch.msgid.link/20260604-v3d-sched-misc-fixes-v4-3-c068f5bf5ccf@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Stable-dep-of: fa98563ab00d ("drm/v3d: Associate BOs with every job that accesses them")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.h    |  3 ++
 drivers/gpu/drm/v3d/v3d_submit.c | 72 +++++++++++++++++++-------------
 2 files changed, 47 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index e175e28ca11b9..261163745cd04 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -301,6 +301,9 @@ struct v3d_job {
 
 	struct v3d_dev *v3d;
 
+	/* The queue that the job was submitted on. */
+	enum v3d_queue queue;
+
 	/* This is the array of BOs that were looked up at the start
 	 * of submission.
 	 */
diff --git a/drivers/gpu/drm/v3d/v3d_submit.c b/drivers/gpu/drm/v3d/v3d_submit.c
index 7682b24f13ec5..d316cd25bdba8 100644
--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -180,17 +180,56 @@ v3d_job_deallocate(void **container)
 	*container = NULL;
 }
 
+static int
+v3d_job_add_syncobjs(struct v3d_job *job, struct drm_file *file_priv,
+		     u32 in_sync, struct v3d_submit_ext *se)
+{
+	bool has_multisync = se && (se->flags & DRM_V3D_EXT_ID_MULTI_SYNC);
+	struct v3d_dev *v3d = job->v3d;
+	int ret = 0;
+
+	if (!has_multisync) {
+		ret = drm_sched_job_add_syncobj_dependency(&job->base, file_priv,
+							   in_sync, 0);
+		// TODO: Investigate why this was filtered out for the IOCTL.
+		if (ret && ret != -ENOENT)
+			return ret;
+		return 0;
+	}
+
+	if (se->in_sync_count && se->wait_stage == job->queue) {
+		struct drm_v3d_sem __user *handle = u64_to_user_ptr(se->in_syncs);
+
+		for (int i = 0; i < se->in_sync_count; i++) {
+			struct drm_v3d_sem in;
+
+			if (copy_from_user(&in, handle++, sizeof(in))) {
+				drm_dbg(&v3d->drm, "Failed to copy wait dep handle.\n");
+				return -EFAULT;
+			}
+
+			ret = drm_sched_job_add_syncobj_dependency(&job->base,
+								   file_priv, in.handle, 0);
+			// TODO: Investigate why this was filtered out for the IOCTL.
+			if (ret && ret != -ENOENT)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int
 v3d_job_init(struct v3d_dev *v3d, struct drm_file *file_priv,
 	     struct v3d_job *job, void (*free)(struct kref *ref),
 	     u32 in_sync, struct v3d_submit_ext *se, enum v3d_queue queue)
 {
 	struct v3d_file_priv *v3d_priv = file_priv->driver_priv;
-	bool has_multisync = se && (se->flags & DRM_V3D_EXT_ID_MULTI_SYNC);
-	int ret, i;
+	int ret;
 
 	job->v3d = v3d;
 	job->free = free;
+	job->queue = queue;
 	job->file_priv = v3d_priv;
 
 	ret = drm_sched_job_init(&job->base, &v3d_priv->sched_entity[queue],
@@ -198,32 +237,9 @@ v3d_job_init(struct v3d_dev *v3d, struct drm_file *file_priv,
 	if (ret)
 		return ret;
 
-	if (has_multisync) {
-		if (se->in_sync_count && se->wait_stage == queue) {
-			struct drm_v3d_sem __user *handle = u64_to_user_ptr(se->in_syncs);
-
-			for (i = 0; i < se->in_sync_count; i++) {
-				struct drm_v3d_sem in;
-
-				if (copy_from_user(&in, handle++, sizeof(in))) {
-					ret = -EFAULT;
-					drm_dbg(&v3d->drm, "Failed to copy wait dep handle.\n");
-					goto fail_job_init;
-				}
-				ret = drm_sched_job_add_syncobj_dependency(&job->base, file_priv, in.handle, 0);
-
-				// TODO: Investigate why this was filtered out for the IOCTL.
-				if (ret && ret != -ENOENT)
-					goto fail_job_init;
-			}
-		}
-	} else {
-		ret = drm_sched_job_add_syncobj_dependency(&job->base, file_priv, in_sync, 0);
-
-		// TODO: Investigate why this was filtered out for the IOCTL.
-		if (ret && ret != -ENOENT)
-			goto fail_job_init;
-	}
+	ret = v3d_job_add_syncobjs(job, file_priv, in_sync, se);
+	if (ret)
+		goto fail_job_init;
 
 	/* CPU jobs don't require hardware resources */
 	if (queue != V3D_CPU) {
-- 
2.53.0



