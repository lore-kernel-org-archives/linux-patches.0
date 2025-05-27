Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708911D88D7;
	Tue, 27 May 2025 17:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366599; cv=none; b=rO8N/TVtb9qzyaXlECI/ZvfxpEoLtMHDXszC67EBbxMIB0ivpvpUFkUOwdBhZb/kur/FeDmqYs2BFlHTaodzRtwtBiz2cOs7sBMD2zd18A0Zc2WlDlToEs3zQqVPZjlKNRKAyRsyrQIC8vw9tJ0jd76ir3ov7z7+pt9OIoiF5Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366599; c=relaxed/simple;
	bh=nD+Hu5b7gdp3gYcz1Ng0zIlVzmD5t0yRw4Gs9RII09o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWNbLIGWS/xp7NPDeizlKZvkH4xUubUj1pqE/iSHiUklCMrdWx3/1macKGEsKggUi0UardPIjU+xbGTFW0vmlfmKpvSGiIewR92z/Vh228uXnvDemPex5zL5ZNH3JQq/Pq7Vg03/dlXzVGcyQ9BBKbegkxe6Qz8k8GCd37276Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUQc/b/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUQc/b/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F02C4CEE9;
	Tue, 27 May 2025 17:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366599;
	bh=nD+Hu5b7gdp3gYcz1Ng0zIlVzmD5t0yRw4Gs9RII09o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUQc/b/0zi95zck42LKtUgoPYDvi3J5l9qPr9Z9Dfj216TJOg02rXpyY6OthfRk9h
	 9YPrKMzo5TK5QlsgrQyNNBlA65UGnbxPYYRnqbkDnI6gpva4THkHyA1HSv4LURAVEu
	 DE3fZHWkHCXhE4ZDfZjaY4i67IKhrg68ROyEXph8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryo Takakura <ryotkkr98@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 090/783] lockdep: Fix wait context check on softirq for PREEMPT_RT
Date: Tue, 27 May 2025 18:18:07 +0200
Message-ID: <20250527162516.803649423@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 4dae6ac2e83fb..513b1945987cc 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -126,6 +126,18 @@ static DEFINE_PER_CPU(struct softirq_ctrl, softirq_ctrl) = {
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
@@ -148,6 +160,8 @@ void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
 
 	WARN_ON_ONCE(in_hardirq());
 
+	lock_map_acquire_read(&bh_lock_map);
+
 	/* First entry of a task into a BH disabled section? */
 	if (!current->softirq_disable_cnt) {
 		if (preemptible()) {
@@ -211,6 +225,8 @@ void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
 	WARN_ON_ONCE(in_hardirq());
 	lockdep_assert_irqs_enabled();
 
+	lock_map_release(&bh_lock_map);
+
 	local_irq_save(flags);
 	curcnt = __this_cpu_read(softirq_ctrl.cnt);
 
@@ -261,6 +277,8 @@ static inline void ksoftirqd_run_begin(void)
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



