Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A891E4B2;
	Wed, 21 Feb 2024 13:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522277; cv=none; b=j9W4l0+RPcXkgNp3XN2/gymoq16TEU5nGd99u21Ncdw1guJzmweU7WPOXu9HNL+/ELs8u3Tg9290lUTWaMH/jxbQbot6Ks6i4ZzeVAMhEbLN3nyQPZid5zAy4uxbuSXji8aATzTq7oDYIzFgMcWxLmDOf1jMEYTP6VMg+9o2afQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522277; c=relaxed/simple;
	bh=989gM96XgIKTUE9B/cBqzUIWtwkzvtIzYaIpSmjF8nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTe7jtbLLs7d4i/8zdhgkBq1HVzR14R/TbHf+WjMBR09rpHEa5QLT57uQ8DumP26k3TueoxI4Vc0MD1WYZvMSu3zMReg4gn/91yNhE14n9fmzJJcp22xfPCLZTMdshjTfZCFEZrj6b58dopkrVFwHo11jOasoajy4wQDfhALJDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PATvD2Mw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PATvD2Mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BA8C433F1;
	Wed, 21 Feb 2024 13:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522277;
	bh=989gM96XgIKTUE9B/cBqzUIWtwkzvtIzYaIpSmjF8nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PATvD2Mw/QJr/+6Be7DNqHXVtvB75mCaQVqoxBOweLgZCvkJo4bvjvy2n/FYIC7xA
	 5ypvJVZyxpXh/srjEPP77a0Tr257AsqGScp0/udEaclkk/5eORI96EAd0uNCNS7Ju8
	 auKvVyxwvAu2ameHi5Ip8MRMqB14/8nmfpA9xWwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Richard Palethorpe <rpalethorpe@suse.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 124/476] x86/entry/ia32: Ensure s32 is sign extended to s64
Date: Wed, 21 Feb 2024 14:02:55 +0100
Message-ID: <20240221130012.558262023@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Palethorpe <rpalethorpe@suse.com>

commit 56062d60f117dccfb5281869e0ab61e090baf864 upstream.

Presently ia32 registers stored in ptregs are unconditionally cast to
unsigned int by the ia32 stub. They are then cast to long when passed to
__se_sys*, but will not be sign extended.

This takes the sign of the syscall argument into account in the ia32
stub. It still casts to unsigned int to avoid implementation specific
behavior. However then casts to int or unsigned int as necessary. So that
the following cast to long sign extends the value.

This fixes the io_pgetevents02 LTP test when compiled with -m32. Presently
the systemcall io_pgetevents_time64() unexpectedly accepts -1 for the
maximum number of events.

It doesn't appear other systemcalls with signed arguments are effected
because they all have compat variants defined and wired up.

Fixes: ebeb8c82ffaf ("syscalls/x86: Use 'struct pt_regs' based syscall calling for IA32_EMULATION and x32")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240110130122.3836513-1-nik.borisov@suse.com
Link: https://lore.kernel.org/ltp/20210921130127.24131-1-rpalethorpe@suse.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/syscall_wrapper.h |   25 +++++++++++++++++++++----
 include/linux/syscalls.h               |    1 +
 2 files changed, 22 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/syscall_wrapper.h
+++ b/arch/x86/include/asm/syscall_wrapper.h
@@ -58,12 +58,29 @@ extern long __ia32_sys_ni_syscall(const
 		,,regs->di,,regs->si,,regs->dx				\
 		,,regs->r10,,regs->r8,,regs->r9)			\
 
+
+/* SYSCALL_PT_ARGS is Adapted from s390x */
+#define SYSCALL_PT_ARG6(m, t1, t2, t3, t4, t5, t6)			\
+	SYSCALL_PT_ARG5(m, t1, t2, t3, t4, t5), m(t6, (regs->bp))
+#define SYSCALL_PT_ARG5(m, t1, t2, t3, t4, t5)				\
+	SYSCALL_PT_ARG4(m, t1, t2, t3, t4),  m(t5, (regs->di))
+#define SYSCALL_PT_ARG4(m, t1, t2, t3, t4)				\
+	SYSCALL_PT_ARG3(m, t1, t2, t3),  m(t4, (regs->si))
+#define SYSCALL_PT_ARG3(m, t1, t2, t3)					\
+	SYSCALL_PT_ARG2(m, t1, t2), m(t3, (regs->dx))
+#define SYSCALL_PT_ARG2(m, t1, t2)					\
+	SYSCALL_PT_ARG1(m, t1), m(t2, (regs->cx))
+#define SYSCALL_PT_ARG1(m, t1) m(t1, (regs->bx))
+#define SYSCALL_PT_ARGS(x, ...) SYSCALL_PT_ARG##x(__VA_ARGS__)
+
+#define __SC_COMPAT_CAST(t, a)						\
+	(__typeof(__builtin_choose_expr(__TYPE_IS_L(t), 0, 0U)))	\
+	(unsigned int)a
+
 /* Mapping of registers to parameters for syscalls on i386 */
 #define SC_IA32_REGS_TO_ARGS(x, ...)					\
-	__MAP(x,__SC_ARGS						\
-	      ,,(unsigned int)regs->bx,,(unsigned int)regs->cx		\
-	      ,,(unsigned int)regs->dx,,(unsigned int)regs->si		\
-	      ,,(unsigned int)regs->di,,(unsigned int)regs->bp)
+	SYSCALL_PT_ARGS(x, __SC_COMPAT_CAST,				\
+			__MAP(x, __SC_TYPE, __VA_ARGS__))		\
 
 #define __SYS_STUB0(abi, name)						\
 	long __##abi##_##name(const struct pt_regs *regs);		\
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -122,6 +122,7 @@ enum landlock_rule_type;
 #define __TYPE_IS_LL(t) (__TYPE_AS(t, 0LL) || __TYPE_AS(t, 0ULL))
 #define __SC_LONG(t, a) __typeof(__builtin_choose_expr(__TYPE_IS_LL(t), 0LL, 0L)) a
 #define __SC_CAST(t, a)	(__force t) a
+#define __SC_TYPE(t, a)	t
 #define __SC_ARGS(t, a)	a
 #define __SC_TEST(t, a) (void)BUILD_BUG_ON_ZERO(!__TYPE_IS_LL(t) && sizeof(t) > sizeof(long))
 


