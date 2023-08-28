Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF51F11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473BDC433C8;
	Mon, 28 Aug 2023 10:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219661;
	bh=UcynV+JAypa/knD/lOg94o9P6wBRqD+Znu9yX1BhcEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aE8mkjnuBLOis1Yw9M8Lhs3S0YSCPYzsgKHVYgixcm+5ZSxylAV/B1sGIx8805HK5
	 G5RhNrE00OX8ZF/EJi3hi4zHHomBmUTf0pqZb7iHV3DTm0EGcbnIELB2pRjQJaGIG1
	 pkANyN9/eYx1UNY40lyl+cnmRGlaDZ6ZMcbgH4Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/84] tracing: Fix memleak due to race between current_tracer and trace
Date: Mon, 28 Aug 2023 12:13:43 +0200
Message-ID: <20230828101150.125622620@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit eecb91b9f98d6427d4af5fdb8f108f52572a39e7 ]

Kmemleak report a leak in graph_trace_open():

  unreferenced object 0xffff0040b95f4a00 (size 128):
    comm "cat", pid 204981, jiffies 4301155872 (age 99771.964s)
    hex dump (first 32 bytes):
      e0 05 e7 b4 ab 7d 00 00 0b 00 01 00 00 00 00 00 .....}..........
      f4 00 01 10 00 a0 ff ff 00 00 00 00 65 00 10 00 ............e...
    backtrace:
      [<000000005db27c8b>] kmem_cache_alloc_trace+0x348/0x5f0
      [<000000007df90faa>] graph_trace_open+0xb0/0x344
      [<00000000737524cd>] __tracing_open+0x450/0xb10
      [<0000000098043327>] tracing_open+0x1a0/0x2a0
      [<00000000291c3876>] do_dentry_open+0x3c0/0xdc0
      [<000000004015bcd6>] vfs_open+0x98/0xd0
      [<000000002b5f60c9>] do_open+0x520/0x8d0
      [<00000000376c7820>] path_openat+0x1c0/0x3e0
      [<00000000336a54b5>] do_filp_open+0x14c/0x324
      [<000000002802df13>] do_sys_openat2+0x2c4/0x530
      [<0000000094eea458>] __arm64_sys_openat+0x130/0x1c4
      [<00000000a71d7881>] el0_svc_common.constprop.0+0xfc/0x394
      [<00000000313647bf>] do_el0_svc+0xac/0xec
      [<000000002ef1c651>] el0_svc+0x20/0x30
      [<000000002fd4692a>] el0_sync_handler+0xb0/0xb4
      [<000000000c309c35>] el0_sync+0x160/0x180

The root cause is descripted as follows:

  __tracing_open() {  // 1. File 'trace' is being opened;
    ...
    *iter->trace = *tr->current_trace;  // 2. Tracer 'function_graph' is
                                        //    currently set;
    ...
    iter->trace->open(iter);  // 3. Call graph_trace_open() here,
                              //    and memory are allocated in it;
    ...
  }

  s_start() {  // 4. The opened file is being read;
    ...
    *iter->trace = *tr->current_trace;  // 5. If tracer is switched to
                                        //    'nop' or others, then memory
                                        //    in step 3 are leaked!!!
    ...
  }

To fix it, in s_start(), close tracer before switching then reopen the
new tracer after switching. And some tracers like 'wakeup' may not update
'iter->private' in some cases when reopen, then it should be cleared
to avoid being mistakenly closed again.

Link: https://lore.kernel.org/linux-trace-kernel/20230817125539.1646321-1-zhengyejian1@huawei.com

Fixes: d7350c3f4569 ("tracing/core: make the read callbacks reentrants")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c              | 9 ++++++++-
 kernel/trace/trace_irqsoff.c      | 3 ++-
 kernel/trace/trace_sched_wakeup.c | 2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d0c9769938ad2..597487a7f1bfb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3782,8 +3782,15 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 	 * will point to the same string as current_trace->name.
 	 */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(tr->current_trace && iter->trace->name != tr->current_trace->name))
+	if (unlikely(tr->current_trace && iter->trace->name != tr->current_trace->name)) {
+		/* Close iter->trace before switching to the new current tracer */
+		if (iter->trace->close)
+			iter->trace->close(iter);
 		*iter->trace = *tr->current_trace;
+		/* Reopen the new current tracer */
+		if (iter->trace->open)
+			iter->trace->open(iter);
+	}
 	mutex_unlock(&trace_types_lock);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index ee4571b624bcb..619a60944bb6d 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -228,7 +228,8 @@ static void irqsoff_trace_open(struct trace_iterator *iter)
 {
 	if (is_graph(iter->tr))
 		graph_trace_open(iter);
-
+	else
+		iter->private = NULL;
 }
 
 static void irqsoff_trace_close(struct trace_iterator *iter)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 97b10bb31a1f0..037e1e863b17f 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -171,6 +171,8 @@ static void wakeup_trace_open(struct trace_iterator *iter)
 {
 	if (is_graph(iter->tr))
 		graph_trace_open(iter);
+	else
+		iter->private = NULL;
 }
 
 static void wakeup_trace_close(struct trace_iterator *iter)
-- 
2.40.1



