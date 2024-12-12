Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EE7215799;
	Thu, 12 Dec 2024 16:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020488; cv=none; b=EzkgKe5kfpPxkc8Uj9XgCpr7pih0EU71DvAUZbqDMBMzpTQkPfTCW5ZXIW6eoYrpt35BCBoapoMW7yFWu5IXHi//ODkvGONvfW+jeJd4TRyLZsITRwhQiDDb6+FKgAsOAFliowEBpvT29E/Mm942iTxC4QJ5njc+llQx5u75PvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020488; c=relaxed/simple;
	bh=BqUtF+c6EqjwBswwXVXASdveY3jx70+1HfWlk/lS1fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfYyEAOsT5BbBnwy9RkMqn+3t2xe/pSg46ZGJvsd6bi3f3BR3gLrkdVqB28VHg3xDRnoxElYYXqbRiOQh1T7KX/WMe4kUDHxkIP2cIguFQWPqlItfuSvm5H/g5JWQtMYm+dfFZHJAH9dFilPW2xJsP3L0tamLdlA8FhSVXuX8pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ej2xM259; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ej2xM259"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495DFC4CECE;
	Thu, 12 Dec 2024 16:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020487;
	bh=BqUtF+c6EqjwBswwXVXASdveY3jx70+1HfWlk/lS1fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ej2xM259/9v9kEOjtwmQ0Pcc5wY7uoNy1SPPscn82LBv19qUEvisY3gBQhJUwP1Sk
	 8OFh+xPb0rHGBvMQo4O7OXy4icSMwsqX8l/mffn+GWPotMM/jKleY3U8IPCTHttRn4
	 SnXogKnR32VniXNqnYHGOIMKNW7mzq9QT+f7fwoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clement LE GOFFIC <clement.legoffic@foss.st.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Linus Walleij <linus.walleij@linaro.org>,
	Melon Liu <melon1335@163.com>
Subject: [PATCH 6.1 479/772] ARM: 9429/1: ioremap: Sync PGDs for VMALLOC shadow
Date: Thu, 12 Dec 2024 15:57:04 +0100
Message-ID: <20241212144409.720217140@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/mm/ioremap.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 794cfea9f9d4..ff555823cceb 100644
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
@@ -115,16 +116,40 @@ int ioremap_page(unsigned long virt, unsigned long phys,
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
-- 
2.47.1



