Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6162715218A;
	Tue,  2 Jul 2024 17:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941032; cv=none; b=C3HLBm9uP7SbHnpEB13Z3ujTi3Rl1JRRxXyJs2GVgC8gI9ERHX1opOGEpiBKVwaHzS/Nu0vqpA6Vb+J0nJW7ljyyiLKm49LsUpVdfw6WIsjpdQUV3m4p3UEcSNfPTLO3wP53oFmqAffsq76Jx9LfuC9uzKaQQNCcr96gNUCVnco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941032; c=relaxed/simple;
	bh=q4t8xo3AcNjHpK3bSK3UPfnUu/0mTs11BFFCos2SN5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0/fxb0Y5vUFuop1LUf8YQ7SPsXED1pySa4XWi+QO/M2Qi28oVs5TPEokwpxTRzXqM98zj4R3IgaBhDj27xsp7UodlLmqRsqXbNMTIE3kxnkJ3aVRJhh3oN10wSjzHBWZxdAbGz0GlE6irwSGdmoPEm+iS72aT3Gwnsuvu8Eehw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VB0WF8HP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VB0WF8HP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54FCC116B1;
	Tue,  2 Jul 2024 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941032;
	bh=q4t8xo3AcNjHpK3bSK3UPfnUu/0mTs11BFFCos2SN5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VB0WF8HPn10qzLpCCo1xmApyzbckQp4Ua+vkjIc+zAOebwAb73q6wB1u1KUVztzrz
	 Cl5aobR5mnDv03JsQ4NEjnbex8iFIZByb4fpoBt8uGsHS98fl6Y9yXJYiHl1g/e3tu
	 4TgQU3Q5O4O17Yt4alRILUV7rcoGOuFTrDt/CJI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 077/163] randomize_kstack: Remove non-functional per-arch entropy filtering
Date: Tue,  2 Jul 2024 19:03:11 +0200
Message-ID: <20240702170235.977529010@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 6db1208bf95b4c091897b597c415e11edeab2e2d ]

An unintended consequence of commit 9c573cd31343 ("randomize_kstack:
Improve entropy diffusion") was that the per-architecture entropy size
filtering reduced how many bits were being added to the mix, rather than
how many bits were being used during the offsetting. All architectures
fell back to the existing default of 0x3FF (10 bits), which will consume
at most 1KiB of stack space. It seems that this is working just fine,
so let's avoid the confusion and update everything to use the default.

The prior intent of the per-architecture limits were:

  arm64: capped at 0x1FF (9 bits), 5 bits effective
  powerpc: uncapped (10 bits), 6 or 7 bits effective
  riscv: uncapped (10 bits), 6 bits effective
  x86: capped at 0xFF (8 bits), 5 (x86_64) or 6 (ia32) bits effective
  s390: capped at 0xFF (8 bits), undocumented effective entropy

Current discussion has led to just dropping the original per-architecture
filters. The additional entropy appears to be safe for arm64, x86,
and s390. Quoting Arnd, "There is no point pretending that 15.75KB is
somehow safe to use while 15.00KB is not."

Co-developed-by: Yuntao Liu <liuyuntao12@huawei.com>
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Fixes: 9c573cd31343 ("randomize_kstack: Improve entropy diffusion")
Link: https://lore.kernel.org/r/20240617133721.377540-1-liuyuntao12@huawei.com
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com> # s390
Link: https://lore.kernel.org/r/20240619214711.work.953-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/syscall.c          | 16 +++++++---------
 arch/s390/include/asm/entry-common.h |  2 +-
 arch/x86/include/asm/entry-common.h  | 15 ++++++---------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 9a70d9746b661..f090e39f69bc4 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -56,17 +56,15 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 	syscall_set_return_value(current, regs, 0, ret);
 
 	/*
-	 * Ultimately, this value will get limited by KSTACK_OFFSET_MAX(),
-	 * but not enough for arm64 stack utilization comfort. To keep
-	 * reasonable stack head room, reduce the maximum offset to 9 bits.
+	 * This value will get limited by KSTACK_OFFSET_MAX(), which is 10
+	 * bits. The actual entropy will be further reduced by the compiler
+	 * when applying stack alignment constraints: the AAPCS mandates a
+	 * 16-byte aligned SP at function boundaries, which will remove the
+	 * 4 low bits from any entropy chosen here.
 	 *
-	 * The actual entropy will be further reduced by the compiler when
-	 * applying stack alignment constraints: the AAPCS mandates a
-	 * 16-byte (i.e. 4-bit) aligned SP at function boundaries.
-	 *
-	 * The resulting 5 bits of entropy is seen in SP[8:4].
+	 * The resulting 6 bits of entropy is seen in SP[9:4].
 	 */
-	choose_random_kstack_offset(get_random_u16() & 0x1FF);
+	choose_random_kstack_offset(get_random_u16());
 }
 
 static inline bool has_syscall_work(unsigned long flags)
diff --git a/arch/s390/include/asm/entry-common.h b/arch/s390/include/asm/entry-common.h
index fdd319a622b06..622cd08e5f50f 100644
--- a/arch/s390/include/asm/entry-common.h
+++ b/arch/s390/include/asm/entry-common.h
@@ -55,7 +55,7 @@ static __always_inline void arch_exit_to_user_mode(void)
 static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 						  unsigned long ti_work)
 {
-	choose_random_kstack_offset(get_tod_clock_fast() & 0xff);
+	choose_random_kstack_offset(get_tod_clock_fast());
 }
 
 #define arch_exit_to_user_mode_prepare arch_exit_to_user_mode_prepare
diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index 7e523bb3d2d31..fb2809b20b0ac 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -73,19 +73,16 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 #endif
 
 	/*
-	 * Ultimately, this value will get limited by KSTACK_OFFSET_MAX(),
-	 * but not enough for x86 stack utilization comfort. To keep
-	 * reasonable stack head room, reduce the maximum offset to 8 bits.
-	 *
-	 * The actual entropy will be further reduced by the compiler when
-	 * applying stack alignment constraints (see cc_stack_align4/8 in
+	 * This value will get limited by KSTACK_OFFSET_MAX(), which is 10
+	 * bits. The actual entropy will be further reduced by the compiler
+	 * when applying stack alignment constraints (see cc_stack_align4/8 in
 	 * arch/x86/Makefile), which will remove the 3 (x86_64) or 2 (ia32)
 	 * low bits from any entropy chosen here.
 	 *
-	 * Therefore, final stack offset entropy will be 5 (x86_64) or
-	 * 6 (ia32) bits.
+	 * Therefore, final stack offset entropy will be 7 (x86_64) or
+	 * 8 (ia32) bits.
 	 */
-	choose_random_kstack_offset(rdtsc() & 0xFF);
+	choose_random_kstack_offset(rdtsc());
 }
 #define arch_exit_to_user_mode_prepare arch_exit_to_user_mode_prepare
 
-- 
2.43.0



