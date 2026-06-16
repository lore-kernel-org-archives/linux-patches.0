Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889293ACA5A;
	Tue, 16 Jun 2026 18:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633793; cv=none; b=aBxdotgi33Zx7pJPpo7BD7OTF9lRmq6+RuEBu02z+yM0H2U/ILFNDNswcEYy0m9F13FDWPq0VCL25N338/32yXKeikGzTuS2V5FKTvxcPr4titjVNIVfV7hGWBkaz8++Z+DunYiqSVZ+gZw9tfp4HGlXBqOArta5bOh+slDBcMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633793; c=relaxed/simple;
	bh=RQceal6+szawDQiZBAOrtgwIPanfln/7VW/2javHSck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFeQOAPxT36uyb+sAYnBnXgjyZTORQKvGLksxHHrDl+ppjp/PO96K+Bje9qjij+xH75MphiPzKZpJlqEdJGlAUI5KXlEyFtMkp2x33wJeQfvUYKlSAV6y1/8SPr7ID0it5+AtheRZoegO4ENVnJTwbKGLCgVwNwyUSZ9AXxyz1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Il3LEGEw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Il3LEGEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540DF1F000E9;
	Tue, 16 Jun 2026 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633792;
	bh=IfrxWxSPVGVnH1PEyFJtGSeSd/2nfEr9jEdRVUapwn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Il3LEGEwxwv0lj2EawPWXswfUSQ9b0oRrFFHXfswmLOUdWBn5fxcbqrXp/1ozIq1R
	 CK4CQ9/qXnuRQoEC0rr2gnhWtSaoSqP70u5hYNAHUmZfiKi8daXySkD42YAS03fjb0
	 r+HDZWf9yYSVWW0JwzFkeQ0UPIOs3BMTyw40XD1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/411] Disable -Wattribute-alias for clang-23 and newer
Date: Tue, 16 Jun 2026 20:26:24 +0530
Message-ID: <20260616145108.164250331@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
index d91fb5225dbf48..c5441ac9050f4f 100644
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
diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index 7ae9fc072302d4..f0b218c914f1fb 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -141,3 +141,9 @@
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
index ca9345e2934d38..2eda6f70169630 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -345,6 +345,10 @@ struct ftrace_likely_data {
 #define __diag_GCC(version, severity, string)
 #endif
 
+#ifndef __diag_clang
+#define __diag_clang(version, severity, string)
+#endif
+
 #define __diag_push()	__diag(push)
 #define __diag_pop()	__diag(pop)
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b8037a46ff41d7..ce63109333a585 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -239,6 +239,10 @@ static inline int is_syscall_trace_event(struct trace_event_call *tp_event)
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



