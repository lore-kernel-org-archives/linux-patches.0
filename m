Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591226;
	b=IY21Chbdfb+QzzNSm/QZ+/SYEILk5HURcyKkLlw2RYUpCaTtkhGTYu1HVXzeZtgrISe4
	 MinXpl8AbpQRkLdrhMi6sKNAxldIQx9XyJLfHeWaKTe70e/ElzG9Qpei+aj004merkcvF
	 4BT/7byfYDKhScG3LwANxmU4ePgnWoXVGbdlHi9qLbD/djuLcPN8KsYm2rh4PUzGbeP3B
	 Uld4GcB2XV8RPxftf1u6pAMg8XinUHAajUW8IIGtbB7cpWok9ccKhY3M+hyDYZQtPULUX
	 w2IhtuyPXf2aeiwe2mtbc1yWbWeeofcIGatFzDHQCpMlzL5XKxr3u67E+ENLJEYmVeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5wq2yE50vCmriPUfnFzyMFj8YDuf7Sg/RrPh+rEPxiQ=;
	b=Zr+cIkk7lJvagsZ2Fp93ASQ5uPTnT0IAQRwmchIFfs38EwSuiqBjR99pn7RvBnSrebOX
	 niE7zAErtIDTdRJmsWhwTb5JbaLjdRDqBH+//Rk9B7/Ycx5QTMlQ8/YSIk/lPwfKN2YXO
	 r6bYTsprViy2QHa9FRB6IoS16MZ5D1r3gmdItzkpA0FelEINY2TiWRArmsa64AjyFrZzh
	 inK/vBY2sCdHfQE1bUO+OmE9O2OgHkOjufdFmG39viSSemi6hgS/NJXnmXHPLiaMVU8I0
	 QCJitLgHL8Xh7/qOiGdneJ2XP/yrNj+Vuapj60fYtjpU+nBjwJeHrR6hvLhUw/eKc7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j+6PUm7K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10086075E39;
	Fri, 13 Nov 2026 17:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j+6PUm7K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898E91F000C4;
	Fri, 13 Nov 2026 17:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591225;
	bh=5wq2yE50vCmriPUfnFzyMFj8YDuf7Sg/RrPh+rEPxiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j+6PUm7KJgAzDVeh0hTvco7rGWJo8LU5iNK/jkvnhQfMMCs5nK8I34CL7D9gN+ucw
	 tFeeFb15sPEWjZHBoQ6s7G3H3zwAtXcvz/ym1FKTqYhL2rWhroRxBMfftk9z8saGIk
	 YLMN2WagBU2Xs/RlMsKrW5TO+QsCLeV5Y+fsmRjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Wei Wang <wvw@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 356/670] arm64: suspend: Save and restore TPIDR2_EL0 across CPU suspend
Date: Fri, 13 Nov 2026 10:48:40 -0500
Message-ID: <20261113153823.883038094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/suspend.h | 2 +-
 arch/arm64/mm/proc.S             | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
index eb60c97355530..2cc5fb405769c 100644
--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 14
+#define NR_CTX_REGS 15
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 7afbece885a30..c7b7fa6491c3b 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -103,6 +103,10 @@ SYM_FUNC_START(cpu_do_suspend)
 alternative_if ARM64_HAS_TCR2
 	mrs	x2, REG_TCR2_EL1
 	str	x2, [x0, #104]
+alternative_else_nop_endif
+alternative_if ARM64_SME
+	mrs_s	x2, SYS_TPIDR2_EL0
+	str	x2, [x0, #112]
 alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
@@ -142,6 +146,10 @@ alternative_if ARM64_HAS_TCR2
 	ldr	x2, [x0, #104]
 	msr	REG_TCR2_EL1, x2
 alternative_else_nop_endif
+alternative_if ARM64_SME
+	ldr	x2, [x0, #112]
+	msr_s	SYS_TPIDR2_EL0, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13
-- 
2.53.0



