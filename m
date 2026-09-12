Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A96A24CEEA;
	Sat, 12 Sep 2026 08:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202964; cv=none; b=X9DhWZkYMQjqfgbH33b6e9EQylOjvlB1ZH0ZP+Vy1vrVyTAOXlRwwc6wQN1Ejkzno30AoKayI4vPI77x1ccbAUOxii00satvKANkMCquQGfbtxwEBPYeIiALZ5KI5MEHlZ8sfpf+Xf+Q9J8dGKCPlhIexgAj03Y+a4wdfdHGXwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202964; c=relaxed/simple;
	bh=xKdqBJUbAbX6Wm5+QPbnKBWXL0JwK2QN3EBsBxCSXJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b79iEbLKKl4eX0eZhq1uVuAmJq8F7G2pGWxDmOs/BKzoIsJ0RTWNe3oqO+qcRCirYVlwEUm6O0dKWAn6Tk5tq6fuebPBmV5dH2HlxJyciES63XqIpAtOrXMcMoxatEaiMtFCy1KoVAPoUAgZCFUp8Lvhbiti8D5phweaPLVtT+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlWEdcFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlWEdcFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D5B1F000FF;
	Sat, 12 Sep 2026 08:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202962;
	bh=xpC8OUNSrW3VCiZKFfbGVOZJBPUD3Q/KVUtVtfFOC/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlWEdcFRIKStLjLLtcgWnRbjxI+cBGOOhFKGbuNlxbvTkRvwKBWfE/O4Y536i0n/p
	 0/tc7sp0QlQHv3ziZu9Bo3znWiD2CXKfK6Jezi+4+NX9imXH6q28VO3juE15eWO6NL
	 ZMUXyYFM8R4z23DRDu71KWzBQMUHVB0mGpp6EUkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Marco Elver <elver@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1310/1815] arm64: Disable KCSAN instrumentation in delay.o
Date: Sat, 12 Sep 2026 08:51:00 +0200
Message-ID: <20260912065719.772254833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

[ Upstream commit 5eaec4cf41a8f5ac1a0c69a607cdc5035a797f73 ]

KCSAN relies on udelay() for injecting delays. To avoid recursively
triggering a watchpoint, where KCSAN sets up watchpoint on an address
that is accessed by udelay() in the same thread, disable instrumentation
in arm64's delay implementation.

Paul found a manifestation of this as follows:

| BUG: KCSAN: data-race in __delay / set_need_resched_current
|
| read (marked) to 0xffff000005899b48 of 8 bytes by interrupt on cpu 8:
|  __delay+0xb0/0x378
|  __udelay+0x4c/0x60
|  kcsan_setup_watchpoint+0x3b4/0x820
|  __tsan_unaligned_write4+0x228/0x26c
|  set_need_resched_current+0x138/0x1a8
|  rcu_exp_handler+0x418/0x4a0
|  __flush_smp_call_function_queue+0x36c/0x4a0
|  generic_smp_call_function_single_interrupt+0x20/0x30
|  ipi_handler+0xec/0x558
|  handle_percpu_devid_irq+0x220/0x2a0
|  generic_handle_domain_irq+0x84/0xb4
|  gic_handle_irq+0x64/0x144
|  call_on_irq_stack+0x30/0x48
|  do_interrupt_handler+0x80/0xb8
|  el1_interrupt+0x3c/0x60
|  el1h_64_irq_handler+0x18/0x24
|  el1h_64_irq+0x6c/0x70
|  smp_call_function_single+0x18c/0x25c
|  sync_rcu_exp_select_node_cpus+0x534/0x8bc
|  rcu_exp_sel_wait_wake+0x358/0xef4
|  wait_rcu_exp_gp+0x30/0x44
|  kthread_worker_fn+0x1b4/0x5dc
|  kthread+0x1d8/0x204
|  ret_from_fork+0x10/0x20
|
| write to 0xffff000005899b4c of 4 bytes by interrupt on cpu 8:
|  set_need_resched_current+0x138/0x1a8
|  [...]

This matches what is already done in arch/x86/lib/Makefile.

Reported-by: "Paul E. McKenney" <paulmck@kernel.org>
Fixes: dd03762ab608 ("arm64: Enable KCSAN")
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/lib/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 448c917494f30..b33e1ca4a7815 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -1,4 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
+
+# KCSAN uses udelay for introducing watchpoint delay; avoid recursion.
+KCSAN_SANITIZE_delay.o := n
+
 lib-y		:= clear_user.o delay.o copy_from_user.o		\
 		   copy_to_user.o copy_page.o				\
 		   clear_page.o csum.o insn.o memchr.o memcpy.o		\
-- 
2.53.0



