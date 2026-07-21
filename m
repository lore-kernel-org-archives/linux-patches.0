Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039B237DE97;
	Tue, 21 Jul 2026 18:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658012; cv=none; b=HhrmSVK8UYPmACCN5bnEv4rTqgvyMOKoZ1VMXV3RMGB1iiiQUp61Fx0SY2fiXsmzC/hlQ4pAaF0pdBd8bm4kn//M9k4WHJhZtA6BioTOm3x6qzZGPOHqqSuY0NnIWBHEqbNOqOVCPQzEKPBce6yPLEgrh4WRiTMtbRPwViMfaY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658012; c=relaxed/simple;
	bh=CyswDC8neBRnbKf/uM06kJ4YEZAlljIP9vHagu9pHGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJ6WxNAxKTXgfNarJUnikC6uO1toia3XrNFs6wVX1+ABXtgVa+voDTAydrDixETzvyN84E0hEUC0p444Sqv15O6kNxmT2T7XnkwvZxOCaelSrpg7z4ZZq1MPK4jgEHydMPppukIZy4w6VYUlB0u4ghLDyqCUJnyErhMNtYPeu0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/RgZkOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/RgZkOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693321F000E9;
	Tue, 21 Jul 2026 18:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658010;
	bh=XRVLCsajYzR7ooJvvr1dz88Gtn+2px0Qu1MEY6raOew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/RgZkOUpiwWI4Zaay90j4B/0sMf7s+FzJO8QjBXsy8njyTL8GopcD2yw0RyLTu8G
	 es2dxpByn6BI4oiwAcn7pSS6MeLvVBWjt70rI3+6ADykRrpYHh5RwxNpzGqmBO+dJt
	 0JB8rVyKZRgOt19VGommaNa6tPhwX5xF0MDGXKnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0983/1611] tracing/fprobe: Fix NULL pointer dereference in fprobe_fgraph_entry()
Date: Tue, 21 Jul 2026 17:18:19 +0200
Message-ID: <20260721152537.502969256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sechang Lim <rhkrqnwk98@gmail.com>

[ Upstream commit 367c49d6e283c17b56a31e7a8d964a079244264c ]

fprobe_fgraph_entry() sizes a shadow-stack reservation in one walk of
the per-ip fprobe list and fills it in a second walk, both under
rcu_read_lock() only. A fprobe registered on an already-live ip can
become visible between the two walks, so the fill walk processes an
exit_handler the sizing walk did not count and used runs past
reserved_words. If the sizing walk counted nothing, fgraph_data is NULL
and the first write_fprobe_header() faults:

  Oops: general protection fault, probably for non-canonical address ...
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:fprobe_fgraph_entry+0xa38/0xf10 kernel/trace/fprobe.c:167
  Call Trace:
   <TASK>
   function_graph_enter_regs+0x44c/0xa10 kernel/trace/fgraph.c:677
   ftrace_graph_func+0xc5/0x140 arch/x86/kernel/ftrace.c:671
   __kernel_text_address+0x9/0x40 kernel/extable.c:78
   arch_stack_walk+0x117/0x170 arch/x86/kernel/stacktrace.c:26
   kmem_cache_free+0x188/0x580 mm/slub.c:6378
   tcp_data_queue+0x18d/0x6550 net/ipv4/tcp_input.c:5590
   [...]
   </TASK>

The list cannot be frozen across the two walks, so skip a node that does
not fit the reservation and count it as missed.

Link: https://lore.kernel.org/all/20260619184425.3824774-1-rhkrqnwk98@gmail.com/

Fixes: 4346ba160409 ("fprobe: Rewrite fprobe on function-graph tracer")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fprobe.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index b9346f4efa6dc1..01f98f8a86e606 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -474,6 +474,16 @@ static int fprobe_fgraph_entry(struct ftrace_graph_ent *trace, struct fgraph_ops
 			continue;
 
 		data_size = fp->entry_data_size;
+		/*
+		 * The list may have grown since it was sized, so this node
+		 * may not fit. Skip it as missed rather than overrun the
+		 * reservation.
+		 */
+		if (fp->exit_handler &&
+		    used + FPROBE_HEADER_SIZE_IN_LONG + SIZE_IN_LONG(data_size) > reserved_words) {
+			fp->nmissed++;
+			continue;
+		}
 		if (data_size && fp->exit_handler)
 			data = fgraph_data + used + FPROBE_HEADER_SIZE_IN_LONG;
 		else
-- 
2.53.0



