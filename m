Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B23F612D7;
	Tue, 20 Feb 2024 21:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463252; cv=none; b=hdpRN5dQO/DvUppdrsjSYz944ZQ59encYU6dHFRaDO+yYZeQclOXDb3T2r4sSKweEHSKJnFAFuNTlaG5Xn9eu9asPGYJ8AfIHlR8bqTvmkVPZSABr6Ni8lD0ghs68wB1+xXvbZnA0U0M2a+G7iDpqrMslm4iiMQ9Gs2OpGnabj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463252; c=relaxed/simple;
	bh=Vqk6HHztxIQhfeqhFB1zTNfhGfSDaAWsvFROWum+xOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJL83P+k6MZjNVlsyYBGKy6D99y/iWNqVwxs1ZJhZZfG2jSyHTjYsAVqAtej/X7rhJeE6n7TQ8qcpKGSmMs2UpNBRMXlN+OpyXy5BZ7DpQt748NMgM8t2kx/Qce7nXkx4OXuH+fkjPhsj3SU1Jo0Bi+CaOrqe+2UYjaO2MYfDVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIveMWVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIveMWVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C6DC433C7;
	Tue, 20 Feb 2024 21:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463251;
	bh=Vqk6HHztxIQhfeqhFB1zTNfhGfSDaAWsvFROWum+xOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIveMWVLvySSj3raW0RlUvDt7H6AnvZz/LC8jTgzSDOoyT+m/A8ZBVW0Uw9TaKUuy
	 Z6fZqE1WDPQguHv5OAD7fqeL3SfkSMkkXGlCx40M7K8aocXxK6vN9EsgjU+8UZ+Saa
	 lx9D/xwDYdXPnb+BSRqMBdfcwr7s3lvM59YsUc8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kalle Valo <kvalo@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 166/197] tracing: Inform kmemleak of saved_cmdlines allocation
Date: Tue, 20 Feb 2024 21:52:05 +0100
Message-ID: <20240220204846.041962443@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 2394ac4145ea91b92271e675a09af2a9ea6840b7 upstream.

The allocation of the struct saved_cmdlines_buffer structure changed from:

        s = kmalloc(sizeof(*s), GFP_KERNEL);
	s->saved_cmdlines = kmalloc_array(TASK_COMM_LEN, val, GFP_KERNEL);

to:

	orig_size = sizeof(*s) + val * TASK_COMM_LEN;
	order = get_order(orig_size);
	size = 1 << (order + PAGE_SHIFT);
	page = alloc_pages(GFP_KERNEL, order);
	if (!page)
		return NULL;

	s = page_address(page);
	memset(s, 0, sizeof(*s));

	s->saved_cmdlines = kmalloc_array(TASK_COMM_LEN, val, GFP_KERNEL);

Where that s->saved_cmdlines allocation looks to be a dangling allocation
to kmemleak. That's because kmemleak only keeps track of kmalloc()
allocations. For allocations that use page_alloc() directly, the kmemleak
needs to be explicitly informed about it.

Add kmemleak_alloc() and kmemleak_free() around the page allocation so
that it doesn't give the following false positive:

unreferenced object 0xffff8881010c8000 (size 32760):
  comm "swapper", pid 0, jiffies 4294667296
  hex dump (first 32 bytes):
    ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
    ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
  backtrace (crc ae6ec1b9):
    [<ffffffff86722405>] kmemleak_alloc+0x45/0x80
    [<ffffffff8414028d>] __kmalloc_large_node+0x10d/0x190
    [<ffffffff84146ab1>] __kmalloc+0x3b1/0x4c0
    [<ffffffff83ed7103>] allocate_cmdlines_buffer+0x113/0x230
    [<ffffffff88649c34>] tracer_alloc_buffers.isra.0+0x124/0x460
    [<ffffffff8864a174>] early_trace_init+0x14/0xa0
    [<ffffffff885dd5ae>] start_kernel+0x12e/0x3c0
    [<ffffffff885f5758>] x86_64_start_reservations+0x18/0x30
    [<ffffffff885f582b>] x86_64_start_kernel+0x7b/0x80
    [<ffffffff83a001c3>] secondary_startup_64_no_verify+0x15e/0x16b

Link: https://lore.kernel.org/linux-trace-kernel/87r0hfnr9r.fsf@kernel.org/
Link: https://lore.kernel.org/linux-trace-kernel/20240214112046.09a322d6@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 44dc5c41b5b1 ("tracing: Fix wasted memory in saved_cmdlines logic")
Reported-by: Kalle Valo <kvalo@kernel.org>
Tested-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -40,6 +40,7 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/panic_notifier.h>
+#include <linux/kmemleak.h>
 #include <linux/poll.h>
 #include <linux/nmi.h>
 #include <linux/fs.h>
@@ -2268,6 +2269,7 @@ static void free_saved_cmdlines_buffer(s
 	int order = get_order(sizeof(*s) + s->cmdline_num * TASK_COMM_LEN);
 
 	kfree(s->map_cmdline_to_pid);
+	kmemleak_free(s);
 	free_pages((unsigned long)s, order);
 }
 
@@ -2287,6 +2289,7 @@ static struct saved_cmdlines_buffer *all
 		return NULL;
 
 	s = page_address(page);
+	kmemleak_alloc(s, size, 1, GFP_KERNEL);
 	memset(s, 0, sizeof(*s));
 
 	/* Round up to actual allocation */


