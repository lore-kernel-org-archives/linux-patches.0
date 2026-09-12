Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECBF429CC6;
	Sat, 12 Sep 2026 12:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217890; cv=none; b=uwfYoMhEaGY/LxT6vO7yxKxuVvQNQJDyBw8mY+1nHJbW/S/ZiKkksaJmzEDttubwgaJeftidoLg0Sw4bjqLPgXEreXv2PVSV8y5ti+fh+NKyVrJVp4SaPOIaoFwloWoY6GdQaLgKc/U/G7jXDQTyzVr7XullrL8MK2xwv0geJCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217890; c=relaxed/simple;
	bh=/Uj0eWYbtCZthtTLpnChIlIR9oDlNNfft4tMNtJuzc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3EdrmpDon/qXEYNDDH/uEvJVf0P5ldm8dF3gFLdKCSgKyktjorrIXM9wD8xRQDRnwPc74K55eitDKO7lw9zLDJmeNy7HPaoKn4NFf6vE+IQJrPgaCfyZPqDWMwQDCoasSX5Ir8VzxslePcEUEHr2v6UWs9IMjpSNfBFFvUHZH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tp+eaAyL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tp+eaAyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B131F000FF;
	Sat, 12 Sep 2026 12:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217888;
	bh=Qp9OTNocAFksyq6zoOufJB9KOWSGxLKMLk+ZBq7OLpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tp+eaAyLGX4+BKdi+GodAV4enB2guSgfPAFd7oqn1l9Ku1M8UNFAn9Bji0BayJD5o
	 vswBsQYE9oufzpsTmNnZp8N3DA1SYb/g4lJpb9Lcn79vJbePKLuMgnyWXMqBSQn3GE
	 DCxxQAwoF7Ul0eSNqHu8Ckeh5Kxd3Ay3/8WjAtw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Marco Elver <elver@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1033/1376] arm64: Disable KCSAN instrumentation in delay.o
Date: Sat, 12 Sep 2026 08:57:39 +0200
Message-ID: <20260912065630.583054196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 13e6a2829116c..68d91c2021f19 100644
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



