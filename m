Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67044234994;
	Sun,  7 Jun 2026 10:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826654; cv=none; b=tF1DOytvqNg4dpAcwUJ1RCC1iVdR0u2UGNIHI1rLer269UZRsOjE7KPx0VDUy0pxCcQZoFXldKDGBftqjengfDlh1b9QI396MCCd2htyeVaPKZFnVj8WXBfSCrEz8bYtdDWJN0gOJLCUE4czZD0N+bEQ/Nc/OyUebUfZxS9ykQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826654; c=relaxed/simple;
	bh=sy87G97T2SJvsPwniIiCwna7UmUTXVTOy6DaACszalM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YByWuLra+gvh+GY6n4SLrNiKuQjs6CncD9X7PKNwKTUBV0umJzbzOZcoq6N5mhIU24i8i/z39A38K3VYWGqyLUp3ZTLeDPphl2kQB0JJmhDjCBTkh6e+J40mAoYXOr0xt7CUd2ozIGEo0z4swZEa4cu0bpaXX71DJrWb/Zo+iC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrmXmIsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrmXmIsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB26B1F00893;
	Sun,  7 Jun 2026 10:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826653;
	bh=p1AMbkG/sK6cOOz7KoK2FtHiDpVIgaVmhNLck9DAfE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrmXmIsijZ613/5EA2HaJYp1ETrHRXBsminLQURMzffMFL1d1rW/BxhkTLl/N7uKO
	 xI/9c/nFnn3ZVHd6HWe+WEmBQff1psU1trlyBGXhxUUGHqYkILcxNrMqAztnzi4kt3
	 G9TAYunwY1U3SW2Dr3FhB7NmycNprI0H0vjY5HaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/307] drm/v3d: Fix use-after-free of CPU job query arrays on error path
Date: Sun,  7 Jun 2026 11:56:39 +0200
Message-ID: <20260607095727.732421478@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit b0fe80c0b9250b35e2211bf3117e7aca814a21b0 ]

The CPU job ioctl's fail label calls kvfree() on cpu_job's timestamp and
performance query arrays after v3d_job_cleanup(), which drops the job's
last reference and frees cpu_job. Reading cpu_job at that point is a
use-after-free. Also, on the early v3d_job_init() failure path, it is a
NULL dereference, since v3d_job_deallocate() zeroes the local pointer.

In the success path, the arrays are released from the scheduler's
.free_job callback, but on the error path, they are freed manually, as
the job was never pushed to the scheduler. While the success path deals
with this correctly, the fail path doesn't.

On top of that, the manual kvfree() calls only free the array storage;
they don't drm_syncobj_put() the per-query syncobjs that
v3d_timestamp_query_info_free() and v3d_performance_query_info_free()
release on the success path. So the same fail path that triggers the
use-after-free also leaks one syncobj reference per query.

Unify the CPU job teardown into the CPU job's kref destructor, mirroring
v3d_render_job_free(). The scheduler's .free_job slot reverts to the
generic v3d_sched_job_free() and the fail label drops the manual
kvfree() calls, leaving a single teardown path that is reached from both
the scheduler and the ioctl error path. That removes the use-after-free,
the NULL dereference, and the syncobj leak by construction.

Cc: stable@vger.kernel.org
Fixes: 9ba0ff3e083f ("drm/v3d: Create a CPU job extension for the timestamp query job")
Assisted-by: Claude:claude-opus-4.7
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260515-v3d-cpu-job-leaks-v1-1-7f147cbbf935@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c  | 16 +---------------
 drivers/gpu/drm/v3d/v3d_submit.c | 19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index c9c88d3ad6698f..90eef062766c8d 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -103,20 +103,6 @@ v3d_performance_query_info_free(struct v3d_performance_query_info *query_info,
 	}
 }
 
-static void
-v3d_cpu_job_free(struct drm_sched_job *sched_job)
-{
-	struct v3d_cpu_job *job = to_cpu_job(sched_job);
-
-	v3d_timestamp_query_info_free(&job->timestamp_query,
-				      job->timestamp_query.count);
-
-	v3d_performance_query_info_free(&job->performance_query,
-					job->performance_query.count);
-
-	v3d_job_cleanup(&job->base);
-}
-
 static void
 v3d_switch_perfmon(struct v3d_dev *v3d, struct v3d_job *job)
 {
@@ -846,7 +832,7 @@ static const struct drm_sched_backend_ops v3d_cache_clean_sched_ops = {
 static const struct drm_sched_backend_ops v3d_cpu_sched_ops = {
 	.run_job = v3d_cpu_job_run,
 	.timedout_job = v3d_generic_job_timedout,
-	.free_job = v3d_cpu_job_free
+	.free_job = v3d_sched_job_free
 };
 
 int
diff --git a/drivers/gpu/drm/v3d/v3d_submit.c b/drivers/gpu/drm/v3d/v3d_submit.c
index ddc20191a1ceef..40c21aaade0d67 100644
--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -118,6 +118,21 @@ v3d_render_job_free(struct kref *ref)
 	v3d_job_free(ref);
 }
 
+static void
+v3d_cpu_job_free(struct kref *ref)
+{
+	struct v3d_cpu_job *job = container_of(ref, struct v3d_cpu_job,
+					       base.refcount);
+
+	v3d_timestamp_query_info_free(&job->timestamp_query,
+				      job->timestamp_query.count);
+
+	v3d_performance_query_info_free(&job->performance_query,
+					job->performance_query.count);
+
+	v3d_job_free(ref);
+}
+
 void v3d_job_cleanup(struct v3d_job *job)
 {
 	if (!job)
@@ -1310,7 +1325,7 @@ v3d_submit_cpu_ioctl(struct drm_device *dev, void *data,
 	trace_v3d_submit_cpu_ioctl(&v3d->drm, cpu_job->job_type);
 
 	ret = v3d_job_init(v3d, file_priv, &cpu_job->base,
-			   v3d_job_free, 0, &se, V3D_CPU);
+			   v3d_cpu_job_free, 0, &se, V3D_CPU);
 	if (ret) {
 		v3d_job_deallocate((void *)&cpu_job);
 		goto fail;
@@ -1393,8 +1408,6 @@ v3d_submit_cpu_ioctl(struct drm_device *dev, void *data,
 	v3d_job_cleanup((void *)csd_job);
 	v3d_job_cleanup(clean_job);
 	v3d_put_multisync_post_deps(&se);
-	kvfree(cpu_job->timestamp_query.queries);
-	kvfree(cpu_job->performance_query.queries);
 
 	return ret;
 }
-- 
2.53.0



