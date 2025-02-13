Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C9926B0BE;
	Thu, 13 Feb 2025 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459935; cv=none; b=XaK0hbkeb9/a6nSk2YxqVbtdsXzpOPfHIz0j40ie6DTQBatB/yCLVKkbk9duglm8zsFjj1k7p8VMSUALLd87EeVRjfzA99pNyUJxO1JXYikNXihQFw/gMBkAaaZpQjpjEZAbxiQY50u9l1TbfADyjf7vC5Zb37y47q6mGs+ha74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459935; c=relaxed/simple;
	bh=0czd+4Gor7rsvnFHaFA16kr3XqTIKXSJfr/2CN2WL+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhCxOZIARjb6cQ007eAhslo5AvIjQ3rI4hoK0K2pPcSKQiQBmtxnY+EfXuUdFDTLl63C0RlbMp1759tXtdbt5V2nfE0Zc/ucp4mP7YCw98s2LZlyNZ0pBmasoW7hW/DsWxp4walOq6V6Zlj+MpPECTZl4M919rI7TgzZsw9tA+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fECl1QYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fECl1QYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A341C4CED1;
	Thu, 13 Feb 2025 15:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459935;
	bh=0czd+4Gor7rsvnFHaFA16kr3XqTIKXSJfr/2CN2WL+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fECl1QYKhAGNDjSEwl3nGISZtgBskfzw8CzcaFRIN9NvpoqGb6+CFNqjRVX0PK6b5
	 rT8TO9GvXipEAlTT45aUL57OCnudwnCPrWPXUqltMu4KS9rBPUciqrqXE3hbF20uit
	 6eAlUD+rcmu61PaFCzo7YffGCaBRMcGW6yr3hb8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 407/443] fgraph: Fix set_graph_notrace with setting TRACE_GRAPH_NOTRACE_BIT
Date: Thu, 13 Feb 2025 15:29:32 +0100
Message-ID: <20250213142456.313895061@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

commit c8c9b1d2d5b4377c72a979f5a26e842a869aefc9 upstream.

The code was restructured where the function graph notrace code, that
would not trace a function and all its children is done by setting a
NOTRACE flag when the function that is not to be traced is hit.

There's a TRACE_GRAPH_NOTRACE_BIT which defines the bit in the flags and a
TRACE_GRAPH_NOTRACE which is the mask with that bit set. But the
restructuring used TRACE_GRAPH_NOTRACE_BIT when it should have used
TRACE_GRAPH_NOTRACE.

For example:

 # cd /sys/kernel/tracing
 # echo set_track_prepare stack_trace_save  > set_graph_notrace
 # echo function_graph > current_tracer
 # cat trace
[..]
 0)               |                          __slab_free() {
 0)               |                            free_to_partial_list() {
 0)               |                                  arch_stack_walk() {
 0)               |                                    __unwind_start() {
 0)   0.501 us    |                                      get_stack_info();

Where a non filter trace looks like:

 # echo > set_graph_notrace
 # cat trace
 0)               |                            free_to_partial_list() {
 0)               |                              set_track_prepare() {
 0)               |                                stack_trace_save() {
 0)               |                                  arch_stack_walk() {
 0)               |                                    __unwind_start() {

Where the filter should look like:

 # cat trace
 0)               |                            free_to_partial_list() {
 0)               |                              _raw_spin_lock_irqsave() {
 0)   0.350 us    |                                preempt_count_add();
 0)   0.351 us    |                                do_raw_spin_lock();
 0)   2.440 us    |                              }

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250208001511.535be150@batman.local.home
Fixes: b84214890a9bc ("function_graph: Move graph notrace bit to shadow stack global var")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions_graph.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -198,7 +198,7 @@ int trace_graph_entry(struct ftrace_grap
 	 * returning from the function.
 	 */
 	if (ftrace_graph_notrace_addr(trace->func)) {
-		*task_var |= TRACE_GRAPH_NOTRACE_BIT;
+		*task_var |= TRACE_GRAPH_NOTRACE;
 		/*
 		 * Need to return 1 to have the return called
 		 * that will clear the NOTRACE bit.


