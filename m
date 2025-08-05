Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BD52737E7;
	Tue,  5 Aug 2025 13:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399464; cv=none; b=ML0hGw5CtBv9JqGAajPWMbiTUkSDQJVtB+A06daVKdcJH2XXbfc2KWZ5S9qAB9QjHn6uLx8JnDdRHsf/Hwi8WQmu89brB58Tn17PeF3O76ee7LSUw2Iuu00LTRMf+cMpZNQbLrEz8C2T6TuNVjZkcKLyshK/A/yqE/J8cQek2QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399464; c=relaxed/simple;
	bh=rn1jRgxLbmbjWFaO09AabzkKJOBOILrftsTvMpbHIY0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HUva76OMd9UicupUAoBpD8TKycl7bmRphwRe/Q3YQWuphsgVE85pDlRygM6SSKUPCo3BMRgG+0IBLE+EjZOd1vPohyDn2SZjfKVuYTSN8QAvcLAC1AnJyPl+S+hbmIhow9o/mPvCnPXnOh9DPiDTQlpMZvcm9xLrmFFZSHZwnh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jDuaP5kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDuaP5kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751A5C4CEF4;
	Tue,  5 Aug 2025 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399463;
	bh=rn1jRgxLbmbjWFaO09AabzkKJOBOILrftsTvMpbHIY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDuaP5kpNo34pdUiYPwlK3YgIAKrU9KCINTaQce4E+V5piwQ8lJD43ZndQM8BFfjc
	 X+gv78SHljTHE/vQVc2SdVwiGsNrZ+OI7Inzabq8aRuTrKQ4AwSjvis9X7diwPJUzA
	 9j9vmmXZ+gCO1RCi4UXHj0XjXAkA5j2OW61xy6b6jcCWoWABznFiZDdVZhbSMUvcb4
	 9CG/tOGZZV0nYCLKR/vUrQgmly5C/EVsMJ2lmmj0AOcQIeeqjigndm6lw4lCGp21tL
	 Q0fUNs27WP2jBzPb2p4DbaDedqaUY0u1b+2ZLYgxbjLXzNR+gOs4A/Hx0iFRr9XASf
	 youpw/3acYC9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	David Gow <davidgow@google.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>,
	chenhuacai@kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] MIPS: Don't crash in stack_top() for tasks without ABI or vDSO
Date: Tue,  5 Aug 2025 09:09:10 -0400
Message-Id: <20250805130945.471732-35-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit e9f4a6b3421e936c3ee9d74710243897d74dbaa2 ]

Not all tasks have an ABI associated or vDSO mapped,
for example kthreads never do.
If such a task ever ends up calling stack_top(), it will derefence the
NULL ABI pointer and crash.

This can for example happen when using kunit:

    mips_stack_top+0x28/0xc0
    arch_pick_mmap_layout+0x190/0x220
    kunit_vm_mmap_init+0xf8/0x138
    __kunit_add_resource+0x40/0xa8
    kunit_vm_mmap+0x88/0xd8
    usercopy_test_init+0xb8/0x240
    kunit_try_run_case+0x5c/0x1a8
    kunit_generic_run_threadfn_adapter+0x28/0x50
    kthread+0x118/0x240
    ret_from_kernel_thread+0x14/0x1c

Only dereference the ABI point if it is set.

The GIC page is also included as it is specific to the vDSO.
Also move the randomization adjustment into the same conditional.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, here's my assessment:

**YES**, this commit should be backported to stable kernel trees.

## Extensive Explanation:

### 1. **Critical NULL Pointer Dereference Fix**
The commit fixes a kernel crash caused by NULL pointer dereference in
`mips_stack_top()`. The original code unconditionally dereferences
`current->thread.abi->vdso->size` at line 694, but kernel threads
(kthreads) never have an ABI structure associated with them, leading to
`current->thread.abi` being NULL.

### 2. **Real-World Impact**
The crash is triggered by legitimate kernel functionality introduced in
June 2024 (commit 51104c19d857 added kunit_vm_mmap). The stack trace
shows this happens when kunit tests run, specifically during
`kunit_vm_mmap_init()` which calls `arch_pick_mmap_layout()`, eventually
reaching `mips_stack_top()`. This affects any MIPS system running kernel
unit tests, which is increasingly common for kernel development and
CI/CD pipelines.

### 3. **Clear Bug Fix, Not a Feature**
The change is purely defensive - it adds a NULL check before
dereferencing the ABI pointer:
```c
if (current->thread.abi) {
    top -= PAGE_ALIGN(current->thread.abi->vdso->size);
    top -= PAGE_SIZE;
    top -= mips_gic_present() ? PAGE_SIZE : 0;
    /* Space to randomize the VDSO base */
    if (current->flags & PF_RANDOMIZE)
        top -= VDSO_RANDOMIZE_SIZE;
}
```

### 4. **Small and Contained Change**
The fix is minimal - only 9 lines added and 7 removed in a single
function. It doesn't change any architecture, APIs, or behavior for
normal processes that have an ABI. It only prevents crashes for kernel
threads that legitimately don't have vDSO mappings.

### 5. **Pattern of Similar Fixes**
The LoongArch architecture had an identical fix (commit 134475a9ab84)
for the same issue in October 2024. This shows it's a real problem
affecting multiple architectures when kernel threads interact with
memory mapping code that assumes userspace context.

### 6. **Low Risk of Regression**
The change is conservative - it only affects code paths where
`current->thread.abi` is NULL, which would have crashed before. For all
normal userspace tasks with valid ABI structures, the behavior remains
unchanged. The GIC page handling and randomization are correctly moved
inside the conditional since they're vDSO-specific.

### 7. **Affects Stable Kernels**
Since kunit_vm_mmap was introduced in kernel 6.10 (June 2024), any MIPS
stable kernel from 6.10 onwards that includes kunit functionality is
vulnerable to this crash. The bug has existed since mips_stack_top() was
introduced in 2018 (commit ea7e0480a4b69) but was only exposed when
kunit started using vm_mmap in kernel threads.

### 8. **Meets Stable Criteria**
According to stable kernel rules:
- ✓ Fixes a real bug (kernel crash)
- ✓ Small change (16 lines diff)
- ✓ Already in mainline (merged July 2025)
- ✓ No new features added
- ✓ Minimal risk of introducing new issues

The commit should be backported to stable kernels 6.10 and later where
kunit_vm_mmap exists and can trigger this crash on MIPS systems.

 arch/mips/kernel/process.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index b630604c577f..02aa6a04a21d 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -690,18 +690,20 @@ unsigned long mips_stack_top(void)
 	}
 
 	/* Space for the VDSO, data page & GIC user page */
-	top -= PAGE_ALIGN(current->thread.abi->vdso->size);
-	top -= PAGE_SIZE;
-	top -= mips_gic_present() ? PAGE_SIZE : 0;
+	if (current->thread.abi) {
+		top -= PAGE_ALIGN(current->thread.abi->vdso->size);
+		top -= PAGE_SIZE;
+		top -= mips_gic_present() ? PAGE_SIZE : 0;
+
+		/* Space to randomize the VDSO base */
+		if (current->flags & PF_RANDOMIZE)
+			top -= VDSO_RANDOMIZE_SIZE;
+	}
 
 	/* Space for cache colour alignment */
 	if (cpu_has_dc_aliases)
 		top -= shm_align_mask + 1;
 
-	/* Space to randomize the VDSO base */
-	if (current->flags & PF_RANDOMIZE)
-		top -= VDSO_RANDOMIZE_SIZE;
-
 	return top;
 }
 
-- 
2.39.5

