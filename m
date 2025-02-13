Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6269D2222D8;
	Thu, 13 Feb 2025 14:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457563; cv=none; b=iKVADyrMM5UOf2hVll+OjtfilBCXKwJpxYtxbaifKhA0lzfx694Qls53h9ZSLA1n6NpO6249obtXHKgr/qKD0edTF8dh68OsPFpgmgSK/4xUaK3UmEWzgf5uTCYsyJvSwLeQivbmKKKTbcIX+xc3KpTuNhwB7MxIP0cvY0z7Wxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457563; c=relaxed/simple;
	bh=MZ7lmcDOplnyX7noCla/QXq9gAkbIJVEIFD7cGcmo8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYBGMeUUWcQfVawl2c6np+yoKiODcCV/y9NmfL2b3+tdBvbgvemZuPBZCpz/DIeQCbBAL6H2IloVID0S3yjT++JVLdrA5OZ2R5bdKZt/mRrn1WBPSrLmDXNAyZF+yStfGpJ5qbb6Rfni+YBmCakjYKNFo6sEV/sm0uzZ0OTf0zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfDjMelt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfDjMelt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553FEC4CEE9;
	Thu, 13 Feb 2025 14:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457562;
	bh=MZ7lmcDOplnyX7noCla/QXq9gAkbIJVEIFD7cGcmo8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfDjMeltOprkOH2VaUKl09L4UGd/P+LR/VaS00+UmniAQyqJa3sTut2XryOIvLXNg
	 QOT5F7oFanOJq0UmuBxmSx+b85wqYPlERlDAv4Wf5KV+b2xKogrFnQjF1Ir+ruE16/
	 lAGkxYCNxPmV1JrUqr3If5U8x8QqWnn7/JiWeUK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 147/422] arm64/mm: Reduce PA space to 48 bits when LPA2 is not enabled
Date: Thu, 13 Feb 2025 15:24:56 +0100
Message-ID: <20250213142442.221268554@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit bf74bb73cd87c64bd5afc1fd4b749029997b6170 upstream.

Currently, LPA2 kernel support implies support for up to 52 bits of
physical addressing, and this is reflected in global definitions such as
PHYS_MASK_SHIFT and MAX_PHYSMEM_BITS.

This is potentially problematic, given that LPA2 hardware support is
modeled as a CPU feature which can be overridden, and with LPA2 hardware
support turned off, attempting to map physical regions with address bits
[51:48] set (which may exist on LPA2 capable systems booting with
arm64.nolva) will result in corrupted mappings with a truncated output
address and bogus shareability attributes.

This means that the accepted physical address range in the mapping
routines should be at most 48 bits wide when LPA2 support is configured
but not enabled at runtime.

Fixes: 352b0395b505 ("arm64: Enable 52-bit virtual addressing for 4k and 16k granule configs")
Cc: stable@vger.kernel.org
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20241212081841.2168124-9-ardb+git@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable-hwdef.h |    6 ------
 arch/arm64/include/asm/pgtable-prot.h  |    7 +++++++
 arch/arm64/include/asm/sparsemem.h     |    5 ++++-
 3 files changed, 11 insertions(+), 7 deletions(-)

--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -218,12 +218,6 @@
  */
 #define S1_TABLE_AP		(_AT(pmdval_t, 3) << 61)
 
-/*
- * Highest possible physical address supported.
- */
-#define PHYS_MASK_SHIFT		(CONFIG_ARM64_PA_BITS)
-#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
-
 #define TTBR_CNP_BIT		(UL(1) << 0)
 
 /*
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -78,6 +78,7 @@ extern bool arm64_use_ng_mappings;
 #define lpa2_is_enabled()	false
 #define PTE_MAYBE_SHARED	PTE_SHARED
 #define PMD_MAYBE_SHARED	PMD_SECT_S
+#define PHYS_MASK_SHIFT		(CONFIG_ARM64_PA_BITS)
 #else
 static inline bool __pure lpa2_is_enabled(void)
 {
@@ -86,9 +87,15 @@ static inline bool __pure lpa2_is_enable
 
 #define PTE_MAYBE_SHARED	(lpa2_is_enabled() ? 0 : PTE_SHARED)
 #define PMD_MAYBE_SHARED	(lpa2_is_enabled() ? 0 : PMD_SECT_S)
+#define PHYS_MASK_SHIFT		(lpa2_is_enabled() ? CONFIG_ARM64_PA_BITS : 48)
 #endif
 
 /*
+ * Highest possible physical address supported.
+ */
+#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
+
+/*
  * If we have userspace only BTI we don't want to mark kernel pages
  * guarded even if the system does support BTI.
  */
--- a/arch/arm64/include/asm/sparsemem.h
+++ b/arch/arm64/include/asm/sparsemem.h
@@ -5,7 +5,10 @@
 #ifndef __ASM_SPARSEMEM_H
 #define __ASM_SPARSEMEM_H
 
-#define MAX_PHYSMEM_BITS	CONFIG_ARM64_PA_BITS
+#include <asm/pgtable-prot.h>
+
+#define MAX_PHYSMEM_BITS		PHYS_MASK_SHIFT
+#define MAX_POSSIBLE_PHYSMEM_BITS	(52)
 
 /*
  * Section size must be at least 512MB for 64K base


