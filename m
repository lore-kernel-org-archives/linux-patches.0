Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3F44A997;
	Wed, 20 Dec 2023 16:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQ10ylk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DF7C433C7;
	Wed, 20 Dec 2023 16:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089091;
	bh=hlTDTkxW7tZaEqRpc8PiODwlYe73RwKvmRz7MKs3/MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQ10ylk3oLEIJw8xr23EsKej/EN45Q9HNUFkvbAVE46cxzATVHq+kpJ7CArq6ILFi
	 QXpEpW/LDlcd5NrF53u+/FV/Ac2O1k3DTXOlUAePHw/CIzL3mZx8+l/fdnk9bICQxY
	 u8rxUKbPPOaY46/6cxq656Ue+FOX8oYfRgaG6kMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Haibo Li <haibo.li@mediatek.com>,
	Kees Cook <keescook@chromium.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.15 159/159] kasan: disable kasan_non_canonical_hook() for HW tags
Date: Wed, 20 Dec 2023 17:10:24 +0100
Message-ID: <20231220160938.705703230@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 17c17567fe510857b18fe01b7a88027600e76ac6 upstream.

On arm64, building with CONFIG_KASAN_HW_TAGS now causes a compile-time
error:

mm/kasan/report.c: In function 'kasan_non_canonical_hook':
mm/kasan/report.c:637:20: error: 'KASAN_SHADOW_OFFSET' undeclared (first use in this function)
  637 |         if (addr < KASAN_SHADOW_OFFSET)
      |                    ^~~~~~~~~~~~~~~~~~~
mm/kasan/report.c:637:20: note: each undeclared identifier is reported only once for each function it appears in
mm/kasan/report.c:640:77: error: expected expression before ';' token
  640 |         orig_addr = (addr - KASAN_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT;

This was caused by removing the dependency on CONFIG_KASAN_INLINE that
used to prevent this from happening. Use the more specific dependency
on KASAN_SW_TAGS || KASAN_GENERIC to only ignore the function for hwasan
mode.

Link: https://lkml.kernel.org/r/20231016200925.984439-1-arnd@kernel.org
Fixes: 12ec6a919b0f ("kasan: print the original fault addr when access invalid shadow")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Haibo Li <haibo.li@mediatek.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kasan.h |    6 +++---
 mm/kasan/report.c     |    4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -471,10 +471,10 @@ static inline void kasan_free_shadow(con
 
 #endif /* (CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS) && !CONFIG_KASAN_VMALLOC */
 
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 void kasan_non_canonical_hook(unsigned long addr);
-#else /* CONFIG_KASAN */
+#else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 static inline void kasan_non_canonical_hook(unsigned long addr) { }
-#endif /* CONFIG_KASAN */
+#endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
 #endif /* LINUX_KASAN_H */
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -457,8 +457,9 @@ bool kasan_report(unsigned long addr, si
 	return ret;
 }
 
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 /*
- * With CONFIG_KASAN, accesses to bogus pointers (outside the high
+ * With CONFIG_KASAN_INLINE, accesses to bogus pointers (outside the high
  * canonical half of the address space) cause out-of-bounds shadow memory reads
  * before the actual access. For addresses in the low canonical half of the
  * address space, as well as most non-canonical addresses, that out-of-bounds
@@ -494,3 +495,4 @@ void kasan_non_canonical_hook(unsigned l
 	pr_alert("KASAN: %s in range [0x%016lx-0x%016lx]\n", bug_type,
 		 orig_addr, orig_addr + KASAN_GRANULE_SIZE - 1);
 }
+#endif


