Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5573D7D86;
	Thu, 16 Jul 2026 13:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209690; cv=none; b=uqynVzelbAwuYqTMLM1A1e4b6QWvyzTleGiliOzHnPs8pOpNIOCJJfm6srvq/wh6LlkTAyxIcSQyFSTccojtUkNJVne/O1BrbgKfjDgICcT83oO9gsz5hFXqCfDmLwkDmKT0khPJtIVkPsGcb01yj94OD7C5XFghUefGqRBSuOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209690; c=relaxed/simple;
	bh=j6hrKnd7TLRNrGm2GzvrDtqi/dZXMh+kfG7inuC8sbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUUAvcLQLEnEcKJcmKxf0JsgCLcBuHxBN3bqkGIPGojOnblKYDZrOQxX66UneRkkz1MJMX/j+dHE8tfUnHEFEmK5zUR/VELiejRnxfUX54w033r8QUk2i+QLTr/OSITKbbHpx/vuW+98UzjONsf7crxX0ZWvKgKVajs21mgG4oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbYG0wSY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbYG0wSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863FA1F00A3F;
	Thu, 16 Jul 2026 13:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209676;
	bh=DEyio8Btndn+obHPgw5S44AJHwqzSD7NASNInrxU2+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qbYG0wSYp5dLA0us1ChRzfkofJb2sBvnQnibUDGa4Zg9pGrz+TTFsUXRaixLWwfJ9
	 Dz3UfP21Z7IDVgSU5492AhUL4FAaXiDnB8wAYnrwrDJu5KHNzJvzhchIAFVRT0P0/g
	 iMkLc28b6G26A6ADqdms3WB+M9m8tg+onymbLh8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 7.1 259/518] s390: Revert support for DCACHE_WORD_ACCESS
Date: Thu, 16 Jul 2026 15:28:47 +0200
Message-ID: <20260716133053.486407383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 37540b8c287fc817bdbd0c62bb75ad6eab0e5d03 upstream.

load_unaligned_zeropad() reads eight bytes from unaligned addresses and may
cross page boundaries. It handles exceptions which may happen if reading
from the second page results in an exception.

For pages which are donated to the Ultravisor for secure execution purposes
the do_secure_storage_access() exception handler however does not handle
such exceptions correctly. Such an exception may result in an endless
exception loop which will never be resolved.

An attempt to fix this [1] turned out to be not sufficient. For now revert
load_unaligned_zeropad() until this problem has been resolved in a proper
way.

Note that the implementation of load_unaligned_zeropad() itself is
correct. The revert is just a temporary workaround until there is complete
fix for secure storage access exceptions.

[1] commit b00be77302d7 ("s390/mm: Add missing secure storage access fixups for donated memory")

Fixes: 802ba53eefc5 ("s390: add support for DCACHE_WORD_ACCESS")
Cc: stable@vger.kernel.org
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Kconfig                      |    1 -
 arch/s390/include/asm/asm-extable.h    |    4 ----
 arch/s390/include/asm/word-at-a-time.h |   22 ----------------------
 arch/s390/mm/extable.c                 |   18 ------------------
 4 files changed, 45 deletions(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -163,7 +163,6 @@ config S390
 	select ARCH_WANTS_THP_SWAP
 	select BUILDTIME_TABLE_SORT
 	select CLONE_BACKWARDS2
-	select DCACHE_WORD_ACCESS if !KMSAN
 	select DYNAMIC_FTRACE if FUNCTION_TRACER
 	select FUNCTION_ALIGNMENT_8B if CC_IS_GCC
 	select FUNCTION_ALIGNMENT_16B if !CC_IS_GCC
--- a/arch/s390/include/asm/asm-extable.h
+++ b/arch/s390/include/asm/asm-extable.h
@@ -12,7 +12,6 @@
 #define EX_TYPE_UA_FAULT	3
 #define EX_TYPE_UA_LOAD_REG	5
 #define EX_TYPE_UA_LOAD_REGPAIR	6
-#define EX_TYPE_ZEROPAD		7
 #define EX_TYPE_FPC		8
 #define EX_TYPE_UA_MVCOS_TO	9
 #define EX_TYPE_UA_MVCOS_FROM	10
@@ -80,9 +79,6 @@
 #define EX_TABLE_UA_LOAD_REGPAIR(_fault, _target, _regerr, _regzero)	\
 	__EX_TABLE(__ex_table, _fault, _target, EX_TYPE_UA_LOAD_REGPAIR, _regerr, _regzero, 0)
 
-#define EX_TABLE_ZEROPAD(_fault, _target, _regdata, _regaddr)		\
-	__EX_TABLE(__ex_table, _fault, _target, EX_TYPE_ZEROPAD, _regdata, _regaddr, 0)
-
 #define EX_TABLE_FPC(_fault, _target)					\
 	__EX_TABLE(__ex_table, _fault, _target, EX_TYPE_FPC, __stringify(%%r0), __stringify(%%r0), 0)
 
--- a/arch/s390/include/asm/word-at-a-time.h
+++ b/arch/s390/include/asm/word-at-a-time.h
@@ -4,7 +4,6 @@
 
 #include <linux/bitops.h>
 #include <linux/wordpart.h>
-#include <asm/asm-extable.h>
 #include <asm/bitsperlong.h>
 
 struct word_at_a_time {
@@ -41,25 +40,4 @@ static inline unsigned long zero_bytemas
 	return ~1UL << data;
 }
 
-/*
- * Load an unaligned word from kernel space.
- *
- * In the (very unlikely) case of the word being a page-crosser
- * and the next page not being mapped, take the exception and
- * return zeroes in the non-existing part.
- */
-static inline unsigned long load_unaligned_zeropad(const void *addr)
-{
-	unsigned long data;
-
-	asm_inline volatile(
-		"0:	lg	%[data],0(%[addr])\n"
-		"1:	nopr	%%r7\n"
-		EX_TABLE_ZEROPAD(0b, 1b, %[data], %[addr])
-		EX_TABLE_ZEROPAD(1b, 1b, %[data], %[addr])
-		: [data] "=d" (data)
-		: [addr] "a" (addr), "m" (*(unsigned long *)addr));
-	return data;
-}
-
 #endif /* _ASM_WORD_AT_A_TIME_H */
--- a/arch/s390/mm/extable.c
+++ b/arch/s390/mm/extable.c
@@ -50,22 +50,6 @@ static bool ex_handler_ua_load_reg(const
 	return true;
 }
 
-static bool ex_handler_zeropad(const struct exception_table_entry *ex, struct pt_regs *regs)
-{
-	unsigned int reg_addr = FIELD_GET(EX_DATA_REG_ADDR, ex->data);
-	unsigned int reg_data = FIELD_GET(EX_DATA_REG_ERR, ex->data);
-	unsigned long data, addr, offset;
-
-	addr = regs->gprs[reg_addr];
-	offset = addr & (sizeof(unsigned long) - 1);
-	addr &= ~(sizeof(unsigned long) - 1);
-	data = *(unsigned long *)addr;
-	data <<= BITS_PER_BYTE * offset;
-	regs->gprs[reg_data] = data;
-	regs->psw.addr = extable_fixup(ex);
-	return true;
-}
-
 static bool ex_handler_fpc(const struct exception_table_entry *ex, struct pt_regs *regs)
 {
 	fpu_sfpc(0);
@@ -134,8 +118,6 @@ bool fixup_exception(struct pt_regs *reg
 		return ex_handler_ua_load_reg(ex, false, regs);
 	case EX_TYPE_UA_LOAD_REGPAIR:
 		return ex_handler_ua_load_reg(ex, true, regs);
-	case EX_TYPE_ZEROPAD:
-		return ex_handler_zeropad(ex, regs);
 	case EX_TYPE_FPC:
 		return ex_handler_fpc(ex, regs);
 	case EX_TYPE_UA_MVCOS_TO:


