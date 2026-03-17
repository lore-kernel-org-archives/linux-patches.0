Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7F63EF641;
	Tue, 17 Mar 2026 16:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766518; cv=none; b=O6lfi8oqsxbwAtWzdBUcAm76XWwvMEl+72odziddXOEdGUxZkrxStiNlNED3XHqp5bynVe5jfWvCe50scXap1vSc0lfto/UOs/XA3aMcMxL94McPqjKYsEtEdJGnaXEU3LRiBExpS/Gai3zdQ80vrJHSo/kP2aVdZjUEPtOCR2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766518; c=relaxed/simple;
	bh=6+8Q5pBdVKjGfuEzLb8Pt98m01QBpqQ7fXXe+TTc7IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfxJzKsF8+cdzaphPmwLZXEx1RaO2IG9bf00JhnJmpQRErCmXkEvemQXM9G+vRG8AttdyIeRih0YcXMUuPbIQyLDfFIX59G//29EUR2FdAYZr3L4mC6abWdnWWWlt8pkPc3Z1m3LpX2NNhZGzToTov2i3pQahpQfnKt29uTICNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKe+gNEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKe+gNEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062C3C4CEF7;
	Tue, 17 Mar 2026 16:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766518;
	bh=6+8Q5pBdVKjGfuEzLb8Pt98m01QBpqQ7fXXe+TTc7IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKe+gNEbOU3Sc6/3rwFy4o52DtgaW8C4BuZPt2k/QbotB+O+z0fXT7HyM7fndJ+ky
	 unlevQiGyV6Z4MBuu36Ppy0VPLKKKhupkbrDV313qZh+GqdjjmnXsXMpaPr+0PFbn0
	 +J9pSEpcFFQuiVZZi0OWEB1r2wWGxB4RfMnOG/5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.19 262/378] fgraph: Fix thresh_return clear per-task notrace
Date: Tue, 17 Mar 2026 17:33:39 +0100
Message-ID: <20260317163016.652911862@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Shengming Hu <hu.shengming@zte.com.cn>

commit 6ca8379b5d36e22b04e6315c3e49a6083377c862 upstream.

When tracing_thresh is enabled, function graph tracing uses
trace_graph_thresh_return() as the return handler. Unlike
trace_graph_return(), it did not clear the per-task TRACE_GRAPH_NOTRACE
flag set by the entry handler for set_graph_notrace addresses. This could
leave the task permanently in "notrace" state and effectively disable
function graph tracing for that task.

Mirror trace_graph_return()'s per-task notrace handling by clearing
TRACE_GRAPH_NOTRACE and returning early when set.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260221113007819YgrZsMGABff4Rc-O_fZxL@zte.com.cn
Fixes: b84214890a9bc ("function_graph: Move graph notrace bit to shadow stack global var")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions_graph.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -400,14 +400,15 @@ static void trace_graph_thresh_return(st
 				      struct fgraph_ops *gops,
 				      struct ftrace_regs *fregs)
 {
+	unsigned long *task_var = fgraph_get_task_var(gops);
 	struct fgraph_times *ftimes;
 	struct trace_array *tr;
 	int size;
 
 	ftrace_graph_addr_finish(gops, trace);
 
-	if (trace_recursion_test(TRACE_GRAPH_NOTRACE_BIT)) {
-		trace_recursion_clear(TRACE_GRAPH_NOTRACE_BIT);
+	if (*task_var & TRACE_GRAPH_NOTRACE) {
+		*task_var &= ~TRACE_GRAPH_NOTRACE;
 		return;
 	}
 


