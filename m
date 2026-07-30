Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4C529BD87;
	Thu, 30 Jul 2026 15:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423653; cv=none; b=NXnH+N+XGNQDKs1aemo+syA59GoeE890Gv+I6lFEFx2GwlXBzOqzf4SrFLJPJNAZ0V8ZOXgCD5tJ2We9GkLd/sRHZugN0QIMpHfQDo8SB6evWy+GfD8i2bUTz45erZrvsPiSFMQUF+2pKxwXYUAw+gzcEkvg26h4nTH1Ws9+MPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423653; c=relaxed/simple;
	bh=pd4bsRKRMk5Jf2MUZ47KMCRGLTA8uNVoGB7QQS79+Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHGYZhT/1XMyhZX7PsH3KFc2XGZ2uJPOANuQaSHG+bcDaJxmzzULO2S5ChbiVDk/ohrazHiK2qOt80iZYW5SWERbtQXvE5xX+pWLch/nWkKthwuChAKFccBJ1VRsox8l2rTtx3dJhINFmEnvNzLPlyvctTLQw92p9pJutXB+8gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvuSjMEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvuSjMEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685A61F000E9;
	Thu, 30 Jul 2026 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423651;
	bh=cqoDo8L0YI3I14ftxcVdwEgXPSDr7Vus6qxdRaJnyJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvuSjMExxOfIt/vkhLoHgYxyfs19BxDDdbmRTc7HnEhVjZ7dQ+poC8rduImuJdGcd
	 Jz6BAalRYRiBzbeAQey6Bo8CDgwIDkJsZffftuKichzbDzT9rxKKAqFjByYNaboarO
	 pxWvd8UOtMcOLE4K4FyXPbvcwLT6xVGY8dnAZ4UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/675] powerpc/time: Prepare to stop elapsing in dynticks-idle
Date: Thu, 30 Jul 2026 16:07:27 +0200
Message-ID: <20260730141447.631132241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit c8ba971cf8567d49eb5f43ee90c4e50424331c18 ]

Currently the tick subsystem stores the idle cputime accounting in
private fields, allowing cohabitation with architecture idle vtime
accounting. The former is fetched on online CPUs, the latter on offline
CPUs.

For consolidation purpose, architecture vtime accounting will continue
to account the cputime but will make a break when the idle tick is
stopped. The dyntick cputime accounting will then be relayed by the tick
subsystem so that the idle cputime is still seen advancing coherently
even when the tick isn't there to flush the idle vtime.

Prepare for that and introduce three new APIs which will be used in
subsequent patches:

  - vtime_dynticks_start() is deemed to be called when idle enters in
    dyntick mode. The idle cputime that elapsed so far is accumulated.

  - vtime_dynticks_stop() is deemed to be called when idle exits from
    dyntick mode. The vtime entry clocks are fast-forward to current time
    so that idle accounting restarts elapsing from now.

  - vtime_reset() is deemed to be called from dynticks idle IRQ entry to
    fast-forward the clock to current time so that the IRQ time is still
    accounted by vtime while nohz cputime is paused.

Also accumulated vtime won't be flushed from dyntick-idle ticks to avoid
accounting twice the idle cputime, along with nohz accounting.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Link: https://patch.msgid.link/20260508131647.43868-6-frederic@kernel.org
Stable-dep-of: c1c1ffa490fc ("powerpc/vtime: Initialize starttime at boot for native accounting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 41 ++++++++++++++++++++++++++++++++++++++
 include/linux/vtime.h      |  6 ++++++
 2 files changed, 47 insertions(+)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b4472288e0d434..3460d1a5a97c2a 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -376,6 +376,47 @@ void vtime_task_switch(struct task_struct *prev)
 		acct->starttime = acct0->starttime;
 	}
 }
+
+#ifdef CONFIG_NO_HZ_COMMON
+/**
+ * vtime_reset - Fast forward vtime entry clocks
+ *
+ * Called from dynticks idle IRQ entry to fast-forward the clocks to current time
+ * so that the IRQ time is still accounted by vtime while nohz cputime is paused.
+ */
+void vtime_reset(void)
+{
+	struct cpu_accounting_data *acct = get_accounting(current);
+
+	acct->starttime = mftb();
+#ifdef CONFIG_ARCH_HAS_SCALED_CPUTIME
+	acct->startspurr = read_spurr(acct->starttime);
+#endif
+}
+
+/**
+ * vtime_dyntick_start - Inform vtime about entry to idle-dynticks
+ *
+ * Called when idle enters in dyntick mode. The idle cputime that elapsed so far
+ * is accumulated and the tick subsystem takes over the idle cputime accounting.
+ */
+void vtime_dyntick_start(void)
+{
+	vtime_account_idle(current);
+}
+
+/**
+ * vtime_dyntick_stop - Inform vtime about exit from idle-dynticks
+ *
+ * Called when idle exits from dyntick mode. The vtime entry clocks are
+ * fast-forward to current time so that idle accounting restarts elapsing from
+ * now.
+ */
+void vtime_dyntick_stop(void)
+{
+	vtime_reset();
+}
+#endif /* CONFIG_NO_HZ_COMMON */
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 void __no_kcsan __delay(unsigned long loops)
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 29dd5b91dd7d66..3fc04b849e4e30 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -32,11 +32,17 @@ extern void vtime_account_irq(struct task_struct *tsk, unsigned int offset);
 extern void vtime_account_softirq(struct task_struct *tsk);
 extern void vtime_account_hardirq(struct task_struct *tsk);
 extern void vtime_flush(struct task_struct *tsk);
+extern void vtime_reset(void);
+extern void vtime_dyntick_start(void);
+extern void vtime_dyntick_stop(void);
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 static inline void vtime_account_irq(struct task_struct *tsk, unsigned int offset) { }
 static inline void vtime_account_softirq(struct task_struct *tsk) { }
 static inline void vtime_account_hardirq(struct task_struct *tsk) { }
 static inline void vtime_flush(struct task_struct *tsk) { }
+static inline void vtime_reset(void) { }
+static inline void vtime_dyntick_start(void) { }
+static inline void vtime_dyntick_stop(void) { }
 #endif
 
 /*
-- 
2.53.0



