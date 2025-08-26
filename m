Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7719923A9A0;
	Tue, 26 Aug 2025 13:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215383; cv=none; b=Of/HIsTDE3fCQCvHjbbRJTrP0COQ0iSWlkrpyK/EvCjliZ3raATk63Ggyox+XCipq7kvYTuI2QyT4YK8lbliOlWo3EU+gwXbY/yKitiwh6mxaYpiUcw/0DsmQ9yAXTYq4PJtgW0chBsKW+JmUObWp6+cmNU8UlDgBrnkX2suQvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215383; c=relaxed/simple;
	bh=lThwC+nIOA7Zmyqt4LSywvWu0J6SLedjbi7R57f73yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t+sHf+U2yWED+68xLn5TAwc2YJn6VX8Z/QsNPfX2SQZytIU3KmV2xMCY016MGqUKVC3OUWj9Ijf4Ok5r+8fFyBpZemooMIP5hERKleVLT3MvPmwBjryNUM3JouYNGvJ9zbiZkT5EAyjEuBJAidSogbm1caC8UkWXwbAgoYgCuNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0nNrw1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0nNrw1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CF7C4CEF1;
	Tue, 26 Aug 2025 13:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215383;
	bh=lThwC+nIOA7Zmyqt4LSywvWu0J6SLedjbi7R57f73yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0nNrw1MUcYOmBP0xQS5sn4YYvaOXFPB3aEjV6NW31hWNyhCy/HIfIbCT48ENP3Hk
	 cmQIhWeparVuIUPHmomCCE7c+TUGQZLAhEmfda0WmW44zQOh8wvB+YlNM6X0aD6zUj
	 yXcb7iDBdurSIgMQgB7w9XiSwWBBIeEr8es0mFYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	=?UTF-8?q?Fusheng=20Huang ?= <Fusheng.Huang@luxshare-ict.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 013/644] tracing: Add down_write(trace_event_sem) when adding trace event
Date: Tue, 26 Aug 2025 13:01:44 +0200
Message-ID: <20250826110946.843568600@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2685,7 +2685,10 @@ __register_event(struct trace_event_call
 	if (ret < 0)
 		return ret;
 
+	down_write(&trace_event_sem);
 	list_add(&call->list, &ftrace_events);
+	up_write(&trace_event_sem);
+
 	if (call->flags & TRACE_EVENT_FL_DYNAMIC)
 		atomic_set(&call->refcnt, 0);
 	else
@@ -3156,6 +3159,8 @@ __trace_add_event_dirs(struct trace_arra
 	struct trace_event_call *call;
 	int ret;
 
+	lockdep_assert_held(&trace_event_sem);
+
 	list_for_each_entry(call, &ftrace_events, list) {
 		ret = __trace_add_new_event(call, tr);
 		if (ret < 0)


