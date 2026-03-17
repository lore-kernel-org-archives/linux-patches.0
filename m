Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362033F23B3;
	Tue, 17 Mar 2026 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766535; cv=none; b=Pfxpq6ghXo8aQ0mjSoKc1Ivet8EuWEkCDijQNIelsYfaQfku+Uv1xzh09csxXdkGCdfxiaZlhICcUdXCHoAL1QaKGlJKT90gVQOrpndfBkFvUdcr/YTsnTHqpw3dl/XTOHKIL+dIZdk5DvM4hDIYBrAZzenUriduR7gUm9FlFHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766535; c=relaxed/simple;
	bh=fvtuui02k6UJilAbeuOogXeub47zAPQB7HjVl2NgX1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGXjzltuJwWbUpMKwve9H05c4GXCXNUL7GimqxqS51kJ62HQZKK7LKHxkezJD5yl3HLp5CeQfBHMKYUjyMKyY6PiQu5T70qenAL+v3knjhQx/bsoCFQux5bb7/EliO5XGTehClulHvczfFpq4zro+aBow+Sals9xVXqRBjsMsFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcV02Uum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcV02Uum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF63C2BC86;
	Tue, 17 Mar 2026 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766535;
	bh=fvtuui02k6UJilAbeuOogXeub47zAPQB7HjVl2NgX1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LcV02Uum8nIm6pOPSEXm7ynwM/bKPzsScb3vjpSIY3NOC37V1o8lk6RiCdMRlwTO8
	 rXPTuMgwF2ZvmTfbIKQPEipLM9Z32xCo+HQ4Geggf9auKTt0rd1G/RugmiQL9hpND5
	 db9TaOcywwSwSig6dLki/R/70Gc6d/4BwAiCNOM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.19 265/378] fgraph: Fix thresh_return nosleeptime double-adjust
Date: Tue, 17 Mar 2026 17:33:42 +0100
Message-ID: <20260317163016.762148030@linuxfoundation.org>
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

commit b96d0c59cdbb2a22b2545f6f3d5c6276b05761dd upstream.

trace_graph_thresh_return() called handle_nosleeptime() and then delegated
to trace_graph_return(), which calls handle_nosleeptime() again. When
sleep-time accounting is disabled this double-adjusts calltime and can
produce bogus durations (including underflow).

Fix this by computing rettime once, applying handle_nosleeptime() only
once, using the adjusted calltime for threshold comparison, and writing
the return event directly via __trace_graph_return() when the threshold is
met.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260221113314048jE4VRwIyZEALiYByGK0My@zte.com.cn
Fixes: 3c9880f3ab52b ("ftrace: Use a running sleeptime instead of saving on shadow stack")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions_graph.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -403,8 +403,12 @@ static void trace_graph_thresh_return(st
 	unsigned long *task_var = fgraph_get_task_var(gops);
 	struct fgraph_times *ftimes;
 	struct trace_array *tr;
+	unsigned int trace_ctx;
+	u64 calltime, rettime;
 	int size;
 
+	rettime = trace_clock_local();
+
 	ftrace_graph_addr_finish(gops, trace);
 
 	if (*task_var & TRACE_GRAPH_NOTRACE) {
@@ -419,11 +423,13 @@ static void trace_graph_thresh_return(st
 	tr = gops->private;
 	handle_nosleeptime(tr, trace, ftimes, size);
 
-	if (tracing_thresh &&
-	    (trace_clock_local() - ftimes->calltime < tracing_thresh))
+	calltime = ftimes->calltime;
+
+	if (tracing_thresh && (rettime - calltime < tracing_thresh))
 		return;
-	else
-		trace_graph_return(trace, gops, fregs);
+
+	trace_ctx = tracing_gen_ctx();
+	__trace_graph_return(tr, trace, trace_ctx, calltime, rettime);
 }
 
 static struct fgraph_ops funcgraph_ops = {


