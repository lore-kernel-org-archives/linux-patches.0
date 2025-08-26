Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1111AB52D;
	Tue, 26 Aug 2025 13:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213872; cv=none; b=QudIo5HQrcepNiF/WShZURx7riQvt6JwhQwlRC2vNlALdW02/jY8oMjTLVg+n6jJDifzl/L1c7qxOS0C7/Vs91inZF5X3+v3DpJeXZFkRrk0KbVxorabdOOAkV0qrWUeBoscN8AtvKLrR0SmPnSPHXa1XJI0+4tKGwk6kZdqvn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213872; c=relaxed/simple;
	bh=tQp+T0SY0TFimh2iGI2GSuf/oqBUoHYbZsAZVlR9FEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+mno6vLTpRN7uwCsVaMSJaMk+P5yJO82o+39zKywnQQ2baI4qtkMADV6a2XebgProbsp4wB14Wdx+azrr7uguKMlMP8+bnruN8QmGOgs+WhGVxKFrRLCCkUXtl3i8UWx9bm0pta0ETeSznLd1K0lS+/MzMxnnR6RP/VPEw4q5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZY7/c53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZY7/c53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BD4C4CEF1;
	Tue, 26 Aug 2025 13:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213872;
	bh=tQp+T0SY0TFimh2iGI2GSuf/oqBUoHYbZsAZVlR9FEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZY7/c531HKlJdjoDkUvh3Wl/v+nEsFl2TFaHjZR/i3zkTT15Yda06l68zqG9jBU5
	 8N2eLYfDm+nvtfbrN0xc/ERvtkPV1UzYsRzngnSKE5u7UpMw2GLodY1Biyjc859VTt
	 pO1L4KOjGevycw3a42HV6KdBA7Sa7AyI6HFY3fDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 510/587] cpuidle: menu: Remove iowait influence
Date: Tue, 26 Aug 2025 13:10:59 +0200
Message-ID: <20250826111005.965704191@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 38f83090f515b4b5d59382dfada1e7457f19aa47 ]

Remove CPU iowaiters influence on idle state selection.

Remove the menu notion of performance multiplier which increased with
the number of tasks that went to iowait sleep on this CPU and haven't
woken up yet.

Relying on iowait for cpuidle is problematic for a few reasons:

 1. There is no guarantee that an iowaiting task will wake up on the
    same CPU.

 2. The task being in iowait says nothing about the idle duration, we
    could be selecting shallower states for a long time.

 3. The task being in iowait doesn't always imply a performance hit
    with increased latency.

 4. If there is such a performance hit, the number of iowaiting tasks
    doesn't directly correlate.

 5. The definition of iowait altogether is vague at best, it is
    sprinkled across kernel code.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20240905092645.2885200-2-christian.loehle@arm.com
[ rjw: Minor edits in the changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 779b1a1cb13a ("cpuidle: governors: menu: Avoid selecting states with too much latency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/governors/menu.c |   52 ++++++---------------------------------
 1 file changed, 9 insertions(+), 43 deletions(-)

--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -21,7 +21,7 @@
 
 #include "gov.h"
 
-#define BUCKETS 12
+#define BUCKETS 6
 #define INTERVAL_SHIFT 3
 #define INTERVALS (1UL << INTERVAL_SHIFT)
 #define RESOLUTION 1024
@@ -31,12 +31,11 @@
 /*
  * Concepts and ideas behind the menu governor
  *
- * For the menu governor, there are 3 decision factors for picking a C
+ * For the menu governor, there are 2 decision factors for picking a C
  * state:
  * 1) Energy break even point
- * 2) Performance impact
- * 3) Latency tolerance (from pmqos infrastructure)
- * These three factors are treated independently.
+ * 2) Latency tolerance (from pmqos infrastructure)
+ * These two factors are treated independently.
  *
  * Energy break even point
  * -----------------------
@@ -119,19 +118,10 @@ struct menu_device {
 	int		interval_ptr;
 };
 
-static inline int which_bucket(u64 duration_ns, unsigned int nr_iowaiters)
+static inline int which_bucket(u64 duration_ns)
 {
 	int bucket = 0;
 
-	/*
-	 * We keep two groups of stats; one with no
-	 * IO pending, one without.
-	 * This allows us to calculate
-	 * E(duration)|iowait
-	 */
-	if (nr_iowaiters)
-		bucket = BUCKETS/2;
-
 	if (duration_ns < 10ULL * NSEC_PER_USEC)
 		return bucket;
 	if (duration_ns < 100ULL * NSEC_PER_USEC)
@@ -145,19 +135,6 @@ static inline int which_bucket(u64 durat
 	return bucket + 5;
 }
 
-/*
- * Return a multiplier for the exit latency that is intended
- * to take performance requirements into account.
- * The more performance critical we estimate the system
- * to be, the higher this multiplier, and thus the higher
- * the barrier to go to an expensive C state.
- */
-static inline int performance_multiplier(unsigned int nr_iowaiters)
-{
-	/* for IO wait tasks (per cpu!) we add 10x each */
-	return 1 + 10 * nr_iowaiters;
-}
-
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
 static void menu_update_intervals(struct menu_device *data, unsigned int interval_us)
@@ -284,8 +261,6 @@ static int menu_select(struct cpuidle_dr
 	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	s64 latency_req = cpuidle_governor_latency_req(dev->cpu);
 	u64 predicted_ns;
-	u64 interactivity_req;
-	unsigned int nr_iowaiters;
 	ktime_t delta, delta_tick;
 	int i, idx;
 
@@ -302,8 +277,6 @@ static int menu_select(struct cpuidle_dr
 		menu_update_intervals(data, UINT_MAX);
 	}
 
-	nr_iowaiters = nr_iowait_cpu(dev->cpu);
-
 	/* Find the shortest expected idle interval. */
 	predicted_ns = get_typical_interval(data) * NSEC_PER_USEC;
 	if (predicted_ns > RESIDENCY_THRESHOLD_NS) {
@@ -317,7 +290,7 @@ static int menu_select(struct cpuidle_dr
 		}
 
 		data->next_timer_ns = delta;
-		data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
+		data->bucket = which_bucket(data->next_timer_ns);
 
 		/* Round up the result for half microseconds. */
 		timer_us = div_u64((RESOLUTION * DECAY * NSEC_PER_USEC) / 2 +
@@ -335,7 +308,7 @@ static int menu_select(struct cpuidle_dr
 		 */
 		data->next_timer_ns = KTIME_MAX;
 		delta_tick = TICK_NSEC / 2;
-		data->bucket = which_bucket(KTIME_MAX, nr_iowaiters);
+		data->bucket = which_bucket(KTIME_MAX);
 	}
 
 	if (unlikely(drv->state_count <= 1 || latency_req == 0) ||
@@ -362,15 +335,8 @@ static int menu_select(struct cpuidle_dr
 		 */
 		if (predicted_ns < TICK_NSEC)
 			predicted_ns = data->next_timer_ns;
-	} else {
-		/*
-		 * Use the performance multiplier and the user-configurable
-		 * latency_req to determine the maximum exit latency.
-		 */
-		interactivity_req = div64_u64(predicted_ns,
-					      performance_multiplier(nr_iowaiters));
-		if (latency_req > interactivity_req)
-			latency_req = interactivity_req;
+	} else if (latency_req > predicted_ns) {
+		latency_req = predicted_ns;
 	}
 
 	/*


