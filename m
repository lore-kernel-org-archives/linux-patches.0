Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679DC18DB24;
	Mon, 10 Mar 2025 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627058; cv=none; b=S9sTZlVkWuyVZ/HrcVUXoyC7/dCefakxRV5vdjhvuXif1BbbDuaZsgaTznwPp4KeBI8Inkg/MJ2m34pAbOrruWh+DqmcqfZe0H4vMwl7D2EIkdLW0Qs9texYk0V9VtW3UqzhIF1CwNn6DQeRDI+Wt9AUTts1zg3h82dUCL/Bb2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627058; c=relaxed/simple;
	bh=f0D5V+OAnA7noYzJ6Sq1r7StG7cClV+ZVtsJlpTkbF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXAWDHaqazUUDORjUofUupXgz3TK7NttDGXS50JFKNaAx7Cz16ivLZNkLEZFLS2AbtVE3iWlwidTQ6kvOBjmVVzQOip6g6XBLVVrl0etqKuRk8UzprCg4hkf6ANF2I40KtPAlOHk+dimcLojPAcwe1v5q+60kXO8vVK+u2DeQAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u90PgzkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u90PgzkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62EBC4CEE5;
	Mon, 10 Mar 2025 17:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627058;
	bh=f0D5V+OAnA7noYzJ6Sq1r7StG7cClV+ZVtsJlpTkbF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u90PgzkZ3GRRTjC7vnVqcWcbruzSe+5C/Orx1nbNwHgYxIbUlVnW6o+cCnNNiHnYY
	 EeWBNbD8544GGCyAXjr4Csqodn90yebN+Ws0HRM4cpLTVoC4RGfOnFm64LAILUZ4jq
	 XPSqLUk1zywkJRQkjpbd4MF90tVKA2+eLpLNQ1xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 205/207] fprobe: Fix accounting of when to unregister from function graph
Date: Mon, 10 Mar 2025 18:06:38 +0100
Message-ID: <20250310170455.926971053@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit ca26554a1498bc905c4a39fb42d55d93f3ae8df2 upstream.

When adding a new fprobe, it will update the function hash to the
functions the fprobe is attached to and register with function graph to
have it call the registered functions. The fprobe_graph_active variable
keeps track of the number of fprobes that are using function graph.

If two fprobes attach to the same function, it increments the
fprobe_graph_active for each of them. But when they are removed, the first
fprobe to be removed will see that the function it is attached to is also
used by another fprobe and it will not remove that function from
function_graph. The logic will skip decrementing the fprobe_graph_active
variable.

This causes the fprobe_graph_active variable to not go to zero when all
fprobes are removed, and in doing so it does not unregister from
function graph. As the fgraph ops hash will now be empty, and an empty
filter hash means all functions are enabled, this triggers function graph
to add a callback to the fprobe infrastructure for every function!

 # echo "f:myevent1 kernel_clone" >> /sys/kernel/tracing/dynamic_events
 # echo "f:myevent2 kernel_clone%return" >> /sys/kernel/tracing/dynamic_events
 # cat /sys/kernel/tracing/enabled_functions
kernel_clone (1)           	tramp: 0xffffffffc0024000 (ftrace_graph_func+0x0/0x60) ->ftrace_graph_func+0x0/0x60

 # > /sys/kernel/tracing/dynamic_events
 # cat /sys/kernel/tracing/enabled_functions
trace_initcall_start_cb (1)             tramp: 0xffffffffc0026000 (function_trace_call+0x0/0x170) ->function_trace_call+0x0/0x170
run_init_process (1)            tramp: 0xffffffffc0026000 (function_trace_call+0x0/0x170) ->function_trace_call+0x0/0x170
try_to_run_init_process (1)             tramp: 0xffffffffc0026000 (function_trace_call+0x0/0x170) ->function_trace_call+0x0/0x170
x86_pmu_show_pmu_cap (1)                tramp: 0xffffffffc0026000 (function_trace_call+0x0/0x170) ->function_trace_call+0x0/0x170
cleanup_rapl_pmus (1)                   tramp: 0xffffffffc0026000 (function_trace_call+0x0/0x170) ->function_trace_call+0x0/0x170
uncore_free_pcibus_map (1)              tramp: 0xffffffffc0026000 (function_trace_call+0x0/0x170) ->function_trace_call+0x0/0x170
uncore_types_exit (1)                   tramp: 0xffffffffc0026000 (function_trace_call+0x0/0x170) ->function_trace_call+0x0/0x170
uncore_pci_exit.part.0 (1)              tramp: 0xffffffffc0026000 (function_trace_call+0x0/0x170) ->function_trace_call+0x0/0x170
kvm_shutdown (1)                tramp: 0xffffffffc0026000 (function_trace_call+0x0/0x170) ->function_trace_call+0x0/0x170
vmx_dump_msrs (1)               tramp: 0xffffffffc0026000 (function_trace_call+0x0/0x170) ->function_trace_call+0x0/0x170
[..]

 # cat /sys/kernel/tracing/enabled_functions | wc -l
54702

If a fprobe is being removed and all its functions are also traced by
other fprobes, still decrement the fprobe_graph_active counter.

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Link: https://lore.kernel.org/20250220202055.565129766@goodmis.org
Fixes: 4346ba1604093 ("fprobe: Rewrite fprobe on function-graph tracer")
Closes: https://lore.kernel.org/all/20250217114918.10397-A-hca@linux.ibm.com/
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Tested-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -378,7 +378,8 @@ static void fprobe_graph_remove_ips(unsi
 	if (!fprobe_graph_active)
 		unregister_ftrace_graph(&fprobe_graph_ops);
 
-	ftrace_set_filter_ips(&fprobe_graph_ops.ops, addrs, num, 1, 0);
+	if (num)
+		ftrace_set_filter_ips(&fprobe_graph_ops.ops, addrs, num, 1, 0);
 }
 
 static int symbols_cmp(const void *a, const void *b)
@@ -648,8 +649,7 @@ int unregister_fprobe(struct fprobe *fp)
 	}
 	del_fprobe_hash(fp);
 
-	if (count)
-		fprobe_graph_remove_ips(addrs, count);
+	fprobe_graph_remove_ips(addrs, count);
 
 	kfree_rcu(hlist_array, rcu);
 	fp->hlist_array = NULL;


