Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27CE308F39;
	Tue, 21 Jul 2026 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654597; cv=none; b=MdBgYqZCzi+W0WXhB2Sr38c75xRFTOX2Yeg+yqXZb2wCP561JPZdkLC8E6JJnUAIfUmheub7OOVO+qTF0q8nZRLzLozvVuRYq3odsSN3HYOPk+qmyG01JhUXFZy0bVWj7L/WUwuGvVnEIjhOcwFl82w2l4ol1QpaZRDB14b+/tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654597; c=relaxed/simple;
	bh=wsy+NUfAZFvD2AQhygD1fvLVvtcWSaaI6NOx+yj+5eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhibiAeYiRldpaolYK0ooS7CL494GwTEEZi3KH/9gwLUloxhiPy+UUd9sHqe7iATxzsiZqfuiJ1n0RHjvaKC2ICRof51Qj0YtmYPdxG1n1InM0FIUDqN8U7VTfvsFL88R26Rw5W8Evh3tN4ZbhQVhccMkGB0sUiHtBwUwuQnz58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2RR1761; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2RR1761"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154E91F00A3A;
	Tue, 21 Jul 2026 17:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654596;
	bh=Ig6Ade1aPaPClPa+bOLg47xiw9Ix6WMcYRQyVXzOcQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2RR1761rfhqCwt9TGkJEPEsu+TpEjAPL4YI/YxlFbFHnVwHLSuCk/SBMH7470s/U
	 nVHS7QAXxVv33CF9tqgqsHNtPaFpwLSmMn7QEcGAhaisXxTuigrQLuiYackUB6n012
	 cMwZ5OOLwRCegHrg9Z1hLEFyuLlYFbhHqI+6mO1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH 7.1 1766/2077] openrisc: Fix jump_label smp syncing
Date: Tue, 21 Jul 2026 17:23:59 +0200
Message-ID: <20260721152634.399078869@linuxfoundation.org>
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

From: Stafford Horne <shorne@gmail.com>

commit aca063c9024522e4e5b9a9d1927433f6a01785a3 upstream.

The original commit 8c30b0018f9d ("openrisc: Add jump label support")
copies from arm64 and does not properly consider how icache invalidation
on remote cores works in OpenRISC.  On OpenRISC remote icaches need to
be invalidated otherwise static key's may remain state after updating.

Fix SMP cache syncing by:

 1. Properly invalidate remote core icaches on SMP systems by using
    icache_all_inv.  The old code uses kick_all_cpus_sync() which runs a
    no-op IPI function call on remote CPU's which does execute a lot of
    code and flushes many cache lines in the process, but does not flush
    all and it's not correct on OpenRISC.
 2. For architectures that do not have WRITETHROUGH caches be sure
    to flush the dcache after patching.

To test this I first reproduced the issue using a custom test module
[0].  The test confirmed that some icache lines maintained stale
static_key code sequences after calling static_branch_enable().  After
this patch there are no longer jump_label coherency issues.

[0] https://github.com/stffrdhrn/or1k-utils/tree/master/tests/smp_static_key_test

Cc: stable@vger.kernel.org # depends on openrisc: Add icache_all_inv
Fixes: 8c30b0018f9d ("openrisc: Add jump label support")
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/openrisc/kernel/jump_label.c |    2 +-
 arch/openrisc/kernel/patching.c   |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/openrisc/kernel/jump_label.c
+++ b/arch/openrisc/kernel/jump_label.c
@@ -47,5 +47,5 @@ bool arch_jump_label_transform_queue(str
 
 void arch_jump_label_transform_apply(void)
 {
-	kick_all_cpus_sync();
+	icache_all_inv();
 }
--- a/arch/openrisc/kernel/patching.c
+++ b/arch/openrisc/kernel/patching.c
@@ -49,6 +49,9 @@ static int __patch_insn_write(void *addr
 	waddr = patch_map(addr, FIX_TEXT_POKE0);
 
 	ret = copy_to_kernel_nofault(waddr, &insn, OPENRISC_INSN_SIZE);
+	if (!IS_ENABLED(CONFIG_DCACHE_WRITETHROUGH))
+		local_dcache_range_flush((unsigned long)waddr,
+					 (unsigned long)waddr + OPENRISC_INSN_SIZE);
 	local_icache_range_inv((unsigned long)waddr,
 			       (unsigned long)waddr + OPENRISC_INSN_SIZE);
 


