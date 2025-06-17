Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76F02FA62B;
	Tue, 17 Jun 2025 16:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179046; cv=none; b=JTZA36qSa9wLgy+fWXoIGivK2/iHp1TdLB6wqYjQL/Cq6+ztHjbDesH9NwEQUE+hPwGhsh02K9JqwN3FLcZL7jSXtXuNkkvX79td+D276K8dWjYscMDzWruDJZZIlm4A8GfFf+nI91QfodpIU2wZuwANKq3xMUF4hbZUEP1Mamk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179046; c=relaxed/simple;
	bh=U2eOGuj3VwqTMKRrYH6En7V7hGdnSFRWZRJraWs2EZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1WQH0j/XY0D9Epzkpd/3VYagCFryV02l/kv/YZyYvOn1wtUxfw7RCnn/6LfpWmiqZOSAsDeJwRq+IqGudGyudg7GM1cyGYkZwTsSeQxt+8l3ixvxR7xlcxt80pKZa2MktyXbR9keVfBy5DszcZkV+MgxCutfDCJ5JnCXxp6ud4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXh1YYGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXh1YYGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46164C4CEE3;
	Tue, 17 Jun 2025 16:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179046;
	bh=U2eOGuj3VwqTMKRrYH6En7V7hGdnSFRWZRJraWs2EZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXh1YYGT51Ct9DzaWT4uwXUVPpTsHM8SQ2e+0kIZYoC2XX0TVNYxQuae2HBRRrmZI
	 brrYEchql59S0yJhmVUKZHK85pTEqTQd8m/87bXskSytORfhuIcCMOBfTpbKtt4Tmc
	 hqla5AERfvvLwSsdz9ygkZ3poz1QBq3yG7bRiK2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong Li <zong.li@sifive.com>,
	Nylon Chen <nylon.chen@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 631/780] riscv: misaligned: fix sleeping function called during misaligned access handling
Date: Tue, 17 Jun 2025 17:25:39 +0200
Message-ID: <20250617152517.171750439@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nylon Chen <nylon.chen@sifive.com>

[ Upstream commit 61a74ad254628ccd9e88838c3c622885dfb6c588 ]

Use copy_from_user_nofault() and copy_to_user_nofault() instead of
copy_from/to_user functions in the misaligned access trap handlers.

The following bug report was found when executing misaligned memory
accesses:

BUG: sleeping function called from invalid context at ./include/linux/uaccess.h:162
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 115, name: two
preempt_count: 0, expected: 0
CPU: 0 UID: 0 PID: 115 Comm: two Not tainted 6.14.0-rc5 #24
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
 [<ffffffff800160ea>] dump_backtrace+0x1c/0x24
 [<ffffffff80002304>] show_stack+0x28/0x34
 [<ffffffff80010fae>] dump_stack_lvl+0x4a/0x68
 [<ffffffff80010fe0>] dump_stack+0x14/0x1c
 [<ffffffff8004e44e>] __might_resched+0xfa/0x104
 [<ffffffff8004e496>] __might_sleep+0x3e/0x62
 [<ffffffff801963c4>] __might_fault+0x1c/0x24
 [<ffffffff80425352>] _copy_from_user+0x28/0xaa
 [<ffffffff8000296c>] handle_misaligned_store+0x204/0x254
 [<ffffffff809eae82>] do_trap_store_misaligned+0x24/0xee
 [<ffffffff809f4f1a>] handle_exception+0x146/0x152

Fixes: b686ecdeacf6 ("riscv: misaligned: Restrict user access to kernel memory")
Fixes: 441381506ba7 ("riscv: misaligned: remove CONFIG_RISCV_M_MODE specific code")

Signed-off-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Nylon Chen <nylon.chen@sifive.com>
Link: https://lore.kernel.org/r/20250411073850.3699180-3-nylon.chen@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps_misaligned.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 77c788660223b..56f06a27d45fb 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -455,7 +455,7 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
 
 	val.data_u64 = 0;
 	if (user_mode(regs)) {
-		if (copy_from_user(&val, (u8 __user *)addr, len))
+		if (copy_from_user_nofault(&val, (u8 __user *)addr, len))
 			return -1;
 	} else {
 		memcpy(&val, (u8 *)addr, len);
@@ -556,7 +556,7 @@ static int handle_scalar_misaligned_store(struct pt_regs *regs)
 		return -EOPNOTSUPP;
 
 	if (user_mode(regs)) {
-		if (copy_to_user((u8 __user *)addr, &val, len))
+		if (copy_to_user_nofault((u8 __user *)addr, &val, len))
 			return -1;
 	} else {
 		memcpy((u8 *)addr, &val, len);
-- 
2.39.5



