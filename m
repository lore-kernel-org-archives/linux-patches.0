Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDEF1494D9;
	Fri,  6 Dec 2024 14:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496125; cv=none; b=is9x8D61+faQ02aFj50Cl5bfO63E72HFziZXl0BdrDNN7T2F5ipLJxXIIrMWjiIk+kt9MRHpSKdmbIWCKDCtBm71wyf+NZpsEOE+sq+OgX0XwenV4xWbcsqt0gGo9uQ1bS49tcwShLnbhAX0Xnm9S7iiM0CkEAKHpUcMa4TUvKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496125; c=relaxed/simple;
	bh=qW4MPdqQeFmpZgbegDOz21DN7XcXCVW1drTNcLz6W+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHtY/kRFXiRwZ6eQw9lG1bgOE1qQUSPKa8HpW7v75f07QOu58WdMigptcYNr0yWTQL5hT4gUGBb+7LwkB54kbTvHwnMh0XEe3mQUTDOkKeYsPVemIIYrTHL99teRWljsYVHRqP3vRzyxSMW6sjeIZIXbHxG7IigRn0821IhZdcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZsSexT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZsSexT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2837EC4CED1;
	Fri,  6 Dec 2024 14:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496125;
	bh=qW4MPdqQeFmpZgbegDOz21DN7XcXCVW1drTNcLz6W+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZsSexT9S8x4/RYKSEFtwcm9rYaCfum+Gyo8xYP6IRH3mpGDTBLBG64qtSN/5bgGM
	 Q6CoUU2ir7thoSX7z4NrO7ydBqE6EH324el69le3zmP/BJ0BATezPPalx6LER2VzFc
	 1KUVSIgKaRZ+FG8B+8hkqb6dopIv9U2wyh3BsqN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clement LE GOFFIC <clement.legoffic@foss.st.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Linus Walleij <linus.walleij@linaro.org>,
	Melon Liu <melon1335@163.com>
Subject: [PATCH 6.12 059/146] ARM: 9429/1: ioremap: Sync PGDs for VMALLOC shadow
Date: Fri,  6 Dec 2024 15:36:30 +0100
Message-ID: <20241206143529.934000950@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit d6e6a74d4cea853b5321eeabb69c611148eedefe upstream.

When sync:ing the VMALLOC area to other CPUs, make sure to also
sync the KASAN shadow memory for the VMALLOC area, so that we
don't get stale entries for the shadow memory in the top level PGD.

Since we are now copying PGDs in two instances, create a helper
function named memcpy_pgd() to do the actual copying, and
create a helper to map the addresses of VMALLOC_START and
VMALLOC_END into the corresponding shadow memory.

Co-developed-by: Melon Liu <melon1335@163.com>

Cc: stable@vger.kernel.org
Fixes: 565cbaad83d8 ("ARM: 9202/1: kasan: support CONFIG_KASAN_VMALLOC")
Link: https://lore.kernel.org/linux-arm-kernel/a1a1d062-f3a2-4d05-9836-3b098de9db6d@foss.st.com/
Reported-by: Clement LE GOFFIC <clement.legoffic@foss.st.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/ioremap.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -23,6 +23,7 @@
  */
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/kasan.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/io.h>
@@ -115,16 +116,40 @@ int ioremap_page(unsigned long virt, uns
 }
 EXPORT_SYMBOL(ioremap_page);
 
+#ifdef CONFIG_KASAN
+static unsigned long arm_kasan_mem_to_shadow(unsigned long addr)
+{
+	return (unsigned long)kasan_mem_to_shadow((void *)addr);
+}
+#else
+static unsigned long arm_kasan_mem_to_shadow(unsigned long addr)
+{
+	return 0;
+}
+#endif
+
+static void memcpy_pgd(struct mm_struct *mm, unsigned long start,
+		       unsigned long end)
+{
+	end = ALIGN(end, PGDIR_SIZE);
+	memcpy(pgd_offset(mm, start), pgd_offset_k(start),
+	       sizeof(pgd_t) * (pgd_index(end) - pgd_index(start)));
+}
+
 void __check_vmalloc_seq(struct mm_struct *mm)
 {
 	int seq;
 
 	do {
 		seq = atomic_read(&init_mm.context.vmalloc_seq);
-		memcpy(pgd_offset(mm, VMALLOC_START),
-		       pgd_offset_k(VMALLOC_START),
-		       sizeof(pgd_t) * (pgd_index(VMALLOC_END) -
-					pgd_index(VMALLOC_START)));
+		memcpy_pgd(mm, VMALLOC_START, VMALLOC_END);
+		if (IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
+			unsigned long start =
+				arm_kasan_mem_to_shadow(VMALLOC_START);
+			unsigned long end =
+				arm_kasan_mem_to_shadow(VMALLOC_END);
+			memcpy_pgd(mm, start, end);
+		}
 		/*
 		 * Use a store-release so that other CPUs that observe the
 		 * counter's new value are guaranteed to see the results of the


