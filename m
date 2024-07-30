Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B90187FFB;
	Tue, 30 Jul 2024 16:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355490; cv=none; b=rlvN+tMKpZNAYmfdOELxBaFPUcVxkP63lpKyipe+4+O7omppNR+45kqw+JLDZhAbDbX7277PB8fHuycfVpTwlgyMKnIyKbx64n/P2BbDjSjwaGeXwKx6C5dzHWqmnTRGh5bEGmUoYssOwITtGW58P3+SNt8g2BMQX94nPZWbY1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355490; c=relaxed/simple;
	bh=ivRllV5663+MgRxBlNVeFwexOpt12L4Jl2ek9YEKYLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKiRTdT654q1hu4NE4JlaFefKujw656DBTKWBHJyd4bU4+mT9UlbeH/sMOVdLEhjhBoLiTbPhqOjl5XJKrQoRa7BwChRfPHMDydlpG8eLN7OOdhYyLurZd0dWavETqsQVty/gozW+pOkSR0ITdUdRilAQ4TrhDsiLbIIE5vpUZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVlR0bZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVlR0bZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA73C4AF0E;
	Tue, 30 Jul 2024 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355490;
	bh=ivRllV5663+MgRxBlNVeFwexOpt12L4Jl2ek9YEKYLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVlR0bZs8D2w9jcD9dINykIQqaa5NkzNstXW7EF/xtdhZvntuv7IeqnDOCsCxkyCN
	 ljn9j8xrFEaw4M8ZQuBiUBFiBPO7U45Kxnk3q77A0+rQVNXLDD1jTWGzkxKiUNt7k8
	 CXqoo67xoOfmtN82qGc9cI//jDhKHLS49mRx0SP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Sun <samsun1006219@gmail.com>,
	Xingwei Lee <xrivendell7@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/440] jump_label: Fix concurrency issues in static_key_slow_dec()
Date: Tue, 30 Jul 2024 17:45:32 +0200
Message-ID: <20240730151619.753507378@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 83ab38ef0a0b2407d43af9575bb32333fdd74fb2 ]

The commit which tried to fix the concurrency issues of concurrent
static_key_slow_inc() failed to fix the equivalent issues
vs. static_key_slow_dec():

CPU0                     CPU1

static_key_slow_dec()
  static_key_slow_try_dec()

	key->enabled == 1
	val = atomic_fetch_add_unless(&key->enabled, -1, 1);
	if (val == 1)
	     return false;

  jump_label_lock();
  if (atomic_dec_and_test(&key->enabled)) {
     --> key->enabled == 0
   __jump_label_update()

			 static_key_slow_dec()
			   static_key_slow_try_dec()

			     key->enabled == 0
			     val = atomic_fetch_add_unless(&key->enabled, -1, 1);

			      --> key->enabled == -1 <- FAIL

There is another bug in that code, when there is a concurrent
static_key_slow_inc() which enables the key as that sets key->enabled to -1
so on the other CPU

	val = atomic_fetch_add_unless(&key->enabled, -1, 1);

will succeed and decrement to -2, which is invalid.

Cure all of this by replacing the atomic_fetch_add_unless() with a
atomic_try_cmpxchg() loop similar to static_key_fast_inc_not_disabled().

[peterz: add WARN_ON_ONCE for the -1 race]
Fixes: 4c5ea0a9cd02 ("locking/static_key: Fix concurrent static_key_slow_inc()")
Reported-by: Yue Sun <samsun1006219@gmail.com>
Reported-by: Xingwei Lee <xrivendell7@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20240610124406.422897838@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/jump_label.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index d9c822bbffb8d..eec802175ccc6 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -131,7 +131,7 @@ bool static_key_fast_inc_not_disabled(struct static_key *key)
 	STATIC_KEY_CHECK_USE(key);
 	/*
 	 * Negative key->enabled has a special meaning: it sends
-	 * static_key_slow_inc() down the slow path, and it is non-zero
+	 * static_key_slow_inc/dec() down the slow path, and it is non-zero
 	 * so it counts as "enabled" in jump_label_update().  Note that
 	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
 	 */
@@ -150,7 +150,7 @@ bool static_key_slow_inc_cpuslocked(struct static_key *key)
 	lockdep_assert_cpus_held();
 
 	/*
-	 * Careful if we get concurrent static_key_slow_inc() calls;
+	 * Careful if we get concurrent static_key_slow_inc/dec() calls;
 	 * later calls must wait for the first one to _finish_ the
 	 * jump_label_update() process.  At the same time, however,
 	 * the jump_label_update() call below wants to see
@@ -247,20 +247,32 @@ EXPORT_SYMBOL_GPL(static_key_disable);
 
 static bool static_key_slow_try_dec(struct static_key *key)
 {
-	int val;
-
-	val = atomic_fetch_add_unless(&key->enabled, -1, 1);
-	if (val == 1)
-		return false;
+	int v;
 
 	/*
-	 * The negative count check is valid even when a negative
-	 * key->enabled is in use by static_key_slow_inc(); a
-	 * __static_key_slow_dec() before the first static_key_slow_inc()
-	 * returns is unbalanced, because all other static_key_slow_inc()
-	 * instances block while the update is in progress.
+	 * Go into the slow path if key::enabled is less than or equal than
+	 * one. One is valid to shut down the key, anything less than one
+	 * is an imbalance, which is handled at the call site.
+	 *
+	 * That includes the special case of '-1' which is set in
+	 * static_key_slow_inc_cpuslocked(), but that's harmless as it is
+	 * fully serialized in the slow path below. By the time this task
+	 * acquires the jump label lock the value is back to one and the
+	 * retry under the lock must succeed.
 	 */
-	WARN(val < 0, "jump label: negative count!\n");
+	v = atomic_read(&key->enabled);
+	do {
+		/*
+		 * Warn about the '-1' case though; since that means a
+		 * decrement is concurrent with a first (0->1) increment. IOW
+		 * people are trying to disable something that wasn't yet fully
+		 * enabled. This suggests an ordering problem on the user side.
+		 */
+		WARN_ON_ONCE(v < 0);
+		if (v <= 1)
+			return false;
+	} while (!likely(atomic_try_cmpxchg(&key->enabled, &v, v - 1)));
+
 	return true;
 }
 
@@ -271,10 +283,11 @@ static void __static_key_slow_dec_cpuslocked(struct static_key *key)
 	if (static_key_slow_try_dec(key))
 		return;
 
-	jump_label_lock();
-	if (atomic_dec_and_test(&key->enabled))
+	guard(mutex)(&jump_label_mutex);
+	if (atomic_cmpxchg(&key->enabled, 1, 0))
 		jump_label_update(key);
-	jump_label_unlock();
+	else
+		WARN_ON_ONCE(!static_key_slow_try_dec(key));
 }
 
 static void __static_key_slow_dec(struct static_key *key)
-- 
2.43.0



