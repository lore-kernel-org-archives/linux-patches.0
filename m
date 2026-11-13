Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591123;
	b=VekpmZC3URcs96JRjRCd0c+dBQecBjuZzmQ50fJjADgXMX6stJ2K0jdSHjSiitylSUTp
	 W4MVNgzP063+k1hK4nP1ZZfloEOQgAwlltKGSUf3KKTqxRuD77r4dydvkStMTq3Kk756m
	 YJRytF47JhDQNp9rtQLAUB3r5FIRhCKPRHuJaF//rBTvlX1YWmDRCeBuJ4RqS9Oeh1UE0
	 9W1xpcsT1eBK4aX2/CAA07BwPl4kBIHBhDNA8sI4vj+QdH8Mx6K0JANFPEY4w7b6AFCYj
	 GmcpzHOEHD+2d5DdcTNoHYDUbJ3/0bKp6cfPLzBfiHIQWVcRQhk0zzMgEOwr94+qPVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PA+AdlmXdhH0wcRElBTwATM4MJugHaP9c54r90ISuyk=;
	b=TrUImwxMalsyieWkraSOoYWW9oJhY/BTvejF/3SgdVtM/GpOxQSYDOr4+xv+bSA9gUmj
	 WJmixcZjFjMgN36O8jkYBDBJ0cNT11plszBgCTWHkaN2AY8HM/c7S/E+0tsjAtutnLwyT
	 6eVkRsvWomvoPpge5MjL/4MKKw7CS1pJUlHPyEDvsvlC0L7Z9p832MPqD/fySoGwE4UQh
	 lAc6ZrSmjEmhvp/bgZbAadsDgMdBXPVTa8EjZ2oIRTEW7ultq9AfCHv79A+Bj+yuncGsj
	 Xpyr4AhxySixsW9252gTO4eQ0pidVbAR24O6ykpR8AqteCELXn65hObNDjDg9hM2mZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSTfMdf5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61697606A88C;
	Fri, 13 Nov 2026 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSTfMdf5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3BA1F000C4;
	Fri, 13 Nov 2026 17:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591123;
	bh=PA+AdlmXdhH0wcRElBTwATM4MJugHaP9c54r90ISuyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSTfMdf5V1zLnZkgwojG1YyfEUxHvvJui7gInoH9DxuZATnszXAWygDx6254iYQSz
	 L+PpPRxvGI1qEgr2J2jUx2aYIkk+5ddEk3AHz4PMhfPrWk3VEIGgWSKHMdB2uA9DUu
	 xiuo984nvgVjk745q0do9MV4i5Lm79gtVP3eXVLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/670] x86/vmware: Fix i386 high-bandwidth hypercall arguments
Date: Fri, 13 Nov 2026 10:47:16 -0500
Message-ID: <20261113153821.115372957@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

[ Upstream commit e0e022004bbedc7caf1c18770980eb5372019189 ]

The high-bandwidth hypercall helpers push %ebp before loading the in6
operand into it. On i386 without frame pointers, both GCC and Clang can
address the memory-constrained operand relative to %esp. The push then
moves the stack and the helpers load the wrong value.

Typical i386 configurations use the frame-pointer unwinder and happen to
address the operand through %ebp. However, UNWINDER_GUESS is available
with EXPERT and permits the affected frame-pointer-disabled configuration.
vmwgfx is also available on i386 and calls both helpers.

Stage in6 through %eax before changing either stack register, then save
%ebp and copy the staged value into it. Load the VMware magic immediately
before the string I/O instruction. Mark %eax early-clobber so it cannot
also provide in6 or an address register for it. Use the same sequence on
x86-64, where the full-width register preserves in6.

Fixes: 34bf25e820ae ("x86/vmware: Introduce VMware hypercall API")
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Cc: stable@vger.kernel.org # 6.11+
Link: https://patch.msgid.link/4ab10678a8f50053934b62b56af81f881c1d3798.1788414669.git.zack.rusin@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/vmware.h | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmware.h b/arch/x86/include/asm/vmware.h
index 4220dae14a2d9..fb011cef01e76 100644
--- a/arch/x86/include/asm/vmware.h
+++ b/arch/x86/include/asm/vmware.h
@@ -276,20 +276,22 @@ unsigned long vmware_hypercall_hb_out(unsigned long cmd, unsigned long in2,
 
 	asm_inline volatile (
 		UNWIND_HINT_SAVE
+		"mov %[in6], %%" _ASM_AX "\n\t"
 		"push %%" _ASM_BP "\n\t"
 		UNWIND_HINT_UNDEFINED
-		"mov %[in6], %%" _ASM_BP "\n\t"
+		"mov %%" _ASM_AX ", %%" _ASM_BP "\n\t"
+		"mov %[magic], %%eax\n\t"
 		"rep outsb\n\t"
 		"pop %%" _ASM_BP "\n\t"
 		UNWIND_HINT_RESTORE
-		: "=a" (out0), "=b" (*out1)
-		: "a" (VMWARE_HYPERVISOR_MAGIC),
-		  "b" (cmd),
+		: "=&a" (out0), "=b" (*out1)
+		: "b" (cmd),
 		  "c" (in2),
 		  "d" (in3 | VMWARE_HYPERVISOR_PORT_HB),
 		  "S" (in4),
 		  "D" (in5),
-		  [in6] VMW_BP_CONSTRAINT (in6)
+		  [in6] VMW_BP_CONSTRAINT(in6),
+		  [magic] "i" (VMWARE_HYPERVISOR_MAGIC)
 		: "cc", "memory");
 	return out0;
 }
@@ -304,20 +306,22 @@ unsigned long vmware_hypercall_hb_in(unsigned long cmd, unsigned long in2,
 
 	asm_inline volatile (
 		UNWIND_HINT_SAVE
+		"mov %[in6], %%" _ASM_AX "\n\t"
 		"push %%" _ASM_BP "\n\t"
 		UNWIND_HINT_UNDEFINED
-		"mov %[in6], %%" _ASM_BP "\n\t"
+		"mov %%" _ASM_AX ", %%" _ASM_BP "\n\t"
+		"mov %[magic], %%eax\n\t"
 		"rep insb\n\t"
 		"pop %%" _ASM_BP "\n\t"
 		UNWIND_HINT_RESTORE
-		: "=a" (out0), "=b" (*out1)
-		: "a" (VMWARE_HYPERVISOR_MAGIC),
-		  "b" (cmd),
+		: "=&a" (out0), "=b" (*out1)
+		: "b" (cmd),
 		  "c" (in2),
 		  "d" (in3 | VMWARE_HYPERVISOR_PORT_HB),
 		  "S" (in4),
 		  "D" (in5),
-		  [in6] VMW_BP_CONSTRAINT (in6)
+		  [in6] VMW_BP_CONSTRAINT(in6),
+		  [magic] "i" (VMWARE_HYPERVISOR_MAGIC)
 		: "cc", "memory");
 	return out0;
 }
-- 
2.53.0



