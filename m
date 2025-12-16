Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3183317BA2;
	Tue, 16 Dec 2025 12:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888708; cv=none; b=eOR8eeYloYIjsVAj9qrFrHwWqHkYwhkTSjCKrzBZePT2EhNQ2E3JGJEAZG41TCLXLpK+kX34LqY+xDF+dpYjWliFwiRqMCbNFiURx6Mr4F1iQCIHV+Y360RoLr5WQWORrDr4f+Z7Fc2PbSBgg6RIzw6PBGLXvZ6e0c+vABfisLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888708; c=relaxed/simple;
	bh=C3fVHQmxD9g144v0RGe7rMLZyfFn4Fy7XM5C3roGk2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaWLF2sKes3aKi857sgpkW3Xf8Kk7K7285KZYEESkRDVTIZFUqogG1y74b0EaygFW00TpMoL6XFBa5T1iDbTyGZA5tfrgXFKX5/MHq9ThCKnP5idPSuAPJl+rZH6hgN30L0ptN+9i8fQTI0znuToELj1J9Sy2dXCUvTbqZqz/fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keytWIMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keytWIMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49190C4CEF1;
	Tue, 16 Dec 2025 12:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888707;
	bh=C3fVHQmxD9g144v0RGe7rMLZyfFn4Fy7XM5C3roGk2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keytWIMASnm4/aDFeYV6iQr4OE/qHvSDlcdVVlP6pjfwmelZzCNRAHahyonGYIgQK
	 oXjAcDLx/WwdMeP4f4jHQHUMHllDIkHa0yChJiHU8IluhcqxLqFFG4O6b96hrGqZ2z
	 xxMYA0HOIWYozqVIMlm/Sqtp+MeCT86n5GupoVFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 598/614] cpu: Make atomic hotplug callbacks run with interrupts disabled on UP
Date: Tue, 16 Dec 2025 12:16:05 +0100
Message-ID: <20251216111423.059845366@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



