Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3433B2FF6;
	Mon, 23 Mar 2026 14:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275016; cv=none; b=VdBcEze3RjRbdER8PDS4v2C7oB6V8ZkQw7ZrPdjOE6af2gy6fe/O29qycX79BXPry5VLS2V3+s5Hg/7Cex6eYSxaqAAvPhmAHIF/AK5mfcHfrRS2kTzHtNPiQRilEebh/w/7Ipe624kgC0YUm+/9AeT4Wspz1vzUw5qnQzcMw7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275016; c=relaxed/simple;
	bh=mmTUF/szwNFwG27eAe8fDFW5Bp8e1hsNtnkNfYh2whc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4r5ph+ZnBL/7bjo8gRapHvm9todsHTYxG67sXi5yxXKaVOJEhGtsZDi6LS3dDAkJE/Yw/QWMS3I8mEeE+JevQT2zRzdalENiCp+XkK+hJ2FSoaiY1eNclkdzIVxTEioYBpuGqYDPFjls1pnb4g1JsTu8ufPFIeVv8PrCTLqFbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUVNsLeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUVNsLeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5F3C4CEF7;
	Mon, 23 Mar 2026 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275016;
	bh=mmTUF/szwNFwG27eAe8fDFW5Bp8e1hsNtnkNfYh2whc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUVNsLeCUDpj8UVOGT+7I8xdZT4sY76wBVl/sqSMzILk7thTSS/TqMxI5nKSL+UFt
	 gi8v1T0ZpfBq8o/Lai1Szp3u4KsIH+HSmLHknjbI0u+U+ke0Kx6WChloT9J3Tn9hHl
	 NL4/eUVRr+9ExXzpqAWClwebuXXiQJDDqa11+n3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.18 194/212] tracing: Fix trace_marker copy link list updates
Date: Mon, 23 Mar 2026 14:46:55 +0100
Message-ID: <20260323134509.857786007@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 07183aac4a6828e474f00b37c9d795d0d99e18a7 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -569,7 +569,7 @@ static bool update_marker_trace(struct t
 	lockdep_assert_held(&event_mutex);
 
 	if (enabled) {
-		if (!list_empty(&tr->marker_list))
+		if (tr->trace_flags & TRACE_ITER_COPY_MARKER)
 			return false;
 
 		list_add_rcu(&tr->marker_list, &marker_copies);
@@ -577,10 +577,10 @@ static bool update_marker_trace(struct t
 		return true;
 	}
 
-	if (list_empty(&tr->marker_list))
+	if (!(tr->trace_flags & TRACE_ITER_COPY_MARKER))
 		return false;
 
-	list_del_init(&tr->marker_list);
+	list_del_rcu(&tr->marker_list);
 	tr->trace_flags &= ~TRACE_ITER_COPY_MARKER;
 	return true;
 }
@@ -10232,18 +10232,19 @@ static int __remove_instance(struct trac
 
 	list_del(&tr->list);
 
-	/* Disable all the flags that were enabled coming in */
-	for (i = 0; i < TRACE_FLAGS_MAX_SIZE; i++) {
-		if ((1 << i) & ZEROED_TRACE_FLAGS)
-			set_tracer_flag(tr, 1 << i, 0);
-	}
-
 	if (printk_trace == tr)
 		update_printk_trace(&global_trace);
 
+	/* Must be done before disabling all the flags */
 	if (update_marker_trace(tr, 0))
 		synchronize_rcu();
 
+	/* Disable all the flags that were enabled coming in */
+	for (i = 0; i < TRACE_FLAGS_MAX_SIZE; i++) {
+		if ((1 << i) & ZEROED_TRACE_FLAGS)
+			set_tracer_flag(tr, 1 << i, 0);
+	}
+
 	tracing_set_nop(tr);
 	clear_ftrace_function_probes(tr);
 	event_trace_del_tracer(tr);


