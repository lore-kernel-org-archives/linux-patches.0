Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FC915CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA62C433C1;
	Tue,  8 Nov 2022 13:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915083;
	bh=DWFcZWy7JG1QE8hN3qHpjStmrS/DwWtUblJR9K7w0Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfbSw2pcChPUzwlDLGUkuf9376jjCznSNqTKL5YIS0DYYraA/Hy14PB2ylK5m4igc
	 WD7wn3jPRgoONyYvZEPQCJsUiu0oVSc9jUqDB79mCD/qWHHUWSVPWolgmqHr4gsNq1
	 iU1vp9m8+Wa1RZJ/R2BCAk5DwndQsTZ9yIpu0cqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Guan Xuetao <gxt@mprc.pku.edu.cn>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	David Howells <dhowells@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Will Deacon <will.deacon@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.14 38/40] linux/const.h: move UL() macro to include/linux/const.h
Date: Tue,  8 Nov 2022 14:39:23 +0100
Message-Id: <20221108133329.748972060@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 2dd8a62c647691161a2346546834262597739872 upstream.

ARM, ARM64 and UniCore32 duplicate the definition of UL():

  #define UL(x) _AC(x, UL)

This is not actually arch-specific, so it will be useful to move it to a
common header.  Currently, we only have the uapi variant for
linux/const.h, so I am creating include/linux/const.h.

I also added _UL(), _ULL() and ULL() because _AC() is mostly used in
the form either _AC(..., UL) or _AC(..., ULL).  I expect they will be
replaced in follow-up cleanups.  The underscore-prefixed ones should
be used for exported headers.

Link: http://lkml.kernel.org/r/1519301715-31798-4-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/memory.h       |    6 ------
 arch/arm64/include/asm/memory.h     |    6 ------
 arch/unicore32/include/asm/memory.h |    6 ------
 include/linux/const.h               |    9 +++++++++
 include/uapi/linux/const.h          |    3 +++
 5 files changed, 12 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/const.h

--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -22,12 +22,6 @@
 #include <mach/memory.h>
 #endif
 
-/*
- * Allow for constants defined here to be used from assembly code
- * by prepending the UL suffix only with actual C code compilation.
- */
-#define UL(x) _AC(x, UL)
-
 /* PAGE_OFFSET - the virtual address of the start of the kernel image */
 #define PAGE_OFFSET		UL(CONFIG_PAGE_OFFSET)
 
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -29,12 +29,6 @@
 #include <asm/sizes.h>
 
 /*
- * Allow for constants defined here to be used from assembly code
- * by prepending the UL suffix only with actual C code compilation.
- */
-#define UL(x) _AC(x, UL)
-
-/*
  * Size of the PCI I/O space. This must remain a power of two so that
  * IO_SPACE_LIMIT acts as a mask for the low bits of I/O addresses.
  */
--- a/arch/unicore32/include/asm/memory.h
+++ b/arch/unicore32/include/asm/memory.h
@@ -20,12 +20,6 @@
 #include <mach/memory.h>
 
 /*
- * Allow for constants defined here to be used from assembly code
- * by prepending the UL suffix only with actual C code compilation.
- */
-#define UL(x) _AC(x, UL)
-
-/*
  * PAGE_OFFSET - the virtual address of the start of the kernel image
  * TASK_SIZE - the maximum size of a user space task.
  * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area
--- /dev/null
+++ b/include/linux/const.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_CONST_H
+#define _LINUX_CONST_H
+
+#include <uapi/linux/const.h>
+
+#define UL(x)		(_UL(x))
+#define ULL(x)		(_ULL(x))
+
+#endif /* _LINUX_CONST_H */
--- a/include/uapi/linux/const.h
+++ b/include/uapi/linux/const.h
@@ -22,6 +22,9 @@
 #define _AT(T,X)	((T)(X))
 #endif
 
+#define _UL(x)		(_AC(x, UL))
+#define _ULL(x)		(_AC(x, ULL))
+
 #define _BITUL(x)	(_AC(1,UL) << (x))
 #define _BITULL(x)	(_AC(1,ULL) << (x))
 


