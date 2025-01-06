Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343C614900B;
	Mon,  6 Jan 2025 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177012; cv=none; b=EfIF3rWAPKAOI3Pp+3GmjJ3GxqMvT73/jTbkGA6k7B140eAz9IufKKnqM4R4TgOixE+ig1GezvZhflPHoKWRKUm18n/bvqt8rJMu+ZMJZR+co3MyGal5Vu2uxZka1I2Z6gkyCq2a1PEzcFsgW6sEdCUF6j52xzt+yrVkLxN2u5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177012; c=relaxed/simple;
	bh=FwF8TjuqiPEYmafmBoYn6GY7gPrxRPbPmkVWdD4eREE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GF4zMR+yR1yFN0tvUccTg1dFA4flv5bBK/HFiB5oaNHZRsRY9sABKmqQys+qd++MthFAdDoZfx3h1RYTBaEpP+XgRazq8Rpsy0TtEa3Vz9Y8qoJqn0XA7GA5UXdOMat7LfxAgfeg2WNKQrMtTqese3uFHvWAMLzjBF0rgLPgEAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cirUSCDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cirUSCDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51397C4CED6;
	Mon,  6 Jan 2025 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177011;
	bh=FwF8TjuqiPEYmafmBoYn6GY7gPrxRPbPmkVWdD4eREE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cirUSCDHO4+8d6Vei0k2L4LdepGeJSlS5M5Zyx3Qv4CLg3PYQlL/yTcGR5BYBEUD7
	 2JyywzV80QrURmMVY46oIh5aJ4NoxCOqYd52XWltFx6dmdjnhAi9bkyQ4CJnIW+mLq
	 L+4e4ZAsziEzudj0eadibJSeEEN5isJGORaHOb48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/222] x86/mm: Carve out INVLPG inline asm for use by others
Date: Mon,  6 Jan 2025 16:13:28 +0100
Message-ID: <20250106151150.760642672@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit f1d84b59cbb9547c243d93991acf187fdbe9fbe9 ]

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/ZyulbYuvrkshfsd2@antipodes
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/tlb.h | 4 ++++
 arch/x86/mm/tlb.c          | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 580636cdc257..4d3c9d00d6b6 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -34,4 +34,8 @@ static inline void __tlb_remove_table(void *table)
 	free_page_and_swap_cache(table);
 }
 
+static inline void invlpg(unsigned long addr)
+{
+	asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
+}
 #endif /* _ASM_X86_TLB_H */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 2fbae48f0b47..64f594826a28 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -19,6 +19,7 @@
 #include <asm/cacheflush.h>
 #include <asm/apic.h>
 #include <asm/perf_event.h>
+#include <asm/tlb.h>
 
 #include "mm_internal.h"
 
@@ -1145,7 +1146,7 @@ STATIC_NOPV void native_flush_tlb_one_user(unsigned long addr)
 	bool cpu_pcide;
 
 	/* Flush 'addr' from the kernel PCID: */
-	asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
+	invlpg(addr);
 
 	/* If PTI is off there is no user PCID and nothing to flush. */
 	if (!static_cpu_has(X86_FEATURE_PTI))
-- 
2.39.5



