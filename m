Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862C43859E3;
	Tue, 10 Mar 2026 11:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141060; cv=none; b=sJgIFQp+oVcy8N0xvWoL3KVmiE14H5MCsIcYskDy7q6fFUmdjpeB0FZKXBLwKq+mi3Vl741S/B5ZVs8pJr6q5lzp50r74gC+5CUn7bAwVnBG4vPiNHQgoCjChrSLt9LsH3xQ7Kn2NNxbWuhOLV03oTpYwBoPIFYCg9PVQwDOrHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141060; c=relaxed/simple;
	bh=qCNJRKXXQggtoi7YssmvZRQtjJRflcDm/m4BG/ZrLsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4RBYoBca3+oQ5k3Hdf9TGyvvp+kNoQI3FZfyQ4Cemw2GoVW0VzTqPmjELPC4CTFB5XECpHuPh9g4IurK+lEsdixfVmY9ncZUwcEsfOsGIR8jbGj/Qp5phLhquVF1uw8PjpwMHYkLTuqcBjG/3XMQ5E5yIdt5Ec/8IzG3tJDJDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dn0km8J9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dn0km8J9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B550FC2BC86;
	Tue, 10 Mar 2026 11:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141060;
	bh=qCNJRKXXQggtoi7YssmvZRQtjJRflcDm/m4BG/ZrLsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dn0km8J9oFLjHLHRE5gPhKX/8Fja3i9WNYrElZxVWiYIENKEEf+X2jm8god05dlPG
	 Ooxg9VS4sn7mXakbAFWmVbRS99MUxgSmfrtj/X8O2rDFavoz1MGr6MCKPhzwsP+sDa
	 uFYN6pttAAFAfg8/6B7APFRlCKWr0Oyibc5OA/48/Fb/rDDQOV1lvw+RGNz+Hee3uz
	 YWjQO/ubaLjzHW2uIAvvUeAbKBIt4+31UQjspsCopvb5AqFjPK89tuzMty+0Fbq8Nh
	 TmOG0QiqvirJzOmVPoQmYDNTUGuv2ecNYoZd0SJ19LBbg2M7fJu5BKYSri5ATtqwxs
	 NxN3xA7Es26eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 060/311] s390/idle: Fix cpu idle exit cpu time accounting
Date: Tue, 10 Mar 2026 07:01:47 -0400
Message-ID: <0d8a3ecc8fa2766418c76e1d7a450c543b3fe5e9.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 0d785e2c324c90662baa4fe07a0d02233ff92824 ]

With the conversion to generic entry [1] cpu idle exit cpu time accounting
was converted from assembly to C. This introduced an reversed order of cpu
time accounting.

On cpu idle exit the current accounting happens with the following call
chain:

-> do_io_irq()/do_ext_irq()
 -> irq_enter_rcu()
  -> account_hardirq_enter()
   -> vtime_account_irq()
    -> vtime_account_kernel()

vtime_account_kernel() accounts the passed cpu time since last_update_timer
as system time, and updates last_update_timer to the current cpu timer
value.

However the subsequent call of

 -> account_idle_time_irq()

will incorrectly subtract passed cpu time from timer_idle_enter to the
updated last_update_timer value from system_timer. Then last_update_timer
is updated to a sys_enter_timer, which means that last_update_timer goes
back in time.

Subsequently account_hardirq_exit() will account too much cpu time as
hardirq time. The sum of all accounted cpu times is still correct, however
some cpu time which was previously accounted as system time is now
accounted as hardirq time, plus there is the oddity that last_update_timer
goes back in time.

Restore previous behavior by extracting cpu time accounting code from
account_idle_time_irq() into a new update_timer_idle() function and call it
before irq_enter_rcu().

Fixes: 56e62a737028 ("s390: convert to generic entry") [1]
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/idle.h |  1 +
 arch/s390/kernel/idle.c      | 13 +++++++++----
 arch/s390/kernel/irq.c       | 10 ++++++++--
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/idle.h b/arch/s390/include/asm/idle.h
index 09f763b9eb40a..133059d9a949c 100644
--- a/arch/s390/include/asm/idle.h
+++ b/arch/s390/include/asm/idle.h
@@ -23,5 +23,6 @@ extern struct device_attribute dev_attr_idle_count;
 extern struct device_attribute dev_attr_idle_time_us;
 
 void psw_idle(struct s390_idle_data *data, unsigned long psw_mask);
+void update_timer_idle(void);
 
 #endif /* _S390_IDLE_H */
diff --git a/arch/s390/kernel/idle.c b/arch/s390/kernel/idle.c
index 39cb8d0ae3480..0f9e53f0a0686 100644
--- a/arch/s390/kernel/idle.c
+++ b/arch/s390/kernel/idle.c
@@ -21,11 +21,10 @@
 
 static DEFINE_PER_CPU(struct s390_idle_data, s390_idle);
 
-void account_idle_time_irq(void)
+void update_timer_idle(void)
 {
 	struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
 	struct lowcore *lc = get_lowcore();
-	unsigned long idle_time;
 	u64 cycles_new[8];
 	int i;
 
@@ -35,13 +34,19 @@ void account_idle_time_irq(void)
 			this_cpu_add(mt_cycles[i], cycles_new[i] - idle->mt_cycles_enter[i]);
 	}
 
-	idle_time = lc->int_clock - idle->clock_idle_enter;
-
 	lc->steal_timer += idle->clock_idle_enter - lc->last_update_clock;
 	lc->last_update_clock = lc->int_clock;
 
 	lc->system_timer += lc->last_update_timer - idle->timer_idle_enter;
 	lc->last_update_timer = lc->sys_enter_timer;
+}
+
+void account_idle_time_irq(void)
+{
+	struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
+	unsigned long idle_time;
+
+	idle_time = get_lowcore()->int_clock - idle->clock_idle_enter;
 
 	/* Account time spent with enabled wait psw loaded as idle time. */
 	WRITE_ONCE(idle->idle_time, READ_ONCE(idle->idle_time) + idle_time);
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index bdf9c7cb5685b..080e9285b3379 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -146,6 +146,10 @@ void noinstr do_io_irq(struct pt_regs *regs)
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	bool from_idle;
 
+	from_idle = test_and_clear_cpu_flag(CIF_ENABLED_WAIT);
+	if (from_idle)
+		update_timer_idle();
+
 	irq_enter_rcu();
 
 	if (user_mode(regs)) {
@@ -154,7 +158,6 @@ void noinstr do_io_irq(struct pt_regs *regs)
 			current->thread.last_break = regs->last_break;
 	}
 
-	from_idle = test_and_clear_cpu_flag(CIF_ENABLED_WAIT);
 	if (from_idle)
 		account_idle_time_irq();
 
@@ -182,6 +185,10 @@ void noinstr do_ext_irq(struct pt_regs *regs)
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	bool from_idle;
 
+	from_idle = test_and_clear_cpu_flag(CIF_ENABLED_WAIT);
+	if (from_idle)
+		update_timer_idle();
+
 	irq_enter_rcu();
 
 	if (user_mode(regs)) {
@@ -194,7 +201,6 @@ void noinstr do_ext_irq(struct pt_regs *regs)
 	regs->int_parm = get_lowcore()->ext_params;
 	regs->int_parm_long = get_lowcore()->ext_params2;
 
-	from_idle = test_and_clear_cpu_flag(CIF_ENABLED_WAIT);
 	if (from_idle)
 		account_idle_time_irq();
 
-- 
2.51.0

