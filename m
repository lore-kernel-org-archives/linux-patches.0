Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473F923B614;
	Tue, 22 Jul 2025 13:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192104; cv=none; b=LaN3kMhPLTUoTK9BjIChQXqJVbVLE/bliiKPZZXATk5QkUsUN6sKx7iCyCp4VTxVHR9qIYdJ1O6VcP6ftNueC+byWRik0ERCdOszm6hz1N6Z+wiIrBxqsAUXBlG++wPff7qH46e6uKL1fCrM3DIDqMNowPCVJs0401CbsNdqpKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192104; c=relaxed/simple;
	bh=RdPe16PxSXJx3+029KMe9DeVTvf5/xyZ8B2+yrACn/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KXFPc2LAiozgkrHYdpr/p0WazIY4VHZ38NyuUe+kHMpkaGhGxTkpZqtERn+yvWg/N38C0XKuERnauNTlnv6HNtjo+ozsYsPAjHjY1mibeLYlzuUBSRFU3e4b06TntVk2hnaW+sWWQX6QVVRAiFVrzd/9eSSqTpBInDu3whyDdz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFy0WcfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFy0WcfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F999C4CEEB;
	Tue, 22 Jul 2025 13:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192104;
	bh=RdPe16PxSXJx3+029KMe9DeVTvf5/xyZ8B2+yrACn/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFy0WcfB+bflEwOb8pSuIA1WBlWqaiAV6zeB9pRtCOX+IGUzW0/q+G526h69lqE8m
	 032BosTCoi7qKyQXqIAgro8XP8PwWg+V8w+kggjx8e9sik/NHjma3ZIvQghrF19AJU
	 DNT8KiLupxtpBhJudYUcDTAz4exf1o9Ev9sTJkXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	=?UTF-8?q?Fusheng=20Huang ?= <Fusheng.Huang@luxshare-ict.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 13/79] tracing: Add down_write(trace_event_sem) when adding trace event
Date: Tue, 22 Jul 2025 15:44:09 +0200
Message-ID: <20250722134328.871934252@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2714,7 +2714,10 @@ __register_event(struct trace_event_call
 	if (ret < 0)
 		return ret;
 
+	down_write(&trace_event_sem);
 	list_add(&call->list, &ftrace_events);
+	up_write(&trace_event_sem);
+
 	if (call->flags & TRACE_EVENT_FL_DYNAMIC)
 		atomic_set(&call->refcnt, 0);
 	else
@@ -3189,6 +3192,8 @@ __trace_add_event_dirs(struct trace_arra
 	struct trace_event_call *call;
 	int ret;
 
+	lockdep_assert_held(&trace_event_sem);
+
 	list_for_each_entry(call, &ftrace_events, list) {
 		ret = __trace_add_new_event(call, tr);
 		if (ret < 0)


