Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CBD38398F;
	Sat, 12 Sep 2026 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230255; cv=none; b=D5cx/Ggy4b0zXNUZ/9s3YMhgWUItcsyGvfdWIR2Y0ADGZa3EaE69WqO0izQUfPD4Vn1nOYx1p2oDhIzaylaVw3Ep8thtqNdB6E5bB2fN7AmJ7MU5H0bnSZ8Z3XzxnCQPc7OUiXLZmYFkco3SAkb9PT8UltCJ29RY2Y1zRYfHJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230255; c=relaxed/simple;
	bh=//I6Z2oAmEFvYoIciHYNh7wmXzCE75Zj7LiHAFaJlIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BC2rP4u158fs5CmA0brNaVHSgm1eK8N58N28MNjCia/jYuNcfiF6TtKstBcNBODUCkICrpn9BLso7n4VtaXyxIuEpUuKTiTZ5TWLxjkHR/ut7BEPTQr4KGJ98hcnhU2xv1U6B3KpVvxo8ZHQoDlZHW5MA47RATBpDNGaFMbQkKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tnnmny/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tnnmny/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A507B1F00898;
	Sat, 12 Sep 2026 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230253;
	bh=hKlozSuTjZq3zlT3n5JWnEHrKVBmnm2jh2oxyuJFGzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tnnmny/ePXfU8Ft8KsSbIz0bK0txUYt3OAHYFFMK4Acv47zakscybHUjIbEOn6Tej
	 KU6aV43Gy++/zRgT2zfQkOvYMLRuJU/BOwDk1f9zsjzLu1N89h1XdR97nkTvcgslAp
	 pG/t4taWiGsMmoFBPa09jsOLmK7v3IXyDhW0r8a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Suggested-by: Clark Williams" <williams@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0756/1191] tracing/osnoise: Add preempt and/or irq disabled options
Date: Sat, 12 Sep 2026 08:58:04 +0200
Message-ID: <20260912065605.258960945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit b5dce2002567a9b1a83ef3e3a8678d8c32be2a78 ]

The osnoise workload runs with preemption and IRQs enabled in such
a way as to allow all sorts of noise to disturb osnoise's execution.
hwlat tracer has a similar workload but works with irq disabled,
allowing only NMIs and the hardware to generate noise.

While thinking about adding an options file to hwlat tracer to
allow the system to panic, and other features I was thinking
to add, like having a tracepoint at each noise detection, it
came to my mind that is easier to make osnoise and also do
hardware latency detection than making hwlat "feature compatible"
with osnoise.

Other points are:
 - osnoise already has an independent cpu file.
 - osnoise has a more intuitive interface, e.g., runtime/period vs.
   window/width (and people often need help remembering what it is).
 - osnoise: tracepoints
 - osnoise stop options
 - osnoise options file itself

Moreover, the user-space side (in rtla) is simplified by reusing the
existing osnoise code.

Finally, people have been asking me about using osnoise for hw latency
detection, and I have to explain that it was sufficient but not
necessary. These options make it sufficient and necessary.

Adding a Suggested-by Clark, as he often asked me about this
possibility.

Link: https://lkml.kernel.org/r/d9c6c19135497054986900f94c8e47410b15316a.1670623111.git.bristot@kernel.org

Cc: Suggested-by: Clark Williams <williams@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 27d73e81195b ("rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_osnoise.c | 48 ++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 37653a871d75d..366d8c288f5fa 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -55,10 +55,17 @@ enum osnoise_options_index {
 	OSN_DEFAULTS = 0,
 	OSN_WORKLOAD,
 	OSN_PANIC_ON_STOP,
+	OSN_PREEMPT_DISABLE,
+	OSN_IRQ_DISABLE,
 	OSN_MAX
 };
 
-static const char * const osnoise_options_str[OSN_MAX] = { "DEFAULTS", "OSNOISE_WORKLOAD", "PANIC_ON_STOP" };
+static const char * const osnoise_options_str[OSN_MAX] = {
+							"DEFAULTS",
+							"OSNOISE_WORKLOAD",
+							"PANIC_ON_STOP",
+							"OSNOISE_PREEMPT_DISABLE",
+							"OSNOISE_IRQ_DISABLE" };
 
 #define OSN_DEFAULT_OPTIONS	0x2
 unsigned long osnoise_options	= OSN_DEFAULT_OPTIONS;
@@ -1309,18 +1316,26 @@ static void notify_new_max_latency(u64 latency)
  */
 static int run_osnoise(void)
 {
+	bool disable_irq = test_bit(OSN_IRQ_DISABLE, &osnoise_options);
 	struct osnoise_variables *osn_var = this_cpu_osn_var();
 	u64 start, sample, last_sample;
 	u64 last_int_count, int_count;
 	s64 noise = 0, max_noise = 0;
 	s64 total, last_total = 0;
 	struct osnoise_sample s;
+	bool disable_preemption;
 	unsigned int threshold;
 	u64 runtime, stop_in;
 	u64 sum_noise = 0;
 	int hw_count = 0;
 	int ret = -1;
 
+	/*
+	 * Disabling preemption is only required if IRQs are enabled,
+	 * and the options is set on.
+	 */
+	disable_preemption = !disable_irq && test_bit(OSN_PREEMPT_DISABLE, &osnoise_options);
+
 	/*
 	 * Considers the current thread as the workload.
 	 */
@@ -1336,6 +1351,15 @@ static int run_osnoise(void)
 	 */
 	threshold = tracing_thresh ? : 5000;
 
+	/*
+	 * Apply PREEMPT and IRQ disabled options.
+	 */
+	if (disable_irq)
+		local_irq_disable();
+
+	if (disable_preemption)
+		preempt_disable();
+
 	/*
 	 * Make sure NMIs see sampling first
 	 */
@@ -1423,16 +1447,21 @@ static int run_osnoise(void)
 		 * cond_resched()
 		 */
 		if (IS_ENABLED(CONFIG_PREEMPT_RCU)) {
-			local_irq_disable();
+			if (!disable_irq)
+				local_irq_disable();
+
 			rcu_momentary_dyntick_idle();
-			local_irq_enable();
+
+			if (!disable_irq)
+				local_irq_enable();
 		}
 
 		/*
 		 * For the non-preemptive kernel config: let threads runs, if
-		 * they so wish.
+		 * they so wish, unless set not do to so.
 		 */
-		cond_resched();
+		if (!disable_irq && !disable_preemption)
+			cond_resched();
 
 		last_sample = sample;
 		last_int_count = int_count;
@@ -1451,6 +1480,15 @@ static int run_osnoise(void)
 	 */
 	barrier();
 
+	/*
+	 * Return to the preemptive state.
+	 */
+	if (disable_preemption)
+		preempt_enable();
+
+	if (disable_irq)
+		local_irq_enable();
+
 	/*
 	 * Save noise info.
 	 */
-- 
2.53.0



