Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B64C1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3yKb4a+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4B1C433C9;
	Wed,  4 Oct 2023 18:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443950;
	bh=kd/4xk/eF8mGJnprY6WuuiQxqi3SfkfqWOgr8vb/GUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3yKb4a+6k4sDOvijaleEXbaqJfSeowcati5hCN36zWjOAkPU546txTkrC0ZS+7wv
	 op2nAPfb7RaZxOpngItxwM6pLKZI0JCStlHbjC2TayfQ7oes3kUY0UBLgYAsmd+suG
	 hvnAyapl9MN/7aD1j2N8aW4/fVmYsHKFasOYp5Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 077/321] x86/asm: Fix build of UML with KASAN
Date: Wed,  4 Oct 2023 19:53:42 +0200
Message-ID: <20231004175232.781183136@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 10f4c9b9a33b7df000f74fa0d896351fb1a61e6a ]

Building UML with KASAN fails since commit 69d4c0d32186 ("entry, kasan,
x86: Disallow overriding mem*() functions") with the following errors:

 $ tools/testing/kunit/kunit.py run --kconfig_add CONFIG_KASAN=y
 ...
 ld: mm/kasan/shadow.o: in function `memset':
 shadow.c:(.text+0x40): multiple definition of `memset';
 arch/x86/lib/memset_64.o:(.noinstr.text+0x0): first defined here
 ld: mm/kasan/shadow.o: in function `memmove':
 shadow.c:(.text+0x90): multiple definition of `memmove';
 arch/x86/lib/memmove_64.o:(.noinstr.text+0x0): first defined here
 ld: mm/kasan/shadow.o: in function `memcpy':
 shadow.c:(.text+0x110): multiple definition of `memcpy';
 arch/x86/lib/memcpy_64.o:(.noinstr.text+0x0): first defined here

UML does not use GENERIC_ENTRY and is still supposed to be allowed to
override the mem*() functions, so use weak aliases in that case.

Fixes: 69d4c0d32186 ("entry, kasan, x86: Disallow overriding mem*() functions")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20230918-uml-kasan-v3-1-7ad6db477df6@axis.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/linkage.h | 7 +++++++
 arch/x86/lib/memcpy_64.S       | 2 +-
 arch/x86/lib/memmove_64.S      | 2 +-
 arch/x86/lib/memset_64.S       | 2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 5ff49fd67732e..571fe4d2d2328 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -105,6 +105,13 @@
 	CFI_POST_PADDING					\
 	SYM_FUNC_END(__cfi_##name)
 
+/* UML needs to be able to override memcpy() and friends for KASAN. */
+#ifdef CONFIG_UML
+# define SYM_FUNC_ALIAS_MEMFUNC	SYM_FUNC_ALIAS_WEAK
+#else
+# define SYM_FUNC_ALIAS_MEMFUNC	SYM_FUNC_ALIAS
+#endif
+
 /* SYM_TYPED_FUNC_START -- use for indirectly called globals, w/ CFI type */
 #define SYM_TYPED_FUNC_START(name)				\
 	SYM_TYPED_START(name, SYM_L_GLOBAL, SYM_F_ALIGN)	\
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 8f95fb267caa7..76697df8dfd5b 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -40,7 +40,7 @@ SYM_TYPED_FUNC_START(__memcpy)
 SYM_FUNC_END(__memcpy)
 EXPORT_SYMBOL(__memcpy)
 
-SYM_FUNC_ALIAS(memcpy, __memcpy)
+SYM_FUNC_ALIAS_MEMFUNC(memcpy, __memcpy)
 EXPORT_SYMBOL(memcpy)
 
 SYM_FUNC_START_LOCAL(memcpy_orig)
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 0559b206fb110..ccdf3a597045e 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -212,5 +212,5 @@ SYM_FUNC_START(__memmove)
 SYM_FUNC_END(__memmove)
 EXPORT_SYMBOL(__memmove)
 
-SYM_FUNC_ALIAS(memmove, __memmove)
+SYM_FUNC_ALIAS_MEMFUNC(memmove, __memmove)
 EXPORT_SYMBOL(memmove)
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 7c59a704c4584..3d818b849ec64 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -40,7 +40,7 @@ SYM_FUNC_START(__memset)
 SYM_FUNC_END(__memset)
 EXPORT_SYMBOL(__memset)
 
-SYM_FUNC_ALIAS(memset, __memset)
+SYM_FUNC_ALIAS_MEMFUNC(memset, __memset)
 EXPORT_SYMBOL(memset)
 
 SYM_FUNC_START_LOCAL(memset_orig)
-- 
2.40.1



