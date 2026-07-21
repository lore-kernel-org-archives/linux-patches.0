Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5833DC4C2;
	Tue, 21 Jul 2026 17:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653502; cv=none; b=SH6GPsmnmt9v+hJ+dLUc6z3txEA4FUPHoudj/ru6OToOju0u4k5P150jdqyA19hxh82/eapWgCRLsxfZy2e0OTKewRBpnyooYwA8RZ/x4ASLyAthwMOI1mHTtpP3zisV4PR7uguy24dbJX3zqbxTM8XbLcTur0X2ih5EekRCm7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653502; c=relaxed/simple;
	bh=GJbglGfHeZQI6WbhxLFslQ6mIt6mkL2faKVIyxwhbcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmy7QpXKp1mpZKx89YrjHbdyPk5ghrf1EMyc1qUhO3bPNN6DiQXtgpFVG0xkvWTUjpOJYoQGyqEYWc9USjje/KQO/Kuj5EaPai33TNP9y2sdPPrZjX4fdVVFuMiqeTl61BM56XFGWtrqNRMsp/LLh6laTTL/5YK+QrS73OyKKEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5E2GOql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5E2GOql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D0F1F000E9;
	Tue, 21 Jul 2026 17:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653501;
	bh=HoE8ZETaimDyh9/yeS8SeoGKHRZk2VIe+ga9MnIDiOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5E2GOqlx+9wIZCFJwrJRUT9hxLZIUUs8HCPjn4eIS84vdicRDZqlAegFwpliBM4K
	 ttZN9Jm40Tf/x/2wWGFaEYV8lCKRIUIU5iK3E7sVoejMjjp41ADRBUuMDtbNbF7RVo
	 7ohD1YCK7p3QuKxrUyZugMatGGSp9JvlPmEKhdJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1352/2077] tracing/fprobe: Fix NULL pointer dereference in fprobe_fgraph_entry()
Date: Tue, 21 Jul 2026 17:17:05 +0200
Message-ID: <20260721152624.707467389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f378613ad1209c..f215990b90613d 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -613,6 +613,16 @@ static int fprobe_fgraph_entry(struct ftrace_graph_ent *trace, struct fgraph_ops
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



