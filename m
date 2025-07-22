Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355122ECE8B;
	Tue, 22 Jul 2025 14:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193228; cv=none; b=Ve8YTCDz9G8ykvWSrx0gLKMHmXz1Xwu6dSRdbI+eofUMpGzz+0H1T0Oe2ZwkSRLFvYjvzfmQpPk6XwqdUyhUO0ZpOOYkseiGLtK3bq1wKVoPMbIVjvjHxn2sYKfqdSOmL85UeCs72eLyqCFnRCnELzRl2uI3pdDkA1gaGSRGmIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193228; c=relaxed/simple;
	bh=UcL8aQ2zC3f1+LvLK9waY+kqu7erFKbxZG0kthScHtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=clmkr7Z3MfgNK4tLyNRDat7QkE5MWpKByGn3g2FYAMYgmZnOUrTP4IjmmY/QJKE38V1zTfrrfxi1q0Yxo/SuSdC6hf1HMKtrVUa44f2Q/5NiOOZTn8HAsDBI/oHRaE+iax7XXFIEM8JTlLyBIy46lLYTLCIw9RishsCtMZcCat8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJ4hCiTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJ4hCiTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001EDC4CEF7;
	Tue, 22 Jul 2025 14:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193227;
	bh=UcL8aQ2zC3f1+LvLK9waY+kqu7erFKbxZG0kthScHtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJ4hCiTExwnxSR1RB8Z1ln9p/22y8t9iEoxWZx9b30Aq18UVjjQ+YMmKFq7DdaE2+
	 E3GeArXAwydDXK8IjkCMADpxKW+oryVR1nQQeDxY4N69ZKKVVNA6CWkceWXIuhHso0
	 vI3CFujXW5KcEzp//jSvGv68ES+0LU3MvtzQ12j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	=?UTF-8?q?Fusheng=20Huang ?= <Fusheng.Huang@luxshare-ict.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.15 029/187] tracing: Add down_write(trace_event_sem) when adding trace event
Date: Tue, 22 Jul 2025 15:43:19 +0200
Message-ID: <20250722134346.845356660@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit b5e8acc14dcb314a9b61ff19dcd9fdd0d88f70df upstream.

When a module is loaded, it adds trace events defined by the module. It
may also need to modify the modules trace printk formats to replace enum
names with their values.

If two modules are loaded at the same time, the adding of the event to the
ftrace_events list can corrupt the walking of the list in the code that is
modifying the printk format strings and crash the kernel.

The addition of the event should take the trace_event_sem for write while
it adds the new event.

Also add a lockdep_assert_held() on that semaphore in
__trace_add_event_dirs() as it iterates the list.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/20250718223158.799bfc0c@batman.local.home
Reported-by: Fusheng Huang(黄富生)  <Fusheng.Huang@luxshare-ict.com>
Closes: https://lore.kernel.org/all/20250717105007.46ccd18f@batman.local.home/
Fixes: 110bf2b764eb6 ("tracing: add protection around module events unload")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3125,7 +3125,10 @@ __register_event(struct trace_event_call
 	if (ret < 0)
 		return ret;
 
+	down_write(&trace_event_sem);
 	list_add(&call->list, &ftrace_events);
+	up_write(&trace_event_sem);
+
 	if (call->flags & TRACE_EVENT_FL_DYNAMIC)
 		atomic_set(&call->refcnt, 0);
 	else
@@ -3739,6 +3742,8 @@ __trace_add_event_dirs(struct trace_arra
 	struct trace_event_call *call;
 	int ret;
 
+	lockdep_assert_held(&trace_event_sem);
+
 	list_for_each_entry(call, &ftrace_events, list) {
 		ret = __trace_add_new_event(call, tr);
 		if (ret < 0)


