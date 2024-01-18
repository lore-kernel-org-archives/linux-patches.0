Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E1B22F16;
	Thu, 18 Jan 2024 11:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575674; cv=none; b=IUKBy7EvPtym67KyNfe7gHSAJcleb/pOAijC/dpCIr1cYB49E88BKVHLa1aJ7pYS0+Mz7+caieH5xs7wLtjsB4QUaHCOy23VNpTfBJ9Yw+ZFvNHACEXl0Mtz3cyem1z9OoYgwO/XASk7XtFYysl6WXUwC7UzgcLYwH2U46faEGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575674; c=relaxed/simple;
	bh=TROUpB22GyDfGFBAC/QtFfG+4S+mIIIFxO/7nYY/WaI=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=TAA9UVf7OqIvJJav2mPnn0SQJvzdJloJEFj6ALAPj5mW8OO+Y/Znq9CdnLjboSwpNx2/PmDBXEysDptf29yMKY+Xgqgq/McefbU8FLNosEBUbRXP9EsWrR/1u0LUAaBuHXZBNyoWwRLLvqB0aSLz2I08URJGFdXGNgpsKquLa6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twT2x21z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twT2x21z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED88C43390;
	Thu, 18 Jan 2024 11:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575673;
	bh=TROUpB22GyDfGFBAC/QtFfG+4S+mIIIFxO/7nYY/WaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twT2x21zRBcqr1JKtGqQV8UuXYyXZuZMqSxZpvzNeGE3hdXZGb6LihBnnbEHlXmsg
	 NkyipHpueSn7es6hQwG7+oC+Nio+MyLy9IHXwHwBgKtig0guDebLl5tUKjoIq3Qdm6
	 yM0k/eLmaUuYcdDfGvc7oM3wWhKoLlMBOxSavFlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/100] mips/smp: Call rcutree_report_cpu_starting() earlier
Date: Thu, 18 Jan 2024 11:48:44 +0100
Message-ID: <20240118104312.487232798@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

From: Stefan Wiehler <stefan.wiehler@nokia.com>

[ Upstream commit 55702ec9603ebeffb15e6f7b113623fe1d8872f4 ]

rcutree_report_cpu_starting() must be called before
clockevents_register_device() to avoid the following lockdep splat triggered by
calling list_add() when CONFIG_PROVE_RCU_LIST=y:

  WARNING: suspicious RCU usage
  ...
  -----------------------------
  kernel/locking/lockdep.c:3680 RCU-list traversed in non-reader section!!

  other info that might help us debug this:

  RCU used illegally from offline CPU!
  rcu_scheduler_active = 1, debug_locks = 1
  no locks held by swapper/1/0.
  ...
  Call Trace:
  [<ffffffff8012a434>] show_stack+0x64/0x158
  [<ffffffff80a93d98>] dump_stack_lvl+0x90/0xc4
  [<ffffffff801c9e9c>] __lock_acquire+0x1404/0x2940
  [<ffffffff801cbf3c>] lock_acquire+0x14c/0x448
  [<ffffffff80aa4260>] _raw_spin_lock_irqsave+0x50/0x88
  [<ffffffff8021e0c8>] clockevents_register_device+0x60/0x1e8
  [<ffffffff80130ff0>] r4k_clockevent_init+0x220/0x3a0
  [<ffffffff801339d0>] start_secondary+0x50/0x3b8

raw_smp_processor_id() is required in order to avoid calling into lockdep
before RCU has declared the CPU to be watched for readers.

See also commit 29368e093921 ("x86/smpboot:  Move rcu_cpu_starting() earlier"),
commit de5d9dae150c ("s390/smp: move rcu_cpu_starting() earlier") and commit
99f070b62322 ("powerpc/smp: Call rcu_cpu_starting() earlier").

Signed-off-by: Stefan Wiehler <stefan.wiehler@nokia.com>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 1d93b85271ba..b951ce3a53ab 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -333,10 +333,11 @@ early_initcall(mips_smp_ipi_init);
  */
 asmlinkage void start_secondary(void)
 {
-	unsigned int cpu;
+	unsigned int cpu = raw_smp_processor_id();
 
 	cpu_probe();
 	per_cpu_trap_init(false);
+	rcutree_report_cpu_starting(cpu);
 	mips_clockevent_init();
 	mp_ops->init_secondary();
 	cpu_report();
@@ -348,7 +349,6 @@ asmlinkage void start_secondary(void)
 	 */
 
 	calibrate_delay();
-	cpu = smp_processor_id();
 	cpu_data[cpu].udelay_val = loops_per_jiffy;
 
 	set_cpu_sibling_map(cpu);
-- 
2.43.0



