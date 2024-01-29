Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E84F3F9EA;
	Mon, 29 Jan 2024 17:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548449; cv=none; b=bCOeRY5XLwr5VU4fEbSysYtn9H6nSTtUjXNwNdHMp5wPPhe9xm7rnYYXpFyPZl6KDRsPHniT5h3IIOOIHxWa+fmCbO3FMUtK1Hg/WDI3WjumI3bqfb/UluZHvlrnGmxMIisbEvp07oC/84xRDw+38Kdu/VyJJ5BslkN1v2prdVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548449; c=relaxed/simple;
	bh=Oex2zGBeolk0jXubnkc6ZMyxDaojrOF3+TVWJo0feuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgAeevwPIqsY4H28UOZhoVhmGBo0LRT3HLwESeNZuZIQQoXA3ZnvV5RrYDKG+ZTTnaLU/ya5ybAuKBx5X+PzoGgAc5t2E1CoMtcVTUDBsfTbHL8W8jRB9TypBb1hH6mXV0ayyicQAVl5BCIIPbv/Ms95cdBibfCQddckTNmCR3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsJ2eTPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsJ2eTPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D83C433F1;
	Mon, 29 Jan 2024 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548449;
	bh=Oex2zGBeolk0jXubnkc6ZMyxDaojrOF3+TVWJo0feuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsJ2eTPVcrqPFpfKzLAooukGQ9NFvIWQ1RgI52AdxWB2uzZNwRLjbwEEhMIJ7pdgV
	 JiYz4Uv742Zp9uMFO9V9j8HzOFb2SSEn86iuXlkRxan4A2MqsdRlbTfu8PJJj7UhPN
	 h6VMi7rkR8KsJ0VxTmZUXx8TRz2XCBIsVVJfqs+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngmin Nam <youngmin.nam@samsung.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 033/331] PM: sleep: Fix possible deadlocks in core system-wide PM code
Date: Mon, 29 Jan 2024 09:01:37 -0800
Message-ID: <20240129170015.918666395@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 7839d0078e0d5e6cc2fa0b0dfbee71de74f1e557 upstream.

It is reported that in low-memory situations the system-wide resume core
code deadlocks, because async_schedule_dev() executes its argument
function synchronously if it cannot allocate memory (and not only in
that case) and that function attempts to acquire a mutex that is already
held.  Executing the argument function synchronously from within
dpm_async_fn() may also be problematic for ordering reasons (it may
cause a consumer device's resume callback to be invoked before a
requisite supplier device's one, for example).

Address this by changing the code in question to use
async_schedule_dev_nocall() for scheduling the asynchronous
execution of device suspend and resume functions and to directly
run them synchronously if async_schedule_dev_nocall() returns false.

Link: https://lore.kernel.org/linux-pm/ZYvjiqX6EsL15moe@perf/
Reported-by: Youngmin Nam <youngmin.nam@samsung.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Tested-by: Youngmin Nam <youngmin.nam@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: 5.7+ <stable@vger.kernel.org> # 5.7+: 6aa09a5bccd8 async: Split async_schedule_node_domain()
Cc: 5.7+ <stable@vger.kernel.org> # 5.7+: 7d4b5d7a37bd async: Introduce async_schedule_dev_nocall()
Cc: 5.7+ <stable@vger.kernel.org> # 5.7+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/main.c |  148 +++++++++++++++++++++-------------------------
 1 file changed, 68 insertions(+), 80 deletions(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -579,7 +579,7 @@ bool dev_pm_skip_resume(struct device *d
 }
 
 /**
- * device_resume_noirq - Execute a "noirq resume" callback for given device.
+ * __device_resume_noirq - Execute a "noirq resume" callback for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  * @async: If true, the device is being resumed asynchronously.
@@ -587,7 +587,7 @@ bool dev_pm_skip_resume(struct device *d
  * The driver of @dev will not receive interrupts while this function is being
  * executed.
  */
-static int device_resume_noirq(struct device *dev, pm_message_t state, bool async)
+static void __device_resume_noirq(struct device *dev, pm_message_t state, bool async)
 {
 	pm_callback_t callback = NULL;
 	const char *info = NULL;
@@ -655,7 +655,13 @@ Skip:
 Out:
 	complete_all(&dev->power.completion);
 	TRACE_RESUME(error);
-	return error;
+
+	if (error) {
+		suspend_stats.failed_resume_noirq++;
+		dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
+		dpm_save_failed_dev(dev_name(dev));
+		pm_dev_err(dev, state, async ? " async noirq" : " noirq", error);
+	}
 }
 
 static bool is_async(struct device *dev)
@@ -668,11 +674,15 @@ static bool dpm_async_fn(struct device *
 {
 	reinit_completion(&dev->power.completion);
 
-	if (is_async(dev)) {
-		get_device(dev);
-		async_schedule_dev(func, dev);
+	if (!is_async(dev))
+		return false;
+
+	get_device(dev);
+
+	if (async_schedule_dev_nocall(func, dev))
 		return true;
-	}
+
+	put_device(dev);
 
 	return false;
 }
@@ -680,15 +690,19 @@ static bool dpm_async_fn(struct device *
 static void async_resume_noirq(void *data, async_cookie_t cookie)
 {
 	struct device *dev = data;
-	int error;
-
-	error = device_resume_noirq(dev, pm_transition, true);
-	if (error)
-		pm_dev_err(dev, pm_transition, " async", error);
 
+	__device_resume_noirq(dev, pm_transition, true);
 	put_device(dev);
 }
 
+static void device_resume_noirq(struct device *dev)
+{
+	if (dpm_async_fn(dev, async_resume_noirq))
+		return;
+
+	__device_resume_noirq(dev, pm_transition, false);
+}
+
 static void dpm_noirq_resume_devices(pm_message_t state)
 {
 	struct device *dev;
@@ -698,14 +712,6 @@ static void dpm_noirq_resume_devices(pm_
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
 
-	/*
-	 * Advanced the async threads upfront,
-	 * in case the starting of async threads is
-	 * delayed by non-async resuming devices.
-	 */
-	list_for_each_entry(dev, &dpm_noirq_list, power.entry)
-		dpm_async_fn(dev, async_resume_noirq);
-
 	while (!list_empty(&dpm_noirq_list)) {
 		dev = to_device(dpm_noirq_list.next);
 		get_device(dev);
@@ -713,17 +719,7 @@ static void dpm_noirq_resume_devices(pm_
 
 		mutex_unlock(&dpm_list_mtx);
 
-		if (!is_async(dev)) {
-			int error;
-
-			error = device_resume_noirq(dev, state, false);
-			if (error) {
-				suspend_stats.failed_resume_noirq++;
-				dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
-				dpm_save_failed_dev(dev_name(dev));
-				pm_dev_err(dev, state, " noirq", error);
-			}
-		}
+		device_resume_noirq(dev);
 
 		put_device(dev);
 
@@ -751,14 +747,14 @@ void dpm_resume_noirq(pm_message_t state
 }
 
 /**
- * device_resume_early - Execute an "early resume" callback for given device.
+ * __device_resume_early - Execute an "early resume" callback for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  * @async: If true, the device is being resumed asynchronously.
  *
  * Runtime PM is disabled for @dev while this function is being executed.
  */
-static int device_resume_early(struct device *dev, pm_message_t state, bool async)
+static void __device_resume_early(struct device *dev, pm_message_t state, bool async)
 {
 	pm_callback_t callback = NULL;
 	const char *info = NULL;
@@ -811,21 +807,31 @@ Out:
 
 	pm_runtime_enable(dev);
 	complete_all(&dev->power.completion);
-	return error;
+
+	if (error) {
+		suspend_stats.failed_resume_early++;
+		dpm_save_failed_step(SUSPEND_RESUME_EARLY);
+		dpm_save_failed_dev(dev_name(dev));
+		pm_dev_err(dev, state, async ? " async early" : " early", error);
+	}
 }
 
 static void async_resume_early(void *data, async_cookie_t cookie)
 {
 	struct device *dev = data;
-	int error;
-
-	error = device_resume_early(dev, pm_transition, true);
-	if (error)
-		pm_dev_err(dev, pm_transition, " async", error);
 
+	__device_resume_early(dev, pm_transition, true);
 	put_device(dev);
 }
 
+static void device_resume_early(struct device *dev)
+{
+	if (dpm_async_fn(dev, async_resume_early))
+		return;
+
+	__device_resume_early(dev, pm_transition, false);
+}
+
 /**
  * dpm_resume_early - Execute "early resume" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -839,14 +845,6 @@ void dpm_resume_early(pm_message_t state
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
 
-	/*
-	 * Advanced the async threads upfront,
-	 * in case the starting of async threads is
-	 * delayed by non-async resuming devices.
-	 */
-	list_for_each_entry(dev, &dpm_late_early_list, power.entry)
-		dpm_async_fn(dev, async_resume_early);
-
 	while (!list_empty(&dpm_late_early_list)) {
 		dev = to_device(dpm_late_early_list.next);
 		get_device(dev);
@@ -854,17 +852,7 @@ void dpm_resume_early(pm_message_t state
 
 		mutex_unlock(&dpm_list_mtx);
 
-		if (!is_async(dev)) {
-			int error;
-
-			error = device_resume_early(dev, state, false);
-			if (error) {
-				suspend_stats.failed_resume_early++;
-				dpm_save_failed_step(SUSPEND_RESUME_EARLY);
-				dpm_save_failed_dev(dev_name(dev));
-				pm_dev_err(dev, state, " early", error);
-			}
-		}
+		device_resume_early(dev);
 
 		put_device(dev);
 
@@ -888,12 +876,12 @@ void dpm_resume_start(pm_message_t state
 EXPORT_SYMBOL_GPL(dpm_resume_start);
 
 /**
- * device_resume - Execute "resume" callbacks for given device.
+ * __device_resume - Execute "resume" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  * @async: If true, the device is being resumed asynchronously.
  */
-static int device_resume(struct device *dev, pm_message_t state, bool async)
+static void __device_resume(struct device *dev, pm_message_t state, bool async)
 {
 	pm_callback_t callback = NULL;
 	const char *info = NULL;
@@ -975,20 +963,30 @@ static int device_resume(struct device *
 
 	TRACE_RESUME(error);
 
-	return error;
+	if (error) {
+		suspend_stats.failed_resume++;
+		dpm_save_failed_step(SUSPEND_RESUME);
+		dpm_save_failed_dev(dev_name(dev));
+		pm_dev_err(dev, state, async ? " async" : "", error);
+	}
 }
 
 static void async_resume(void *data, async_cookie_t cookie)
 {
 	struct device *dev = data;
-	int error;
 
-	error = device_resume(dev, pm_transition, true);
-	if (error)
-		pm_dev_err(dev, pm_transition, " async", error);
+	__device_resume(dev, pm_transition, true);
 	put_device(dev);
 }
 
+static void device_resume(struct device *dev)
+{
+	if (dpm_async_fn(dev, async_resume))
+		return;
+
+	__device_resume(dev, pm_transition, false);
+}
+
 /**
  * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -1008,27 +1006,17 @@ void dpm_resume(pm_message_t state)
 	pm_transition = state;
 	async_error = 0;
 
-	list_for_each_entry(dev, &dpm_suspended_list, power.entry)
-		dpm_async_fn(dev, async_resume);
-
 	while (!list_empty(&dpm_suspended_list)) {
 		dev = to_device(dpm_suspended_list.next);
+
 		get_device(dev);
-		if (!is_async(dev)) {
-			int error;
 
-			mutex_unlock(&dpm_list_mtx);
+		mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state, false);
-			if (error) {
-				suspend_stats.failed_resume++;
-				dpm_save_failed_step(SUSPEND_RESUME);
-				dpm_save_failed_dev(dev_name(dev));
-				pm_dev_err(dev, state, "", error);
-			}
+		device_resume(dev);
+
+		mutex_lock(&dpm_list_mtx);
 
-			mutex_lock(&dpm_list_mtx);
-		}
 		if (!list_empty(&dev->power.entry))
 			list_move_tail(&dev->power.entry, &dpm_prepared_list);
 


