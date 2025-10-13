Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6D9213E6D;
	Mon, 13 Oct 2025 15:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370205; cv=none; b=Eb3fSsrPL08Fncj8J7XUijNrM9l+GNZ3riTTUI369AVTF6pGQkn1vbdc2OioSac6tYtQcjKo/dpkpx/obLmER1ZJAhGe6t86ylUg1T4FUtNKValFhx01L9FGVb6POK2CDRIKAPqXiljrU3jrXF2YgKy4xzia8R82ETDGxwus5kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370205; c=relaxed/simple;
	bh=12d0w3CSDbjB11mCTl83qEkEToKH1s8zwlIOawh68x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXY+A1HJ7aJS2nHiXe0plebXSKUCaJ/no50yyrqLjq0cuv+Z0To+n00bgZTtdqqUiO2I3G7gK3kBwnTn6HsOPOtljOk02f0w6PI9SE/TjKzHQNIkD1BN3QkcD/L3ctYRHwuY/9fAtlGWAIM8jRKlPAcvimaa661P9v+GZcbCYI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obBoDLEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obBoDLEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23D7C4CEE7;
	Mon, 13 Oct 2025 15:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370205;
	bh=12d0w3CSDbjB11mCTl83qEkEToKH1s8zwlIOawh68x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obBoDLEr5cWPN7mu7w4KTLUKqAqx4gmEiQ0Yk+RjWAmYo0JbTLATq+5EN+dcSgtnH
	 2fNvB/xl8Sy+pjowWQ4LjZdL/jrLbQ6HmZu4JLBMfDHIf14FwMG+WA+UFpznZZFaaR
	 RslSfshDeX+a508xawWUC2vSpGdtixI3aglCjYe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.17 514/563] tracing: Fix wakeup tracers on failure of acquiring calltime
Date: Mon, 13 Oct 2025 16:46:15 +0200
Message-ID: <20251013144429.929746706@linuxfoundation.org>
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

commit 4f7bf54b07e5acf79edd58dafede4096854776cd upstream.

The functions wakeup_graph_entry() and wakeup_graph_return() both call
func_prolog_preempt_disable() that will test if the data->disable is
already set and if not, increment it and disable preemption. If it was
set, it returns false and the caller exits.

The caller of this function must decrement the disable counter, but misses
doing so if the calltime fails to be acquired.

Instead of exiting out when calltime is NULL, change the logic to do the
work if it is not NULL and still do the clean up at the end of the
function if it is NULL.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20251008114835.027b878a@gandalf.local.home
Fixes: a485ea9e3ef3 ("tracing: Fix irqsoff and wakeup latency tracers when using function graph")
Reported-by: Sasha Levin <sashal@kernel.org>
Closes: https://lore.kernel.org/linux-trace-kernel/20251006175848.1906912-1-sashal@kernel.org/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_sched_wakeup.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -138,12 +138,10 @@ static int wakeup_graph_entry(struct ftr
 		return 0;
 
 	calltime = fgraph_reserve_data(gops->idx, sizeof(*calltime));
-	if (!calltime)
-		return 0;
-
-	*calltime = trace_clock_local();
-
-	ret = __trace_graph_entry(tr, trace, trace_ctx);
+	if (calltime) {
+		*calltime = trace_clock_local();
+		ret = __trace_graph_entry(tr, trace, trace_ctx);
+	}
 	local_dec(&data->disabled);
 	preempt_enable_notrace();
 
@@ -169,12 +167,10 @@ static void wakeup_graph_return(struct f
 	rettime = trace_clock_local();
 
 	calltime = fgraph_retrieve_data(gops->idx, &size);
-	if (!calltime)
-		return;
+	if (calltime)
+		__trace_graph_return(tr, trace, trace_ctx, *calltime, rettime);
 
-	__trace_graph_return(tr, trace, trace_ctx, *calltime, rettime);
 	local_dec(&data->disabled);
-
 	preempt_enable_notrace();
 	return;
 }


