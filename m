Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18498264A76;
	Tue,  8 Apr 2025 11:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111130; cv=none; b=G3DpCAQ/E6MW5vAtae9rfTfZZZFkv8RZX3ysYAQUpemMeQNzMdggeWpMQoLRJSU2PWbAut6dQnD648y339QB/G4RyRNpcy6VPsJ5A1k7tJn6mX+BDc16CHeCgly86H2Z8BeFyn8qAXr030RV0bMCK4b9bxCtffSkwAeVf84097A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111130; c=relaxed/simple;
	bh=kDIdchBqlVViD0SaCLiDjFW7qjMeqctoidiihVDTgpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JByaF5VNT9HnZVMKFosfu+XBwkuOx/1ctAU1RSZL7CwvQn3S4zuMqEcnwjsb5yizTw33bHLLQax78/U/iLChCW3gyz5zgn7BIrHiFDnQIk0hZmFzzQXFJl2QELhuXJ3g7KLccVrgjht+RsGI7XOwFVnGYX682pMC6BtzLMysPzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRPgj9th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRPgj9th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDD3C4CEE5;
	Tue,  8 Apr 2025 11:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111130;
	bh=kDIdchBqlVViD0SaCLiDjFW7qjMeqctoidiihVDTgpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRPgj9th4+CsrgQ/7kD11F0czyKeGHFDq2PGg9zWsYWrJcjsaJIuDWNwnUYxm5AQE
	 06lzRCpBgWXxqFguCjuwrhqqxyKJT0xeVn4/IGjtvJqYFGTmjP8TxXbpIuw0VstvCY
	 59dhlV+i90+LAiLTmCBdtsm8xQrtHWGydtZKeN0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 319/731] drm/panthor: Replace sleep locks with spinlocks in fdinfo path
Date: Tue,  8 Apr 2025 12:43:36 +0200
Message-ID: <20250408104921.697105731@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit e379856b428acafb8ed689f31d65814da6447b2e ]

Commit 0590c94c3596 ("drm/panthor: Fix race condition when gathering fdinfo
group samples") introduced an xarray lock to deal with potential
use-after-free errors when accessing groups fdinfo figures. However, this
toggles the kernel's atomic context status, so the next nested mutex lock
will raise a warning when the kernel is compiled with mutex debug options:

CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_MUTEXES=y

Replace Panthor's group fdinfo data mutex with a guarded spinlock.

Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Fixes: 0590c94c3596 ("drm/panthor: Fix race condition when gathering fdinfo group samples")
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250303190923.1639985-1-adrian.larumbe@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 26 ++++++++++++-------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 2f92ef2b5ab99..b8dbeb1586f64 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -9,6 +9,7 @@
 #include <drm/panthor_drm.h>
 
 #include <linux/build_bug.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -634,10 +635,10 @@ struct panthor_group {
 		struct panthor_gpu_usage data;
 
 		/**
-		 * @lock: Mutex to govern concurrent access from drm file's fdinfo callback
-		 * and job post-completion processing function
+		 * @fdinfo.lock: Spinlock to govern concurrent access from drm file's fdinfo
+		 * callback and job post-completion processing function
 		 */
-		struct mutex lock;
+		spinlock_t lock;
 
 		/** @fdinfo.kbo_sizes: Aggregate size of private kernel BO's held by the group. */
 		size_t kbo_sizes;
@@ -913,8 +914,6 @@ static void group_release_work(struct work_struct *work)
 						   release_work);
 	u32 i;
 
-	mutex_destroy(&group->fdinfo.lock);
-
 	for (i = 0; i < group->queue_count; i++)
 		group_free_queue(group, group->queues[i]);
 
@@ -2864,12 +2863,12 @@ static void update_fdinfo_stats(struct panthor_job *job)
 	struct panthor_job_profiling_data *slots = queue->profiling.slots->kmap;
 	struct panthor_job_profiling_data *data = &slots[job->profiling.slot];
 
-	mutex_lock(&group->fdinfo.lock);
-	if (job->profiling.mask & PANTHOR_DEVICE_PROFILING_CYCLES)
-		fdinfo->cycles += data->cycles.after - data->cycles.before;
-	if (job->profiling.mask & PANTHOR_DEVICE_PROFILING_TIMESTAMP)
-		fdinfo->time += data->time.after - data->time.before;
-	mutex_unlock(&group->fdinfo.lock);
+	scoped_guard(spinlock, &group->fdinfo.lock) {
+		if (job->profiling.mask & PANTHOR_DEVICE_PROFILING_CYCLES)
+			fdinfo->cycles += data->cycles.after - data->cycles.before;
+		if (job->profiling.mask & PANTHOR_DEVICE_PROFILING_TIMESTAMP)
+			fdinfo->time += data->time.after - data->time.before;
+	}
 }
 
 void panthor_fdinfo_gather_group_samples(struct panthor_file *pfile)
@@ -2883,12 +2882,11 @@ void panthor_fdinfo_gather_group_samples(struct panthor_file *pfile)
 
 	xa_lock(&gpool->xa);
 	xa_for_each(&gpool->xa, i, group) {
-		mutex_lock(&group->fdinfo.lock);
+		guard(spinlock)(&group->fdinfo.lock);
 		pfile->stats.cycles += group->fdinfo.data.cycles;
 		pfile->stats.time += group->fdinfo.data.time;
 		group->fdinfo.data.cycles = 0;
 		group->fdinfo.data.time = 0;
-		mutex_unlock(&group->fdinfo.lock);
 	}
 	xa_unlock(&gpool->xa);
 }
@@ -3534,7 +3532,7 @@ int panthor_group_create(struct panthor_file *pfile,
 	mutex_unlock(&sched->reset.lock);
 
 	add_group_kbo_sizes(group->ptdev, group);
-	mutex_init(&group->fdinfo.lock);
+	spin_lock_init(&group->fdinfo.lock);
 
 	return gid;
 
-- 
2.39.5



