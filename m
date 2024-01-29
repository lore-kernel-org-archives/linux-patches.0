Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA4972243;
	Mon, 29 Jan 2024 17:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548513; cv=none; b=gOK1iYpCVPyyQ+7pq24jMmkfYO8ZXUoCo38FaQzpCRzBFHxXZrOW0A6KLO0b1ZBgec8+M4kE1sdxs/dTDGV2ZSgqSf4MBSQ0/U0Sre0o8baA/FvPyvJjwIyW/lkXCbb3ru82h+rlrEaIt4FgsCNNlAIGrsX3t/9wzlkv8rdHEa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548513; c=relaxed/simple;
	bh=y0SGJFk0EGVHfX3UKdqJEuv4gPMl6h0y/MMwF2oRvZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7SToECjtH8ptOWz5/vhEvhhVGDp16hM+TVDayWmbZrNGrD1BZivdlWPhK35bimVTS7WmCiKm+BJlxqYW6WRt5SsPCsF+YjMa/eLb1rmQ2ay9/eL9wHgwRqIoE1+y0YXECNLiW+WL6GMl0Xz/tPCQ99Z1ElCY+IcagUtUP0V4/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4l6k16D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4l6k16D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78BCC433F1;
	Mon, 29 Jan 2024 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548513;
	bh=y0SGJFk0EGVHfX3UKdqJEuv4gPMl6h0y/MMwF2oRvZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4l6k16D7YVM5qXv2B5rz1+o/egtYR/lwo9SCb6HAhgb798HijwSp3FKnQIVfNLyU
	 d9fMskQSA4QBIaRYYufgEvDBunrS1yqBwY5iF3OWilgrNpqpiKmdJqGBHV1wPyh7g/
	 rMIYZYlr9pwAJgmzmzPZBkGFzhPKsi2jm+kj+7PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 137/331] LoongArch/smp: Call rcutree_report_cpu_starting() earlier
Date: Mon, 29 Jan 2024 09:03:21 -0800
Message-ID: <20240129170018.955982269@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit a2ccf46333d7b2cf9658f0d82ac74097c1542fae upstream.

rcutree_report_cpu_starting() must be called before cpu_probe() to avoid
the following lockdep splat that triggered by calling __alloc_pages() when
CONFIG_PROVE_RCU_LIST=y:

 =============================
 WARNING: suspicious RCU usage
 6.6.0+ #980 Not tainted
 -----------------------------
 kernel/locking/lockdep.c:3761 RCU-list traversed in non-reader section!!
 other info that might help us debug this:
 RCU used illegally from offline CPU!
 rcu_scheduler_active = 1, debug_locks = 1
 1 lock held by swapper/1/0:
  #0: 900000000c82ef98 (&pcp->lock){+.+.}-{2:2}, at: get_page_from_freelist+0x894/0x1790
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.6.0+ #980
 Stack : 0000000000000001 9000000004f79508 9000000004893670 9000000100310000
         90000001003137d0 0000000000000000 90000001003137d8 9000000004f79508
         0000000000000000 0000000000000001 0000000000000000 90000000048a3384
         203a656d616e2065 ca43677b3687e616 90000001002c3480 0000000000000008
         000000000000009d 0000000000000000 0000000000000001 80000000ffffe0b8
         000000000000000d 0000000000000033 0000000007ec0000 13bbf50562dad831
         9000000005140748 0000000000000000 9000000004f79508 0000000000000004
         0000000000000000 9000000005140748 90000001002bad40 0000000000000000
         90000001002ba400 0000000000000000 9000000003573ec8 0000000000000000
         00000000000000b0 0000000000000004 0000000000000000 0000000000070000
         ...
 Call Trace:
 [<9000000003573ec8>] show_stack+0x38/0x150
 [<9000000004893670>] dump_stack_lvl+0x74/0xa8
 [<900000000360d2bc>] lockdep_rcu_suspicious+0x14c/0x190
 [<900000000361235c>] __lock_acquire+0xd0c/0x2740
 [<90000000036146f4>] lock_acquire+0x104/0x2c0
 [<90000000048a955c>] _raw_spin_lock_irqsave+0x5c/0x90
 [<900000000381cd5c>] rmqueue_bulk+0x6c/0x950
 [<900000000381fc0c>] get_page_from_freelist+0xd4c/0x1790
 [<9000000003821c6c>] __alloc_pages+0x1bc/0x3e0
 [<9000000003583b40>] tlb_init+0x150/0x2a0
 [<90000000035742a0>] per_cpu_trap_init+0xf0/0x110
 [<90000000035712fc>] cpu_probe+0x3dc/0x7a0
 [<900000000357ed20>] start_secondary+0x40/0xb0
 [<9000000004897138>] smpboot_entry+0x54/0x58

raw_smp_processor_id() is required in order to avoid calling into lockdep
before RCU has declared the CPU to be watched for readers.

See also commit 29368e093921 ("x86/smpboot: Move rcu_cpu_starting() earlier"),
commit de5d9dae150c ("s390/smp: move rcu_cpu_starting() earlier") and commit
99f070b62322 ("powerpc/smp: Call rcu_cpu_starting() earlier").

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/smp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -504,8 +504,9 @@ asmlinkage void start_secondary(void)
 	unsigned int cpu;
 
 	sync_counter();
-	cpu = smp_processor_id();
+	cpu = raw_smp_processor_id();
 	set_my_cpu_offset(per_cpu_offset(cpu));
+	rcu_cpu_starting(cpu);
 
 	cpu_probe();
 	constant_clockevent_init();


