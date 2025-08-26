Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F80F2D0626;
	Tue, 26 Aug 2025 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219341; cv=none; b=TyHU45AAy1g7J/g+VJgYRmxdGWoR0yBuEm0qQuIgwcQoAubSU3TybbUmRb826lu1PFZZ5pyEYJSpu8ZPDaTYLqiBM/AF4febyVItY2SjwE2gI3sC9EoLJCoIhqKmjo2r9EUnvw8ma6n1Ipxzj6eLqPSWHHSHHlGLVmdT37sPHjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219341; c=relaxed/simple;
	bh=nhlr0Z8DGhI8XZCb/d19XX+OZK88ZxIjX+pG5N2KQnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4dgtD5FXB2cTLdmId5DvgEVo0eqjOVddTrTqf9uTuZSwp4cnLlBdUGDu9wReeY4M/0nXFhmviqRKtqA9JUiHs1dxvyS8/vq95nXikA3ilfu1PRc4xDeTdoJ66czwtlPgjBdoTAZnvvXRCUpum15Gd8CPWNpBkmEeN+r1UGNjAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL+CRNbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL+CRNbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF9FC4CEF1;
	Tue, 26 Aug 2025 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219341;
	bh=nhlr0Z8DGhI8XZCb/d19XX+OZK88ZxIjX+pG5N2KQnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eL+CRNbDtuCc9p5NyveAiYTYAQow/cZvT+9v1XgFnaL9ZMtiCOoL4IeDlMGYpVSsr
	 /5gw8sENqGjy1jOTcU1HuzSk3PSRjrNenxaQwIAGWBlw8ln3K+cn6jflTpXw7FVXXo
	 Ogl/OUVhCjMJvrbdBPASfHanJt4LzQnB1BOYhGZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	=?UTF-8?q?Fusheng=20Huang ?= <Fusheng.Huang@luxshare-ict.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 344/403] tracing: Add down_write(trace_event_sem) when adding trace event
Date: Tue, 26 Aug 2025 13:11:10 +0200
Message-ID: <20250826110916.365860099@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit b5e8acc14dcb314a9b61ff19dcd9fdd0d88f70df ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2109,7 +2109,10 @@ __register_event(struct trace_event_call
 	if (ret < 0)
 		return ret;
 
+	down_write(&trace_event_sem);
 	list_add(&call->list, &ftrace_events);
+	up_write(&trace_event_sem);
+
 	call->mod = mod;
 
 	return 0;
@@ -2489,6 +2492,8 @@ __trace_add_event_dirs(struct trace_arra
 	struct trace_event_call *call;
 	int ret;
 
+	lockdep_assert_held(&trace_event_sem);
+
 	list_for_each_entry(call, &ftrace_events, list) {
 		ret = __trace_add_new_event(call, tr);
 		if (ret < 0)


