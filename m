Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5EEEDE;
	Tue, 20 May 2025 14:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749855; cv=none; b=TJpDUNhSZsAiLyFz/IhTQ2KUzM/CifDvvAqZu2v5CerQuGz4laZBF5/23uT5L+nfVudWOKZa/JlH7S0g9Z3YZ/J1XOVC9oY+xiHT8nnQbbbjQKC3K8EvYWTHtM+ipXSYF1qVtEkQBIu30FDpRXoJ+AOyfxy03hIrQczd5iaoh0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749855; c=relaxed/simple;
	bh=oNHdK/wazY9RTtrwG3HqNjKf3AA58dbqGk6Ee6em+pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4hECklMxmF62RT8qxWL+fbq+gUcyU4ZXtgzB2cekjXE7vHQr+ExhJj472gVJsSULoyItrYla+J+N6Qz0riJNnlQr+UfufCbUepPMQeuolnRWfgfKtnk8e4+l7HCtQc/GGZ15pBhyeghNlKh13C5ZQJ/rXrmCba2RR2lsJQkpj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhCkJf0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhCkJf0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CD7C4CEE9;
	Tue, 20 May 2025 14:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749854;
	bh=oNHdK/wazY9RTtrwG3HqNjKf3AA58dbqGk6Ee6em+pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhCkJf0G8bJuJyx/X2YGEHTVZA6ocqmOzQrZbGNzHq4sqIE4fBWZg8y4L5pxrE5Dr
	 4OZGMCcn0LGPHq8qXMq1f1YyrD2smWeI4fvgely6wLDDAOnTMURIdRJpv5pC3X2eNH
	 2teKJGZY+dqGEyuZZyIGu26qkv1L3Pt8IZFpvFnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pengdonglin <dolinux.peng@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 080/117] ftrace: Fix preemption accounting for stacktrace trigger command
Date: Tue, 20 May 2025 15:50:45 +0200
Message-ID: <20250520125807.173332733@linuxfoundation.org>
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

commit e333332657f615ac2b55aa35565c4a882018bbe9 upstream.

When using the stacktrace trigger command to trace syscalls, the
preemption count was consistently reported as 1 when the system call
event itself had 0 (".").

For example:

root@ubuntu22-vm:/sys/kernel/tracing/events/syscalls/sys_enter_read
$ echo stacktrace > trigger
$ echo 1 > enable

    sshd-416     [002] .....   232.864910: sys_read(fd: a, buf: 556b1f3221d0, count: 8000)
    sshd-416     [002] ...1.   232.864913: <stack trace>
 => ftrace_syscall_enter
 => syscall_trace_enter
 => do_syscall_64
 => entry_SYSCALL_64_after_hwframe

The root cause is that the trace framework disables preemption in __DO_TRACE before
invoking the trigger callback.

Use the tracing_gen_ctx_dec() that will accommodate for the increase of
the preemption count in __DO_TRACE when calling the callback. The result
is the accurate reporting of:

    sshd-410     [004] .....   210.117660: sys_read(fd: 4, buf: 559b725ba130, count: 40000)
    sshd-410     [004] .....   210.117662: <stack trace>
 => ftrace_syscall_enter
 => syscall_trace_enter
 => do_syscall_64
 => entry_SYSCALL_64_after_hwframe

Cc: stable@vger.kernel.org
Fixes: ce33c845b030c ("tracing: Dump stacktrace trigger to the corresponding instance")
Link: https://lore.kernel.org/20250512094246.1167956-1-dolinux.peng@gmail.com
Signed-off-by: pengdonglin <dolinux.peng@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1554,7 +1554,7 @@ stacktrace_trigger(struct event_trigger_
 	struct trace_event_file *file = data->private_data;
 
 	if (file)
-		__trace_stack(file->tr, tracing_gen_ctx(), STACK_SKIP);
+		__trace_stack(file->tr, tracing_gen_ctx_dec(), STACK_SKIP);
 	else
 		trace_dump_stack(STACK_SKIP);
 }


