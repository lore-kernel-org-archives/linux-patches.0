Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624102;
	b=ir5C/GAtlgzNZC7rbmMhh8V5NsrUUMlglmG9NeXs54sP+owXNPKcSEd9NdPTCKhbeTjj
	 8AeNc4dSoWRwkCDz2sXLXa3LH40m5rFSM2BRI/+A1b52l7X7VG7/4Z4/qby0FW122OuR+
	 EdC4e50GVGWxY/oWxkeAEK46p+sDAnCc5Juz6Ty84UVmVJ+KcZ/wWFe9Ixd7zv9y6VnfP
	 NOvp/culuXlxCqEkfOI5yuah7e0+z++XWhbBE45gkwFHvxiMqBC2O9hEudHKZaXaD68n7
	 WK8W7rEvW+g6Q9gUT204jb3kD7BvtY16UUpex3Ld1Ie5WO58ajhjd8qVvtpIU1V9XFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YcMGPg6ripMbpl5yWUR6jUjDLAsJoFXg7xS32s9GQIs=;
	b=3ea3WVM70NFJVcor+eZNgp/yaqt4h/Ic/PAcboRVxAZcjqnf07RWMGSo9Y4P+FjmkiRn
	 nu4cFkZGyC0TbwH1oMQ982Vn4C58GgIL0BVa0F6dm9AVCQwp9Ml1uDIlrEP+XqMKBfS6N
	 V8K5xzU+RrKlFlV5koh1aDaHcGWbTzJt5OMLCSjR/V0iAgDoPWYlymCJpzOp7/kQenimc
	 gMJFCQoik4/pMcmrJQdBKqi4W1Q7g1P2Mc2KUREYIiw22/sQTathLIhazPJ1AzOwnOxWE
	 tPkPEODTbV3jlp3maGGtvxC5cLDLAKP0C9avydwbHDD4wdhq7OSSSt/G9XPvmnoonlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1JL04MR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192E4606A31E;
	Wed, 25 Nov 2026 16:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1JL04MR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6460F1F000D0;
	Wed, 25 Nov 2026 16:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624101;
	bh=YcMGPg6ripMbpl5yWUR6jUjDLAsJoFXg7xS32s9GQIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1JL04MRfcoW0G6euiO1m225OMcM2T3v7qyeWD4fN30pkWBtvNG+f1EK9X4CC5v8e
	 L43bwAVKpkveJdc5zw0U1E3mTWDkPaEz1Js56+Bu5smaS6GZvF9UHB2f68x5eVpqb3
	 GtV+o98r2HcnygOJykC5MmSTbV8gI0CSdji1CazQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/816] ptp: vclock: propagate physical clock sampling errors
Date: Wed, 25 Nov 2026 15:27:07 +0100
Message-ID: <20261125143851.050105066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit d1bdfdafd663dd00b01d43eb3391f87718f2a09d ]

The cyclecounter read callback cannot report errors. ptp_vclock_read()
ignores the return from the physical clock and consumes its output even
if the read failed. A zero sample followed by the real counter can add
an extra 32-bit wrap to virtual time. This was found by code inspection
of reset-time PHC access and the virtual clock callers.

Sample the parent before calling timecounter_read() or timecounter_init()
and have the cyclecounter callback return the cached successful sample.
On failure, leave the counter and frequency adjustment unchanged and
return the PHC error to the caller.

Retry the first failed refresh after 10 ms instead of waiting another two
seconds. With the existing 32-bit nanosecond mask, timecounter_cyc2time()
can interpret a fresh timestamp as being in the past once the last
successful refresh is about 2.147 seconds old. An isolated read failure
should not deliberately defer the next attempt until that sample is four
seconds old.

Double the retry delay after consecutive failures, up to the normal
two-second refresh interval, and reset it after a successful refresh.
Each virtual clock has its own worker, and a failed parent read can involve
bus traffic and error logging. Backoff limits that repeated work during a
persistent failure while retaining a prompt first retry.

Limit each retry delay to the next regular refresh deadline. Otherwise,
backoff can skip the next two-second refresh opportunity and lose a full
counter wrap even when the parent has recovered before that refresh was
due. Advance the deadline when an attempt reaches it without resetting the
backoff, so sustained failures still settle at the normal refresh interval.
Keep the retry state private to each clock's auxiliary worker.

Take the initial sample and initialize the counter before publishing the
clock. Return an error pointer from registration and propagate its errno
through n_vclocks, including when the initial sample fails. Queue the first
refresh immediately after registration so registration latency is not
followed by another full refresh interval.

Keep the existing cyclecounter mask and scaling. These scheduling changes
do not guarantee timely samples: prolonged read failures or worker delays
can still exceed the half-wrap conversion window, and a gap of about
4.295 seconds between successful samples can lose a full counter wrap.
Do not assume that getcycles64() exposes a full-width nanosecond counter.

Fixes: 5d43f951b1ac ("ptp: add ptp virtual clock driver framework")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261026-ptp-vclock-sampling-v6-3-e705612541f1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_private.h |  6 ++-
 drivers/ptp/ptp_sysfs.c   |  4 +-
 drivers/ptp/ptp_vclock.c  | 89 ++++++++++++++++++++++++++++++---------
 3 files changed, 76 insertions(+), 23 deletions(-)

diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 5ac416074ad26..104474956a844 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -81,7 +81,11 @@ struct ptp_vclock {
 	struct hlist_node vclock_hash_node;
 	struct cyclecounter cc;
 	struct timecounter tc;
-	struct mutex lock;	/* protects tc/cc */
+	u64 cycles;
+	struct mutex lock;	/* protects tc/cc and the cached sample */
+	/* Owned by the auxiliary worker. */
+	unsigned long retry_delay;
+	unsigned long refresh_deadline;
 };
 
 /*
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index b07274b67294a..de073b21f1f72 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -228,8 +228,10 @@ static ssize_t n_vclocks_store(struct device *dev,
 	if (num > ptp->n_vclocks) {
 		for (i = 0; i < num - ptp->n_vclocks; i++) {
 			vclock = ptp_vclock_register(ptp);
-			if (!vclock)
+			if (IS_ERR(vclock)) {
+				err = PTR_ERR(vclock);
 				goto err_register;
+			}
 
 			*(ptp->vclock_index + ptp->n_vclocks + i) =
 				vclock->clock->index;
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 5e2730c73bc28..2016e2481580e 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -4,6 +4,7 @@
  *
  * Copyright 2021 NXP
  */
+#include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/hashtable.h>
 #include "ptp_private.h"
@@ -13,6 +14,7 @@
 #define PTP_VCLOCK_FADJ_SHIFT		9
 #define PTP_VCLOCK_FADJ_DENOMINATOR	15625ULL
 #define PTP_VCLOCK_REFRESH_INTERVAL	(HZ * 2)
+#define PTP_VCLOCK_RETRY_INTERVAL		msecs_to_jiffies(10)
 
 /* protects vclock_hash addition/deletion */
 static DEFINE_SPINLOCK(vclock_hash_lock);
@@ -42,21 +44,39 @@ static void ptp_vclock_hash_del(struct ptp_vclock *vclock)
 	synchronize_srcu(&vclock_srcu);
 }
 
+/* The caller holds vclock->lock, or has not published the clock yet. */
+static int ptp_vclock_sample(struct ptp_vclock *vclock)
+{
+	struct ptp_clock *ptp = vclock->pclock;
+	struct timespec64 ts;
+	int err;
+
+	err = ptp->info->getcycles64(ptp->info, &ts);
+	if (!err)
+		vclock->cycles = timespec64_to_ns(&ts);
+
+	return err;
+}
+
 static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	s64 adj;
+	int err;
 
 	adj = (s64)scaled_ppm << PTP_VCLOCK_FADJ_SHIFT;
 	adj = div_s64(adj, PTP_VCLOCK_FADJ_DENOMINATOR);
 
 	if (mutex_lock_interruptible(&vclock->lock))
 		return -EINTR;
-	timecounter_read(&vclock->tc);
-	vclock->cc.mult = PTP_VCLOCK_CC_MULT + adj;
+	err = ptp_vclock_sample(vclock);
+	if (!err) {
+		timecounter_read(&vclock->tc);
+		vclock->cc.mult = PTP_VCLOCK_CC_MULT + adj;
+	}
 	mutex_unlock(&vclock->lock);
 
-	return 0;
+	return err;
 }
 
 static int ptp_vclock_adjtime(struct ptp_clock_info *ptp, s64 delta)
@@ -75,15 +95,16 @@ static int ptp_vclock_gettime(struct ptp_clock_info *ptp,
 			      struct timespec64 *ts)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
-	u64 ns;
+	int err;
 
 	if (mutex_lock_interruptible(&vclock->lock))
 		return -EINTR;
-	ns = timecounter_read(&vclock->tc);
+	err = ptp_vclock_sample(vclock);
+	if (!err)
+		*ts = ns_to_timespec64(timecounter_read(&vclock->tc));
 	mutex_unlock(&vclock->lock);
-	*ts = ns_to_timespec64(ns);
 
-	return 0;
+	return err;
 }
 
 static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
@@ -115,13 +136,16 @@ static int ptp_vclock_settime(struct ptp_clock_info *ptp,
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	u64 ns = timespec64_to_ns(ts);
+	int err;
 
 	if (mutex_lock_interruptible(&vclock->lock))
 		return -EINTR;
-	timecounter_init(&vclock->tc, &vclock->cc, ns);
+	err = ptp_vclock_sample(vclock);
+	if (!err)
+		timecounter_init(&vclock->tc, &vclock->cc, ns);
 	mutex_unlock(&vclock->lock);
 
-	return 0;
+	return err;
 }
 
 static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
@@ -151,8 +175,24 @@ static long ptp_vclock_refresh(struct ptp_clock_info *ptp)
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	struct timespec64 ts;
 
-	ptp_vclock_gettime(&vclock->info, &ts);
+	/* Retry transient failures promptly, but back off during long outages. */
+	if (ptp_vclock_gettime(&vclock->info, &ts)) {
+		unsigned long now = jiffies;
+
+		/* Retries must not postpone the next regular refresh attempt. */
+		if (!vclock->retry_delay || time_after_eq(now, vclock->refresh_deadline))
+			vclock->refresh_deadline = now + PTP_VCLOCK_REFRESH_INTERVAL;
+
+		if (!vclock->retry_delay)
+			vclock->retry_delay = PTP_VCLOCK_RETRY_INTERVAL;
+		else
+			vclock->retry_delay = min_t(unsigned long,
+						    vclock->retry_delay * 2,
+						    PTP_VCLOCK_REFRESH_INTERVAL);
+		return min(vclock->retry_delay, vclock->refresh_deadline - now);
+	}
 
+	vclock->retry_delay = 0;
 	return PTP_VCLOCK_REFRESH_INTERVAL;
 }
 
@@ -174,12 +214,9 @@ static const struct ptp_clock_info ptp_vclock_info = {
 static u64 ptp_vclock_read(const struct cyclecounter *cc)
 {
 	struct ptp_vclock *vclock = cc_to_vclock(cc);
-	struct ptp_clock *ptp = vclock->pclock;
-	struct timespec64 ts = {};
-
-	ptp->info->getcycles64(ptp->info, &ts);
 
-	return timespec64_to_ns(&ts);
+	/* The cyclecounter callback cannot report a failed PHC read. */
+	return vclock->cycles;
 }
 
 static const struct cyclecounter ptp_vclock_cc = {
@@ -192,10 +229,11 @@ static const struct cyclecounter ptp_vclock_cc = {
 struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 {
 	struct ptp_vclock *vclock;
+	int err;
 
 	vclock = kzalloc(sizeof(*vclock), GFP_KERNEL);
 	if (!vclock)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	vclock->pclock = pclock;
 	vclock->info = ptp_vclock_info;
@@ -214,20 +252,29 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 
 	mutex_init(&vclock->lock);
 
+	err = ptp_vclock_sample(vclock);
+	if (err)
+		goto free_vclock;
+	timecounter_init(&vclock->tc, &vclock->cc, 0);
+
 	vclock->clock = ptp_clock_register(&vclock->info, &pclock->dev);
-	if (IS_ERR_OR_NULL(vclock->clock)) {
-		kfree(vclock);
-		return NULL;
+	if (IS_ERR(vclock->clock)) {
+		err = PTR_ERR(vclock->clock);
+		goto free_vclock;
 	}
 
 	ptp_vclock_set_subclass(vclock->clock);
 
-	timecounter_init(&vclock->tc, &vclock->cc, 0);
-	ptp_schedule_worker(vclock->clock, PTP_VCLOCK_REFRESH_INTERVAL);
+	/* The initial sample predates registration; refresh without more delay. */
+	ptp_schedule_worker(vclock->clock, 0);
 
 	ptp_vclock_hash_add(vclock);
 
 	return vclock;
+
+free_vclock:
+	kfree(vclock);
+	return ERR_PTR(err);
 }
 
 void ptp_vclock_unregister(struct ptp_vclock *vclock)
-- 
2.53.0



