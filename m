Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76644314B71;
	Mon, 13 Oct 2025 15:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370208; cv=none; b=eQXVUFohogU9DwrzJTcBSe/GVIX7WtcYUa5dvv7YsIcBkE07AksctNWgo7gShXyRxX/1/2s9n0idV5nOFpeObxgaMOE68jvBCck88QTjxZKABsExnzRnNZwtrnXGf0IcZiFbxEMjuUGbW//AskSUnFpfIq9tGDMNBIQ6jbdLPYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370208; c=relaxed/simple;
	bh=PJNhLeamefwbV7HLotRCUCx9WSC+eNUFeqhhd1zBgjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxfmG1L8oQSPzdy0NGE5USyaBUV/GYl4eXzUHJR4bvtaVY6LIOnR+9me8Upiknmn3Jmc3LujQoZ6dGHCmPrewUshA1RV3ikoCDX54TrG+JDwkN2gxmNFfPEvW5mCsg8CEnZ5pNxZnTqNowXexyrE9yBZgt+4em07dpJnTDRar4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWP7HRXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWP7HRXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDF6C4CEE7;
	Mon, 13 Oct 2025 15:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370208;
	bh=PJNhLeamefwbV7HLotRCUCx9WSC+eNUFeqhhd1zBgjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWP7HRXTlyRAPqFWvpwywWfkJx0527MG7pA6CbJTl2gwV2g3ykkfTZWuWVJDNoUXi
	 Kywe7PFFbSsLl8XpPyzVi1dGsKbWNeHW9A25aiDYESnRVLEQZMvPSttV6jqGDNBnI4
	 J9PhsFf7aDcuwYmMdGBMeDUQsG24ykMSfMmWsBNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.17 515/563] tracing: Fix irqoff tracers on failure of acquiring calltime
Date: Mon, 13 Oct 2025 16:46:16 +0200
Message-ID: <20251013144429.966496922@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit c834a97962c708ff5bb8582ca76b0e1225feb675 upstream.

The functions irqsoff_graph_entry() and irqsoff_graph_return() both call
func_prolog_dec() that will test if the data->disable is already set and
if not, increment it and return. If it was set, it returns false and the
caller exits.

The caller of this function must decrement the disable counter, but misses
doing so if the calltime fails to be acquired.

Instead of exiting out when calltime is NULL, change the logic to do the
work if it is not NULL and still do the clean up at the end of the
function if it is NULL.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20251008114943.6f60f30f@gandalf.local.home
Fixes: a485ea9e3ef3 ("tracing: Fix irqsoff and wakeup latency tracers when using function graph")
Reported-by: Sasha Levin <sashal@kernel.org>
Closes: https://lore.kernel.org/linux-trace-kernel/20251006175848.1906912-2-sashal@kernel.org/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_irqsoff.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 5496758b6c76..4c45c49b06c8 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -184,7 +184,7 @@ static int irqsoff_graph_entry(struct ftrace_graph_ent *trace,
 	unsigned long flags;
 	unsigned int trace_ctx;
 	u64 *calltime;
-	int ret;
+	int ret = 0;
 
 	if (ftrace_graph_ignore_func(gops, trace))
 		return 0;
@@ -202,13 +202,11 @@ static int irqsoff_graph_entry(struct ftrace_graph_ent *trace,
 		return 0;
 
 	calltime = fgraph_reserve_data(gops->idx, sizeof(*calltime));
-	if (!calltime)
-		return 0;
-
-	*calltime = trace_clock_local();
-
-	trace_ctx = tracing_gen_ctx_flags(flags);
-	ret = __trace_graph_entry(tr, trace, trace_ctx);
+	if (calltime) {
+		*calltime = trace_clock_local();
+		trace_ctx = tracing_gen_ctx_flags(flags);
+		ret = __trace_graph_entry(tr, trace, trace_ctx);
+	}
 	local_dec(&data->disabled);
 
 	return ret;
@@ -233,11 +231,10 @@ static void irqsoff_graph_return(struct ftrace_graph_ret *trace,
 
 	rettime = trace_clock_local();
 	calltime = fgraph_retrieve_data(gops->idx, &size);
-	if (!calltime)
-		return;
-
-	trace_ctx = tracing_gen_ctx_flags(flags);
-	__trace_graph_return(tr, trace, trace_ctx, *calltime, rettime);
+	if (calltime) {
+		trace_ctx = tracing_gen_ctx_flags(flags);
+		__trace_graph_return(tr, trace, trace_ctx, *calltime, rettime);
+	}
 	local_dec(&data->disabled);
 }
 
-- 
2.51.0



