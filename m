Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D756FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339FBC433C8;
	Sun, 17 Sep 2023 19:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979516;
	bh=LuXKwXSbLwWdOI8ZrzyXLYo1tMCI4+avI3yNJJfzFaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJ0MKHEHlAZMRIO/rgVKXLy1NcCBOapH5LA+eDTRJtl1FrK4k595eH7RLzkT6+Rc5
	 juR0uQBPhdH4jhzw+GuquhWLhA+Xu7hKapEtxP8tS/JIO63tn6YWSfdUTDGT7qhckF
	 n/NKeEnSgB57Ly2F/sbWV36gkBkjsmFm41pXeuxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 310/406] tracing: Zero the pipe cpumask on alloc to avoid spurious -EBUSY
Date: Sun, 17 Sep 2023 21:12:44 +0200
Message-ID: <20230917191109.489562899@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

commit 3d07fa1dd19035eb0b13ae6697efd5caa9033e74 upstream.

The pipe cpumask used to serialize opens between the main and percpu
trace pipes is not zeroed or initialized. This can result in
spurious -EBUSY returns if underlying memory is not fully zeroed.
This has been observed by immediate failure to read the main
trace_pipe file on an otherwise newly booted and idle system:

 # cat /sys/kernel/debug/tracing/trace_pipe
 cat: /sys/kernel/debug/tracing/trace_pipe: Device or resource busy

Zero the allocation of pipe_cpumask to avoid the problem.

Link: https://lore.kernel.org/linux-trace-kernel/20230831125500.986862-1-bfoster@redhat.com

Cc: stable@vger.kernel.org
Fixes: c2489bb7e6be ("tracing: Introduce pipe_cpumask to avoid race on trace_pipes")
Reviewed-by: Zheng Yejian <zhengyejian1@huawei.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8890,7 +8890,7 @@ static struct trace_array *trace_array_c
 	if (!alloc_cpumask_var(&tr->tracing_cpumask, GFP_KERNEL))
 		goto out_free_tr;
 
-	if (!alloc_cpumask_var(&tr->pipe_cpumask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&tr->pipe_cpumask, GFP_KERNEL))
 		goto out_free_tr;
 
 	tr->trace_flags = global_trace.trace_flags & ~ZEROED_TRACE_FLAGS;
@@ -9736,7 +9736,7 @@ __init static int tracer_alloc_buffers(v
 	if (trace_create_savedcmd() < 0)
 		goto out_free_temp_buffer;
 
-	if (!alloc_cpumask_var(&global_trace.pipe_cpumask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&global_trace.pipe_cpumask, GFP_KERNEL))
 		goto out_free_savedcmd;
 
 	/* TODO: make the number of buffers hot pluggable with CPUS */


