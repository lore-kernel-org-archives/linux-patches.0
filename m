Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA621FBEA8;
	Tue, 17 Jun 2025 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177721; cv=none; b=HEskkLxeEn22xuHhofR1Z7bNLHyaUZNd7L9JgYeb43hDMkIpl0f84/ixIJYQPz/50a1SRQ1Fv55Oy3zMOHs+rxwVoOkhoKZowd2irv3yXDlU1JFeghHQyhY2AC4SvuQp45LE2INCXMRnfRxpsH/igJ8d+7dNilZXQ93ZxMVw9p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177721; c=relaxed/simple;
	bh=OnDUgxiFEQfFubsLjUcPsb+HHO53l0/cZYEfVESxaFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qr8o66qIUtxLSoq2FPGQ1L1hKfU79eYh+cvJ3ZyPd+Su8UD7Ks3dGZxw+d+clXrdOIegoyyGMCb9lFwOBEQprumJYA8vuZnWFYhfP/GWehWXrjf2QT2puGT1JtyArQeh6RRyEFvbU2kOuYV+4HuwkYUOeOZFIp3FGiTw5f4g0mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbiUJ81i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbiUJ81i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3CEC4CEE3;
	Tue, 17 Jun 2025 16:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177720;
	bh=OnDUgxiFEQfFubsLjUcPsb+HHO53l0/cZYEfVESxaFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbiUJ81i1d4oCLfdU9zoySdMKHkJeEKi9g/jSZ7xnILPq2h6HX521JsOo5AyzzAiP
	 bOieDPR+6Hnf9FKWLmPZNpcne10wpYRfGpJHk154zqaU2TqrMI7eumRrMcx3QsSOHb
	 ZjVYVBUTW6tmazOtBxSi4RdD/kiqgVRPTUbM1tYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong Li <zong.li@sifive.com>,
	Nylon Chen <nylon.chen@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 386/512] riscv: misaligned: fix sleeping function called during misaligned access handling
Date: Tue, 17 Jun 2025 17:25:52 +0200
Message-ID: <20250617152435.223676120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d14bfc23e315b..36ac96eac9c9e 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -429,7 +429,7 @@ int handle_misaligned_load(struct pt_regs *regs)
 
 	val.data_u64 = 0;
 	if (user_mode(regs)) {
-		if (copy_from_user(&val, (u8 __user *)addr, len))
+		if (copy_from_user_nofault(&val, (u8 __user *)addr, len))
 			return -1;
 	} else {
 		memcpy(&val, (u8 *)addr, len);
@@ -530,7 +530,7 @@ int handle_misaligned_store(struct pt_regs *regs)
 		return -EOPNOTSUPP;
 
 	if (user_mode(regs)) {
-		if (copy_to_user((u8 __user *)addr, &val, len))
+		if (copy_to_user_nofault((u8 __user *)addr, &val, len))
 			return -1;
 	} else {
 		memcpy((u8 *)addr, &val, len);
-- 
2.39.5



