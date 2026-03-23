Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3533B19AF;
	Mon, 23 Mar 2026 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276929; cv=none; b=XD7TyYS4SzQhmSKIaEbJkRWQt1FO3yfruoJpDlRe+MLg8JwRGomxnFnqQdCrXoHco4J/M+rGc2HIfkJ6VYV62OX1INsUGmVKBaAvKuK8HeAES57CgSttdlXFElb4os2Cxg2nJb8p1ATsKQfj0wqW7zu1dDu5ieop7eJAGHpkUCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276929; c=relaxed/simple;
	bh=IhA97Pj7W3h5bsOZrW27YYZztvksyLk5S8/k1rjHuSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDXBVW6Q+yah778Dl25pMe3Wlk0sdf3s9tAKmIV86bIY4lZ/tkzNMch4edaF/kjLt9Lj+i3A9tE6dr/Y6yHjqqu556BJSHpERCc5N/CnMA9+uDM7Li1i1TBuyRzZshrTYW8EzI1XUtbpV9VPG5B2vfkGeHX1BF9ao4QAtu+BuvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ka0dAq4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ka0dAq4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A4FC2BCB1;
	Mon, 23 Mar 2026 14:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276929;
	bh=IhA97Pj7W3h5bsOZrW27YYZztvksyLk5S8/k1rjHuSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ka0dAq4FmoFNpGQVp8OcFXm/zNCa8iDe1mWs2fobuIqeAxsKWdOk8ZoVUc9DZp8Ms
	 kNPfBbmU7eWC8MrX7cDzm7pui+3DXe9owc2xVwYBjD9/4mRcRs1ZL/evF2n5fI1mK+
	 Zr+kcWIl9idthFOU+QPBxR+TzXvIsH3sXiFtGdyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/460] fgraph: Fix thresh_return clear per-task notrace
Date: Mon, 23 Mar 2026 14:44:14 +0100
Message-ID: <20260323134532.825994386@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengming Hu <hu.shengming@zte.com.cn>

[ Upstream commit 6ca8379b5d36e22b04e6315c3e49a6083377c862 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions_graph.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -271,10 +271,12 @@ void trace_graph_return(struct ftrace_gr
 static void trace_graph_thresh_return(struct ftrace_graph_ret *trace,
 				      struct fgraph_ops *gops)
 {
+	unsigned long *task_var = fgraph_get_task_var(gops);
+
 	ftrace_graph_addr_finish(gops, trace);
 
-	if (trace_recursion_test(TRACE_GRAPH_NOTRACE_BIT)) {
-		trace_recursion_clear(TRACE_GRAPH_NOTRACE_BIT);
+	if (*task_var & TRACE_GRAPH_NOTRACE) {
+		*task_var &= ~TRACE_GRAPH_NOTRACE;
 		return;
 	}
 


