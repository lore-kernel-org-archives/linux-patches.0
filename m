Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752AA86334;
	Thu, 15 Jan 2026 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498659; cv=none; b=jdq8BMim7iBG0TooWI+PuiCcH4vbwhDAlR4rKZGwfvQ3jLPF3HJ6zoC0BIYRZYmL556Wd6sNsNnGOBER18Pc6njonuSMV8fiFmwkraa2dikFtmmv9LoPD/WT2MwWUcwsOPclJTDeiFsUw7vS4mqIrnwseuzlhC5zf6bdvlh8Vwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498659; c=relaxed/simple;
	bh=jrRX4xtwaCelAvKieE7lker8VVnfxK+Lotlh/HLZTK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej5sBswsHjSeiCDQv6HV8iICQJdf6PoOkqkli2CCxMbFCQfEDge3dEF6MrVp0OlhV7OBgp2FwwzkEP55zVS8nzT6NzUcEOJRzNsYrZOPES76MPSq9zyMKt6okQpWRmE7LTSRriX7nGI8a4mFYvKA7s8/UMMZVbuy1ZPfCvKmuSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5alk2h8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5alk2h8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3322C116D0;
	Thu, 15 Jan 2026 17:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498659;
	bh=jrRX4xtwaCelAvKieE7lker8VVnfxK+Lotlh/HLZTK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5alk2h8+nbhiD6AFZ+t9TGpThYN+bx/e6JKGScu0Ho+7QDQdQOon3chGcvhoE+53
	 W8zbwSAnVN0gIcgXVa5/k0sLIENFzEY3Bxo+hXFIMER8H2WbF8VFu9QA2f48O7sMCj
	 TZhtOZnuoKiVZt+g7bMwJwCckDmVWVsQCm71ybiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 492/554] x86: remove __range_not_ok()
Date: Thu, 15 Jan 2026 17:49:18 +0100
Message-ID: <20260115164304.125289275@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 36903abedfe8d419e90ce349b2b4ce6dc2883e17 upstream.

The __range_not_ok() helper is an x86 (and sparc64) specific interface
that does roughly the same thing as __access_ok(), but with different
calling conventions.

Change this to use the normal interface in order for consistency as we
clean up all access_ok() implementations.

This changes the limit from TASK_SIZE to TASK_SIZE_MAX, which Al points
out is the right thing do do here anyway.

The callers have to use __access_ok() instead of the normal access_ok()
though, because on x86 that contains a WARN_ON_IN_IRQ() check that cannot
be used inside of NMI context while tracing.

The check in copy_code() is not needed any more, because this one is
already done by copy_from_user_nmi().

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Link: https://lore.kernel.org/lkml/YgsUKcXGR7r4nINj@zeniv-ca.linux.org.uk/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Stable-dep-of: d319f344561d ("mm: Fix copy_from_user_nofault().")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/core.c         |    2 +-
 arch/x86/include/asm/uaccess.h |   10 ++++++----
 arch/x86/kernel/dumpstack.c    |    6 ------
 arch/x86/kernel/stacktrace.c   |    2 +-
 arch/x86/lib/usercopy.c        |    2 +-
 5 files changed, 9 insertions(+), 13 deletions(-)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2790,7 +2790,7 @@ perf_callchain_kernel(struct perf_callch
 static inline int
 valid_user_frame(const void __user *fp, unsigned long size)
 {
-	return (__range_not_ok(fp, size, TASK_SIZE) == 0);
+	return __access_ok(fp, size);
 }
 
 static unsigned long get_segment_base(unsigned int segment)
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -16,8 +16,10 @@
  * Test whether a block of memory is a valid user space address.
  * Returns 0 if the range is valid, nonzero otherwise.
  */
-static inline bool __chk_range_not_ok(unsigned long addr, unsigned long size, unsigned long limit)
+static inline bool __chk_range_not_ok(unsigned long addr, unsigned long size)
 {
+	unsigned long limit = TASK_SIZE_MAX;
+
 	/*
 	 * If we have used "sizeof()" for the size,
 	 * we know it won't overflow the limit (but
@@ -35,10 +37,10 @@ static inline bool __chk_range_not_ok(un
 	return unlikely(addr > limit);
 }
 
-#define __range_not_ok(addr, size, limit)				\
+#define __access_ok(addr, size)						\
 ({									\
 	__chk_user_ptr(addr);						\
-	__chk_range_not_ok((unsigned long __force)(addr), size, limit); \
+	!__chk_range_not_ok((unsigned long __force)(addr), size);	\
 })
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
@@ -69,7 +71,7 @@ static inline bool pagefault_disabled(vo
 #define access_ok(addr, size)					\
 ({									\
 	WARN_ON_IN_IRQ();						\
-	likely(!__range_not_ok(addr, size, TASK_SIZE_MAX));		\
+	likely(__access_ok(addr, size));				\
 })
 
 extern int __get_user_1(void);
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -81,12 +81,6 @@ static int copy_code(struct pt_regs *reg
 	/* The user space code from other tasks cannot be accessed. */
 	if (regs != task_pt_regs(current))
 		return -EPERM;
-	/*
-	 * Make sure userspace isn't trying to trick us into dumping kernel
-	 * memory by pointing the userspace instruction pointer at it.
-	 */
-	if (__chk_range_not_ok(src, nbytes, TASK_SIZE_MAX))
-		return -EINVAL;
 
 	/*
 	 * Even if named copy_from_user_nmi() this can be invoked from
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -90,7 +90,7 @@ copy_stack_frame(const struct stack_fram
 {
 	int ret;
 
-	if (__range_not_ok(fp, sizeof(*frame), TASK_SIZE))
+	if (!__access_ok(fp, sizeof(*frame)))
 		return 0;
 
 	ret = 1;
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -32,7 +32,7 @@ copy_from_user_nmi(void *to, const void
 {
 	unsigned long ret;
 
-	if (__range_not_ok(from, n, TASK_SIZE))
+	if (!__access_ok(from, n))
 		return n;
 
 	if (!nmi_uaccess_okay())


