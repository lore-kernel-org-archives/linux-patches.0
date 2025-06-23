Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C92B676;
	Mon, 23 Jun 2025 22:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716965; cv=none; b=eKRB1SwfaU78c/faWJiSQv8U5fml8LgLkGuwOSyY574uljasILxRPJ1TJiNerr0kNL2SMm+DN9GEgmTyCkGl0G45G3pmXdOHhGpOjjvbRyo6m6h87Z6tq8Zu8mlYy6lqyudj99z5zpgQu+PmDp6M+LHd9GVu7EdOBOP9+nnct7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716965; c=relaxed/simple;
	bh=f+PkneAZZLrDrcYp9VNFIrzF21n/r6tjLd3/Sur/ni8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9qyT8ahkug0Br6fUddXgmrvpOHklcF7zhU1ZLik46qY1qK1j2rIpHlDQlrzYRbPKaPVca15Dgw4Gdo6QyMIXhaU/UhsD7PgqxLpu9yHt5pETycqsx91d5XUHfzFh3LWjX698e1W6J6OuHY18NM+qQ1ffUNQvNUlq6afiF5CI6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2e3I3n/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2e3I3n/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0650C4CEEA;
	Mon, 23 Jun 2025 22:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716965;
	bh=f+PkneAZZLrDrcYp9VNFIrzF21n/r6tjLd3/Sur/ni8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2e3I3n/oEw5FYPC0jSMXJbL4kvDAf+lKuit6h3JbaD9CZsLsgadWrKSFz0fl1AB8s
	 68whoH9J89af9l76PqYWLSCKRl7BhUUbr2pUO6zmxuFmiL/61GRQcmbaU4KGuOhbaI
	 Om6eRL99RD22+UP9FbNJAtoaWV4LL8+uWLjOsSvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <si.yanteng@linux.dev>,
	WANG Rui <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 302/414] LoongArch: Avoid using $r0/$r1 as "mask" for csrxchg
Date: Mon, 23 Jun 2025 15:07:19 +0200
Message-ID: <20250623130649.555316515@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 52c22661c79a7b6af7fad9f77200738fc6c51878 upstream.

When building kernel with LLVM there are occasionally such errors:

In file included from ./include/linux/spinlock.h:59:
In file included from ./include/linux/irqflags.h:17:
arch/loongarch/include/asm/irqflags.h:38:3: error: must not be $r0 or $r1
   38 |                 "csrxchg %[val], %[mask], %[reg]\n\t"
      |                 ^
<inline asm>:1:16: note: instantiated into assembly here
    1 |         csrxchg $a1, $ra, 0
      |                       ^

To prevent the compiler from allocating $r0 or $r1 for the "mask" of the
csrxchg instruction, the 'q' constraint must be used but Clang < 21 does
not support it. So force to use $t0 in the inline asm, in order to avoid
using $r0/$r1 while keeping the backward compatibility.

Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/pull/141037
Reviewed-by: Yanteng Si <si.yanteng@linux.dev>
Suggested-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/irqflags.h |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/arch/loongarch/include/asm/irqflags.h
+++ b/arch/loongarch/include/asm/irqflags.h
@@ -14,40 +14,48 @@
 static inline void arch_local_irq_enable(void)
 {
 	u32 flags = CSR_CRMD_IE;
+	register u32 mask asm("t0") = CSR_CRMD_IE;
+
 	__asm__ __volatile__(
 		"csrxchg %[val], %[mask], %[reg]\n\t"
 		: [val] "+r" (flags)
-		: [mask] "r" (CSR_CRMD_IE), [reg] "i" (LOONGARCH_CSR_CRMD)
+		: [mask] "r" (mask), [reg] "i" (LOONGARCH_CSR_CRMD)
 		: "memory");
 }
 
 static inline void arch_local_irq_disable(void)
 {
 	u32 flags = 0;
+	register u32 mask asm("t0") = CSR_CRMD_IE;
+
 	__asm__ __volatile__(
 		"csrxchg %[val], %[mask], %[reg]\n\t"
 		: [val] "+r" (flags)
-		: [mask] "r" (CSR_CRMD_IE), [reg] "i" (LOONGARCH_CSR_CRMD)
+		: [mask] "r" (mask), [reg] "i" (LOONGARCH_CSR_CRMD)
 		: "memory");
 }
 
 static inline unsigned long arch_local_irq_save(void)
 {
 	u32 flags = 0;
+	register u32 mask asm("t0") = CSR_CRMD_IE;
+
 	__asm__ __volatile__(
 		"csrxchg %[val], %[mask], %[reg]\n\t"
 		: [val] "+r" (flags)
-		: [mask] "r" (CSR_CRMD_IE), [reg] "i" (LOONGARCH_CSR_CRMD)
+		: [mask] "r" (mask), [reg] "i" (LOONGARCH_CSR_CRMD)
 		: "memory");
 	return flags;
 }
 
 static inline void arch_local_irq_restore(unsigned long flags)
 {
+	register u32 mask asm("t0") = CSR_CRMD_IE;
+
 	__asm__ __volatile__(
 		"csrxchg %[val], %[mask], %[reg]\n\t"
 		: [val] "+r" (flags)
-		: [mask] "r" (CSR_CRMD_IE), [reg] "i" (LOONGARCH_CSR_CRMD)
+		: [mask] "r" (mask), [reg] "i" (LOONGARCH_CSR_CRMD)
 		: "memory");
 }
 


