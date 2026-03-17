Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F4F2459DC;
	Tue, 17 Mar 2026 17:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767993; cv=none; b=sart/qWJZgUh7Fe1by+JVBykWePAGWrimMMBH1ijONVqu6xpzK1Fd6GNpwDOBG/bbdW7Domz+dOp6h3AmI02EBYcO4EUKfJE93weT0yJPWSbT77uZn/scPDlW+KWLlhoilXqrYekzote4a8zOa4d59tmIVkgXad/ZptEYKGmmvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767993; c=relaxed/simple;
	bh=fJ6QJa6XO9USKGJd3UVojEtZdlDmtGh0vySKvadjskY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCpQN9zqmucq8gIkzSrBnG2Vva/AjzIB+TuUwVvGJLK/FCyCbKJn5h4+QMFPEDiw4GdBup0SK/0zrEidafCno51SOtQNdjJ0cZHZMJ8yV5XmVKmYaDrjpUJgyOKbWZNkdMfO7UY9Yy9K0bhEEd35O+2d5e0KX5IXJeRfXp/n9nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZE7BzAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZE7BzAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE88C4CEF7;
	Tue, 17 Mar 2026 17:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767992;
	bh=fJ6QJa6XO9USKGJd3UVojEtZdlDmtGh0vySKvadjskY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZE7BzAN0kwXnRJOn/B5J4B8JaKPh0r+SL8o6NQX6pfsvEgD32eBHsGde+dzNc5fp
	 e/6AgwizdnWpLpiAeKkfqccW48HWwDpZzg2Wt/oh2BDhwXkZLU4hUrQDImQpP/yvCY
	 KyPMToQjKY4nj4BgstPB/nx4dFlne9LC5smXwdbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 206/333] kunit: irq: Ensure timer doesnt fire too frequently
Date: Tue, 17 Mar 2026 17:33:55 +0100
Message-ID: <20260317163006.999274003@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
 include/kunit/run-in-irq-context.h | 44 +++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/kunit/run-in-irq-context.h b/include/kunit/run-in-irq-context.h
index c89b1b1b12dd..bfe60d6cf28d 100644
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
@@ -30,14 +30,25 @@ static enum hrtimer_restart kunit_irq_test_timer_func(struct hrtimer *timer)
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
@@ -86,10 +97,14 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
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
@@ -104,21 +119,18 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
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
-- 
2.53.0



