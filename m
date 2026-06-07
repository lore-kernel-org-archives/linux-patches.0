Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214651FE47B;
	Sun,  7 Jun 2026 10:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828355; cv=none; b=uJbrfwRYZG3PINhO0754Zvt1FgCl3ECTgRV48QD9gur1fW1npIoqGCfo4Yfvkc1bVh1rs9W7ZDkH3bj8P5RkQFwllXHHlKDIifCMbVU2xicagombHPFcRc+jWlJLbXKcI3RezO7mgP4Z5uM72Q4NX+4YeITiHx5qeFMhZwqIhyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828355; c=relaxed/simple;
	bh=sVq3wJAw7CTzFqEp2vUDQpkuhJOUHkaKIBNhmoHqDeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz5mkZqqdH/AQIjmS7XC9RWhg5Y1kY24jkgAh5w/H1oRbnaaYWh1DK+3uaKrIgtk+MNGhR4Ysane0Oqsk4cRug09SzMOJrOsuZEFy3ta5IkbHiMoJ+rwIn2oivxizmMrzGnD+Vy4flMXXTtnC5i4SQ8tZz7ldJhLPQae9CUPFcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tsjcuku5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tsjcuku5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD8F1F00893;
	Sun,  7 Jun 2026 10:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828353;
	bh=P6dbCCIGK3NZP0qtF+EUf08NuwpHsLSrhG/Hi+cHqv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tsjcuku51CDKdxN6QiPUqPS0NXDRcqUf9nNNK6TzmQbW4rfmQKVYZl+wYLDIHnv5u
	 qeNyx6FzoCs6l8fw9dUUBV6H6rO0irhhOnPlr5VzoU1/LX2+g7c+YoXvrrWFXacH2u
	 7O6PG1LqwiaGbMvsltL4AmoEgN3v+plFHEucMNGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.18 152/315] Disable -Wattribute-alias for clang-23 and newer
Date: Sun,  7 Jun 2026 11:58:59 +0200
Message-ID: <20260607095733.189792177@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 175db11786bde9061db526bf1ac5107d915f5163 upstream.

Clang recently added support for -Wattribute-alias [1], which results in
the same warnings that necessitated commit bee20031772a ("disable
-Wattribute-alias warning for SYSCALL_DEFINEx()") for GCC.

  kernel/time/itimer.c:325:1: error: alias and aliasee have different types 'long (unsigned int)' and 'long (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((unsigned int)0), typeof (0LL)) || __builtin_types_compatible_p(typeof ((unsigned int)0), typeof (0ULL))), 0LL, 0L)))' (aka 'long (long)') [-Werror,-Wattribute-alias]
    325 | SYSCALL_DEFINE1(alarm, unsigned int, seconds)
        | ^
  include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
    225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
        |                                    ^
  include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
    236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
        |         ^
  include/linux/syscalls.h:251:18: note: expanded from macro '__SYSCALL_DEFINEx'
    251 |                 __attribute__((alias(__stringify(__se_sys##name))));    \
        |                                ^
  kernel/time/itimer.c:325:1: note: aliasee is declared here
  include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
    225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
        |                                    ^
  include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
    236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
        |         ^
  include/linux/syscalls.h:255:18: note: expanded from macro '__SYSCALL_DEFINEx'
    255 |         asmlinkage long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))  \
        |                         ^
  <scratch space>:16:1: note: expanded from here
     16 | __se_sys_alarm
        | ^

Disable the warnings in the same way for clang-23 and newer. Disable the
warning about unknown warning options to avoid breaking the build for
versions of clang-23 that do not have -Wattribute-alias, such as ones
deployed by vendors like Android or CI systems or when bisecting LLVM
between llvmorg-23-init and release/23.x.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2163
Link: https://github.com/llvm/llvm-project/commit/40da6920a0d71d49dfa2392b09153600b0759f5e [1]
Link: https://patch.msgid.link/20260515-syscall-disable-attribute-alias-for-clang-v1-1-9a9d95d41df6@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/syscall_wrapper.h |    4 ++++
 include/linux/compat.h                   |    4 ++++
 include/linux/compiler-clang.h           |    6 ++++++
 include/linux/compiler_types.h           |    4 ++++
 include/linux/syscalls.h                 |    4 ++++
 5 files changed, 22 insertions(+)

--- a/arch/riscv/include/asm/syscall_wrapper.h
+++ b/arch/riscv/include/asm/syscall_wrapper.h
@@ -32,6 +32,10 @@ asmlinkage long __riscv_sys_ni_syscall(c
 	__diag_push();									\
 	__diag_ignore(GCC, 8, "-Wattribute-alias",					\
 			"Type aliasing is used to sanitize syscall arguments");		\
+	__diag_ignore(clang, 23, "-Wunknown-warning-option",				\
+		      "Avoid breaking versions without -Wattribute-alias");		\
+	__diag_ignore(clang, 23, "-Wattribute-alias",					\
+			"Type aliasing is used to sanitize syscall arguments");		\
 	static long __se_##prefix##name(ulong, ulong, ulong, ulong, ulong, ulong, 	\
 					ulong)						\
 			__attribute__((alias(__stringify(___se_##prefix##name))));	\
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -72,6 +72,10 @@
 	__diag_push();								\
 	__diag_ignore(GCC, 8, "-Wattribute-alias",				\
 		      "Type aliasing is used to sanitize syscall arguments");\
+	__diag_ignore(clang, 23, "-Wunknown-warning-option",			\
+		      "Avoid breaking versions without -Wattribute-alias");	\
+	__diag_ignore(clang, 23, "-Wattribute-alias",				\
+		      "Type aliasing is used to sanitize syscall arguments");	\
 	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
 		__attribute__((alias(__stringify(__se_compat_sys##name))));	\
 	ALLOW_ERROR_INJECTION(compat_sys##name, ERRNO);				\
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -131,6 +131,12 @@
 #define __diag_str(s)		__diag_str1(s)
 #define __diag(s)		_Pragma(__diag_str(clang diagnostic s))
 
+#if CONFIG_CLANG_VERSION >= 230000
+#define __diag_clang_23(s)	__diag(s)
+#else
+#define __diag_clang_23(s)
+#endif
+
 #define __diag_clang_13(s)	__diag(s)
 
 #define __diag_ignore_all(option, comment) \
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -636,6 +636,10 @@ struct ftrace_likely_data {
 #define __diag_GCC(version, severity, string)
 #endif
 
+#ifndef __diag_clang
+#define __diag_clang(version, severity, string)
+#endif
+
 #define __diag_push()	__diag(push)
 #define __diag_pop()	__diag(pop)
 
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -247,6 +247,10 @@ static inline int is_syscall_trace_event
 	__diag_push();							\
 	__diag_ignore(GCC, 8, "-Wattribute-alias",			\
 		      "Type aliasing is used to sanitize syscall arguments");\
+	__diag_ignore(clang, 23, "-Wunknown-warning-option",		\
+		      "Avoid breaking versions without -Wattribute-alias");\
+	__diag_ignore(clang, 23, "-Wattribute-alias",			\
+		      "Type aliasing is used to sanitize syscall arguments");\
 	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
 		__attribute__((alias(__stringify(__se_sys##name))));	\
 	ALLOW_ERROR_INJECTION(sys##name, ERRNO);			\


