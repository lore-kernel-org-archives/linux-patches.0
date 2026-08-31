Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE95A5164B2;
	Mon, 31 Aug 2026 13:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183814; cv=none; b=fAKA2YWk0mvn7YR3WrLpYeiGFlH7yS+UM2iK7QDpHlqHuYEg3+quUj+SbzoWTVwOstCoguqp276VbP5BagJNN9ITNpmywPrBqQ9fTgcDhn+NdqBDSFHinYk4nM+2Ut8XvrrYWqJvjIaJVZ0Y7gAyUdCun2WDiqi/v3NvevHkNoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183814; c=relaxed/simple;
	bh=QwLpm0nvi7EV2RlxfIxlUHPsJjbTtqj4RlzH/6ZYUGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M4UmgfjeG4ScU5WbjGsZ4r/03BNId8PvN7Zq38hvfHABEVFGNivxoB1bXVBGxLbZL4JuXbOcNASz7ytR/lqxZHCHg6bYtQKN1KREWM9n4d4zjcer4b76DvJ844GkvEeTVSQ9qoiBwBEQvfCUkIV1iV9+ds5Rj9e4yTlnVWCuK0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R58WqMve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R58WqMve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1F41F00A3D;
	Mon, 31 Aug 2026 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183811;
	bh=NNeDVYB834eBUK2IVKo137f7ozwOhKTwFFvma5/NENo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R58WqMve6aSy3tvmBPPnEBnmRfBHDJ1cIOkUvsPRuf5Uq4vJGi0aEGfSGnbrpsW5c
	 CR7/D+WblCHsHIGjKuiB4A4GTWiJ7QJB5foWqkhzrg6z9xUR0oda+EP8r3rDYzldgl
	 eD7liJDRPOGNyw8ATcVVszGnywI+9iVW+1CxSmc3OMZN7tY6RNoIFovl6CQ2Wh3ztF
	 BVyPA4SSP+8Wu2/0NWjo4Poc0yUalk76qArZtHWaP2sfmYGibVlIjskxroGoed2d4F
	 tjrZQDzej6X3MLUGRS6SyjbZ0pkaogebxFZGiIhp6DeCBtsT2+IERhET7x+SMEEt4e
	 vQvbwIJTW8Vsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	alexander.shishkin@linux.intel.com,
	coresight@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] coresight: perf: Retrieve path and source from event data
Date: Mon, 31 Aug 2026 09:25:47 -0400
Message-ID: <20260831133314.4125787-319-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit f37bc31447c0ddafedb25e3c4a4f4e2284034247 ]

ETM perf callbacks currently use the per-CPU csdev_src pointer, which
can race with updates during device registration and unregistration.

The AUX setup already builds and stores the path in the event data.
Use this path to retrieve the source instead of csdev_src to avoid
the race.

Export coresight_get_source() and add etm_event_get_ctxt_path() to
retrieve the context's path and its source with READ_ONCE() /
WRITE_ONCE() accessors. Give the comments to explain why this
approach is safe when pause or resume callbacks preempt the disable
callback (e.g. via NMI).

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Tested-by: Jie Gan <jie.gan@oss.qualcomm.com>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260515-arm_coresight_path_power_management_improvement-v14-7-f88c4a3ecfe9@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished:

1. **linux-next lookup** — Subject/`etm_event_get_ctxt_path` searches on
   `linux-next` didn’t turn up this commit (the `-S` pickaxe run was
   slow and returned unrelated results).

2. **Branch containment** — The full `git branch -a --contains
   f37bc31447c0` scan returned nothing after ~2.5 minutes. A quicker
   check confirms the commit object exists locally but is **not** an
   ancestor of `linux-next` or `origin/master` in this checkout.

That matches the earlier finding: the fix is present as commit
`f37bc31447c0` but isn’t merged into mainline or the current 6.18.43
tree yet. The backport recommendation remains **YES** on technical merit
once it lands upstream.

 drivers/hwtracing/coresight/coresight-core.c  |   2 +-
 .../hwtracing/coresight/coresight-etm-perf.c  | 114 +++++++++++-------
 drivers/hwtracing/coresight/coresight-priv.h  |   1 +
 3 files changed, 74 insertions(+), 43 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index 911a7b6d4867b..4cf4a3e92c272 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -79,7 +79,7 @@ struct coresight_device *coresight_get_percpu_sink(int cpu)
 }
 EXPORT_SYMBOL_GPL(coresight_get_percpu_sink);
 
-static struct coresight_device *coresight_get_source(struct coresight_path *path)
+struct coresight_device *coresight_get_source(struct coresight_path *path)
 {
 	struct coresight_device *csdev;
 
diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index accf101779de8..60f4fde3b398b 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -312,6 +312,35 @@ static bool sinks_compatible(struct coresight_device *a,
 	       (sink_ops(a) == sink_ops(b));
 }
 
+/*
+ * This helper is used for fetching the path pointer via the ctxt.
+ *
+ * Perf event callbacks run on the same CPU in atomic context, but AUX pause
+ * and resume may run in NMI context and preempt other callbacks. Since the
+ * event stop callback clears ctxt->event_data before the data is released,
+ * AUX pause/resume will either observe a NULL pointer and stop fetching the
+ * path pointer, or safely access event_data and the path, as the data has
+ * not yet been freed.
+ */
+static struct coresight_path *etm_event_get_ctxt_path(struct etm_ctxt *ctxt)
+{
+	struct etm_event_data *event_data;
+	struct coresight_path *path;
+
+	if (!ctxt)
+		return NULL;
+
+	event_data = READ_ONCE(ctxt->event_data);
+	if (!event_data)
+		return NULL;
+
+	path = etm_event_cpu_path(event_data, smp_processor_id());
+	if (!path)
+		return NULL;
+
+	return path;
+}
+
 static void *etm_setup_aux(struct perf_event *event, void **pages,
 			   int nr_pages, bool overwrite)
 {
@@ -463,13 +492,23 @@ static void *etm_setup_aux(struct perf_event *event, void **pages,
 	goto out;
 }
 
-static int etm_event_resume(struct coresight_device *csdev,
-			     struct etm_ctxt *ctxt)
+static int etm_event_resume(struct coresight_path *path)
 {
-	if (!ctxt->event_data)
+	struct coresight_device *source;
+	int ret;
+
+	if (!path)
 		return 0;
 
-	return coresight_resume_source(csdev);
+	source = coresight_get_source(path);
+	if (!source)
+		return 0;
+
+	ret = coresight_resume_source(source);
+	if (ret < 0)
+		dev_err(&source->dev, "Failed to resume ETM event.\n");
+
+	return ret;
 }
 
 static void etm_event_start(struct perf_event *event, int flags)
@@ -478,23 +517,19 @@ static void etm_event_start(struct perf_event *event, int flags)
 	struct etm_event_data *event_data;
 	struct etm_ctxt *ctxt = this_cpu_ptr(&etm_ctxt);
 	struct perf_output_handle *handle = &ctxt->handle;
-	struct coresight_device *sink, *csdev = per_cpu(csdev_src, cpu);
+	struct coresight_device *source, *sink;
 	struct coresight_path *path;
 	u64 hw_id;
 
-	if (!csdev)
-		goto fail;
-
 	if (flags & PERF_EF_RESUME) {
-		if (etm_event_resume(csdev, ctxt) < 0) {
-			dev_err(&csdev->dev, "Failed to resume ETM event.\n");
+		path = etm_event_get_ctxt_path(ctxt);
+		if (etm_event_resume(path) < 0)
 			goto fail;
-		}
 		return;
 	}
 
 	/* Have we messed up our tracking ? */
-	if (WARN_ON(ctxt->event_data))
+	if (WARN_ON(READ_ONCE(ctxt->event_data)))
 		goto fail;
 
 	/*
@@ -522,9 +557,10 @@ static void etm_event_start(struct perf_event *event, int flags)
 
 	path = etm_event_cpu_path(event_data, cpu);
 	path->handle = handle;
-	/* We need a sink, no need to continue without one */
+	/* We need source and sink, no need to continue if any is not set */
+	source = coresight_get_source(path);
 	sink = coresight_get_sink(path);
-	if (WARN_ON_ONCE(!sink))
+	if (WARN_ON_ONCE(!source || !sink))
 		goto fail_end_stop;
 
 	/* Nothing will happen without a path */
@@ -532,7 +568,7 @@ static void etm_event_start(struct perf_event *event, int flags)
 		goto fail_end_stop;
 
 	/* Finally enable the tracer */
-	if (source_ops(csdev)->enable(csdev, event, CS_MODE_PERF, path))
+	if (source_ops(source)->enable(source, event, CS_MODE_PERF, path))
 		goto fail_disable_path;
 
 	/*
@@ -556,7 +592,7 @@ static void etm_event_start(struct perf_event *event, int flags)
 	/* Tell the perf core the event is alive */
 	event->hw.state = 0;
 	/* Save the event_data for this ETM */
-	ctxt->event_data = event_data;
+	WRITE_ONCE(ctxt->event_data, event_data);
 	return;
 
 fail_disable_path:
@@ -576,27 +612,26 @@ static void etm_event_start(struct perf_event *event, int flags)
 	return;
 }
 
-static void etm_event_pause(struct perf_event *event,
-			    struct coresight_device *csdev,
+static void etm_event_pause(struct coresight_path *path,
+			    struct perf_event *event,
 			    struct etm_ctxt *ctxt)
 {
-	int cpu = smp_processor_id();
-	struct coresight_device *sink;
 	struct perf_output_handle *handle = &ctxt->handle;
-	struct coresight_path *path;
+	struct coresight_device *source, *sink;
+	struct etm_event_data *event_data;
 	unsigned long size;
 
-	if (!ctxt->event_data)
+	if (!path)
 		return;
 
-	/* Stop tracer */
-	coresight_pause_source(csdev);
-
-	path = etm_event_cpu_path(ctxt->event_data, cpu);
+	source = coresight_get_source(path);
 	sink = coresight_get_sink(path);
-	if (WARN_ON_ONCE(!sink))
+	if (WARN_ON_ONCE(!source || !sink))
 		return;
 
+	/* Stop tracer */
+	coresight_pause_source(source);
+
 	/*
 	 * The per CPU sink has own interrupt handling, it might have
 	 * race condition with updating buffer on AUX trace pause if
@@ -612,8 +647,9 @@ static void etm_event_pause(struct perf_event *event,
 	if (!sink_ops(sink)->update_buffer)
 		return;
 
+	event_data = READ_ONCE(ctxt->event_data);
 	size = sink_ops(sink)->update_buffer(sink, handle,
-					     ctxt->event_data->snk_config);
+					     event_data->snk_config);
 	if (READ_ONCE(handle->event)) {
 		if (!size)
 			return;
@@ -629,14 +665,14 @@ static void etm_event_stop(struct perf_event *event, int mode)
 {
 	int cpu = smp_processor_id();
 	unsigned long size;
-	struct coresight_device *sink, *csdev = per_cpu(csdev_src, cpu);
+	struct coresight_device *source, *sink;
 	struct etm_ctxt *ctxt = this_cpu_ptr(&etm_ctxt);
 	struct perf_output_handle *handle = &ctxt->handle;
+	struct coresight_path *path = etm_event_get_ctxt_path(ctxt);
 	struct etm_event_data *event_data;
-	struct coresight_path *path;
 
 	if (mode & PERF_EF_PAUSE)
-		return etm_event_pause(event, csdev, ctxt);
+		return etm_event_pause(path, event, ctxt);
 
 	/*
 	 * If we still have access to the event_data via handle,
@@ -646,9 +682,9 @@ static void etm_event_stop(struct perf_event *event, int mode)
 	    WARN_ON(perf_get_aux(handle) != ctxt->event_data))
 		return;
 
-	event_data = ctxt->event_data;
+	event_data = READ_ONCE(ctxt->event_data);
 	/* Clear the event_data as this ETM is stopping the trace. */
-	ctxt->event_data = NULL;
+	WRITE_ONCE(ctxt->event_data, NULL);
 
 	if (event->hw.state == PERF_HES_STOPPED)
 		return;
@@ -670,19 +706,13 @@ static void etm_event_stop(struct perf_event *event, int mode)
 		return;
 	}
 
-	if (!csdev)
-		return;
-
-	path = etm_event_cpu_path(event_data, cpu);
-	if (!path)
-		return;
-
+	source = coresight_get_source(path);
 	sink = coresight_get_sink(path);
-	if (!sink)
+	if (!source || !sink)
 		return;
 
 	/* stop tracer */
-	coresight_disable_source(csdev, event);
+	coresight_disable_source(source, event);
 
 	/* tell the core */
 	event->hw.state = PERF_HES_STOPPED;
diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
index bcc5db0d9c3c2..7f27ef2ab1619 100644
--- a/drivers/hwtracing/coresight/coresight-priv.h
+++ b/drivers/hwtracing/coresight/coresight-priv.h
@@ -250,6 +250,7 @@ void coresight_add_helper(struct coresight_device *csdev,
 
 void coresight_set_percpu_sink(int cpu, struct coresight_device *csdev);
 struct coresight_device *coresight_get_percpu_sink(int cpu);
+struct coresight_device *coresight_get_source(struct coresight_path *path);
 void coresight_disable_source(struct coresight_device *csdev, void *data);
 void coresight_pause_source(struct coresight_device *csdev);
 int coresight_resume_source(struct coresight_device *csdev);
-- 
2.53.0

