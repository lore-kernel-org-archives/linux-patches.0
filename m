Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C7829C338;
	Thu, 15 Jan 2026 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496500; cv=none; b=e7j5Pgp8vbtUkNpDwkRc1ocmBL5i+nhYFit8cSN94HBVTdp17pv/XLsdcl0gHD3F2+v+Jg/u2Mdg6W6F8KgnOCyBBu7wM0GztA0wdKKnsfTI+jDrusGEyjKr/SENayoOi2u/mjzShNhadRjtaP8O9VXj0nG4hYeLrNALL3FR5Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496500; c=relaxed/simple;
	bh=pCer/eoQg/+/hKPk9NVz8rvtwztvWe85om+Zcvx6MZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEfimnOuE37BWbsXkws+Ff42HkXsAPOJmuoEGTOmt3IjmIxTmmAXyPXB7azEFms1vR5/hqANQ8l5vnHv2tHCTdrG7jnPnJeA3XEJh9WB4hmVzjMbQ6hUjIpVFzum3fFI1WCXi+BQhbniNvVW5diYgha3NA6Nqcz7WUml6YvWTzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvZHCvZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvZHCvZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F435C116D0;
	Thu, 15 Jan 2026 17:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496500;
	bh=pCer/eoQg/+/hKPk9NVz8rvtwztvWe85om+Zcvx6MZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvZHCvZAVxtaxlr9FRXSuSOeqITlVOi3osjgRUlqCCMeqSNxOxHukdQkBL2JZ/xGj
	 ccsxiFObrcl6urxLc/rM75vyj+LTcH1dOm7MbW17Fz73FEHzth3NiQxa+eFuFWik5M
	 g6/whqyYzUbYrlBKejesRBLdFahn1H3tVXLZMyBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 009/119] arm64: Fix cleared E0POE bit after cpu_suspend()/resume()
Date: Thu, 15 Jan 2026 17:47:04 +0100
Message-ID: <20260115164152.294611664@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

commit bdf3f4176092df5281877cacf42f843063b4784d upstream.

TCR2_ELx.E0POE is set during smp_init().
However, this bit is not reprogrammed when the CPU enters suspension and
later resumes via cpu_resume(), as __cpu_setup() does not re-enable E0POE
and there is no save/restore logic for the TCR2_ELx system register.

As a result, the E0POE feature no longer works after cpu_resume().

To address this, save and restore TCR2_EL1 in the cpu_suspend()/cpu_resume()
path, rather than adding related logic to __cpu_setup(), taking into account
possible future extensions of the TCR2_ELx feature.

Fixes: bf83dae90fbc ("arm64: enable the Permission Overlay Extension for EL0")
Cc: <stable@vger.kernel.org> # 6.12.x
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/suspend.h |    2 +-
 arch/arm64/mm/proc.S             |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 13
+#define NR_CTX_REGS 14
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -100,6 +100,10 @@ SYM_FUNC_START(cpu_do_suspend)
 	 * call stack.
 	 */
 	str	x18, [x0, #96]
+alternative_if ARM64_HAS_TCR2
+	mrs	x2, REG_TCR2_EL1
+	str	x2, [x0, #104]
+alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
 
@@ -134,6 +138,10 @@ SYM_FUNC_START(cpu_do_resume)
 	msr	tcr_el1, x8
 	msr	vbar_el1, x9
 	msr	mdscr_el1, x10
+alternative_if ARM64_HAS_TCR2
+	ldr	x2, [x0, #104]
+	msr	REG_TCR2_EL1, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13


