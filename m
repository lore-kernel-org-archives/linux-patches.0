Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFD4335BA;
	Thu, 13 Feb 2025 15:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460019; cv=none; b=iYND1S1wIDXf6mQFVq3mBmIeOztLenwWHX6xRTS7AyCqBqnLcfZFn4CgvSAAjtvZHq1waGVFezbpCmADUG2m3ygVzmj+i4yMHy/Ql0nV30csDU8mdJhtiGM6Pr9OmmhkMzqUmtZtUE0BD41+RGWgjv/FKywUeKiK+uFF5sf2aBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460019; c=relaxed/simple;
	bh=Y21syk57M5itfPXaIznKSPl/V17gHBAfeCu8KaMrmH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jt8UMVMRvss4brALjNTur56f/uXWD35f2GKC7oBxbVwdIPwXMmAckYi3SsQ3rZsEKzXggbPwwipR4nSvrig6L+8BQXVjGwTXiG93Ph7/LED4py19VDqhmfwLFbH2oG8WeSZVjBhkcc6rqVtP3rAkqHTqplIkb+vFSETXAiIqxRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=px3OBexy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="px3OBexy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8351EC4CED1;
	Thu, 13 Feb 2025 15:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460019;
	bh=Y21syk57M5itfPXaIznKSPl/V17gHBAfeCu8KaMrmH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=px3OBexyumyPfI5XUz1j4ImtLGcNqQrnr8EDVAOpq6Z0/HFEjKcAgFQn1Ozirkoax
	 ai9ttW9d2WGUACXmWAAcWSXIQkK91KcB6I9+qd5L6rbJf/z/Lf0UpKMDvVYIdnQVXT
	 AfiN1yDaMFbCIEBVxdKquGr+BCDykhrtnWQnWCMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.13 433/443] s390/fpu: Add fpc exception handler / remove fixup section again
Date: Thu, 13 Feb 2025 15:29:58 +0100
Message-ID: <20250213142457.328632125@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit ae02615b7fcea9ce9a4ec40b3c5b5dafd322b179 upstream.

The fixup section was added again by mistake when test_fp_ctl() was
removed. The reason for the removal of the fixup section is described in
commit 484a8ed8b7d1 ("s390/extable: add dedicated uaccess handler").
Remove it again for the same reason.

Add an exception handler which handles exceptions when the floating point
control register is attempted to be set to invalid values. The exception
handler sets the floating point control register to zero and continues
execution at the specified address.

The new sfpc inline assembly is open-coded to make back porting a bit
easier.

Fixes: 702644249d3e ("s390/fpu: get rid of test_fp_ctl()")
Cc: stable@vger.kernel.org
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/asm-extable.h |    4 ++++
 arch/s390/include/asm/fpu-insn.h    |   17 +++++------------
 arch/s390/kernel/vmlinux.lds.S      |    1 -
 arch/s390/mm/extable.c              |    9 +++++++++
 4 files changed, 18 insertions(+), 13 deletions(-)

--- a/arch/s390/include/asm/asm-extable.h
+++ b/arch/s390/include/asm/asm-extable.h
@@ -14,6 +14,7 @@
 #define EX_TYPE_UA_LOAD_REG	5
 #define EX_TYPE_UA_LOAD_REGPAIR	6
 #define EX_TYPE_ZEROPAD		7
+#define EX_TYPE_FPC		8
 
 #define EX_DATA_REG_ERR_SHIFT	0
 #define EX_DATA_REG_ERR		GENMASK(3, 0)
@@ -84,4 +85,7 @@
 #define EX_TABLE_ZEROPAD(_fault, _target, _regdata, _regaddr)		\
 	__EX_TABLE(__ex_table, _fault, _target, EX_TYPE_ZEROPAD, _regdata, _regaddr, 0)
 
+#define EX_TABLE_FPC(_fault, _target)					\
+	__EX_TABLE(__ex_table, _fault, _target, EX_TYPE_FPC, __stringify(%%r0), __stringify(%%r0), 0)
+
 #endif /* __ASM_EXTABLE_H */
--- a/arch/s390/include/asm/fpu-insn.h
+++ b/arch/s390/include/asm/fpu-insn.h
@@ -100,19 +100,12 @@ static __always_inline void fpu_lfpc(uns
  */
 static inline void fpu_lfpc_safe(unsigned int *fpc)
 {
-	u32 tmp;
-
 	instrument_read(fpc, sizeof(*fpc));
-	asm volatile("\n"
-		"0:	lfpc	%[fpc]\n"
-		"1:	nopr	%%r7\n"
-		".pushsection .fixup, \"ax\"\n"
-		"2:	lghi	%[tmp],0\n"
-		"	sfpc	%[tmp]\n"
-		"	jg	1b\n"
-		".popsection\n"
-		EX_TABLE(1b, 2b)
-		: [tmp] "=d" (tmp)
+	asm_inline volatile(
+		"	lfpc	%[fpc]\n"
+		"0:	nopr	%%r7\n"
+		EX_TABLE_FPC(0b, 0b)
+		:
 		: [fpc] "Q" (*fpc)
 		: "memory");
 }
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -52,7 +52,6 @@ SECTIONS
 		SOFTIRQENTRY_TEXT
 		FTRACE_HOTPATCH_TRAMPOLINES_TEXT
 		*(.text.*_indirect_*)
-		*(.fixup)
 		*(.gnu.warning)
 		. = ALIGN(PAGE_SIZE);
 		_etext = .;		/* End of text section */
--- a/arch/s390/mm/extable.c
+++ b/arch/s390/mm/extable.c
@@ -77,6 +77,13 @@ static bool ex_handler_zeropad(const str
 	return true;
 }
 
+static bool ex_handler_fpc(const struct exception_table_entry *ex, struct pt_regs *regs)
+{
+	asm volatile("sfpc	%[val]\n" : : [val] "d" (0));
+	regs->psw.addr = extable_fixup(ex);
+	return true;
+}
+
 bool fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *ex;
@@ -99,6 +106,8 @@ bool fixup_exception(struct pt_regs *reg
 		return ex_handler_ua_load_reg(ex, true, regs);
 	case EX_TYPE_ZEROPAD:
 		return ex_handler_zeropad(ex, regs);
+	case EX_TYPE_FPC:
+		return ex_handler_fpc(ex, regs);
 	}
 	panic("invalid exception table entry");
 }


