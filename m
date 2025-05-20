Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78887242D7D;
	Tue, 20 May 2025 13:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749476; cv=none; b=cdS928lpTS1Qti/K9d/wb14sKpZIgc+x5b+jaTqeBTGxhDBqHvMpmmHWeLYh7XjZgpC67XE/ChXUm7yA0c5TFH8FOwbiJE7s0Q/8Oy1Dwa025fJSO8/E9/JBj7GWmJsPch0iafWZHGrrOJASdvMNQArBLcMv3uihHvR0KRtXMqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749476; c=relaxed/simple;
	bh=YaX/z0HixTmk3VchSbi9c7VfuvwnUl9XwV6LDwHJF9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yw4RdSxE2kVEsOFIe/gOuZkwkzhrc1s5jxqwEkuDfw7NmJD6Hjy1Vc+dhMUdh1ogwrfgK5UFGFVQVa33yjqhW4y9LxdTNrmZDg0yxIFb/Q13Rd6pzhLZA1MVqRXooj4ThlMuSlCYoyi58nNXk4GrhNKTANUUpa0Kp/eDRqLodu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOsVwXG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOsVwXG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37D4C4CEE9;
	Tue, 20 May 2025 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749476;
	bh=YaX/z0HixTmk3VchSbi9c7VfuvwnUl9XwV6LDwHJF9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOsVwXG3LW+O0mA7s1TmNapqY3WwhAxvaP1ZuQ9C3bNFcf2+feCNlZFzhdIKma46J
	 3InaW0eVk/SkQSR1jvz6aUq81r7JLmK2Gi0+b4ddE242sF32+FsPsYvp4XMd1jCmLK
	 7B/03OtUkzkEP5nBPk289KbpSTZwXvtkrnTe++v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pengdonglin <dolinux.peng@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 56/97] ftrace: Fix preemption accounting for stacktrace filter command
Date: Tue, 20 May 2025 15:50:21 +0200
Message-ID: <20250520125802.851841291@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


