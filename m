Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD69219B588;
	Thu,  6 Jun 2024 14:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683064; cv=none; b=gd6Obv5QY1eyUzThCY03SCK3CfCTt2AlReFL1+KM5NzW590z+YDdVT1u9plfw6K61bKIHiOP/O3KEy7joUDo2I/Dx/fEEYIvbL31Y6MkPdMp7d7UrDR5q4YXWtfR0o1iozV2MbsAEgLncriruT2qugmsEBKKIrwYdFFFsfevY6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683064; c=relaxed/simple;
	bh=FKSqlzkkOnrjEgBTsN3SJVqQvPRdhITh405bnTfeP3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+J6cyW4h4uq+8KfBouNfLqkaAH2hlAYY4v1Wq3YVw0WaeiBgdXBjg/tOEXSvk4xDSDPKIc9b+WAszosb2pN3HYCD+dG5DJzHUWhPME3YimlC5P18VR7P2lG+EEH83INljyfX3uVNdj7Boa7Clafj1QoTLi6zYz7vnVT6XM1/6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzJmzpkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzJmzpkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB314C4AF1C;
	Thu,  6 Jun 2024 14:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683064;
	bh=FKSqlzkkOnrjEgBTsN3SJVqQvPRdhITh405bnTfeP3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzJmzpkj63exHpXFw77iL08BJwE1md3miXuSIGnFQYA5ikizk01t/SmjcffQ3hG4h
	 4BlWN58Mxmy0m640tgrHuDYmO0MyW1ajyTjSsvJrdJcGZLpZwYraHA5b8PghvA1CRm
	 caTpKlhIiDS54As9E2UhyPR54MaYZaTqRcQttuQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Erhard Furtner <erhard_f@mailbox.org>,
	Nico Pache <npache@redhat.com>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Daniel Axtens <dja@axtens.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 277/374] kasan, fortify: properly rename memintrinsics
Date: Thu,  6 Jun 2024 16:04:16 +0200
Message-ID: <20240606131701.178752324@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Konovalov <andreyknvl@gmail.com>

[ Upstream commit 2e577732e8d28b9183df701fb90cb7943aa4ed16 ]

After commit 69d4c0d32186 ("entry, kasan, x86: Disallow overriding mem*()
functions") and the follow-up fixes, with CONFIG_FORTIFY_SOURCE enabled,
even though the compiler instruments meminstrinsics by generating calls to
__asan/__hwasan_ prefixed functions, FORTIFY_SOURCE still uses
uninstrumented memset/memmove/memcpy as the underlying functions.

As a result, KASAN cannot detect bad accesses in memset/memmove/memcpy.
This also makes KASAN tests corrupt kernel memory and cause crashes.

To fix this, use __asan_/__hwasan_memset/memmove/memcpy as the underlying
functions whenever appropriate.  Do this only for the instrumented code
(as indicated by __SANITIZE_ADDRESS__).

Link: https://lkml.kernel.org/r/20240517130118.759301-1-andrey.konovalov@linux.dev
Fixes: 69d4c0d32186 ("entry, kasan, x86: Disallow overriding mem*() functions")
Fixes: 51287dcb00cc ("kasan: emit different calls for instrumentable memintrinsics")
Fixes: 36be5cba99f6 ("kasan: treat meminstrinsic as builtins in uninstrumented files")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Reported-by: Nico Pache <npache@redhat.com>
Closes: https://lore.kernel.org/all/20240501144156.17e65021@outsider.home/
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Nico Pache <npache@redhat.com>
Acked-by: Nico Pache <npache@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 6eaa190d0083c..9754f97e71e52 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -71,17 +71,30 @@ void __write_overflow_field(size_t avail, size_t wanted) __compiletime_warning("
 	__ret;							\
 })
 
-#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
+#if defined(__SANITIZE_ADDRESS__)
+
+#if !defined(CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX) && !defined(CONFIG_GENERIC_ENTRY)
+extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(memset);
+extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(memmove);
+extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(memcpy);
+#elif defined(CONFIG_KASAN_GENERIC)
+extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(__asan_memset);
+extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(__asan_memmove);
+extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(__asan_memcpy);
+#else /* CONFIG_KASAN_SW_TAGS */
+extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(__hwasan_memset);
+extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(__hwasan_memmove);
+extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(__hwasan_memcpy);
+#endif
+
 extern void *__underlying_memchr(const void *p, int c, __kernel_size_t size) __RENAME(memchr);
 extern int __underlying_memcmp(const void *p, const void *q, __kernel_size_t size) __RENAME(memcmp);
-extern void *__underlying_memcpy(void *p, const void *q, __kernel_size_t size) __RENAME(memcpy);
-extern void *__underlying_memmove(void *p, const void *q, __kernel_size_t size) __RENAME(memmove);
-extern void *__underlying_memset(void *p, int c, __kernel_size_t size) __RENAME(memset);
 extern char *__underlying_strcat(char *p, const char *q) __RENAME(strcat);
 extern char *__underlying_strcpy(char *p, const char *q) __RENAME(strcpy);
 extern __kernel_size_t __underlying_strlen(const char *p) __RENAME(strlen);
 extern char *__underlying_strncat(char *p, const char *q, __kernel_size_t count) __RENAME(strncat);
 extern char *__underlying_strncpy(char *p, const char *q, __kernel_size_t size) __RENAME(strncpy);
+
 #else
 
 #if defined(__SANITIZE_MEMORY__)
@@ -106,6 +119,7 @@ extern char *__underlying_strncpy(char *p, const char *q, __kernel_size_t size)
 #define __underlying_strlen	__builtin_strlen
 #define __underlying_strncat	__builtin_strncat
 #define __underlying_strncpy	__builtin_strncpy
+
 #endif
 
 /**
-- 
2.43.0



