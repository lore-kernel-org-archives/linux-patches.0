Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1E4219E9
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JD3yZUjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37CDC433C8;
	Mon,  6 Nov 2023 13:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277101;
	bh=NCxS50/xsamC4vZNn3E0MVrUD0jGF46BARaVuJ+6zo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JD3yZUjEtocJ5NYLapruTMEppeSrf30oZBRzAAA9PX1eFZ8HY9I19xYZpN9wKSFeD
	 YLiVCJHtnr0UpZNcnHWzQIme/14EaltdTPC/tYwTOf0ZMcL0s8RhjafXFHEI/yMozt
	 9HX4Y9Tz1wCn4MRgF2b+V3svaxr9xBA+eJf3Aeuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Li <haibo.li@mediatek.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 039/128] kasan: print the original fault addr when access invalid shadow
Date: Mon,  6 Nov 2023 14:03:19 +0100
Message-ID: <20231106130310.911555480@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

From: Haibo Li <haibo.li@mediatek.com>

commit babddbfb7d7d70ae7f10fedd75a45d8ad75fdddf upstream.

when the checked address is illegal,the corresponding shadow address from
kasan_mem_to_shadow may have no mapping in mmu table.  Access such shadow
address causes kernel oops.  Here is a sample about oops on arm64(VA
39bit) with KASAN_SW_TAGS and KASAN_OUTLINE on:

[ffffffb80aaaaaaa] pgd=000000005d3ce003, p4d=000000005d3ce003,
    pud=000000005d3ce003, pmd=0000000000000000
Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
Modules linked in:
CPU: 3 PID: 100 Comm: sh Not tainted 6.6.0-rc1-dirty #43
Hardware name: linux,dummy-virt (DT)
pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __hwasan_load8_noabort+0x5c/0x90
lr : do_ib_ob+0xf4/0x110
ffffffb80aaaaaaa is the shadow address for efffff80aaaaaaaa.
The problem is reading invalid shadow in kasan_check_range.

The generic kasan also has similar oops.

It only reports the shadow address which causes oops but not
the original address.

Commit 2f004eea0fc8("x86/kasan: Print original address on #GP")
introduce to kasan_non_canonical_hook but limit it to KASAN_INLINE.

This patch extends it to KASAN_OUTLINE mode.

Link: https://lkml.kernel.org/r/20231009073748.159228-1-haibo.li@mediatek.com
Fixes: 2f004eea0fc8("x86/kasan: Print original address on #GP")
Signed-off-by: Haibo Li <haibo.li@mediatek.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Haibo Li <haibo.li@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kasan.h |    6 +++---
 mm/kasan/report.c     |    4 +---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -471,10 +471,10 @@ static inline void kasan_free_shadow(con
 
 #endif /* (CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS) && !CONFIG_KASAN_VMALLOC */
 
-#ifdef CONFIG_KASAN_INLINE
+#ifdef CONFIG_KASAN
 void kasan_non_canonical_hook(unsigned long addr);
-#else /* CONFIG_KASAN_INLINE */
+#else /* CONFIG_KASAN */
 static inline void kasan_non_canonical_hook(unsigned long addr) { }
-#endif /* CONFIG_KASAN_INLINE */
+#endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -457,9 +457,8 @@ bool kasan_report(unsigned long addr, si
 	return ret;
 }
 
-#ifdef CONFIG_KASAN_INLINE
 /*
- * With CONFIG_KASAN_INLINE, accesses to bogus pointers (outside the high
+ * With CONFIG_KASAN, accesses to bogus pointers (outside the high
  * canonical half of the address space) cause out-of-bounds shadow memory reads
  * before the actual access. For addresses in the low canonical half of the
  * address space, as well as most non-canonical addresses, that out-of-bounds
@@ -495,4 +494,3 @@ void kasan_non_canonical_hook(unsigned l
 	pr_alert("KASAN: %s in range [0x%016lx-0x%016lx]\n", bug_type,
 		 orig_addr, orig_addr + KASAN_GRANULE_SIZE - 1);
 }
-#endif


