Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CC429A0;
	Wed,  7 May 2025 19:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644488; cv=none; b=L/XqeNo3wnl9QlTr3E433GoeN4OHVkl0143icKupToUVVQKLmq8+dMfRRkJW0fYJJpoIH0qwRkkIMmHm3UfhoIoKs3E3SKTEM0JocwcUy5MN5Fq2mbEXwilJhje+oYLaFJIvh9wZlVD3aL+m+jh4cgoCbPNuv/HxQdcuLrQuBaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644488; c=relaxed/simple;
	bh=2MgdHd5LIDeG1PM5jtATOfXXtb/u+CWXG3DKpCWXtlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1mQE68TTL2LQKdF3Ez3mj76uN/Y0LLI5Hb2lTOOfN7Cn2xIviRdjZNA05OLNbtrC7ix4YLlZAGfsj1IU++qIJzUfvDsIIKPGc4RPfHRXXIDNJVU3X2tuBWe7LIXee71q7n6ozuyRqQ1FzUuQ44YWybl0q+Ic4hXqpNTKIEupqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ5dqxGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ5dqxGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712BAC4CEE2;
	Wed,  7 May 2025 19:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644487;
	bh=2MgdHd5LIDeG1PM5jtATOfXXtb/u+CWXG3DKpCWXtlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJ5dqxGk8/eHGzHNftF/DoB0RPxS/5EjWgyT/hw0dVuseUHGXhJrqRdHKPvwynkGS
	 +1vXGfbmDRmj1vNxfq1NsKbQ6XfNHEcOOMU/akAG+G1e6g8tucHUXmKAOIgrlKOf+R
	 kHNijIbr1bSdVc8vsLKCx90HhCDz9VOf1ZdQe+TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	syzbot+441582c1592938fccf09@syzkaller.appspotmail.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 029/164] tracing: Do not take trace_event_sem in print_event_fields()
Date: Wed,  7 May 2025 20:38:34 +0200
Message-ID: <20250507183822.048963072@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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
@@ -950,11 +950,12 @@ enum print_line_t print_event_fields(str
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
@@ -964,7 +965,6 @@ enum print_line_t print_event_fields(str
 			if (call->event.type > __TRACE_LAST_TYPE)
 				break;
 		}
-		up_read(&trace_event_sem);
 		if (!found) {
 			trace_seq_printf(&iter->seq, "UNKNOWN TYPE %d\n", event->type);
 			goto out;


