Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764CC256C72;
	Wed,  5 Mar 2025 18:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198769; cv=none; b=nXmSOegybgWWOjaiMuyqdYosT4QuOwoASDLizWPaqa2rIAJyS4+aYrklgwyZqtWVfiP2wPDNsAO4EVHHAceiTeJvtB4HFzdNfSMnAjb4AwSBE+jqL3HEQZ2qe+dsZzdJ07RskrKiCxMBy+jw9gyyDYcvROhHVwGVgw0OaYBpOho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198769; c=relaxed/simple;
	bh=e+YSKygURuMCwZvEtTgp4SZU3F0f6+BncZDrhWo4y9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIxxyoRhuPbN5d5V49jwsuIxCsdIpEeRK7Qym1GJlfJ7DmTKFvG0OyLnlNe8pBjCavP8Zxp+QxAXKt9dgPPvyVtrl4hPHmbn7+1qVJKu4TQUfMqISZpI0Jc/jqwGHJZI1wSSKzP+9k5QHI/1HhhhAzNDDz5eetHW3TerXvr9NH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9aoPy7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9aoPy7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1330C4CED1;
	Wed,  5 Mar 2025 18:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198769;
	bh=e+YSKygURuMCwZvEtTgp4SZU3F0f6+BncZDrhWo4y9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9aoPy7GhoF8CiaVUi+op2vybfRif+T7r9ABONT/H8/QTyCpVNxNzgkMZg29WjIaI
	 MWVoBAxCw5C3DchMSM2hUiD7yycG48bTol3h5l4p3rxSTJYRZI+Y2zxTJtR1Gkla8l
	 Fj6YgROQcMtMNHxq6wP7I1L17Kyb/vPdZG8yResQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stafford Horne <shorne@gmail.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.13 142/157] rseq/selftests: Fix riscv rseq_offset_deref_addv inline asm
Date: Wed,  5 Mar 2025 18:49:38 +0100
Message-ID: <20250305174511.009961816@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

From: Stafford Horne <shorne@gmail.com>

commit 713e788c0e07e185fd44dd581f74855ef149722f upstream.

When working on OpenRISC support for restartable sequences I noticed
and fixed these two issues with the riscv support bits.

 1 The 'inc' argument to RSEQ_ASM_OP_R_DEREF_ADDV was being implicitly
   passed to the macro.  Fix this by adding 'inc' to the list of macro
   arguments.
 2 The inline asm input constraints for 'inc' and 'off' use "er",  The
   riscv gcc port does not have an "e" constraint, this looks to be
   copied from the x86 port.  Fix this by just using an "r" constraint.

I have compile tested this only for riscv.  However, the same fixes I
use in the OpenRISC rseq selftests and everything passes with no issues.

Fixes: 171586a6ab66 ("selftests/rseq: riscv: Template memory ordering and percpu access mode")
Signed-off-by: Stafford Horne <shorne@gmail.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250114170721.3613280-1-shorne@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq-riscv-bits.h |    6 +++---
 tools/testing/selftests/rseq/rseq-riscv.h      |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/rseq/rseq-riscv-bits.h
+++ b/tools/testing/selftests/rseq/rseq-riscv-bits.h
@@ -243,7 +243,7 @@ int RSEQ_TEMPLATE_IDENTIFIER(rseq_offset
 #ifdef RSEQ_COMPARE_TWICE
 				  RSEQ_ASM_CMP_CPU_ID(cpu_id, current_cpu_id, "%l[error1]")
 #endif
-				  RSEQ_ASM_OP_R_DEREF_ADDV(ptr, off, 3)
+				  RSEQ_ASM_OP_R_DEREF_ADDV(ptr, off, inc, 3)
 				  RSEQ_INJECT_ASM(4)
 				  RSEQ_ASM_DEFINE_ABORT(4, abort)
 				  : /* gcc asm goto does not allow outputs */
@@ -251,8 +251,8 @@ int RSEQ_TEMPLATE_IDENTIFIER(rseq_offset
 				    [current_cpu_id]		"m" (rseq_get_abi()->RSEQ_TEMPLATE_CPU_ID_FIELD),
 				    [rseq_cs]			"m" (rseq_get_abi()->rseq_cs.arch.ptr),
 				    [ptr]			"r" (ptr),
-				    [off]			"er" (off),
-				    [inc]			"er" (inc)
+				    [off]			"r" (off),
+				    [inc]			"r" (inc)
 				    RSEQ_INJECT_INPUT
 				  : "memory", RSEQ_ASM_TMP_REG_1
 				    RSEQ_INJECT_CLOBBER
--- a/tools/testing/selftests/rseq/rseq-riscv.h
+++ b/tools/testing/selftests/rseq/rseq-riscv.h
@@ -158,7 +158,7 @@ do {									\
 	"bnez	" RSEQ_ASM_TMP_REG_1 ", 222b\n"				\
 	"333:\n"
 
-#define RSEQ_ASM_OP_R_DEREF_ADDV(ptr, off, post_commit_label)		\
+#define RSEQ_ASM_OP_R_DEREF_ADDV(ptr, off, inc, post_commit_label)	\
 	"mv	" RSEQ_ASM_TMP_REG_1 ", %[" __rseq_str(ptr) "]\n"	\
 	RSEQ_ASM_OP_R_ADD(off)						\
 	REG_L	  RSEQ_ASM_TMP_REG_1 ", 0(" RSEQ_ASM_TMP_REG_1 ")\n"	\


