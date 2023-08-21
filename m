Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B1F1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BD3C43395;
	Mon, 21 Aug 2023 20:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648500;
	bh=beFuRUs66v2wXy+j9FqyEF57gIoFuQr1pWKalieRImY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwO18vUxl2Ba3j6xlUIFaT5g8xC9ilmbaod7KL7xcSo1cG8Rydlhmuiw/cXT04JNL
	 2m0qeR+0tQ2hCp2EEnUVtAnYHcGCOrCa3y8ejjN1Y0+i5HaGB48PM2Jhd6e8C2n/W6
	 OCZb1kaxJKichNarbzsKx16LTtF7MF2XrtmXz2Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Yan <felixonmars@archlinux.org>,
	Ruizhe Pan <c141028@gmail.com>,
	Shiqi Zhang <shiqi@isrc.iscas.ac.cn>,
	Celeste Liu <CoelacanthusHex@gmail.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 198/234] riscv: entry: set a0 = -ENOSYS only when syscall != -1
Date: Mon, 21 Aug 2023 21:42:41 +0200
Message-ID: <20230821194137.578534960@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Celeste Liu <coelacanthushex@gmail.com>

[ Upstream commit 52449c17bdd1540940e21511612b58acebc49c06 ]

When we test seccomp with 6.4 kernel, we found errno has wrong value.
If we deny NETLINK_AUDIT with EAFNOSUPPORT, after f0bddf50586d, we will
get ENOSYS instead. We got same result with commit 9c2598d43510 ("riscv:
entry: Save a0 prior syscall_enter_from_user_mode()").

After analysing code, we think that regs->a0 = -ENOSYS should only be
executed when syscall != -1. In __seccomp_filter, when seccomp rejected
this syscall with specified errno, they will set a0 to return number as
syscall ABI, and then return -1. This return number is finally pass as
return number of syscall_enter_from_user_mode, and then is compared with
NR_syscalls after converted to ulong (so it will be ULONG_MAX). The
condition syscall < NR_syscalls will always be false, so regs->a0 = -ENOSYS
is always executed. It covered a0 set by seccomp, so we always get
ENOSYS when match seccomp RET_ERRNO rule.

Fixes: f0bddf50586d ("riscv: entry: Convert to generic entry")
Reported-by: Felix Yan <felixonmars@archlinux.org>
Co-developed-by: Ruizhe Pan <c141028@gmail.com>
Signed-off-by: Ruizhe Pan <c141028@gmail.com>
Co-developed-by: Shiqi Zhang <shiqi@isrc.iscas.ac.cn>
Signed-off-by: Shiqi Zhang <shiqi@isrc.iscas.ac.cn>
Signed-off-by: Celeste Liu <CoelacanthusHex@gmail.com>
Tested-by: Felix Yan <felixonmars@archlinux.org>
Tested-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20230801141607.435192-1-CoelacanthusHex@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 8c258b78c925c..bd19e885dcec1 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -268,16 +268,16 @@ asmlinkage __visible __trap_section void do_trap_break(struct pt_regs *regs)
 asmlinkage __visible __trap_section void do_trap_ecall_u(struct pt_regs *regs)
 {
 	if (user_mode(regs)) {
-		ulong syscall = regs->a7;
+		long syscall = regs->a7;
 
 		regs->epc += 4;
 		regs->orig_a0 = regs->a0;
 
 		syscall = syscall_enter_from_user_mode(regs, syscall);
 
-		if (syscall < NR_syscalls)
+		if (syscall >= 0 && syscall < NR_syscalls)
 			syscall_handler(regs, syscall);
-		else
+		else if (syscall != -1)
 			regs->a0 = -ENOSYS;
 
 		syscall_exit_to_user_mode(regs);
-- 
2.40.1



