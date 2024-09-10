Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2B614D431;
	Tue, 10 Sep 2024 09:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962295; cv=none; b=InbaGHys6zdPUUxAuHRvw8uMUnn6VcD+5dlA2I9a4qJbIQIKjSw9xWofqZdrPKp/plWatJC6VnEkIwCLu2qSjsTqgoW0duNSB92U7V/fLEJkxdt9HdI9skTlXBp/QiCC9MvqP2u+DV0KQvsfvBDR86LTFgvwpd8SmX3nsmaOXJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962295; c=relaxed/simple;
	bh=Md2w+TCsAq50OCX6rgswNru9B7jCF739nLDq/AKUGTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEqCl427LT2qMw+4as/mp6MLIjuUB783O8CivHbdgLbtsciQvgzAyCQGJXMPxW4Ut7XG4zLV0uWg9kThfAt2u3UZL6hfeJoyRit5zwIaUUfxKI00Zxt/swksJ271VmsayEqHn+sv+HqBMUPX7Csknu6/x8Uu3/0M7qJl3ozZKGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLjBmrVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLjBmrVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33582C4CEC3;
	Tue, 10 Sep 2024 09:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962295;
	bh=Md2w+TCsAq50OCX6rgswNru9B7jCF739nLDq/AKUGTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLjBmrVQP86Q1xDoUo/PGaDotdbe5hIP0j6sFF8IMvxVMeEGpp9y4qr+zGb6dCiPl
	 bXe+jxj/FOWCTzuCL+yUXWJ+qxDQKAJqKNpgbCJjcoSNfTUvQnaQ9u1B68k4TPpJ33
	 hq8Uqk606oUkke60VY0OQpoosvWJQZKahjzUHByQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Atish Patra <atishp@rivosinc.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 361/375] riscv: Improve sbi_ecall() code generation by reordering arguments
Date: Tue, 10 Sep 2024 11:32:38 +0200
Message-ID: <20240910092634.740804238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 16badacd8af48980c546839626d0329bab32b4c3 ]

The sbi_ecall() function arguments are not in the same order as the
ecall arguments, so we end up re-ordering the registers before the
ecall which is useless and costly.

So simply reorder the arguments in the same way as expected by ecall.
Instead of reordering directly the arguments of sbi_ecall(), use a proxy
macro since the current ordering is more natural.

Before:

Dump of assembler code for function sbi_ecall:
   0xffffffff800085e0 <+0>: add sp,sp,-32
   0xffffffff800085e2 <+2>: sd s0,24(sp)
   0xffffffff800085e4 <+4>: mv t1,a0
   0xffffffff800085e6 <+6>: add s0,sp,32
   0xffffffff800085e8 <+8>: mv t3,a1
   0xffffffff800085ea <+10>: mv a0,a2
   0xffffffff800085ec <+12>: mv a1,a3
   0xffffffff800085ee <+14>: mv a2,a4
   0xffffffff800085f0 <+16>: mv a3,a5
   0xffffffff800085f2 <+18>: mv a4,a6
   0xffffffff800085f4 <+20>: mv a5,a7
   0xffffffff800085f6 <+22>: mv a6,t3
   0xffffffff800085f8 <+24>: mv a7,t1
   0xffffffff800085fa <+26>: ecall
   0xffffffff800085fe <+30>: ld s0,24(sp)
   0xffffffff80008600 <+32>: add sp,sp,32
   0xffffffff80008602 <+34>: ret

After:

Dump of assembler code for function __sbi_ecall:
   0xffffffff8000b6b2 <+0>:	add	sp,sp,-32
   0xffffffff8000b6b4 <+2>:	sd	s0,24(sp)
   0xffffffff8000b6b6 <+4>:	add	s0,sp,32
   0xffffffff8000b6b8 <+6>:	ecall
   0xffffffff8000b6bc <+10>:	ld	s0,24(sp)
   0xffffffff8000b6be <+12>:	add	sp,sp,32
   0xffffffff8000b6c0 <+14>:	ret

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Yunhui Cui <cuiyunhui@bytedance.com>
Link: https://lore.kernel.org/r/20240322112629.68170-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 1ff95eb2bebd ("riscv: Fix RISCV_ALTERNATIVE_EARLY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/sbi.h | 10 ++++++----
 arch/riscv/kernel/sbi.c      | 10 +++++-----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 1079e214fe85..7cffd4ffecd0 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -304,10 +304,12 @@ struct sbiret {
 };
 
 void sbi_init(void);
-struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
-			unsigned long arg1, unsigned long arg2,
-			unsigned long arg3, unsigned long arg4,
-			unsigned long arg5);
+struct sbiret __sbi_ecall(unsigned long arg0, unsigned long arg1,
+			  unsigned long arg2, unsigned long arg3,
+			  unsigned long arg4, unsigned long arg5,
+			  int fid, int ext);
+#define sbi_ecall(e, f, a0, a1, a2, a3, a4, a5)	\
+		__sbi_ecall(a0, a1, a2, a3, a4, a5, f, e)
 
 #ifdef CONFIG_RISCV_SBI_V01
 void sbi_console_putchar(int ch);
diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index a1d21d8f5293..837bdab2601b 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -27,10 +27,10 @@ static int (*__sbi_rfence)(int fid, const struct cpumask *cpu_mask,
 			   unsigned long start, unsigned long size,
 			   unsigned long arg4, unsigned long arg5) __ro_after_init;
 
-struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
-			unsigned long arg1, unsigned long arg2,
-			unsigned long arg3, unsigned long arg4,
-			unsigned long arg5)
+struct sbiret __sbi_ecall(unsigned long arg0, unsigned long arg1,
+			  unsigned long arg2, unsigned long arg3,
+			  unsigned long arg4, unsigned long arg5,
+			  int fid, int ext)
 {
 	struct sbiret ret;
 
@@ -55,7 +55,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 
 	return ret;
 }
-EXPORT_SYMBOL(sbi_ecall);
+EXPORT_SYMBOL(__sbi_ecall);
 
 int sbi_err_map_linux_errno(int err)
 {
-- 
2.43.0



