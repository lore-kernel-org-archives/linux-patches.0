Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B58EEDE;
	Tue, 20 May 2025 14:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749857; cv=none; b=gCipcEa5gxBaPCqmRFUqvzjupwUxxieVFjRWKiA0i4mdl5nehKLHq3+5VWMC6xYLs97ri/ydZNEZPM8IYowK66D9RvH1J4qMC318xVsVYMIveL4IZgUkCTNaS9oKGVLBU1dwYe/stERjAp1CcdWaD44yYyU6bhsqqWpKXLM6D5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749857; c=relaxed/simple;
	bh=afLxmKZUVxp8AgOYJbyiEzA37pKbqS5HOio27kli+KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnrFUbqO8Xt3zNvzHtgOFyjCSym71vLLZ6R8g1IF1iHYtUJqGjR17qMFEY6hAt63HCbwJ58QHrXcBZLDXLQJjeB8K/6xGYKyhIn1sHLZOSIbV2lY1bDcyrl8d7/9mNLfjv+zyBZldo13AmxyU3aGdVPGySwe2a7kz5zHYFJEdoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdtsRxH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdtsRxH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431C9C4CEE9;
	Tue, 20 May 2025 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749857;
	bh=afLxmKZUVxp8AgOYJbyiEzA37pKbqS5HOio27kli+KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdtsRxH2UE7+S3gwQthe98M3zii1wC46NrE8sxv8Boz+Th+vybkB6/qXU70iVuIIC
	 bDOKp16xhtx7uiED2D5yuzEMJ7OIF/F1iNR3ho+8bOZDtat1pv7Mbb8X0WZavajR4Q
	 OHUDXsmxJ0WoO+B4JFPuz1YdvM+5B6Ab5nkRO5v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pengdonglin <dolinux.peng@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 081/117] ftrace: Fix preemption accounting for stacktrace filter command
Date: Tue, 20 May 2025 15:50:46 +0200
Message-ID: <20250520125807.210873396@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: pengdonglin <pengdonglin@xiaomi.com>

commit 11aff32439df6ca5b3b891b43032faf88f4a6a29 upstream.

The preemption count of the stacktrace filter command to trace ksys_read
is consistently incorrect:

$ echo ksys_read:stacktrace > set_ftrace_filter

   <...>-453     [004] ...1.    38.308956: <stack trace>
=> ksys_read
=> do_syscall_64
=> entry_SYSCALL_64_after_hwframe

The root cause is that the trace framework disables preemption when
invoking the filter command callback in function_trace_probe_call:

   preempt_disable_notrace();
   probe_ops->func(ip, parent_ip, probe_opsbe->tr, probe_ops, probe->data);
   preempt_enable_notrace();

Use tracing_gen_ctx_dec() to account for the preempt_disable_notrace(),
which will output the correct preemption count:

$ echo ksys_read:stacktrace > set_ftrace_filter

   <...>-410     [006] .....    31.420396: <stack trace>
=> ksys_read
=> do_syscall_64
=> entry_SYSCALL_64_after_hwframe

Cc: stable@vger.kernel.org
Fixes: 36590c50b2d07 ("tracing: Merge irqflags + preempt counter.")
Link: https://lore.kernel.org/20250512094246.1167956-2-dolinux.peng@gmail.com
Signed-off-by: pengdonglin <dolinux.peng@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -561,11 +561,7 @@ ftrace_traceoff(unsigned long ip, unsign
 
 static __always_inline void trace_stack(struct trace_array *tr)
 {
-	unsigned int trace_ctx;
-
-	trace_ctx = tracing_gen_ctx();
-
-	__trace_stack(tr, trace_ctx, FTRACE_STACK_SKIP);
+	__trace_stack(tr, tracing_gen_ctx_dec(), FTRACE_STACK_SKIP);
 }
 
 static void


