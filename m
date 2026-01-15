Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A683271F2;
	Thu, 15 Jan 2026 17:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498916; cv=none; b=HQ8905/4V/bSQ8cvMDe4DvXKsAdij0o49FjVwSE463r6pr0zXRbYORT7Fomq0Q6UmFJmq5sPnGZ6rAqKoMlouB9yVrMJOuFtuam0axcdsos/O6MK9uqhHBU49ZsK82BWinvo2zsr+PUUd8P//EoOh9UjjvOvBili5PmRBKx29Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498916; c=relaxed/simple;
	bh=awOEpI+q1G3yIokUWW0M5YlA5Xi3fJA6Fql86X0oT4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGf3d+0k80nCzEbsEL3rw3tharRWXU9yvyOcg3r7N4Zc4kVTbzw801JjTFiSocGIvAhdjVznmISSrsFoffCsJmaNSCHhrCav89yIrDQaaecNFQgDjuPLOWsnASziArj84ic1rCPYVa8+MjcFLhSiccw92D3xrWecrHU7CUw47oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvuPsT6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvuPsT6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890FAC116D0;
	Thu, 15 Jan 2026 17:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498916;
	bh=awOEpI+q1G3yIokUWW0M5YlA5Xi3fJA6Fql86X0oT4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvuPsT6m3vHKqBSGdHtIu35HT+FvyxnwWBc+S7JQJSqOdiQld++FWIVVJ+J5tVphZ
	 QxKQFrZabKJ28JNca49v4fnt7T3DNVdzHpIN4xPJQMysyg8HWtwXQ+zCIJ7fmyh6qf
	 Fx2R/XcUL+/KXZqEUvsJ9XzJW20dptYxo5Drvnzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Will Deacon <will@kernel.org>,
	Arvind Sankar <nivedita@alum.mit.edu>,
	Masahiro Yamada <masahiroy@kernel.org>,
	llvm@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/451] compiler-gcc.h: Define __SANITIZE_ADDRESS__ under hwaddress sanitizer
Date: Thu, 15 Jan 2026 17:44:04 +0100
Message-ID: <20260115164232.451882189@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 9a48e7564ac83fb0f1d5b0eac5fe8a7af62da398 ]

When Clang is using the hwaddress sanitizer, it sets __SANITIZE_ADDRESS__
explicitly:

 #if __has_feature(address_sanitizer) || __has_feature(hwaddress_sanitizer)
 /* Emulate GCC's __SANITIZE_ADDRESS__ flag */
 #define __SANITIZE_ADDRESS__
 #endif

Once hwaddress sanitizer was added to GCC, however, a separate define
was created, __SANITIZE_HWADDRESS__. The kernel is expecting to find
__SANITIZE_ADDRESS__ in either case, though, and the existing string
macros break on supported architectures:

 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
          !defined(__SANITIZE_ADDRESS__)

where as other architectures (like arm32) have no idea about hwaddress
sanitizer and just check for __SANITIZE_ADDRESS__:

 #if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)

This would lead to compiler foritfy self-test warnings when building
with CONFIG_KASAN_SW_TAGS=y:

warning: unsafe memmove() usage lacked '__read_overflow2' symbol in lib/test_fortify/read_overflow2-memmove.c
warning: unsafe memcpy() usage lacked '__write_overflow' symbol in lib/test_fortify/write_overflow-memcpy.c
...

Sort this out by also defining __SANITIZE_ADDRESS__ in GCC under the
hwaddress sanitizer.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will@kernel.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: llvm@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/r/20211020200039.170424-1-keescook@chromium.org
Stable-dep-of: ced37e9ceae5 ("x86/dumpstack: Prevent KASAN false positive warnings in __show_regs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-gcc.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index ae9a8e17287ce..faf0fd509cb5a 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -140,6 +140,14 @@
 #define __no_sanitize_coverage
 #endif
 
+/*
+ * Treat __SANITIZE_HWADDRESS__ the same as __SANITIZE_ADDRESS__ in the kernel,
+ * matching the defines used by Clang.
+ */
+#ifdef __SANITIZE_HWADDRESS__
+#define __SANITIZE_ADDRESS__
+#endif
+
 /*
  * Turn individual warnings and errors on and off locally, depending
  * on version.
-- 
2.51.0



