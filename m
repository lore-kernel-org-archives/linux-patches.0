Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C117920F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDD5C433C8;
	Fri, 21 Jul 2023 19:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967529;
	bh=5i9kiCk8TDfUKL36m3HOkdT/dr+K+/NrZSQ7g9ejV7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqODkb9XSd6Zcprjo+TLDChUQeZ754ejOgIeMHrsDT52W6FF503CCKyd/COGFP5jV
	 V13p41LDkhPueovxuDvTjP5+/UGR7SuboHYj0FdPNExMpxNxWufsPUhToLFcqcHcap
	 8ZtDQ7t7DxjvP+OEpgLKGOtpiTCzTQ3tVP0BSk7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 194/223] fprobe: Ensure running fprobe_exit_handler() finished before calling rethook_free()
Date: Fri, 21 Jul 2023 18:07:27 +0200
Message-ID: <20230721160529.154964344@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 195b9cb5b288fec1c871ef89f78cc9a7461aad3a upstream.

Ensure running fprobe_exit_handler() has finished before
calling rethook_free() in the unregister_fprobe() so that caller can free
the fprobe right after unregister_fprobe().

unregister_fprobe() ensured that all running fprobe_entry/exit_handler()
have finished by calling unregister_ftrace_function() which synchronizes
RCU. But commit 5f81018753df ("fprobe: Release rethook after the ftrace_ops
is unregistered") changed to call rethook_free() after
unregister_ftrace_function(). So call rethook_stop() to make rethook
disabled before unregister_ftrace_function() and ensure it again.

Here is the possible code flow that can call the exit handler after
unregister_fprobe().

------
 CPU1                              CPU2
 call unregister_fprobe(fp)
 ...
                                   __fprobe_handler()
                                   rethook_hook() on probed function
 unregister_ftrace_function()
                                   return from probed function
                                   rethook hooks
                                   find rh->handler == fprobe_exit_handler
                                   call fprobe_exit_handler()
 rethook_free():
   set rh->handler = NULL;
 return from unreigster_fprobe;
                                   call fp->exit_handler() <- (*)
------

(*) At this point, the exit handler is called after returning from
unregister_fprobe().

This fixes it as following;
------
 CPU1                              CPU2
 call unregister_fprobe()
 ...
 rethook_stop():
   set rh->handler = NULL;
                                   __fprobe_handler()
                                   rethook_hook() on probed function
 unregister_ftrace_function()
                                   return from probed function
                                   rethook hooks
                                   find rh->handler == NULL
                                   return from rethook
 rethook_free()
 return from unreigster_fprobe;
------

Link: https://lore.kernel.org/all/168873859949.156157.13039240432299335849.stgit@devnote2/

Fixes: 5f81018753df ("fprobe: Release rethook after the ftrace_ops is unregistered")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rethook.h |    1 +
 kernel/trace/fprobe.c   |    3 +++
 kernel/trace/rethook.c  |   13 +++++++++++++
 3 files changed, 17 insertions(+)

--- a/include/linux/rethook.h
+++ b/include/linux/rethook.h
@@ -59,6 +59,7 @@ struct rethook_node {
 };
 
 struct rethook *rethook_alloc(void *data, rethook_handler_t handler);
+void rethook_stop(struct rethook *rh);
 void rethook_free(struct rethook *rh);
 void rethook_add_node(struct rethook *rh, struct rethook_node *node);
 struct rethook_node *rethook_try_get(struct rethook *rh);
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -307,6 +307,9 @@ int unregister_fprobe(struct fprobe *fp)
 		    fp->ops.saved_func != fprobe_kprobe_handler))
 		return -EINVAL;
 
+	if (fp->rethook)
+		rethook_stop(fp->rethook);
+
 	ret = unregister_ftrace_function(&fp->ops);
 	if (ret < 0)
 		return ret;
--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -54,6 +54,19 @@ static void rethook_free_rcu(struct rcu_
 }
 
 /**
+ * rethook_stop() - Stop using a rethook.
+ * @rh: the struct rethook to stop.
+ *
+ * Stop using a rethook to prepare for freeing it. If you want to wait for
+ * all running rethook handler before calling rethook_free(), you need to
+ * call this first and wait RCU, and call rethook_free().
+ */
+void rethook_stop(struct rethook *rh)
+{
+	WRITE_ONCE(rh->handler, NULL);
+}
+
+/**
  * rethook_free() - Free struct rethook.
  * @rh: the struct rethook to be freed.
  *


