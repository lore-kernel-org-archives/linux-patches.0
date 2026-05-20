Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E5D3BE165;
	Wed, 20 May 2026 17:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297063; cv=none; b=u2tW5SyVmNGMFnQPWCqFq30nTPwOguqlRwiXRfWPd/8aUw+RGJpra6i9qh26TcyZSE8nRAOOa73KcoIRLDwZemyVDY7aY0uxMHuRA+zj2PNl73D7/AzlkqmjPZu9MhiWCbX43zG9cO5HC/pOVhdPT3y7nt44wqDINTXWyFgPAaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297063; c=relaxed/simple;
	bh=WIZf8zyzorpMDfIvg4mrLueJWUG1b8qd9U+IzjR+oCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unE9T6gDBkCKZnZ9QcIygur8/dCdDDx9SQof/Fu78pxdmLAEnbbjhNPcSVtOjzou4UPZQ+d5ai/mcqFdcLiBQs171vgk2s/DEXovbhVSLknJH2yqyD7kvkTZP+emkxshr49YYD285v1VnAhdesITaIZy4ZbUEADYpha66jY3gFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROk0vvcy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROk0vvcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6F11F000E9;
	Wed, 20 May 2026 17:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297062;
	bh=FE+gkwVhFCTOskp/We6UFa+9LGWR7dUzqxUL8NMIM/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROk0vvcyto57UY0/2U2bBNWKLgqlQzOHauZeypHVx1ZtMQLDtNb1AvJWCJ9J3JQ4/
	 MGri29F6tBxAnaG8Xkr0wwBIeSuwHKgkvrsZY+fAaVA1XEXNgDmlxh6MadCWCaJRO0
	 Xn3XeyEWmSoLTNlFECqKy+IKmBS24/amtnPn76lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1035/1146] arm64: Reserve an extra page for early kernel mapping
Date: Wed, 20 May 2026 18:21:25 +0200
Message-ID: <20260520162211.654409848@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

[ Upstream commit 4d8e74ad4585672489da6145b3328d415f50db82 ]

The final part of [data, end) segment may overflow into the next page of
init_pg_end[1] which is the gap page before early_init_stack[2]:

[1]
crash_arm64_v9.0.1> vtop ffffffed00601000
VIRTUAL           PHYSICAL
ffffffed00601000  83401000

PAGE DIRECTORY: ffffffecffd62000
   PGD: ffffffecffd62da0 => 10000000833fb003
   PMD: ffffff80033fb018 => 10000000833fe003
   PTE: ffffff80033fe008 => 68000083401f03
  PAGE: 83401000

     PTE        PHYSICAL  FLAGS
68000083401f03  83401000  (VALID|SHARED|AF|NG|PXN|UXN)

      PAGE       PHYSICAL      MAPPING       INDEX CNT FLAGS
fffffffec00d0040 83401000                0        0  1 4000 reserved

[2]
ffffffed002c8000 (r) __pi__data
ffffffed0054e000 (d) __pi___bss_start
ffffffed005f5000 (b) __pi_init_pg_dir
ffffffed005fe000 (b) __pi_init_pg_end
ffffffed005ff000 (B) early_init_stack
ffffffed00608000 (b) __pi__end

For 4K pages, the early kernel mapping may use 2MB block entries but the
kernel segments are only 64KB aligned. Segment boundaries that fall
within a 2MB block therefore require a PTE table so that different
attributes can be applied on either side of the boundary.

KERNEL_SEGMENT_COUNT still correctly counts the five permanent kernel
VMAs registered by declare_kernel_vmas(). However, since commit
5973a62efa34 ("arm64: map [_text, _stext) virtual address range
non-executable+read-only"), the early mapper also maps [_text, _stext)
separately from [_stext, _etext). This adds one more early-only split
and can require one more page-table page than the existing
EARLY_SEGMENT_EXTRA_PAGES allowance reserves.

Increase the 4K-page early mapping allowance by one page to cover that
additional split.

Fixes: 5973a62efa34 ("arm64: map [_text, _stext) virtual address range non-executable+read-only")
Assisted-by: TRAE:GLM-5.1
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
[catalin.marinas@arm.com: rewrote part of the commit log]
[catalin.marinas@arm.com: expanded the code comment]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kernel-pgtable.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index 74a4f738c5f52..229ee7976f693 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -68,7 +68,12 @@
 #define KERNEL_SEGMENT_COUNT	5
 
 #if SWAPPER_BLOCK_SIZE > SEGMENT_ALIGN
-#define EARLY_SEGMENT_EXTRA_PAGES (KERNEL_SEGMENT_COUNT + 1)
+/*
+ * KERNEL_SEGMENT_COUNT counts the permanent kernel VMAs. The early mapping
+ * has one additional split, [_text, _stext). Reserve one more page for the
+ * SWAPPER_BLOCK_SIZE-unaligned boundaries.
+ */
+#define EARLY_SEGMENT_EXTRA_PAGES (KERNEL_SEGMENT_COUNT + 2)
 /*
  * The initial ID map consists of the kernel image, mapped as two separate
  * segments, and may appear misaligned wrt the swapper block size. This means
-- 
2.53.0



