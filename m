Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB9C45C1C;
	Mon, 14 Oct 2024 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918517; cv=none; b=uGrt+39ySgFwAwM3KRTtRVT2IpYHF53zwY65hMvOI63wnSQv+Q5MEwdoAWXtEr61DotvhmWvrHnr2PfytLyw/uAuYAqFIIAZoNUh7eNUk+f2+cVE+WSgU1HP/HvwrmZLgafQ7Z6Go46pnveEcr887zz5owXkYBOJxrSlfrHlTd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918517; c=relaxed/simple;
	bh=ZR7cfMakUyqACl12pA5VKt6JNTbazR/HPYwYqua0hEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHW4g9tY2XynCIgM4YlXXsVdjW5vIchCUxxVvIHdty0qmfCEfMd7YHJODhHxhw8MwYtwnsTuYQ0dhLLvbE2CuMv3FQehodgXuew8pDE8m2dGJNdFBmeOSATzGTnaxZYsfQIvN8+OzL/zPbRpk50+4+SQSURnUkpXjL6gBRbGK+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpyXTzx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpyXTzx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530DCC4CEC7;
	Mon, 14 Oct 2024 15:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918517;
	bh=ZR7cfMakUyqACl12pA5VKt6JNTbazR/HPYwYqua0hEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpyXTzx/I6fNKE+/GwEdOXzzzIXr3KMxw7LEg+8TFKIAlWvp9aDOIMVttxb4PE77d
	 F4cLQ6sARtYIiVQ8YfTYi8fIS2cXgvlAy29hWjpSy87Hz2qZqnrR7ewJulO34aup9T
	 eShLi/oT3H8O2IImHdvhF74aoqPTHhEu8NLBwk/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Mina Almasry <almasrymina@google.com>,
	Segher Boessenkool <segher@kernel.crashing.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 345/798] powerpc/atomic: Use YZ constraints for DS-form instructions
Date: Mon, 14 Oct 2024 16:14:59 +0200
Message-ID: <20241014141231.502078707@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 39190ac7cff1fd15135fa8e658030d9646fdb5f2 ]

The 'ld' and 'std' instructions require a 4-byte aligned displacement
because they are DS-form instructions. But the "m" asm constraint
doesn't enforce that.

That can lead to build errors if the compiler chooses a non-aligned
displacement, as seen with GCC 14:

  /tmp/ccuSzwiR.s: Assembler messages:
  /tmp/ccuSzwiR.s:2579: Error: operand out of domain (39 is not a multiple of 4)
  make[5]: *** [scripts/Makefile.build:229: net/core/page_pool.o] Error 1

Dumping the generated assembler shows:

  ld 8,39(8)       # MEM[(const struct atomic64_t *)_29].counter, t

Use the YZ constraints to tell the compiler either to generate a DS-form
displacement, or use an X-form instruction, either of which prevents the
build error.

See commit 2d43cc701b96 ("powerpc/uaccess: Fix build errors seen with
GCC 13/14") for more details on the constraint letters.

Fixes: 9f0cbea0d8cc ("[POWERPC] Implement atomic{, 64}_{read, write}() without volatile")
Cc: stable@vger.kernel.org # v2.6.24+
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20240913125302.0a06b4c7@canb.auug.org.au
Tested-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240916120510.2017749-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/asm-compat.h | 6 ++++++
 arch/powerpc/include/asm/atomic.h     | 5 +++--
 arch/powerpc/include/asm/uaccess.h    | 7 +------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/asm-compat.h b/arch/powerpc/include/asm/asm-compat.h
index 2bc53c646ccd7..83848b534cb17 100644
--- a/arch/powerpc/include/asm/asm-compat.h
+++ b/arch/powerpc/include/asm/asm-compat.h
@@ -39,6 +39,12 @@
 #define STDX_BE	stringify_in_c(stdbrx)
 #endif
 
+#ifdef CONFIG_CC_IS_CLANG
+#define DS_FORM_CONSTRAINT "Z<>"
+#else
+#define DS_FORM_CONSTRAINT "YZ<>"
+#endif
+
 #else /* 32-bit */
 
 /* operations for longs and pointers */
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index 50212c44be2a9..33742fec25c1b 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -11,6 +11,7 @@
 #include <asm/cmpxchg.h>
 #include <asm/barrier.h>
 #include <asm/asm-const.h>
+#include <asm/asm-compat.h>
 
 /*
  * Since *_return_relaxed and {cmp}xchg_relaxed are implemented with
@@ -238,7 +239,7 @@ static __inline__ s64 arch_atomic64_read(const atomic64_t *v)
 	if (IS_ENABLED(CONFIG_PPC_KERNEL_PREFIXED))
 		__asm__ __volatile__("ld %0,0(%1)" : "=r"(t) : "b"(&v->counter));
 	else
-		__asm__ __volatile__("ld%U1%X1 %0,%1" : "=r"(t) : "m<>"(v->counter));
+		__asm__ __volatile__("ld%U1%X1 %0,%1" : "=r"(t) : DS_FORM_CONSTRAINT (v->counter));
 
 	return t;
 }
@@ -249,7 +250,7 @@ static __inline__ void arch_atomic64_set(atomic64_t *v, s64 i)
 	if (IS_ENABLED(CONFIG_PPC_KERNEL_PREFIXED))
 		__asm__ __volatile__("std %1,0(%2)" : "=m"(v->counter) : "r"(i), "b"(&v->counter));
 	else
-		__asm__ __volatile__("std%U0%X0 %1,%0" : "=m<>"(v->counter) : "r"(i));
+		__asm__ __volatile__("std%U0%X0 %1,%0" : "=" DS_FORM_CONSTRAINT (v->counter) : "r"(i));
 }
 
 #define ATOMIC64_OP(op, asm_op)						\
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 2d17f1193b25c..63e7c3107cc88 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -6,6 +6,7 @@
 #include <asm/page.h>
 #include <asm/extable.h>
 #include <asm/kup.h>
+#include <asm/asm-compat.h>
 
 #ifdef __powerpc64__
 /* We use TASK_SIZE_USER64 as TASK_SIZE is not constant */
@@ -92,12 +93,6 @@ __pu_failed:							\
 		: label)
 #endif
 
-#ifdef CONFIG_CC_IS_CLANG
-#define DS_FORM_CONSTRAINT "Z<>"
-#else
-#define DS_FORM_CONSTRAINT "YZ<>"
-#endif
-
 #ifdef __powerpc64__
 #define __put_user_asm2_goto(x, addr, label)			\
 	asm goto ("1: std%U1%X1 %0,%1	# put_user\n"		\
-- 
2.43.0



