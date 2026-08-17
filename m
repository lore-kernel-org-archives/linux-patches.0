Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828E54B04A7;
	Mon, 17 Aug 2026 14:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976638; cv=none; b=LRNdh2/NC9kFyIJIeHGdHIYOsh2W8LNdqU3167+YhoO7CSPGfJtbfxYfsfx5Y4M+eFIVt8EE16zbe/lDIN8TsrPkcyKYbIN3No7WWsF5UGhROKAhe0yHWi2+BPFtsHA4k2o+XDb1ZgxewWU3lgehHDSaeOSioMLneLMfleaQ1s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976638; c=relaxed/simple;
	bh=g8/CBC3f/P6ftNsqkx/VHZ8SvYu3a4Gbma891jsiJxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmgO8oKtTeo298XHFqbLAzf5E/ooHEkop1PF3Qj3TNA0NSXn8SLxTByFhmomE8n/YCsd6zZYzKQVcACWwqvCYLoyeOU6h3itNwsH3vALKxXtYKEDEvhf3Vcg+5sEx6e9uNtKgvNv/oSX+JHtVzQeRqP/UKgEZ3Bl5vUCB7+pje4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dnjucyy+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dnjucyy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC8A1F000E9;
	Mon, 17 Aug 2026 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976637;
	bh=d3TKoeupIVabE4bcUkiV6iAWKtO30KsA3A/zHCr/vZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dnjucyy+WqN4OGgtLX5koS2r5HyqQTFXtZsQH2eOyET4Z1Q8CKYgV45gjH0yga7hT
	 YPt9pUSrDXAB+yg1Ou7I4vrOwxGCbKMGCjU6wmtT7d8U85IM4yCGo5QON7u64wSzRf
	 cDvC6v/rzZ09SMylLhWjidLnllzmRXJUVSLl8/Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/456] powerpc/time: Prepare to stop elapsing in dynticks-idle
Date: Mon, 17 Aug 2026 15:27:21 +0200
Message-ID: <20260817132542.030716446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 65235323bee49c..e4ccacdd95435e 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -451,6 +451,47 @@ void vtime_task_switch(struct task_struct *prev)
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
index 3684487d01e1c6..7cee518fde3a24 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -37,11 +37,17 @@ extern void vtime_account_irq(struct task_struct *tsk, unsigned int offset);
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



