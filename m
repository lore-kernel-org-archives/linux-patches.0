Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047633;
	b=bJNu7b8crd4fU0kD+j+n0MwCSfl6MWA2IePmucfRRFNPzsVF7dAxmLYpJbi45KrocRZ8
	 tdyH+S7vSxRhddgXHqRzo7sdqZ+yTcl7etCBD7GWzpMdsEp4fJUJfQ4L972MbItCEPcZu
	 ImjF+Ab+VH5CRqSNSZc3kpJGWp34pQChAZERYEvqmszfByiArrmMaJjXJb9EnVprYR4Sh
	 tTynyYaEwRdTp7Pq1ysFyegOFIlhAOI7hHznuYSkABgwYalE524d3NHf7fhgnmctPA3tw
	 lKmlh8qxfPsQbcebCu3FI/MJVjAQc5u05L8uucuv7mV0H0S/upO1wL6HE096dKn2sVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OUvc8URwJst8yaNsyTEelF+VTW89CLb7QeJD3gaf3ec=;
	b=XnW8TdBz0T3lBWoyq7nUZeLm3J4AhGUTKnpGiqgAAp/0vmpaSU74fC/RfTWfU/JcJB3A
	 qj467lP+i1GlQIBpjbNlWiwVMQToahlmt8ojSsBDmYNDznhnINu7ZoyJ6wDcG/cwgbd5K
	 ihpv3rv1HGmcZv4Wl/ppouTjRfma0t3+4RrgSiTtjFg+xWfyiTfBd59XwnRUHGW5ViOct
	 oTVZ5KdblgSw9eMSh/z4KLiBHoYxasCR3i1JXoySJFXsAbyHt32A71G/Z3Bj52yIppsrf
	 qk4VAMKRByHjmpNp6annJqbvI1O7l4FLCmft3jTkCbmuDIVQBLfMSPM4WFXgLVnHvPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ActjSES0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AE8606A320;
	Thu, 19 Nov 2026 00:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ActjSES0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284761F000C4;
	Thu, 19 Nov 2026 00:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047633;
	bh=OUvc8URwJst8yaNsyTEelF+VTW89CLb7QeJD3gaf3ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ActjSES0dC2WxqVxgfOyv6da/8chKxSP5xW8YnOfkZ1XSW08gvFjdU3VAw47GDoFw
	 qcjwfNeMccQDXDC6D13xzLBUam9gBal9mOAH9nL1Y45y8N0aBHzVs+mWfjisrCTeVa
	 AM1HnHRD3oRuyxD8PJgNH0vmGNk9AY4B2w/MsD+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Wei Wang <wvw@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1708/2857] arm64: suspend: Save and restore TPIDR2_EL0 across CPU suspend
Date: Wed, 18 Nov 2026 15:45:42 +0100
Message-ID: <20261118150302.829427870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Wang <wvw@google.com>

[ Upstream commit beeec04046227eba42b7cc5ab32498aa43da9632 ]

TPIDR2_EL0 is a live EL0 register on systems with SME, but
cpu_do_suspend()/cpu_do_resume() don't preserve it. Its value is
UNKNOWN after a warm reset, so the task that initiates suspend can
return to userspace with a corrupted TPIDR2_EL0.

Save and restore it alongside TPIDR_EL0 and TPIDRRO_EL0. The new slot
fits in existing padding, so sizeof(struct cpu_suspend_ctx) is
unchanged.

Fixes: a9d691585950 ("arm64/sme: Implement support for TPIDR2")
Cc: stable@vger.kernel.org
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Wei Wang <wvw@google.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ sashal: Adapted the suspend context layout for the missing TCR2_EL1 slot, using offset 104 instead of 112 for TPIDR2_EL0. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/suspend.h | 2 +-
 arch/arm64/mm/proc.S             | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
index 0cde2f473971e..eb60c97355530 100644
--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 13
+#define NR_CTX_REGS 14
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index b9ecbbae1e1ab..5d41d39d58472 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -102,6 +102,10 @@ SYM_FUNC_START(cpu_do_suspend)
 	 * call stack.
 	 */
 	str	x18, [x0, #96]
+alternative_if ARM64_SME
+	mrs_s	x2, SYS_TPIDR2_EL0
+	str	x2, [x0, #104]
+alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
 
@@ -145,6 +149,10 @@ SYM_FUNC_START(cpu_do_resume)
 	 */
 	disable_daif
 	msr	mdscr_el1, x10
+alternative_if ARM64_SME
+	ldr	x2, [x0, #104]
+	msr_s	SYS_TPIDR2_EL0, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13
-- 
2.53.0



