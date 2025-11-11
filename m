Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6001F419F;
	Tue, 11 Nov 2025 01:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824680; cv=none; b=nmS1BewMfUeJX9S3V7eNaPZSXeuFSchhA66dp9Yhhu4h/AzCNLcyckQD3LkfTn+zVKkYLoDfR2ElgAYBzg6dA7b3mE3017dCLNki4osiUcHvOPBOhDXuFsUThV43kCnpHJSmgr1AKIVEm1o8PJOueZzvrErFRrEPSdtNY1Ds8Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824680; c=relaxed/simple;
	bh=e7rW7qSX9cFCWm+CqUnTj4Xy9wtcix9cYVp8AEQkcqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9pZU3RLpyDg6oiyXcQHaXIPMKVFJo0vWkt2eHBHbl+D2qWhFawsthUOha0PXkIN9oboS/aKrMSjJxxuQGIR8IwPxQYwgCqB7heBWAgaxTzny1sAP+A1AuiXyUN5ZPZFCPhSTZOLf6NYUOGOuD79RxslNE3W/VWOILhiumQEr78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YID9aUrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YID9aUrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CB1C19422;
	Tue, 11 Nov 2025 01:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824680;
	bh=e7rW7qSX9cFCWm+CqUnTj4Xy9wtcix9cYVp8AEQkcqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YID9aUrQNkytWQNDSZ53XzI3JIHEuxqWRhHKhin4KkXIbOGZuCAKWnEQbJ9GH4Wwq
	 JXRkn01sXHGax4Rfh9uHXV8DCC/3aIrZPttm+AStL5ZEe55uyxd9/JJLtpu01rwIkb
	 FJw1LK4zMhu2t+7XHsX74hGzg1BaxYj4BViOWRfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 497/565] x86/runtime-const: Add the RUNTIME_CONST_PTR assembly macro
Date: Tue, 11 Nov 2025 09:45:53 +0900
Message-ID: <20251111004538.118878049@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[ Upstream commit bd72baff229920da1d57c14364c11ecdbaf5b458 ]

Add an assembly macro to refer runtime cost. It hides linker magic and
makes assembly more readable.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250304153342.2016569-1-kirill.shutemov@linux.intel.com
Stable-dep-of: 284922f4c563 ("x86: uaccess: don't use runtime-const rewriting in modules")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/runtime-const.h | 13 +++++++++++++
 arch/x86/lib/getuser.S               |  7 ++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/runtime-const.h b/arch/x86/include/asm/runtime-const.h
index 6652ebddfd02f..8d983cfd06ea6 100644
--- a/arch/x86/include/asm/runtime-const.h
+++ b/arch/x86/include/asm/runtime-const.h
@@ -2,6 +2,18 @@
 #ifndef _ASM_RUNTIME_CONST_H
 #define _ASM_RUNTIME_CONST_H
 
+#ifdef __ASSEMBLY__
+
+.macro RUNTIME_CONST_PTR sym reg
+	movq	$0x0123456789abcdef, %\reg
+	1:
+	.pushsection runtime_ptr_\sym, "a"
+	.long	1b - 8 - .
+	.popsection
+.endm
+
+#else /* __ASSEMBLY__ */
+
 #define runtime_const_ptr(sym) ({				\
 	typeof(sym) __ret;					\
 	asm_inline("mov %1,%0\n1:\n"				\
@@ -58,4 +70,5 @@ static inline void runtime_const_fixup(void (*fn)(void *, unsigned long),
 	}
 }
 
+#endif /* __ASSEMBLY__ */
 #endif
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index 89ecd57c9d423..853a2e6287698 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -34,16 +34,13 @@
 #include <asm/thread_info.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
+#include <asm/runtime-const.h>
 
 #define ASM_BARRIER_NOSPEC ALTERNATIVE "", "lfence", X86_FEATURE_LFENCE_RDTSC
 
 .macro check_range size:req
 .if IS_ENABLED(CONFIG_X86_64)
-	movq $0x0123456789abcdef,%rdx
-  1:
-  .pushsection runtime_ptr_USER_PTR_MAX,"a"
-	.long 1b - 8 - .
-  .popsection
+	RUNTIME_CONST_PTR USER_PTR_MAX, rdx
 	cmp %rdx, %rax
 	cmova %rdx, %rax
 .else
-- 
2.51.0



