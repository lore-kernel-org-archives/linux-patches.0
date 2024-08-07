Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E3E7E0E9;
	Wed,  7 Aug 2024 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043506; cv=none; b=pYGEdT94WyqA7A9rpREZP/ArWBWUBa2wK1oZxPEosv1UcxXW/xpRP4lTw/GGjzXqy3haaN5AaXtHFSkzWg4MWE7H5xDJ6JtD3BSUPTimg1pfm0wo9QzTyWkXrDKzeHKyiDeAgdzLMz3ESyIxCAfwqvPBptTfO6ZvlFYUaeUh+tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043506; c=relaxed/simple;
	bh=axM/TX5HSrjXuD7QGp2rMMTzB9HMm9e8ZQ+LY4T/SFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pfCnNsS4b/kdc3z3WT+uPJnC5UPob9uWgxIWSfwouG4+sL+6pZgSRP2hi3mphgT2OSjRs1CPTLaMJp41qciIndC+MpI5rPG+ULRGonlI00mMRRcBH7htRIcOInJ3W21OiZW3eLatQ/JF1DQECW9iXLbXedB5Jwiza8tAQz5txK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vgj7GC71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vgj7GC71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE78C32781;
	Wed,  7 Aug 2024 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043506;
	bh=axM/TX5HSrjXuD7QGp2rMMTzB9HMm9e8ZQ+LY4T/SFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vgj7GC71MEez7cxMyFoDX1ydlxj4+Flib5vFylrxAm6yiH+hj13Y2PnuzyLJj8+4U
	 V1wRIdqUv1X4yrJLkml3uytQpOaeg8k3mMcMlzm9Lz1ruHH2VHTIDZreUnOayyt/vS
	 2yIYBoani4hUNTN8Me1l55Napzf9N55D5qbI6DFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/121] riscv: remove unused functions in traps_misaligned.c
Date: Wed,  7 Aug 2024 17:00:21 +0200
Message-ID: <20240807150022.317079443@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit f19c3b4239f5bfb69aacbaf75d4277c095e7aa7d ]

Replace macros by the only two function calls that are done from this
file, store_u8() and load_u8().

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Link: https://lore.kernel.org/r/20231004151405.521596-2-cleger@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: fb197c5d2fd2 ("riscv/purgatory: align riscv_kernel_entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps_misaligned.c | 46 +++++-----------------------
 1 file changed, 7 insertions(+), 39 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 5348d842c7453..e867fe465164e 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -151,51 +151,19 @@
 #define PRECISION_S 0
 #define PRECISION_D 1
 
-#define DECLARE_UNPRIVILEGED_LOAD_FUNCTION(type, insn)			\
-static inline type load_##type(const type *addr)			\
-{									\
-	type val;							\
-	asm (#insn " %0, %1"						\
-	: "=&r" (val) : "m" (*addr));					\
-	return val;							\
-}
+static inline u8 load_u8(const u8 *addr)
+{
+	u8 val;
 
-#define DECLARE_UNPRIVILEGED_STORE_FUNCTION(type, insn)			\
-static inline void store_##type(type *addr, type val)			\
-{									\
-	asm volatile (#insn " %0, %1\n"					\
-	: : "r" (val), "m" (*addr));					\
-}
+	asm volatile("lbu %0, %1" : "=&r" (val) : "m" (*addr));
 
-DECLARE_UNPRIVILEGED_LOAD_FUNCTION(u8, lbu)
-DECLARE_UNPRIVILEGED_LOAD_FUNCTION(u16, lhu)
-DECLARE_UNPRIVILEGED_LOAD_FUNCTION(s8, lb)
-DECLARE_UNPRIVILEGED_LOAD_FUNCTION(s16, lh)
-DECLARE_UNPRIVILEGED_LOAD_FUNCTION(s32, lw)
-DECLARE_UNPRIVILEGED_STORE_FUNCTION(u8, sb)
-DECLARE_UNPRIVILEGED_STORE_FUNCTION(u16, sh)
-DECLARE_UNPRIVILEGED_STORE_FUNCTION(u32, sw)
-#if defined(CONFIG_64BIT)
-DECLARE_UNPRIVILEGED_LOAD_FUNCTION(u32, lwu)
-DECLARE_UNPRIVILEGED_LOAD_FUNCTION(u64, ld)
-DECLARE_UNPRIVILEGED_STORE_FUNCTION(u64, sd)
-DECLARE_UNPRIVILEGED_LOAD_FUNCTION(ulong, ld)
-#else
-DECLARE_UNPRIVILEGED_LOAD_FUNCTION(u32, lw)
-DECLARE_UNPRIVILEGED_LOAD_FUNCTION(ulong, lw)
-
-static inline u64 load_u64(const u64 *addr)
-{
-	return load_u32((u32 *)addr)
-		+ ((u64)load_u32((u32 *)addr + 1) << 32);
+	return val;
 }
 
-static inline void store_u64(u64 *addr, u64 val)
+static inline void store_u8(u8 *addr, u8 val)
 {
-	store_u32((u32 *)addr, val);
-	store_u32((u32 *)addr + 1, val >> 32);
+	asm volatile ("sb %0, %1\n" : : "r" (val), "m" (*addr));
 }
-#endif
 
 static inline ulong get_insn(ulong mepc)
 {
-- 
2.43.0



