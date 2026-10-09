Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BF6BA45;
	Fri,  9 Oct 2026 14:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556603; cv=none; b=sqC5+YkNYMhxnxykNxnQs44EoIRyzUo0yLwOK8NdkESKK7B4xCdLBchPtQLz3Twpsi56FmysjdIEJEl8II9W1e6p0r46RZj28e1k2sIM4fXMqF8NSjhYxGPSFnE5wDKcj+yDS73PNtt96LgelLpe1+7Gatu3+IrsTQeHpY1h+Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556603; c=relaxed/simple;
	bh=j6OabV4CJSvFJ/gALxqRf+2x1VNSk4HyfkOX7H9yvqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/Q3vqpgcEFIhlr3DvEl0irqFdNc229QmqJAGaauRk+p88VgwsdoAVjXJe0bRq/HgbGvnDzt5XwNJoRvhrd4YHMuB1pG8iQ71TJfOpJJExcpjOEXAgq6s+aVSupLzCoFl/nmps+aq7mbKnGSM7fmCTQyKnFtcRgyPZtErmBip3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXESdLma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXESdLma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C08C1F000FF;
	Fri,  9 Oct 2026 14:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556601;
	bh=Tg3d22hs4a84XttgfX1jC+8L9DjftzCE+9GJDDs64gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXESdLmar7PmXOa9mndRBQr5ygb3Ry9b49ONxys+hXqyijd9yyO9b3CGFDT5M3KLo
	 uvXPJnCW4Z9gRag4A2BVy9XRory/96W82LpLbsXe1pgiggLVYskWfe+rd5aeRsuwti
	 u4T4mF8zaa6WEYbckzGfBdpTTa4QNzWk14A/Gue8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Menglong Dong <dongml2@chinatelecom.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 239/403] tracing: fprobe: fix suspicious rcu usage in fprobe_entry
Date: Fri,  9 Oct 2026 16:10:00 +0200
Message-ID: <20261009140957.755998211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit ceb5d8d367d6d37a220023df443d8b67c2f4d1cd ]

rcu_read_lock() is not needed in fprobe_entry, but rcu_dereference_check()
is used in rhltable_lookup(), which causes suspicious RCU usage warning:

  WARNING: suspicious RCU usage
  6.17.0-rc1-00001-gdfe0d675df82 #1 Tainted: G S
  -----------------------------
  include/linux/rhashtable.h:602 suspicious rcu_dereference_check() usage!
  ......
  stack backtrace:
  CPU: 1 UID: 0 PID: 4652 Comm: ftracetest Tainted: G S
  Tainted: [S]=CPU_OUT_OF_SPEC, [I]=FIRMWARE_WORKAROUND
  Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.1.1 10/07/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x7c/0x90
   lockdep_rcu_suspicious+0x14f/0x1c0
   __rhashtable_lookup+0x1e0/0x260
   ? __pfx_kernel_clone+0x10/0x10
   fprobe_entry+0x9a/0x450
   ? __lock_acquire+0x6b0/0xca0
   ? find_held_lock+0x2b/0x80
   ? __pfx_fprobe_entry+0x10/0x10
   ? __pfx_kernel_clone+0x10/0x10
   ? lock_acquire+0x14c/0x2d0
   ? __might_fault+0x74/0xc0
   function_graph_enter_regs+0x2a0/0x550
   ? __do_sys_clone+0xb5/0x100
   ? __pfx_function_graph_enter_regs+0x10/0x10
   ? _copy_to_user+0x58/0x70
   ? __pfx_kernel_clone+0x10/0x10
   ? __x64_sys_rt_sigprocmask+0x114/0x180
   ? __pfx___x64_sys_rt_sigprocmask+0x10/0x10
   ? __pfx_kernel_clone+0x10/0x10
   ftrace_graph_func+0x87/0xb0

As we discussed in [1], fix this by using guard(rcu)() in fprobe_entry()
to protect the rhltable_lookup() and rhl_for_each_entry_rcu() with
rcu_read_lock and suppress this warning.

Link: https://lore.kernel.org/all/20250904062729.151931-1-dongml2@chinatelecom.cn/

Link: https://lore.kernel.org/all/20250829021436.19982-1-dongml2@chinatelecom.cn/ [1]
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202508281655.54c87330-lkp@intel.com
Fixes: dfe0d675df82 ("tracing: fprobe: use rhltable for fprobe_ip_table")
Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: e0a624919040 ("fprobe: Use guard(rcu_sched_notrace) and check rcu_is_watching()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fprobe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 1c9ae332afad1..2ba7470443551 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -428,6 +428,7 @@ static int fprobe_fgraph_entry(struct ftrace_graph_ent *trace, struct fgraph_ops
 	if (WARN_ON_ONCE(!fregs))
 		return 0;
 
+	guard(rcu)();
 	head = rhltable_lookup(&fprobe_ip_table, &func, fprobe_rht_params);
 	reserved_words = 0;
 	rhl_for_each_entry_rcu(node, pos, head, hlist) {
-- 
2.53.0



