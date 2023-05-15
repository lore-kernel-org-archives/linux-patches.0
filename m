Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97945FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB87C433EF;
	Mon, 15 May 2023 16:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169485;
	bh=WXHX+duXFT1bKg3lep9sRXBUbNqewxIpuZCG/cKch40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVpbufu1g5o6I+WPRdyoXXqY72demmGCeiAG2E9BhC1MDM6U1uwqw1DP3s+jMKBUC
	 k5RGrGwtH/gWNDPs1hf2jbN71e5m4Z/RSGx+4k1jK307fpRFg7iJ8/Sz7t5sFVmOUH
	 XpN828SINuXAi1oUZFCN73irbWJDll9RiYP+C3Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 055/246] arm64: kernel: remove SHF_WRITE|SHF_EXECINSTR from .idmap.text
Date: Mon, 15 May 2023 18:24:27 +0200
Message-Id: <20230515161724.230453483@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ndesaulniers@google.com <ndesaulniers@google.com>

[ Upstream commit 4df69e0df295822cdf816442fe4897f214cccb08 ]

commit d54170812ef1 ("arm64: fix .idmap.text assertion for large kernels")
modified some of the section assembler directives that declare
.idmap.text to be SHF_ALLOC instead of
SHF_ALLOC|SHF_WRITE|SHF_EXECINSTR.

This patch fixes up the remaining stragglers that were left behind.  Add
Fixes tag so that this doesn't precede related change in stable.

Fixes: d54170812ef1 ("arm64: fix .idmap.text assertion for large kernels")
Reported-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20230428-awx-v2-1-b197ffa16edc@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpu-reset.S | 2 +-
 arch/arm64/kernel/sleep.S     | 2 +-
 arch/arm64/mm/proc.S          | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/cpu-reset.S b/arch/arm64/kernel/cpu-reset.S
index 6b752fe897451..c87445dde6745 100644
--- a/arch/arm64/kernel/cpu-reset.S
+++ b/arch/arm64/kernel/cpu-reset.S
@@ -14,7 +14,7 @@
 #include <asm/virt.h>
 
 .text
-.pushsection    .idmap.text, "awx"
+.pushsection    .idmap.text, "a"
 
 /*
  * cpu_soft_restart(el2_switch, entry, arg0, arg1, arg2)
diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
index 2ae7cff1953aa..2aa5129d82537 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -97,7 +97,7 @@ SYM_FUNC_START(__cpu_suspend_enter)
 	ret
 SYM_FUNC_END(__cpu_suspend_enter)
 
-	.pushsection ".idmap.text", "awx"
+	.pushsection ".idmap.text", "a"
 SYM_CODE_START(cpu_resume)
 	mov	x0, xzr
 	bl	init_kernel_el
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 91410f4880900..c2cb437821ca4 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -167,7 +167,7 @@ alternative_else_nop_endif
 SYM_FUNC_END(cpu_do_resume)
 #endif
 
-	.pushsection ".idmap.text", "awx"
+	.pushsection ".idmap.text", "a"
 
 .macro	__idmap_cpu_set_reserved_ttbr1, tmp1, tmp2
 	adrp	\tmp1, reserved_pg_dir
@@ -201,7 +201,7 @@ SYM_FUNC_END(idmap_cpu_replace_ttbr1)
 
 #define KPTI_NG_PTE_FLAGS	(PTE_ATTRINDX(MT_NORMAL) | SWAPPER_PTE_FLAGS)
 
-	.pushsection ".idmap.text", "awx"
+	.pushsection ".idmap.text", "a"
 
 	.macro	kpti_mk_tbl_ng, type, num_entries
 	add	end_\type\()p, cur_\type\()p, #\num_entries * 8
@@ -400,7 +400,7 @@ SYM_FUNC_END(idmap_kpti_install_ng_mappings)
  * Output:
  *	Return in x0 the value of the SCTLR_EL1 register.
  */
-	.pushsection ".idmap.text", "awx"
+	.pushsection ".idmap.text", "a"
 SYM_FUNC_START(__cpu_setup)
 	tlbi	vmalle1				// Invalidate local TLB
 	dsb	nsh
-- 
2.39.2



