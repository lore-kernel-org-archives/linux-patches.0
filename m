Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711BB35A3B6;
	Thu, 12 Mar 2026 20:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346483; cv=none; b=TidiA0FfdckUcq2l50Inr5vi4k+OeqLbwsWk9Y3BJnfXLoh7ozuRuZ+m/ggbQd572Qmuaw5f6JY6zif75F9Zmd982+U4fl3mrxMgtKk4vG867FuMDZS/nmPUkfeU8scJDre6V8I9Ng00oDnaMaaCtY3DPsi1m4wvwFKtdp8fxvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346483; c=relaxed/simple;
	bh=9q3AXUbUJaQGVnf4C5Iq/QH7uIDrBpSPscAWdUx9duE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/AcWTb0lc4sHqBtqoVlb5n/ji7fhrtzHX/ooBB5aiBhnGjJTFxkG8pJLJ4NqNIB9CuC1TIDR8EqnbcJfXEVV0w0hGradCPtpLXRXFQ7aC+u+RXIPS2haGGeuzyozn012sH6oGqWKkCs7hBcvfxqoE2e4y2Z1rEQWGY3004Rr7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkTQCgc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkTQCgc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B673C4CEF7;
	Thu, 12 Mar 2026 20:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346483;
	bh=9q3AXUbUJaQGVnf4C5Iq/QH7uIDrBpSPscAWdUx9duE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkTQCgc6aF4UmIGZ5cmMyKv0BigN2aRQul76oSql0TPQTJ7Mlg0YwH9z4hTHKt2/T
	 6bU4lWV3ZBpgisR9AwaY3NhBYsX45SSTJf5M2k/6V6ArFeGwYArXJBzRvytQEdqNt2
	 8WNfVqREx/JDvfOA7ZN42Vx4PfLV4Ts/0xooyLLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/265] s390/idle: Fix cpu idle exit cpu time accounting
Date: Thu, 12 Mar 2026 21:06:48 +0100
Message-ID: <20260312201018.947318504@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 2639a3d12736a..1fe941dc86c32 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -140,6 +140,10 @@ void noinstr do_io_irq(struct pt_regs *regs)
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	bool from_idle;
 
+	from_idle = test_and_clear_cpu_flag(CIF_ENABLED_WAIT);
+	if (from_idle)
+		update_timer_idle();
+
 	irq_enter_rcu();
 
 	if (user_mode(regs)) {
@@ -148,7 +152,6 @@ void noinstr do_io_irq(struct pt_regs *regs)
 			current->thread.last_break = regs->last_break;
 	}
 
-	from_idle = test_and_clear_cpu_flag(CIF_ENABLED_WAIT);
 	if (from_idle)
 		account_idle_time_irq();
 
@@ -176,6 +179,10 @@ void noinstr do_ext_irq(struct pt_regs *regs)
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	bool from_idle;
 
+	from_idle = test_and_clear_cpu_flag(CIF_ENABLED_WAIT);
+	if (from_idle)
+		update_timer_idle();
+
 	irq_enter_rcu();
 
 	if (user_mode(regs)) {
@@ -188,7 +195,6 @@ void noinstr do_ext_irq(struct pt_regs *regs)
 	regs->int_parm = get_lowcore()->ext_params;
 	regs->int_parm_long = get_lowcore()->ext_params2;
 
-	from_idle = test_and_clear_cpu_flag(CIF_ENABLED_WAIT);
 	if (from_idle)
 		account_idle_time_irq();
 
-- 
2.51.0



