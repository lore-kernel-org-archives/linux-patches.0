Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA57F2747B;
	Mon, 24 Feb 2025 15:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409252; cv=none; b=Tb+a2p0j5YbOmAMAlxNwmFG4j7NhO2sNXeIlfHVMw/0HugGyU4i7FcYy4HoD6reK81QMiQr95vK/JAf+t+8K16g7MFTG0JofA2Z6EVAzQW/i6lxczf6DfP+WJ7qFUPXTqVdZeslFiWia+RvsQpeADdiyaTvnk/aPCvc+SVb4XBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409252; c=relaxed/simple;
	bh=htqgz1Chd3nk2aqEdjWkAwDSfgp84PeuDqEm0pHe48g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2KfJPs2Zes17xW7r9lerz4LIEPofvdgzSJ9tMqzw+DvW2kD72IG9kaHLa5J5tJxOIFL1AcLspAri184c0IdtN7AfYnxmw11lWYTU8JopqUApYsyWgO8avE8IduWBjXRXdQb4xGD39NQl8TMjLvkxDRL20TzgLT2f25jzGKCCJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRHztOyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRHztOyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317C2C4CED6;
	Mon, 24 Feb 2025 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409252;
	bh=htqgz1Chd3nk2aqEdjWkAwDSfgp84PeuDqEm0pHe48g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRHztOyqy7vsGH+c6DNt/f7To1s+QSE95NzNWAFrHL8NaRrtlXvlz6jY9rC5NCZld
	 /TqWZzfX8EmlRiej66+VrUnIWohyo7CH9ZLFe7futU6cq0OjI2OPzRjcMI1/jGeom/
	 I35e75NQwuSjiwkqGBUZRg7jddF5+jywV/c3XVT4=
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
Subject: [PATCH 6.13 131/138] ftrace: Correct preemption accounting for function tracing.
Date: Mon, 24 Feb 2025 15:36:01 +0100
Message-ID: <20250224142609.617267759@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -216,7 +216,7 @@ function_trace_call(unsigned long ip, un
 
 	parent_ip = function_get_true_parent_ip(parent_ip, fregs);
 
-	trace_ctx = tracing_gen_ctx();
+	trace_ctx = tracing_gen_ctx_dec();
 
 	data = this_cpu_ptr(tr->array_buffer.data);
 	if (!atomic_read(&data->disabled))
@@ -321,7 +321,6 @@ function_no_repeats_trace_call(unsigned
 	struct trace_array *tr = op->private;
 	struct trace_array_cpu *data;
 	unsigned int trace_ctx;
-	unsigned long flags;
 	int bit;
 
 	if (unlikely(!tr->function_enabled))
@@ -347,8 +346,7 @@ function_no_repeats_trace_call(unsigned
 	if (is_repeat_check(tr, last_info, ip, parent_ip))
 		goto out;
 
-	local_save_flags(flags);
-	trace_ctx = tracing_gen_ctx_flags(flags);
+	trace_ctx = tracing_gen_ctx_dec();
 	process_repeats(tr, ip, parent_ip, last_info, trace_ctx);
 
 	trace_function(tr, ip, parent_ip, trace_ctx);


