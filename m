Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6779C21B91D;
	Thu, 12 Dec 2024 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019286; cv=none; b=l/RQ7SwcVIXlL+8MOd/e8+z+tW4iinDpcyGbeI+kJz0eZOrRi4rOAaOwqXPT4MR39xUpnNhVDczgrjW3yNTvkEvNi+uMFDTyZfOGddMou/PEP8BDBM43lHSNWpNlrBXVdxoa4hqikL3tTCW0jZanumXxNeLY/eYxv57S8slq/9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019286; c=relaxed/simple;
	bh=4HMy847AMIyEH1E1lpac7zAzuziFKUHk49l0fMSNrY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eb6DqiyEQUNaymbmFBttInyqgFYTBvfo7Sr/VCIbM8hZ3vbd6LNnCWFI5X9N7b9fX/UKmsRfTd5SMLckOaUN2ExaqFrU1cOMTDoeUYi5tI8v73g9tJGJphtYoNz4Xu1q3RR/bFfiPUIu8fIlTV6pvQDHoC6eYmx3kPaSEkBcTNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU1NTk2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU1NTk2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2132C4CECE;
	Thu, 12 Dec 2024 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019286;
	bh=4HMy847AMIyEH1E1lpac7zAzuziFKUHk49l0fMSNrY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UU1NTk2ypC4boG7HOuQNIn+ThNCmWBi8oHxLh2JWdzZhz6rgRItKLebwnK/e/q9Eo
	 2C0r1HdttmFcA4cD+qMEYFmKQWX8zjX7WdJwa8KqLn5hJYYkiqfed9YCw4bjqs8vDX
	 dw/mQrPEG0+DHugWzC//qlBpC6iy866/mJ8suQ1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/772] drm/msm/gpu: Bypass PM QoS constraint for idle clamp
Date: Thu, 12 Dec 2024 15:51:53 +0100
Message-ID: <20241212144356.883305486@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit fadcc3ab1302d4e5baa32c272b658221f0066696 ]

Change idle freq clamping back to the direct method, bypassing PM QoS
requests.  The problem with using PM QoS requests is they call
(indirectly) the governors ->get_target_freq() which goes thru a
get_dev_status() cycle.  The problem comes when the GPU becomes active
again and we remove the idle-clamp request, we go through another
get_dev_status() cycle for the period that the GPU has been idle, which
triggers the governor to lower the target freq excessively.

This partially reverts commit 7c0ffcd40b16 ("drm/msm/gpu: Respect PM QoS
constraints"), but preserves the use of boost QoS request, so that it
will continue to play nicely with other QoS requests such as a cooling
device.  This also mostly undoes commit 78f815c1cf8f ("drm/msm: return the
average load over the polling period")

Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/517785/
Link: https://lore.kernel.org/r/20230110231447.1939101-3-robdclark@gmail.com
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Stable-dep-of: 8f32ddd87e49 ("drm/msm/gpu: Check the status of registration to PM QoS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.h         |  12 ++-
 drivers/gpu/drm/msm/msm_gpu_devfreq.c | 135 +++++++++++---------------
 2 files changed, 65 insertions(+), 82 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index a326b6d1adbe2..5929ecaa1fcdc 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -109,11 +109,15 @@ struct msm_gpu_devfreq {
 	struct mutex lock;
 
 	/**
-	 * idle_constraint:
+	 * idle_freq:
 	 *
-	 * A PM QoS constraint to limit max freq while the GPU is idle.
+	 * Shadow frequency used while the GPU is idle.  From the PoV of
+	 * the devfreq governor, we are continuing to sample busyness and
+	 * adjust frequency while the GPU is idle, but we use this shadow
+	 * value as the GPU is actually clamped to minimum frequency while
+	 * it is inactive.
 	 */
-	struct dev_pm_qos_request idle_freq;
+	unsigned long idle_freq;
 
 	/**
 	 * boost_constraint:
@@ -135,8 +139,6 @@ struct msm_gpu_devfreq {
 	/** idle_time: Time of last transition to idle: */
 	ktime_t idle_time;
 
-	struct devfreq_dev_status average_status;
-
 	/**
 	 * idle_work:
 	 *
diff --git a/drivers/gpu/drm/msm/msm_gpu_devfreq.c b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
index 1f4e2dd8e76dd..ae5380e2abf76 100644
--- a/drivers/gpu/drm/msm/msm_gpu_devfreq.c
+++ b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
@@ -33,6 +33,16 @@ static int msm_devfreq_target(struct device *dev, unsigned long *freq,
 
 	trace_msm_gpu_freq_change(dev_pm_opp_get_freq(opp));
 
+	/*
+	 * If the GPU is idle, devfreq is not aware, so just stash
+	 * the new target freq (to use when we return to active)
+	 */
+	if (df->idle_freq) {
+		df->idle_freq = *freq;
+		dev_pm_opp_put(opp);
+		return 0;
+	}
+
 	if (gpu->funcs->gpu_set_freq) {
 		mutex_lock(&df->lock);
 		gpu->funcs->gpu_set_freq(gpu, opp, df->suspended);
@@ -48,15 +58,26 @@ static int msm_devfreq_target(struct device *dev, unsigned long *freq,
 
 static unsigned long get_freq(struct msm_gpu *gpu)
 {
+	struct msm_gpu_devfreq *df = &gpu->devfreq;
+
+	/*
+	 * If the GPU is idle, use the shadow/saved freq to avoid
+	 * confusing devfreq (which is unaware that we are switching
+	 * to lowest freq until the device is active again)
+	 */
+	if (df->idle_freq)
+		return df->idle_freq;
+
 	if (gpu->funcs->gpu_get_freq)
 		return gpu->funcs->gpu_get_freq(gpu);
 
 	return clk_get_rate(gpu->core_clk);
 }
 
-static void get_raw_dev_status(struct msm_gpu *gpu,
+static int msm_devfreq_get_dev_status(struct device *dev,
 		struct devfreq_dev_status *status)
 {
+	struct msm_gpu *gpu = dev_to_gpu(dev);
 	struct msm_gpu_devfreq *df = &gpu->devfreq;
 	u64 busy_cycles, busy_time;
 	unsigned long sample_rate;
@@ -72,7 +93,7 @@ static void get_raw_dev_status(struct msm_gpu *gpu,
 	if (df->suspended) {
 		mutex_unlock(&df->lock);
 		status->busy_time = 0;
-		return;
+		return 0;
 	}
 
 	busy_cycles = gpu->funcs->gpu_busy(gpu, &sample_rate);
@@ -87,71 +108,6 @@ static void get_raw_dev_status(struct msm_gpu *gpu,
 		busy_time = ~0LU;
 
 	status->busy_time = busy_time;
-}
-
-static void update_average_dev_status(struct msm_gpu *gpu,
-		const struct devfreq_dev_status *raw)
-{
-	struct msm_gpu_devfreq *df = &gpu->devfreq;
-	const u32 polling_ms = df->devfreq->profile->polling_ms;
-	const u32 max_history_ms = polling_ms * 11 / 10;
-	struct devfreq_dev_status *avg = &df->average_status;
-	u64 avg_freq;
-
-	/* simple_ondemand governor interacts poorly with gpu->clamp_to_idle.
-	 * When we enforce the constraint on idle, it calls get_dev_status
-	 * which would normally reset the stats.  When we remove the
-	 * constraint on active, it calls get_dev_status again where busy_time
-	 * would be 0.
-	 *
-	 * To remedy this, we always return the average load over the past
-	 * polling_ms.
-	 */
-
-	/* raw is longer than polling_ms or avg has no history */
-	if (div_u64(raw->total_time, USEC_PER_MSEC) >= polling_ms ||
-	    !avg->total_time) {
-		*avg = *raw;
-		return;
-	}
-
-	/* Truncate the oldest history first.
-	 *
-	 * Because we keep the history with a single devfreq_dev_status,
-	 * rather than a list of devfreq_dev_status, we have to assume freq
-	 * and load are the same over avg->total_time.  We can scale down
-	 * avg->busy_time and avg->total_time by the same factor to drop
-	 * history.
-	 */
-	if (div_u64(avg->total_time + raw->total_time, USEC_PER_MSEC) >=
-			max_history_ms) {
-		const u32 new_total_time = polling_ms * USEC_PER_MSEC -
-			raw->total_time;
-		avg->busy_time = div_u64(
-				mul_u32_u32(avg->busy_time, new_total_time),
-				avg->total_time);
-		avg->total_time = new_total_time;
-	}
-
-	/* compute the average freq over avg->total_time + raw->total_time */
-	avg_freq = mul_u32_u32(avg->current_frequency, avg->total_time);
-	avg_freq += mul_u32_u32(raw->current_frequency, raw->total_time);
-	do_div(avg_freq, avg->total_time + raw->total_time);
-
-	avg->current_frequency = avg_freq;
-	avg->busy_time += raw->busy_time;
-	avg->total_time += raw->total_time;
-}
-
-static int msm_devfreq_get_dev_status(struct device *dev,
-		struct devfreq_dev_status *status)
-{
-	struct msm_gpu *gpu = dev_to_gpu(dev);
-	struct devfreq_dev_status raw;
-
-	get_raw_dev_status(gpu, &raw);
-	update_average_dev_status(gpu, &raw);
-	*status = gpu->devfreq.average_status;
 
 	return 0;
 }
@@ -191,9 +147,6 @@ void msm_devfreq_init(struct msm_gpu *gpu)
 
 	mutex_init(&df->lock);
 
-	dev_pm_qos_add_request(&gpu->pdev->dev, &df->idle_freq,
-			       DEV_PM_QOS_MAX_FREQUENCY,
-			       PM_QOS_MAX_FREQUENCY_DEFAULT_VALUE);
 	dev_pm_qos_add_request(&gpu->pdev->dev, &df->boost_freq,
 			       DEV_PM_QOS_MIN_FREQUENCY, 0);
 
@@ -214,7 +167,6 @@ void msm_devfreq_init(struct msm_gpu *gpu)
 
 	if (IS_ERR(df->devfreq)) {
 		DRM_DEV_ERROR(&gpu->pdev->dev, "Couldn't initialize GPU devfreq\n");
-		dev_pm_qos_remove_request(&df->idle_freq);
 		dev_pm_qos_remove_request(&df->boost_freq);
 		df->devfreq = NULL;
 		return;
@@ -256,7 +208,6 @@ void msm_devfreq_cleanup(struct msm_gpu *gpu)
 
 	devfreq_cooling_unregister(gpu->cooling);
 	dev_pm_qos_remove_request(&df->boost_freq);
-	dev_pm_qos_remove_request(&df->idle_freq);
 }
 
 void msm_devfreq_resume(struct msm_gpu *gpu)
@@ -329,6 +280,7 @@ void msm_devfreq_active(struct msm_gpu *gpu)
 {
 	struct msm_gpu_devfreq *df = &gpu->devfreq;
 	unsigned int idle_time;
+	unsigned long target_freq;
 
 	if (!has_devfreq(gpu))
 		return;
@@ -338,8 +290,28 @@ void msm_devfreq_active(struct msm_gpu *gpu)
 	 */
 	cancel_idle_work(df);
 
+	/*
+	 * Hold devfreq lock to synchronize with get_dev_status()/
+	 * target() callbacks
+	 */
+	mutex_lock(&df->devfreq->lock);
+
+	target_freq = df->idle_freq;
+
 	idle_time = ktime_to_ms(ktime_sub(ktime_get(), df->idle_time));
 
+	df->idle_freq = 0;
+
+	/*
+	 * We could have become active again before the idle work had a
+	 * chance to run, in which case the df->idle_freq would have
+	 * still been zero.  In this case, no need to change freq.
+	 */
+	if (target_freq)
+		msm_devfreq_target(&gpu->pdev->dev, &target_freq, 0);
+
+	mutex_unlock(&df->devfreq->lock);
+
 	/*
 	 * If we've been idle for a significant fraction of a polling
 	 * interval, then we won't meet the threshold of busyness for
@@ -348,9 +320,6 @@ void msm_devfreq_active(struct msm_gpu *gpu)
 	if (idle_time > msm_devfreq_profile.polling_ms) {
 		msm_devfreq_boost(gpu, 2);
 	}
-
-	dev_pm_qos_update_request(&df->idle_freq,
-				  PM_QOS_MAX_FREQUENCY_DEFAULT_VALUE);
 }
 
 
@@ -360,11 +329,23 @@ static void msm_devfreq_idle_work(struct kthread_work *work)
 			struct msm_gpu_devfreq, idle_work.work);
 	struct msm_gpu *gpu = container_of(df, struct msm_gpu, devfreq);
 	struct msm_drm_private *priv = gpu->dev->dev_private;
+	unsigned long idle_freq, target_freq = 0;
 
-	df->idle_time = ktime_get();
+	/*
+	 * Hold devfreq lock to synchronize with get_dev_status()/
+	 * target() callbacks
+	 */
+	mutex_lock(&df->devfreq->lock);
+
+	idle_freq = get_freq(gpu);
 
 	if (priv->gpu_clamp_to_idle)
-		dev_pm_qos_update_request(&df->idle_freq, 0);
+		msm_devfreq_target(&gpu->pdev->dev, &target_freq, 0);
+
+	df->idle_time = ktime_get();
+	df->idle_freq = idle_freq;
+
+	mutex_unlock(&df->devfreq->lock);
 }
 
 void msm_devfreq_idle(struct msm_gpu *gpu)
-- 
2.43.0



