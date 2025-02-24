Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A7127701;
	Mon, 24 Feb 2025 14:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408737; cv=none; b=WeSmuT/GkImmJk+ZRwyHHzAaCExC7sNfVUJdrtgfYCqF/kKtgO+9ZXh422jq+WXmQC8LQHcvLzlx8iboxuWjNc/2fXMU0V2aTSG09kb9aw2a4HNBMbezUEufXxYQsoCFOehylHdNhFSGYnBNgYlBxBVFRu+bOkc4TiMbWVBc3FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408737; c=relaxed/simple;
	bh=ztCvN/1lU66tIZ4Pz1H/1pRV0t1lNYcrNmM55gtTNM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGrSznN9HAPzNADnjyUwnYNJvraLxWFeikXZ2ftBD2/KVBweHdmgkjRZLY2iDILbiWwFAmCacszC/ZCfCXotqC3MkOOg8FaMHvs7/T9LkqXqCsaaccVJg1IFPzr/7jVh3pQ/GejrcaVjoWVKL2DAZeUG2mn2WsZ/St6tmo0AUEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeMiZPR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeMiZPR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B47C4CED6;
	Mon, 24 Feb 2025 14:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408737;
	bh=ztCvN/1lU66tIZ4Pz1H/1pRV0t1lNYcrNmM55gtTNM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeMiZPR1z+7o/RbYR53cUhxm8P9VaiZi8EY/bEzypkrMN8q/sfNrv8/OabCfTFNq1
	 LwG6IU3Wyjhj0Vx0XWAu9bBugrVINkaOqyjsAn3eF4Qx6phtD1lM8GMULswVQr1QWY
	 iUNYRw2E52mOHOXnn7Zk8X3bsRa0++FrOf/lgPjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 145/154] ftrace: Correct preemption accounting for function tracing.
Date: Mon, 24 Feb 2025 15:35:44 +0100
Message-ID: <20250224142612.726200639@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 57b76bedc5c52c66968183b5ef57234894c25ce7 upstream.

The function tracer should record the preemption level at the point when
the function is invoked. If the tracing subsystem decrement the
preemption counter it needs to correct this before feeding the data into
the trace buffer. This was broken in the commit cited below while
shifting the preempt-disabled section.

Use tracing_gen_ctx_dec() which properly subtracts one from the
preemption counter on a preemptible kernel.

Cc: stable@vger.kernel.org
Cc: Wander Lairson Costa <wander@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/20250220140749.pfw8qoNZ@linutronix.de
Fixes: ce5e48036c9e7 ("ftrace: disable preemption when recursion locked")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -193,7 +193,7 @@ function_trace_call(unsigned long ip, un
 	if (bit < 0)
 		return;
 
-	trace_ctx = tracing_gen_ctx();
+	trace_ctx = tracing_gen_ctx_dec();
 
 	cpu = smp_processor_id();
 	data = per_cpu_ptr(tr->array_buffer.data, cpu);
@@ -298,7 +298,6 @@ function_no_repeats_trace_call(unsigned
 	struct trace_array *tr = op->private;
 	struct trace_array_cpu *data;
 	unsigned int trace_ctx;
-	unsigned long flags;
 	int bit;
 	int cpu;
 
@@ -325,8 +324,7 @@ function_no_repeats_trace_call(unsigned
 	if (is_repeat_check(tr, last_info, ip, parent_ip))
 		goto out;
 
-	local_save_flags(flags);
-	trace_ctx = tracing_gen_ctx_flags(flags);
+	trace_ctx = tracing_gen_ctx_dec();
 	process_repeats(tr, ip, parent_ip, last_info, trace_ctx);
 
 	trace_function(tr, ip, parent_ip, trace_ctx);


