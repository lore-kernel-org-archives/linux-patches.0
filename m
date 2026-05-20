Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9443A453B;
	Wed, 20 May 2026 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301545; cv=none; b=XaROvy+SOVtD3bNbIRVQS/4S3ox/mF7b5T3893MORLpb1PZ9de8UxASSYHt/xKH433BupwMWDiMDarYeKj8BxCxcAXa9QOQvudyH/ZEZYhoah6lcnu3U2m68vIQXjwWkaT9UlVI2IrttRsCb9olaUZWsO8jkj5Ml7efkwwTGOI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301545; c=relaxed/simple;
	bh=3eXZfJAlWiGQ2dapnZefwyFeVPXaJsGx0H4odIU6dg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucYucJGcR4UwbVLlcEHBpZiFlCCDu/WeYIM/kDvbpfAacIV1v2bl3yOTYn4odbn6RPvloRjUwnph7zw+SkCB6eC1v4AAyaaNowogtfJtRmiW6Hm5WuleaTtHxXEP0d+rHzpw/KE//Z8Cc410E0scpxP40IHDv0ynUO6geNz1bds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUmfJnl5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUmfJnl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A7E1F000E9;
	Wed, 20 May 2026 18:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301544;
	bh=VI9WSh/yphqr7TYFETASbo1VNum5yyUDrYe+y1YA6a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUmfJnl55Pe7CqQuOO51/ITmzlOt8lEwvtzl1qoES/LR0NvVeZuBJmLA+WFDn9mKb
	 1mpoly9xL7fmz9GAfdnajHRKvuNA4/eulgTJyaPZyI/Cmah3E4balWKzYVt2mzfxh4
	 NONdeNxB559fDKKonBydOWywnpnuH34SF1WlfAzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 594/666] arm64: Reserve an extra page for early kernel mapping
Date: Wed, 20 May 2026 18:23:25 +0200
Message-ID: <20260520162124.138855134@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bf05a77873a49..56fe12a6f7b0a 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -69,7 +69,12 @@
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



