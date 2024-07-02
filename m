Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ECA15B0FE;
	Tue,  2 Jul 2024 17:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940295; cv=none; b=uiz1oVChVyhi4L4x3aNDegas+6kbyz0XVpQqXfFpjluHzCVvfboSb6NgaT+UnONQNXk8EpvnpU4tSyuDB0qO8RFgl0KPKbLAETZDQI3exg92vyKY7HCP6JLXmq+01/ytxC/K8zC8NXNpNWDXA78c1lQcKwwHUCe9CEI6FIRPYpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940295; c=relaxed/simple;
	bh=gPjjCG2ewUVdGY8Af3g2LGvwkigmjmukJpy4b+pu9T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ci4KpTrtOgnJcmD+8Rp3vSorjSBjo5NuSAWidX7ZIPGcW0I4ArGqMCLFIYy2Cdj3eqDi52eTSW6irBqllcs/7H2QCK5d1F8AQ+qQngZhVItbRPQGjnEDGBW9oPzWM8TkIkRSwveWM+a7ijZoMg+46S54lPfSGSF/4BQqr0E/Sto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LH7qNExm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LH7qNExm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E76C116B1;
	Tue,  2 Jul 2024 17:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940295;
	bh=gPjjCG2ewUVdGY8Af3g2LGvwkigmjmukJpy4b+pu9T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LH7qNExmTC/KrK0WkbutVQnLP9vMJ5F8MGbnWzNdpcM3N/zXxUVdhMHF6tFIESKxa
	 lttGF5AwSuzOcfUprwZ2ogzcMHNHk7okZZ4WSxDvZ4qFiim2+JtpA+iB7LssYba6a2
	 0PlKcNU8GCnvlGO1/y93hmEunbLw+uQe7goPx6ZU=
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
Subject: [PATCH 6.9 110/222] randomize_kstack: Remove non-functional per-arch entropy filtering
Date: Tue,  2 Jul 2024 19:02:28 +0200
Message-ID: <20240702170248.170282159@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index ad198262b9817..7230f6e20ab8b 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -53,17 +53,15 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
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
index 7f5004065e8aa..35555c9446308 100644
--- a/arch/s390/include/asm/entry-common.h
+++ b/arch/s390/include/asm/entry-common.h
@@ -54,7 +54,7 @@ static __always_inline void arch_exit_to_user_mode(void)
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



