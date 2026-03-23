Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E163B893A;
	Mon, 23 Mar 2026 13:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274364; cv=none; b=PNKGA2wI9C1krr7147v6DQtidvR7tm8Uyp2EFCoMUF7dAC4VJ4+6/3R+6l9SYfA7+00Wy9PKG1H7rkFJCeEmrvADdtYgUCkjmnDQs0VJHxKry5Os6LAox7qMIz8JAt1ccwwBEYDsD3jWUPX2c6tINWerRfUFLjfwHA1qz9GM/KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274364; c=relaxed/simple;
	bh=qiMNeTlRqWWfXXMjFvp5n09UwXmTjHjaiIJMRYHq5Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOM6VpTboMLUxZ9zIqNJWZ906fcT5DNQmqQ7maWu9pmAoaKkgTs3H80Jl8oJWe1tPUDqAfO5cyVRe2xX3GVGAUsYAk9nciO8WsHjJBPt9PYqNdWUd1YsylbgX63jXkXOtdjPDZ6um36Ip8ERxI+r1mnziCWEeXNGmWBp8wyKrag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loeO/vq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loeO/vq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAAFC2BC9E;
	Mon, 23 Mar 2026 13:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274364;
	bh=qiMNeTlRqWWfXXMjFvp5n09UwXmTjHjaiIJMRYHq5Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=loeO/vq+I23O8CLKeqC0Pa+eVhwcIZyML2u91xxmeoUkefbFVIA6RIW6bcinXxfKI
	 bV7OPJi8G2ywbGwsTgXhDE42mHEuQxR1SgRTZKwA0efIVsL93xuQkPRjCoS6pmhM1p
	 sBifOtqFQD5ACWYkdMf71LmD4B9TUPy4ZCcuaCow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.19 194/220] tracing: Fix trace_marker copy link list updates
Date: Mon, 23 Mar 2026 14:46:11 +0100
Message-ID: <20260323134510.715990348@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 07183aac4a6828e474f00b37c9d795d0d99e18a7 upstream.

When the "copy_trace_marker" option is enabled for an instance, anything
written into /sys/kernel/tracing/trace_marker is also copied into that
instances buffer. When the option is set, that instance's trace_array
descriptor is added to the marker_copies link list. This list is protected
by RCU, as all iterations uses an RCU protected list traversal.

When the instance is deleted, all the flags that were enabled are cleared.
This also clears the copy_trace_marker flag and removes the trace_array
descriptor from the list.

The issue is after the flags are called, a direct call to
update_marker_trace() is performed to clear the flag. This function
returns true if the state of the flag changed and false otherwise. If it
returns true here, synchronize_rcu() is called to make sure all readers
see that its removed from the list.

But since the flag was already cleared, the state does not change and the
synchronization is never called, leaving a possible UAF bug.

Move the clearing of all flags below the updating of the copy_trace_marker
option which then makes sure the synchronization is performed.

Also use the flag for checking the state in update_marker_trace() instead
of looking at if the list is empty.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20260318185512.1b6c7db4@gandalf.local.home
Fixes: 7b382efd5e8a ("tracing: Allow the top level trace_marker to write into another instances")
Reported-by: Sasha Levin <sashal@kernel.org>
Closes: https://lore.kernel.org/all/20260225133122.237275-1-sashal@kernel.org/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -567,7 +567,7 @@ static bool update_marker_trace(struct t
 	lockdep_assert_held(&event_mutex);
 
 	if (enabled) {
-		if (!list_empty(&tr->marker_list))
+		if (tr->trace_flags & TRACE_ITER(COPY_MARKER))
 			return false;
 
 		list_add_rcu(&tr->marker_list, &marker_copies);
@@ -575,10 +575,10 @@ static bool update_marker_trace(struct t
 		return true;
 	}
 
-	if (list_empty(&tr->marker_list))
+	if (!(tr->trace_flags & TRACE_ITER(COPY_MARKER)))
 		return false;
 
-	list_del_init(&tr->marker_list);
+	list_del_rcu(&tr->marker_list);
 	tr->trace_flags &= ~TRACE_ITER(COPY_MARKER);
 	return true;
 }
@@ -10547,18 +10547,19 @@ static int __remove_instance(struct trac
 
 	list_del(&tr->list);
 
-	/* Disable all the flags that were enabled coming in */
-	for (i = 0; i < TRACE_FLAGS_MAX_SIZE; i++) {
-		if ((1ULL << i) & ZEROED_TRACE_FLAGS)
-			set_tracer_flag(tr, 1ULL << i, 0);
-	}
-
 	if (printk_trace == tr)
 		update_printk_trace(&global_trace);
 
+	/* Must be done before disabling all the flags */
 	if (update_marker_trace(tr, 0))
 		synchronize_rcu();
 
+	/* Disable all the flags that were enabled coming in */
+	for (i = 0; i < TRACE_FLAGS_MAX_SIZE; i++) {
+		if ((1ULL << i) & ZEROED_TRACE_FLAGS)
+			set_tracer_flag(tr, 1ULL << i, 0);
+	}
+
 	tracing_set_nop(tr);
 	clear_ftrace_function_probes(tr);
 	event_trace_del_tracer(tr);


