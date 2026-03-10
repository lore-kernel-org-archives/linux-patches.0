Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99741387562;
	Tue, 10 Mar 2026 11:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141919; cv=none; b=IqtOrReOcGsenAhGYF5lNl0snksLtCv+wmFPVNjGT1MTl0DwEVw4TMNunIMGmJRWcAM/yC0oWoWAYxWsCcLCZZVtRifzUMiXpNXjU1EsBicqI3/eXthlPH/IBt5kP08gFs4ZAYGciouPVtj7hXf0upLNhfkJG1d0LD0lSwTmnHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141919; c=relaxed/simple;
	bh=qCNJRKXXQggtoi7YssmvZRQtjJRflcDm/m4BG/ZrLsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYikIPieiRq5DY0ctXkxG7RTLHCVk0Sn9L8eX+2VHd2AoEKihxu7LK2mzYFPrSiFyGx0WX05PgIkt6HdvQfvWluj8FV0FDZi141jRKD8F1REpc59KvfBbdr5QGL3Ot3vyya9dh2dwxdwcTDUKcNJFgjl+PxXr7p8p8fH5P0w5E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EhFeiijd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EhFeiijd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BCBC2BC86;
	Tue, 10 Mar 2026 11:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141919;
	bh=qCNJRKXXQggtoi7YssmvZRQtjJRflcDm/m4BG/ZrLsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhFeiijdKpoLU1X3Oyhobt00est0L9xfdThA/AmsWyt/MvFnswt2cYs5oxPiukbfn
	 YYd5sWhh17AUFpyjaVufuFwzE/PF9kFO/cWxxfQvXwsjbbMsQB5544TR48OBPvfrtx
	 yPGreZBXZl1JG2slpwpiuHWpn1wUnPCXOEAHnMbtcTahrrKQ+UpIFRJfikhAF8jo6o
	 GKV+o33yp4HEFsMFg/HX35y1Eavzl5PHCPYF47Rx6LalBrT9tCvVL9UYLR2T7jtZOv
	 WjaLrzr6dVS/iDyFEOLxu30muq6g9htZhOP6Dxvlp2L2z6rgNVm8L6ryWIO0HCJdzz
	 8kCeDr3kU36AQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/314] s390/idle: Fix cpu idle exit cpu time accounting
Date: Tue, 10 Mar 2026 07:15:02 -0400
Message-ID: <fda00504fa8dd80f9409ccee1da6acf8fd95b631.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

