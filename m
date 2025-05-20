Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E870C242D9A;
	Tue, 20 May 2025 13:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749316; cv=none; b=ina8tvI8XxUdTbvLJpneAlFE/w7e9TY9VwCxCz0c1W3HokkXAOa8T1vxzKJ55C7PDYId0JRmvtmmPe3UZJTgw6/6RQ942V+lTPs0P/XJ4Nl+VOXV5f/iJP9BX1yjxGCwqRgkMKGZDZ1Q3ORHbRm9WsKjFKtv7cZRMSitP7u3Ghw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749316; c=relaxed/simple;
	bh=TfNhB8PQ6nvRllrZ4skaT98hoIinNlKHvZkyB4Q7l1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAxM5sAIWfjEwznYQ0pvp9P/kUKvpS9is3QMMtXBVcBeQFGsJddoCJNhTLtM+HazNqd6WPVNJGbn0xi2jY0py+i5eDXBJcmmNgeZzQO1qMFF1+5QsWEy+gcSChT+QzK58Knlm5kmXQDV/kVOLT+OJoeeearGiZx08vktlcSLiP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pjz0vALA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pjz0vALA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B20C4CEE9;
	Tue, 20 May 2025 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749315;
	bh=TfNhB8PQ6nvRllrZ4skaT98hoIinNlKHvZkyB4Q7l1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pjz0vALAVZytYwRo2eLMdQ1s8qM1WHrKbWX1bv1mTV+9zobCiQf3bMITV85g7hx4y
	 gXuOk+g5xZ0xfS5QP7CnEi/xydXno4FABWjki4k1a5NjYS1X3WMiQVdQ+VMr340vCE
	 fU649nLwd5lMG5TBSJVuhes3bEntHHrPO4+C5feM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pengdonglin <dolinux.peng@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 36/59] ftrace: Fix preemption accounting for stacktrace trigger command
Date: Tue, 20 May 2025 15:50:27 +0200
Message-ID: <20250520125755.289732793@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1244,7 +1244,7 @@ stacktrace_trigger(struct event_trigger_
 	struct trace_event_file *file = data->private_data;
 
 	if (file)
-		__trace_stack(file->tr, tracing_gen_ctx(), STACK_SKIP);
+		__trace_stack(file->tr, tracing_gen_ctx_dec(), STACK_SKIP);
 	else
 		trace_dump_stack(STACK_SKIP);
 }


