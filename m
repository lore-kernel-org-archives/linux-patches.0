Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D5D2153C6;
	Wed,  7 May 2025 18:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643810; cv=none; b=fktpw6EatGLFUAzytraps4XBpctKM1o1j2T/xZ4MqQ5wtDJ2pttXKUgv8n/B3c0nfKj+qB6m75xNtew6ITFjQjRTiz7WojPNK5VSgldcZRR2jczrzXbMCaLvImFDOirz3IBc8AScH0nPBIxZv9Xe/7mkMwc8s0pnAO1ZTCiClAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643810; c=relaxed/simple;
	bh=nWcqKzPyrY7jP+COhEwjdD+F/U5pSV2LkJ/HPvR6qiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEm5yUbxaibdLoMaa0JF4V4En2g4LYBlL5wkHMc9O7lakn9s5wwb1XyPlRJa9Np1RvQzSXxmDEL5NTWKBCdN/T699ySPQSfBwcggBayuVL8ONr4rjKJfbhS4+0Vjnn1dUh5wUceVJxF+WaVrGSQcpb1XJhK4evBkhoynqEMIN6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/wArH6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/wArH6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F64C4CEE2;
	Wed,  7 May 2025 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643810;
	bh=nWcqKzPyrY7jP+COhEwjdD+F/U5pSV2LkJ/HPvR6qiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/wArH6gl8eqDIHANd/qV67nUF1FZsKjVaUEo6dxHqpkRcfnlXaoz+j+FA+AXPPMG
	 X0iFXq9lbgdNOlN0f871t9uauezP4KxZwmNS+1xEXdN+U6G7fcUt+s4NGWvkekWRwA
	 iRIELpPqWS8hiaM/qwe3sWwEfPqdinVvnSCzXn2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	syzbot+441582c1592938fccf09@syzkaller.appspotmail.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.14 025/183] tracing: Do not take trace_event_sem in print_event_fields()
Date: Wed,  7 May 2025 20:37:50 +0200
Message-ID: <20250507183825.706270381@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 0a8f11f8569e7ed16cbcedeb28c4350f6378fea6 upstream.

On some paths in print_event_fields() it takes the trace_event_sem for
read, even though it should always be held when the function is called.

Remove the taking of that mutex and add a lockdep_assert_held_read() to
make sure the trace_event_sem is held when print_event_fields() is called.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250501224128.0b1f0571@batman.local.home
Fixes: 80a76994b2d88 ("tracing: Add "fields" option to show raw trace event fields")
Reported-by: syzbot+441582c1592938fccf09@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6813ff5e.050a0220.14dd7d.001b.GAE@google.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_output.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -961,11 +961,12 @@ enum print_line_t print_event_fields(str
 	struct trace_event_call *call;
 	struct list_head *head;
 
+	lockdep_assert_held_read(&trace_event_sem);
+
 	/* ftrace defined events have separate call structures */
 	if (event->type <= __TRACE_LAST_TYPE) {
 		bool found = false;
 
-		down_read(&trace_event_sem);
 		list_for_each_entry(call, &ftrace_events, list) {
 			if (call->event.type == event->type) {
 				found = true;
@@ -975,7 +976,6 @@ enum print_line_t print_event_fields(str
 			if (call->event.type > __TRACE_LAST_TYPE)
 				break;
 		}
-		up_read(&trace_event_sem);
 		if (!found) {
 			trace_seq_printf(&iter->seq, "UNKNOWN TYPE %d\n", event->type);
 			goto out;


