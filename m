Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2853612CD;
	Tue,  6 Jan 2026 17:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721803; cv=none; b=p6e8eJjBc1dVe0b+l1F+JW+cSEMggQMZh0PgBs8mKJVj/0/shrU0fZZSDW6R5YBXukkAnYDNFI9XMiNIwaul7MvEpUUDCzEFAHfGzb2sc00BLfJr6bKm5SIHyV1PfB11mPIt4E3sOgAK42ugVBy4/+SXaJ4QWd5INVN4cqrgfoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721803; c=relaxed/simple;
	bh=V3BMCeXvGVuKypIp8zxthgA78cr56GSEP5AU3jLkA8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEmcC2gFECVA2DbjoAr8Uv5wlKs+OMmHY4MYBqkA2re/3dd3svJtSXGYBIajngbvaHaEkYpCmuL8T5TD/j8EEO24yuvLHULeQ+5vwc1/YZEZmMMtFtft5VwUUrbO5wIHsy4qdNe67tCpVsXA/xdEYGnSo0qSf195LXwuI9UBB00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbACAATD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbACAATD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A759C19423;
	Tue,  6 Jan 2026 17:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721803;
	bh=V3BMCeXvGVuKypIp8zxthgA78cr56GSEP5AU3jLkA8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbACAATDlfojoQJDuOyU4Kz52btFxrq5Ey80UKWiaLBnnUNFzrjw3Wo9eRZWdu2Wp
	 M4h8JAs82Gnjhdi/kFBxt5heKx7Qo18OSVCWebznwKnXw3D6BX1wT8X2yH05RIl+lQ
	 Hq8cDRHUdTYfe5IsR08qVNlGoWAVCtX9gLJeIWjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/312] kunit: Enforce task execution in {soft,hard}irq contexts
Date: Tue,  6 Jan 2026 18:02:30 +0100
Message-ID: <20260106170550.593353687@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <davidgow@google.com>

[ Upstream commit c31f4aa8fed048fa70e742c4bb49bb48dc489ab3 ]

The kunit_run_irq_test() helper allows a function to be run in hardirq
and softirq contexts (in addition to the task context). It does this by
running the user-provided function concurrently in the three contexts,
until either a timeout has expired or a number of iterations have
completed in the normal task context.

However, on setups where the initialisation of the hardirq and softirq
contexts (or, indeed, the scheduling of those tasks) is significantly
slower than the function execution, it's possible for that number of
iterations to be exceeded before any runs in irq contexts actually
occur. This occurs with the polyval.test_polyval_preparekey_in_irqs
test, which runs 20000 iterations of the relatively fast preparekey
function, and therefore fails often under many UML, 32-bit arm, m68k and
other environments.

Instead, ensure that the max_iterations limit counts executions in all
three contexts, and requires at least one of each. This will cause the
test to continue iterating until at least the irq contexts have been
tested, or the 1s wall-clock limit has been exceeded. This causes the
test to pass in all of my environments.

In so doing, we also update the task counters to atomic ints, to better
match both the 'int' max_iterations input, and to ensure they are
correctly updated across contexts.

Finally, we also fix a few potential assertion messages to be
less-specific to the original crypto usecases.

Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
Signed-off-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/r/20251219085259.1163048-1-davidgow@google.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/kunit/run-in-irq-context.h | 53 +++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/include/kunit/run-in-irq-context.h b/include/kunit/run-in-irq-context.h
index 108e96433ea4..c89b1b1b12dd 100644
--- a/include/kunit/run-in-irq-context.h
+++ b/include/kunit/run-in-irq-context.h
@@ -20,8 +20,8 @@ struct kunit_irq_test_state {
 	bool task_func_reported_failure;
 	bool hardirq_func_reported_failure;
 	bool softirq_func_reported_failure;
-	unsigned long hardirq_func_calls;
-	unsigned long softirq_func_calls;
+	atomic_t hardirq_func_calls;
+	atomic_t softirq_func_calls;
 	struct hrtimer timer;
 	struct work_struct bh_work;
 };
@@ -32,7 +32,7 @@ static enum hrtimer_restart kunit_irq_test_timer_func(struct hrtimer *timer)
 		container_of(timer, typeof(*state), timer);
 
 	WARN_ON_ONCE(!in_hardirq());
-	state->hardirq_func_calls++;
+	atomic_inc(&state->hardirq_func_calls);
 
 	if (!state->func(state->test_specific_state))
 		state->hardirq_func_reported_failure = true;
@@ -48,7 +48,7 @@ static void kunit_irq_test_bh_work_func(struct work_struct *work)
 		container_of(work, typeof(*state), bh_work);
 
 	WARN_ON_ONCE(!in_serving_softirq());
-	state->softirq_func_calls++;
+	atomic_inc(&state->softirq_func_calls);
 
 	if (!state->func(state->test_specific_state))
 		state->softirq_func_reported_failure = true;
@@ -59,7 +59,10 @@ static void kunit_irq_test_bh_work_func(struct work_struct *work)
  * hardirq context concurrently, and reports a failure to KUnit if any
  * invocation of @func in any context returns false.  @func is passed
  * @test_specific_state as its argument.  At most 3 invocations of @func will
- * run concurrently: one in each of task, softirq, and hardirq context.
+ * run concurrently: one in each of task, softirq, and hardirq context.  @func
+ * will continue running until either @max_iterations calls have been made (so
+ * long as at least one each runs in task, softirq, and hardirq contexts), or
+ * one second has passed.
  *
  * The main purpose of this interrupt context testing is to validate fallback
  * code paths that run in contexts where the normal code path cannot be used,
@@ -85,6 +88,8 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
 		.test_specific_state = test_specific_state,
 	};
 	unsigned long end_jiffies;
+	int hardirq_calls, softirq_calls;
+	bool allctx = false;
 
 	/*
 	 * Set up a hrtimer (the way we access hardirq context) and a work
@@ -94,14 +99,25 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
 			       CLOCK_MONOTONIC, HRTIMER_MODE_REL_HARD);
 	INIT_WORK_ONSTACK(&state.bh_work, kunit_irq_test_bh_work_func);
 
-	/* Run for up to max_iterations or 1 second, whichever comes first. */
+	/*
+	 * Run for up to max_iterations (including at least one task, softirq,
+	 * and hardirq), or 1 second, whichever comes first.
+	 */
 	end_jiffies = jiffies + HZ;
 	hrtimer_start(&state.timer, KUNIT_IRQ_TEST_HRTIMER_INTERVAL,
 		      HRTIMER_MODE_REL_HARD);
-	for (int i = 0; i < max_iterations && !time_after(jiffies, end_jiffies);
-	     i++) {
+	for (int task_calls = 0, calls = 0;
+	     ((calls < max_iterations) || !allctx) &&
+	     !time_after(jiffies, end_jiffies);
+	     task_calls++) {
 		if (!func(test_specific_state))
 			state.task_func_reported_failure = true;
+
+		hardirq_calls = atomic_read(&state.hardirq_func_calls);
+		softirq_calls = atomic_read(&state.softirq_func_calls);
+		calls = task_calls + hardirq_calls + softirq_calls;
+		allctx = (task_calls > 0) && (hardirq_calls > 0) &&
+			 (softirq_calls > 0);
 	}
 
 	/* Cancel the timer and work. */
@@ -109,21 +125,18 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
 	flush_work(&state.bh_work);
 
 	/* Sanity check: the timer and BH functions should have been run. */
-	KUNIT_EXPECT_GT_MSG(test, state.hardirq_func_calls, 0,
+	KUNIT_EXPECT_GT_MSG(test, atomic_read(&state.hardirq_func_calls), 0,
 			    "Timer function was not called");
-	KUNIT_EXPECT_GT_MSG(test, state.softirq_func_calls, 0,
+	KUNIT_EXPECT_GT_MSG(test, atomic_read(&state.softirq_func_calls), 0,
 			    "BH work function was not called");
 
-	/* Check for incorrect hash values reported from any context. */
-	KUNIT_EXPECT_FALSE_MSG(
-		test, state.task_func_reported_failure,
-		"Incorrect hash values reported from task context");
-	KUNIT_EXPECT_FALSE_MSG(
-		test, state.hardirq_func_reported_failure,
-		"Incorrect hash values reported from hardirq context");
-	KUNIT_EXPECT_FALSE_MSG(
-		test, state.softirq_func_reported_failure,
-		"Incorrect hash values reported from softirq context");
+	/* Check for failure reported from any context. */
+	KUNIT_EXPECT_FALSE_MSG(test, state.task_func_reported_failure,
+			       "Failure reported from task context");
+	KUNIT_EXPECT_FALSE_MSG(test, state.hardirq_func_reported_failure,
+			       "Failure reported from hardirq context");
+	KUNIT_EXPECT_FALSE_MSG(test, state.softirq_func_reported_failure,
+			       "Failure reported from softirq context");
 }
 
 #endif /* _KUNIT_RUN_IN_IRQ_CONTEXT_H */
-- 
2.51.0



