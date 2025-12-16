Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771AE3596E6;
	Tue, 16 Dec 2025 12:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886680; cv=none; b=Zw76HPRhewZlAs6ij8ABw5rBiT0myI6rLXTfXVlTBFa80+lJa2eyM7ZiJEjPuJhtyPyqroKWaSgvtT+FaTQohc5JuZwceQxNU5TGstosj79j8/PBIXh3oTYLJOasZNVthjsfuswVg9317wMUVTvjUJxPxzbjhbQV2Bgixxs3qlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886680; c=relaxed/simple;
	bh=Gl5Vc1GKFDMTAqErdhDChfrOnDCZxOjgbhyekghnK+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K02VxvNXkwTk0SaSWTt/XuCzUn4QbxVEX8mjwFGxN5yng+fAq5nUl/9mceLUfdp87L6G+1oalOuIm9uS8eyifc4EZgK4G83/nfDQ5E5mejZEyMYJN2N+7kN0WujG/j0V/PjHP64blu1JZ7M2lzKd/vwm7wgAjbjzAJnAtRfyFVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/J+Vce5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/J+Vce5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0167AC4CEF1;
	Tue, 16 Dec 2025 12:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886680;
	bh=Gl5Vc1GKFDMTAqErdhDChfrOnDCZxOjgbhyekghnK+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/J+Vce5Sh3OYllkNWTK7T3g5LisCKt4XWX1foqnu4A2hyBwSC1BlchaQgpQ8u+d4
	 peLW7x1HhRfvRrIqyopO915siebVoKhVa4+R+ASApYgO151ywjjfKC7Qfk5lEZVMRS
	 OvQCBWA2iYRygmTLtZGqdtk7yCnU8aIJtY7+JAHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 495/507] cpu: Make atomic hotplug callbacks run with interrupts disabled on UP
Date: Tue, 16 Dec 2025 12:15:36 +0100
Message-ID: <20251216111403.372397208@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit c94291914b200e10c72cef23c8e4c67eb4fdbcd9 ]

On SMP systems the CPU hotplug callbacks in the "starting" range are
invoked while the CPU is brought up and interrupts are still
disabled. Callbacks which are added later are invoked via the
hotplug-thread on the target CPU and interrupts are explicitly disabled.

In the UP case callbacks which are added later are invoked directly without
the thread indirection. This is in principle okay since there is just one
CPU but those callbacks are invoked with interrupt disabled code. That's
incorrect as those callbacks assume interrupt disabled context.

Disable interrupts before invoking the callbacks on UP if the state is
atomic and interrupts are expected to be disabled.  The "save" part is
required because this is also invoked early in the boot process while
interrupts are disabled and must not be enabled prematurely.

Fixes: 06ddd17521bf1 ("sched/smp: Always define is_percpu_thread() and scheduler_ipi()")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251127144723.ev9DuXXR@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index db9f6c539b28c..15000c7abc659 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -249,6 +249,14 @@ static int cpuhp_invoke_callback(unsigned int cpu, enum cpuhp_state state,
 	return ret;
 }
 
+/*
+ * The former STARTING/DYING states, ran with IRQs disabled and must not fail.
+ */
+static bool cpuhp_is_atomic_state(enum cpuhp_state state)
+{
+	return CPUHP_AP_IDLE_DEAD <= state && state < CPUHP_AP_ONLINE;
+}
+
 #ifdef CONFIG_SMP
 static bool cpuhp_is_ap_state(enum cpuhp_state state)
 {
@@ -271,14 +279,6 @@ static inline void complete_ap_thread(struct cpuhp_cpu_state *st, bool bringup)
 	complete(done);
 }
 
-/*
- * The former STARTING/DYING states, ran with IRQs disabled and must not fail.
- */
-static bool cpuhp_is_atomic_state(enum cpuhp_state state)
-{
-	return CPUHP_AP_IDLE_DEAD <= state && state < CPUHP_AP_ONLINE;
-}
-
 /* Synchronization state management */
 enum cpuhp_sync_state {
 	SYNC_STATE_DEAD,
@@ -2364,7 +2364,14 @@ static int cpuhp_issue_call(int cpu, enum cpuhp_state state, bool bringup,
 	else
 		ret = cpuhp_invoke_callback(cpu, state, bringup, node, NULL);
 #else
-	ret = cpuhp_invoke_callback(cpu, state, bringup, node, NULL);
+	if (cpuhp_is_atomic_state(state)) {
+		guard(irqsave)();
+		ret = cpuhp_invoke_callback(cpu, state, bringup, node, NULL);
+		/* STARTING/DYING must not fail! */
+		WARN_ON_ONCE(ret);
+	} else {
+		ret = cpuhp_invoke_callback(cpu, state, bringup, node, NULL);
+	}
 #endif
 	BUG_ON(ret && !bringup);
 	return ret;
-- 
2.51.0



