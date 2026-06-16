Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7373A3CC303;
	Tue, 16 Jun 2026 18:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636034; cv=none; b=C78CyIy7nfWg+KFasG/RypDGb2kH7Sg/wi2SeI6Lt+BmmZ3MOTNI3YyNtuMok7dBjGVEpgdlIbrJherBkT/neQLOID6qAs6L375vPm9TOxSAP8CUV5lIAitWrht4vU6Z6P2MhWW4CETCLNYBBC77hKeZRHYYtVtjau9qa4X4g8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636034; c=relaxed/simple;
	bh=CPCh6hjvOTFGC/mxos/eKaaezAIauwboIXJfQAnLmPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wotpdq1QKz4ghtkWIFdCZJfetWqEUoEo5i4ZfiFiIsoifBLuAw+Fk7LuEp9DiJhFrIHzrLqBZsLMDFp0rpzIw1Ou/kYIi/u+pEsrhCvoNTOKB1VXdIsCkOCJprXjIEqG/lTsuRMQDUCNReXPuGiRzRkHsbAuDt3euBHkKZvXPhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0p4C977p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0p4C977p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C091F000E9;
	Tue, 16 Jun 2026 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636033;
	bh=ckANAfpf3xCi0dJc6aGP5lc8l4xUu4GQqPDIQXeTOec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0p4C977pXvI65tYaLb7yyhkxSiLl2n8GHVEkYCcAnq2xm60Vs2RvjyTSOgcrtCYzu
	 WClT+e3lpGk/6bnIKUhEIcH8I7m9haHZ1JXeJUVWhuaRxa6s6eee0r2qZvkjIaFJEH
	 E7CRPL71eqH0v5I04d7Sm6A1MItrrjhRN01oIiGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/342] Disable -Wattribute-alias for clang-23 and newer
Date: Tue, 16 Jun 2026 20:27:05 +0530
Message-ID: <20260616145054.208355449@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[nathan: Drop arch/riscv hunk in older trees and address conflicts]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compat.h         | 4 ++++
 include/linux/compiler-clang.h | 6 ++++++
 include/linux/compiler_types.h | 4 ++++
 include/linux/syscalls.h       | 4 ++++
 4 files changed, 18 insertions(+)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 8dffffe846ce54..93c9bbec96acba 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -75,6 +75,10 @@
 	__diag_push();								\
 	__diag_ignore(GCC, 8, "-Wattribute-alias",				\
 		      "Type aliasing is used to sanitize syscall arguments");\
+	__diag_ignore(clang, 23, "-Wunknown-warning-option",			\
+		      "Avoid breaking versions without -Wattribute-alias");	\
+	__diag_ignore(clang, 23, "-Wattribute-alias",				\
+		      "Type aliasing is used to sanitize syscall arguments");	\
 	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));	\
 	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
 		__attribute__((alias(__stringify(__se_compat_sys##name))));	\
diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index fae3775d02b516..a8953f9c766bcf 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -148,3 +148,9 @@
 #else
 #define __diag_clang_11(s)
 #endif
+
+#if CONFIG_CLANG_VERSION >= 230000
+#define __diag_clang_23(s)	__diag(s)
+#else
+#define __diag_clang_23(s)
+#endif
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 9cecd02c1280a9..88cc4457297d22 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -320,6 +320,10 @@ struct ftrace_likely_data {
 #define __diag_GCC(version, severity, string)
 #endif
 
+#ifndef __diag_clang
+#define __diag_clang(version, severity, string)
+#endif
+
 #define __diag_push()	__diag(push)
 #define __diag_pop()	__diag(pop)
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a96e924c7b45ed..339a35aad83935 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -236,6 +236,10 @@ static inline int is_syscall_trace_event(struct trace_event_call *tp_event)
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
-- 
2.53.0



