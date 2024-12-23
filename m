Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF54C188006;
	Mon, 23 Dec 2024 16:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969967; cv=none; b=MHKuuN7NceGfQp75BKu+4VY7lJkHdnygEjMHvVgqM4yP9W7ZSEGbXmyKd5tRgRWR8zS0kc+TENefTaGGm1c+930q60wzIaTeKB5Xj+/JBOuSMXIQosZzbvijE/IpO6NC32F8TPh6vu4j8RkLdRVUcpP5MAyl6EWuXPzpywqhgdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969967; c=relaxed/simple;
	bh=+SKNky6p52CItMrDoyDR0lFQVh4NAS/pFzkizuMG+7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH66ngQBCQJNpzL6cY81zItfGiDBUYQMEdXILHrCwsca5eJ4xN/x7w4JqegtHpgiXct1S7rIOPBz6GfPHX4jVkXVctYmfEaJOTxw0MqAdJBmoguByJ5JkmyowWu2dkVB/WiMP5CvzLJexxAfqDJOBLgmShTa0ekrZ7a83W/dnvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTx9NbE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTx9NbE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3211BC4CED3;
	Mon, 23 Dec 2024 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969967;
	bh=+SKNky6p52CItMrDoyDR0lFQVh4NAS/pFzkizuMG+7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTx9NbE8H7Iz0UXXlYplHWbIMo5Ssehj9MKUWMxgrzRl2fzrU1eMedFyCJ+LiCOhm
	 4T2zChS/Y9/xclhdhnJsQlA6W2FhGEvdPPrfDxNE9AxC4bR8cWdQlZm9PnTDKY50Tq
	 p5MuBvh7mlOJrCCl1jJ3Yp7/Rn2iY+W053XJOns0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 105/160] trace/ring-buffer: Do not use TP_printk() formatting for boot mapped buffers
Date: Mon, 23 Dec 2024 16:58:36 +0100
Message-ID: <20241223155412.738603698@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 8cd63406d08110c8098e1efda8aef7ddab4db348 upstream.

The TP_printk() of a TRACE_EVENT() is a generic printf format that any
developer can create for their event. It may include pointers to strings
and such. A boot mapped buffer may contain data from a previous kernel
where the strings addresses are different.

One solution is to copy the event content and update the pointers by the
recorded delta, but a simpler solution (for now) is to just use the
print_fields() function to print these events. The print_fields() function
just iterates the fields and prints them according to what type they are,
and ignores the TP_printk() format from the event itself.

To understand the difference, when printing via TP_printk() the output
looks like this:

  4582.696626: kmem_cache_alloc: call_site=getname_flags+0x47/0x1f0 ptr=00000000e70e10e0 bytes_req=4096 bytes_alloc=4096 gfp_flags=GFP_KERNEL node=-1 accounted=false
  4582.696629: kmem_cache_alloc: call_site=alloc_empty_file+0x6b/0x110 ptr=0000000095808002 bytes_req=360 bytes_alloc=384 gfp_flags=GFP_KERNEL node=-1 accounted=false
  4582.696630: kmem_cache_alloc: call_site=security_file_alloc+0x24/0x100 ptr=00000000576339c3 bytes_req=16 bytes_alloc=16 gfp_flags=GFP_KERNEL|__GFP_ZERO node=-1 accounted=false
  4582.696653: kmem_cache_free: call_site=do_sys_openat2+0xa7/0xd0 ptr=00000000e70e10e0 name=names_cache

But when printing via print_fields() (echo 1 > /sys/kernel/tracing/options/fields)
the same event output looks like this:

  4582.696626: kmem_cache_alloc: call_site=0xffffffff92d10d97 (-1831793257) ptr=0xffff9e0e8571e000 (-107689771147264) bytes_req=0x1000 (4096) bytes_alloc=0x1000 (4096) gfp_flags=0xcc0 (3264) node=0xffffffff (-1) accounted=(0)
  4582.696629: kmem_cache_alloc: call_site=0xffffffff92d0250b (-1831852789) ptr=0xffff9e0e8577f800 (-107689770747904) bytes_req=0x168 (360) bytes_alloc=0x180 (384) gfp_flags=0xcc0 (3264) node=0xffffffff (-1) accounted=(0)
  4582.696630: kmem_cache_alloc: call_site=0xffffffff92efca74 (-1829778828) ptr=0xffff9e0e8d35d3b0 (-107689640864848) bytes_req=0x10 (16) bytes_alloc=0x10 (16) gfp_flags=0xdc0 (3520) node=0xffffffff (-1) accounted=(0)
  4582.696653: kmem_cache_free: call_site=0xffffffff92cfbea7 (-1831879001) ptr=0xffff9e0e8571e000 (-107689771147264) name=names_cache

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/20241218141507.28389a1d@gandalf.local.home
Fixes: 07714b4bb3f98 ("tracing: Handle old buffer mappings for event strings and functions")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4377,6 +4377,15 @@ static enum print_line_t print_trace_fmt
 	if (event) {
 		if (tr->trace_flags & TRACE_ITER_FIELDS)
 			return print_event_fields(iter, event);
+		/*
+		 * For TRACE_EVENT() events, the print_fmt is not
+		 * safe to use if the array has delta offsets
+		 * Force printing via the fields.
+		 */
+		if ((tr->text_delta || tr->data_delta) &&
+		    event->type > __TRACE_LAST_TYPE)
+			return print_event_fields(iter, event);
+
 		return event->funcs->trace(iter, sym_flags, event);
 	}
 


