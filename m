Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F803EAC6F;
	Tue, 17 Mar 2026 16:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766435; cv=none; b=Xhs2r1nuj7/cgAL0FeGxMKc2jZOWa19PvmZ9gA4AnAsa0IBU2vkQIf/mVHgQQhx9Vkpf6BExy7KzQ3uuZJcHmVsKGzZZyHrz4EcKVLrQqMx3mMIda1CP7FcJmen78k+mhUbp6IVBmn5z6aFOCnq9too3lvB98uU6E8ngOXNvsck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766435; c=relaxed/simple;
	bh=lgZ6BtE4Zkx7yrMPJEfYnuaMH82MfBhsipDte/7J42Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqZaMiPH9QsnVfSXFy5SzLKQjWUWgWMQMeeSS102mIUZ6bpS2Rd/GeB0n8IIDMnbTQ/BcBGe3Y/RoCf3C9UFzciy9sBsd+2JfogkWDr+P9id9Yu8h5Mt47g0d1kikk+ZUvTmu0ZETIosDx2r6GP3lU77mw2AhKRhb6HiS86PwDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfUCtQ8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfUCtQ8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A2EC19424;
	Tue, 17 Mar 2026 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766434;
	bh=lgZ6BtE4Zkx7yrMPJEfYnuaMH82MfBhsipDte/7J42Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfUCtQ8FYglS101z1gBk05XI6f5HcDY/XI1SeT+xiWRPPhoZ0nlSpwBuLYfD0yF9W
	 XdT25zqoKfXq6KWowNY1C7goPx5SsqaQWJnrSjOVO6wFtTrHAy6tf3QKg71bRmLy5s
	 N0NZnJl2VeFzu+NzRT34rVTxkFTLCutzziK04sj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.19 246/378] kunit: irq: Ensure timer doesnt fire too frequently
Date: Tue, 17 Mar 2026 17:33:23 +0100
Message-ID: <20260317163016.072809363@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 201ceb94aa1def0024a7c18ce643e5f65026be06 upstream.

Fix a bug where kunit_run_irq_test() could hang if the system is too
slow.  This was noticed with the crypto library tests in certain VMs.

Specifically, if kunit_irq_test_timer_func() and the associated hrtimer
code took over 5us to run, then the CPU would spend all its time
executing that code in hardirq context.  As a result, the task executing
kunit_run_irq_test() never had a chance to run, exit the loop, and
cancel the timer.

To fix it, make kunit_irq_test_timer_func() increase the timer interval
when the other contexts aren't having a chance to run.

Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
Cc: stable@vger.kernel.org
Reviewed-by: David Gow <david@davidgow.net>
Link: https://lore.kernel.org/r/20260224033751.97615-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/kunit/run-in-irq-context.h |   44 +++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 16 deletions(-)

--- a/include/kunit/run-in-irq-context.h
+++ b/include/kunit/run-in-irq-context.h
@@ -12,16 +12,16 @@
 #include <linux/hrtimer.h>
 #include <linux/workqueue.h>
 
-#define KUNIT_IRQ_TEST_HRTIMER_INTERVAL us_to_ktime(5)
-
 struct kunit_irq_test_state {
 	bool (*func)(void *test_specific_state);
 	void *test_specific_state;
 	bool task_func_reported_failure;
 	bool hardirq_func_reported_failure;
 	bool softirq_func_reported_failure;
+	atomic_t task_func_calls;
 	atomic_t hardirq_func_calls;
 	atomic_t softirq_func_calls;
+	ktime_t interval;
 	struct hrtimer timer;
 	struct work_struct bh_work;
 };
@@ -30,14 +30,25 @@ static enum hrtimer_restart kunit_irq_te
 {
 	struct kunit_irq_test_state *state =
 		container_of(timer, typeof(*state), timer);
+	int task_calls, hardirq_calls, softirq_calls;
 
 	WARN_ON_ONCE(!in_hardirq());
-	atomic_inc(&state->hardirq_func_calls);
+	task_calls = atomic_read(&state->task_func_calls);
+	hardirq_calls = atomic_inc_return(&state->hardirq_func_calls);
+	softirq_calls = atomic_read(&state->softirq_func_calls);
+
+	/*
+	 * If the timer is firing too often for the softirq or task to ever have
+	 * a chance to run, increase the timer interval.  This is needed on very
+	 * slow systems.
+	 */
+	if (hardirq_calls >= 20 && (softirq_calls == 0 || task_calls == 0))
+		state->interval = ktime_add_ns(state->interval, 250);
 
 	if (!state->func(state->test_specific_state))
 		state->hardirq_func_reported_failure = true;
 
-	hrtimer_forward_now(&state->timer, KUNIT_IRQ_TEST_HRTIMER_INTERVAL);
+	hrtimer_forward_now(&state->timer, state->interval);
 	queue_work(system_bh_wq, &state->bh_work);
 	return HRTIMER_RESTART;
 }
@@ -86,10 +97,14 @@ static inline void kunit_run_irq_test(st
 	struct kunit_irq_test_state state = {
 		.func = func,
 		.test_specific_state = test_specific_state,
+		/*
+		 * Start with a 5us timer interval.  If the system can't keep
+		 * up, kunit_irq_test_timer_func() will increase it.
+		 */
+		.interval = us_to_ktime(5),
 	};
 	unsigned long end_jiffies;
-	int hardirq_calls, softirq_calls;
-	bool allctx = false;
+	int task_calls, hardirq_calls, softirq_calls;
 
 	/*
 	 * Set up a hrtimer (the way we access hardirq context) and a work
@@ -104,21 +119,18 @@ static inline void kunit_run_irq_test(st
 	 * and hardirq), or 1 second, whichever comes first.
 	 */
 	end_jiffies = jiffies + HZ;
-	hrtimer_start(&state.timer, KUNIT_IRQ_TEST_HRTIMER_INTERVAL,
-		      HRTIMER_MODE_REL_HARD);
-	for (int task_calls = 0, calls = 0;
-	     ((calls < max_iterations) || !allctx) &&
-	     !time_after(jiffies, end_jiffies);
-	     task_calls++) {
+	hrtimer_start(&state.timer, state.interval, HRTIMER_MODE_REL_HARD);
+	do {
 		if (!func(test_specific_state))
 			state.task_func_reported_failure = true;
 
+		task_calls = atomic_inc_return(&state.task_func_calls);
 		hardirq_calls = atomic_read(&state.hardirq_func_calls);
 		softirq_calls = atomic_read(&state.softirq_func_calls);
-		calls = task_calls + hardirq_calls + softirq_calls;
-		allctx = (task_calls > 0) && (hardirq_calls > 0) &&
-			 (softirq_calls > 0);
-	}
+	} while ((task_calls + hardirq_calls + softirq_calls < max_iterations ||
+		  (task_calls == 0 || hardirq_calls == 0 ||
+		   softirq_calls == 0)) &&
+		 !time_after(jiffies, end_jiffies));
 
 	/* Cancel the timer and work. */
 	hrtimer_cancel(&state.timer);


