Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFE135968;
	Mon,  2 Jun 2025 14:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873169; cv=none; b=ueZ8fG1DsrIx+HJNPlb/1hQ5NO4dmkGCCEIhI9BMXrErHARcnxuBppP/iRTfafWY4VB6ENKBlgJPY50BtIV7mM4eUJEM3dcyCoyXv5Tsihkv6tpJ/fjR8rP+/BJsOrGqpcM+zWcS6Fni+4u/wSSq0f1+hixvfuzZfQF7IZviqAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873169; c=relaxed/simple;
	bh=DeWyc3fS8eR7tcPnewc0S4uPiqz9Yxi8PTRJaoB7h48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6F/zQ+7LhdSfqBsMKkmbWfMjz3LqOkELvaJxbUw3WPmU1OqjfaL/53G4DXqwWEl81BGk2+WwpOyb+uh02rCv0zYTwktaARFFXCTS+YWDj/E8Is5FMcopBnSInHgT96ryeSR7AEOmVFoX7vkJMlDqRnGqisZ1xdstnWHygFDNzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoV+m6ts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoV+m6ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C68C4CEEB;
	Mon,  2 Jun 2025 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873169;
	bh=DeWyc3fS8eR7tcPnewc0S4uPiqz9Yxi8PTRJaoB7h48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NoV+m6tsyCNv7I7KcECzgvYuDneZ3hdOqiCgMdo7wl1MW/JSVSCAuRvSrdDhrZ0pm
	 3Z52ySGZJ3Xk7cULrNKXka2U8bHspmYLhvJ510drO3ZREkffPy4iTIowpJdhaRVtpm
	 E9y5RatTpwXTuODYYY8jv8RCgSjFGxTWRfa/drUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryo Takakura <ryotkkr98@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/444] lockdep: Fix wait context check on softirq for PREEMPT_RT
Date: Mon,  2 Jun 2025 15:42:04 +0200
Message-ID: <20250602134343.362423653@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Ryo Takakura <ryotkkr98@gmail.com>

[ Upstream commit 61c39d8c83e2077f33e0a2c8980a76a7f323f0ce ]

Since:

  0c1d7a2c2d32 ("lockdep: Remove softirq accounting on PREEMPT_RT.")

the wait context test for mutex usage within "in softirq context" fails
as it references @softirq_context:

    | wait context tests |
    --------------------------------------------------------------------------
                                   | rcu  | raw  | spin |mutex |
    --------------------------------------------------------------------------
                 in hardirq context:  ok  |  ok  |  ok  |  ok  |
  in hardirq context (not threaded):  ok  |  ok  |  ok  |  ok  |
                 in softirq context:  ok  |  ok  |  ok  |FAILED|

As a fix, add lockdep map for BH disabled section. This fixes the
issue by letting us catch cases when local_bh_disable() gets called
with preemption disabled where local_lock doesn't get acquired.
In the case of "in softirq context" selftest, local_bh_disable() was
being called with preemption disable as it's early in the boot.

[ boqun: Move the lockdep annotations into __local_bh_*() to avoid false
         positives because of unpaired local_bh_disable() reported by
	 Borislav Petkov and Peter Zijlstra, and make bh_lock_map
	 only exist for PREEMPT_RT. ]

[ mingo: Restored authorship and improved the bh_lock_map definition. ]

Signed-off-by: Ryo Takakura <ryotkkr98@gmail.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250321143322.79651-1-boqun.feng@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/softirq.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index f24d80cf20bd3..d9e37f3fa1303 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -125,6 +125,18 @@ static DEFINE_PER_CPU(struct softirq_ctrl, softirq_ctrl) = {
 	.lock	= INIT_LOCAL_LOCK(softirq_ctrl.lock),
 };
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key bh_lock_key;
+struct lockdep_map bh_lock_map = {
+	.name			= "local_bh",
+	.key			= &bh_lock_key,
+	.wait_type_outer	= LD_WAIT_FREE,
+	.wait_type_inner	= LD_WAIT_CONFIG, /* PREEMPT_RT makes BH preemptible. */
+	.lock_type		= LD_LOCK_PERCPU,
+};
+EXPORT_SYMBOL_GPL(bh_lock_map);
+#endif
+
 /**
  * local_bh_blocked() - Check for idle whether BH processing is blocked
  *
@@ -147,6 +159,8 @@ void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
 
 	WARN_ON_ONCE(in_hardirq());
 
+	lock_map_acquire_read(&bh_lock_map);
+
 	/* First entry of a task into a BH disabled section? */
 	if (!current->softirq_disable_cnt) {
 		if (preemptible()) {
@@ -210,6 +224,8 @@ void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
 	WARN_ON_ONCE(in_hardirq());
 	lockdep_assert_irqs_enabled();
 
+	lock_map_release(&bh_lock_map);
+
 	local_irq_save(flags);
 	curcnt = __this_cpu_read(softirq_ctrl.cnt);
 
@@ -260,6 +276,8 @@ static inline void ksoftirqd_run_begin(void)
 /* Counterpart to ksoftirqd_run_begin() */
 static inline void ksoftirqd_run_end(void)
 {
+	/* pairs with the lock_map_acquire_read() in ksoftirqd_run_begin() */
+	lock_map_release(&bh_lock_map);
 	__local_bh_enable(SOFTIRQ_OFFSET, true);
 	WARN_ON_ONCE(in_interrupt());
 	local_irq_enable();
-- 
2.39.5



