Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1031181CE1;
	Sun,  1 Sep 2024 16:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208283; cv=none; b=k/D4sZ/flCBw7z2TMY4bgfBQOPtcndk1KhSvUkqDK4YqlkVkcf7wf/QqG2gMFrLD1mzecHbsqbYsHc4TZSZ1REQrCfXqK8gUOLaFaKaaLPcHnkrVOy6oC+xrh1PZY3uWtCosCIjpYOSpedTRowgbME5KBU419p31qWnEHQlESPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208283; c=relaxed/simple;
	bh=wWhDUtQWEEc59DnKnsPBWImRYCR/lCLBlJyYpyFRhKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=acL2aaIESZyLAwryQMyDabXQpXVJPvExuCKKUMnp5mgB71oLgoUYSZV1WwcKowARky4zUGPc1C9IpQaDlM3PLZF9nS6Oqw7mRkv9Y0wd1hN1H3qAavhjpW1BeBRPljl9ffHhi7uSICypH3igdMJyyYboC4XwXOIlbtMSg6MgDTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSCcNHlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSCcNHlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E55AC4CEC3;
	Sun,  1 Sep 2024 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208282;
	bh=wWhDUtQWEEc59DnKnsPBWImRYCR/lCLBlJyYpyFRhKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSCcNHlGnaKcbGh9gJKhpvZ+QIio07PGvvj73JM5JMT7ghjE2JfgEw/fmaqBvEUiu
	 RoNQwihVlwv9xvZCXiXNHcZw87aIAYd81cYJ/E7d/29kCRsRKaP/+PFqdWTd9OsvCk
	 7n1AQeHCk2zruB4zhfa90FOyqcL/3Ad+0/bfpbFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: [PATCH 6.10 035/149] drm/v3d: Disable preemption while updating GPU stats
Date: Sun,  1 Sep 2024 18:15:46 +0200
Message-ID: <20240901160818.782119823@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

commit 9d824c7fce58f59982228aa85b0376b113cdfa35 upstream.

We forgot to disable preemption around the write_seqcount_begin/end() pair
while updating GPU stats:

  [ ] WARNING: CPU: 2 PID: 12 at include/linux/seqlock.h:221 __seqprop_assert.isra.0+0x128/0x150 [v3d]
  [ ] Workqueue: v3d_bin drm_sched_run_job_work [gpu_sched]
 <...snip...>
  [ ] Call trace:
  [ ]  __seqprop_assert.isra.0+0x128/0x150 [v3d]
  [ ]  v3d_job_start_stats.isra.0+0x90/0x218 [v3d]
  [ ]  v3d_bin_job_run+0x23c/0x388 [v3d]
  [ ]  drm_sched_run_job_work+0x520/0x6d0 [gpu_sched]
  [ ]  process_one_work+0x62c/0xb48
  [ ]  worker_thread+0x468/0x5b0
  [ ]  kthread+0x1c4/0x1e0
  [ ]  ret_from_fork+0x10/0x20

Fix it.

Cc: Maíra Canal <mcanal@igalia.com>
Cc: stable@vger.kernel.org # v6.10+
Fixes: 6abe93b621ab ("drm/v3d: Fix race-condition between sysfs/fdinfo and interrupt handler")
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Acked-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240813102505.80512-1-tursulin@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index b8682818bafa..ad1e6236ff6f 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -134,6 +134,8 @@ v3d_job_start_stats(struct v3d_job *job, enum v3d_queue queue)
 	struct v3d_stats *local_stats = &file->stats[queue];
 	u64 now = local_clock();
 
+	preempt_disable();
+
 	write_seqcount_begin(&local_stats->lock);
 	local_stats->start_ns = now;
 	write_seqcount_end(&local_stats->lock);
@@ -141,6 +143,8 @@ v3d_job_start_stats(struct v3d_job *job, enum v3d_queue queue)
 	write_seqcount_begin(&global_stats->lock);
 	global_stats->start_ns = now;
 	write_seqcount_end(&global_stats->lock);
+
+	preempt_enable();
 }
 
 static void
@@ -162,8 +166,10 @@ v3d_job_update_stats(struct v3d_job *job, enum v3d_queue queue)
 	struct v3d_stats *local_stats = &file->stats[queue];
 	u64 now = local_clock();
 
+	preempt_disable();
 	v3d_stats_update(local_stats, now);
 	v3d_stats_update(global_stats, now);
+	preempt_enable();
 }
 
 static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
-- 
2.46.0



