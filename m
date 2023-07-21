Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE9927F1D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48C6C433C7;
	Fri, 21 Jul 2023 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965440;
	bh=bAhStFhzlqoxQsyZRbak5m/yVq038vBGexsGtZpeKG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7lvAylHsXe6SymkNPlMUXE5s7KvZZb663P8Xt9Ugsd/Jg4mGSQks8/kMeDr5A4Bb
	 2NkS7pDHN9KZTEHE/RicKxV4mDWQ8O8QgyBXkScLkdtF/9b72utScRSl7/VxL9halL
	 05nA1FtKjv/xHrzaz1oJpy+HKSzIR/USwkCYfRVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.4 256/292] fprobe: Release rethook after the ftrace_ops is unregistered
Date: Fri, 21 Jul 2023 18:06:05 +0200
Message-ID: <20230721160539.939199525@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

commit 5f81018753dfd4989e33ece1f0cb6b8aae498b82 upstream.

While running bpf selftests it's possible to get following fault:

  general protection fault, probably for non-canonical address \
  0x6b6b6b6b6b6b6b6b: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
  ...
  Call Trace:
   <TASK>
   fprobe_handler+0xc1/0x270
   ? __pfx_bpf_testmod_init+0x10/0x10
   ? __pfx_bpf_testmod_init+0x10/0x10
   ? bpf_fentry_test1+0x5/0x10
   ? bpf_fentry_test1+0x5/0x10
   ? bpf_testmod_init+0x22/0x80
   ? do_one_initcall+0x63/0x2e0
   ? rcu_is_watching+0xd/0x40
   ? kmalloc_trace+0xaf/0xc0
   ? do_init_module+0x60/0x250
   ? __do_sys_finit_module+0xac/0x120
   ? do_syscall_64+0x37/0x90
   ? entry_SYSCALL_64_after_hwframe+0x72/0xdc
   </TASK>

In unregister_fprobe function we can't release fp->rethook while it's
possible there are some of its users still running on another cpu.

Moving rethook_free call after fp->ops is unregistered with
unregister_ftrace_function call.

Link: https://lore.kernel.org/all/20230615115236.3476617-1-jolsa@kernel.org/

Fixes: 5b0ab78998e3 ("fprobe: Add exit_handler support")
Cc: stable@vger.kernel.org
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -366,19 +366,13 @@ int unregister_fprobe(struct fprobe *fp)
 		    fp->ops.saved_func != fprobe_kprobe_handler))
 		return -EINVAL;
 
-	/*
-	 * rethook_free() starts disabling the rethook, but the rethook handlers
-	 * may be running on other processors at this point. To make sure that all
-	 * current running handlers are finished, call unregister_ftrace_function()
-	 * after this.
-	 */
-	if (fp->rethook)
-		rethook_free(fp->rethook);
-
 	ret = unregister_ftrace_function(&fp->ops);
 	if (ret < 0)
 		return ret;
 
+	if (fp->rethook)
+		rethook_free(fp->rethook);
+
 	ftrace_free_filter(&fp->ops);
 
 	return ret;


