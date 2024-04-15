Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D482899;
	Mon, 15 Apr 2024 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191655; cv=none; b=ut9HUsLL7ybZEGN0LzYkcxFH3qQ7iYDESK5OGu8pAih1lvTVjD1ToxABbW2BJ0U8OcVcfVCIF3dTT4L89InF0X+dGbneI7sKaEu4UegjzDU/QZPa8nsXOtmB5l2EYHZQoehT/s25LPGu5mdrBcwv2jnG04m2h9pw0l275l0KbWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191655; c=relaxed/simple;
	bh=7oeo8BP0uqea6ifi6ay2Da9cZhdMRwVZx+r2ZcUfvfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qcm0m2lFmYqHUqiSI4/n6Z28huPBdDbAJHn7BgqAICd95lp3ixVgzFi29mIeooFVYQD6CNMnQta1ikZMP86Bp29N/XdGI1yh6ByN0eIG0ocSWY7elOigbwZoUfTB+8CXjmrbotZ8o9WRgLe3Uxton3UPnWuWtAKPAkgeXyfGkT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9m6Uz5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9m6Uz5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2CAC113CC;
	Mon, 15 Apr 2024 14:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191655;
	bh=7oeo8BP0uqea6ifi6ay2Da9cZhdMRwVZx+r2ZcUfvfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9m6Uz5ObarhKyYcCWIMKcGyDP54GrrTlco6mNUQZZk+eVgdoFG1xY0NZ/IAHdLVY
	 pu/ZV1AGSx7VwCEfSjX8bMVraDMwv+gp5bKeR85nqGfEx0wkGhyP1Mg6eDhn10+EuM
	 /FMCO3VaBc/r0ukxT9BPQuVO/d3udJhKCoASdjnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihuang Yu <yihyu@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	stable@kernel.org
Subject: [PATCH 6.6 005/122] arm64: tlb: Fix TLBI RANGE operand
Date: Mon, 15 Apr 2024 16:19:30 +0200
Message-ID: <20240415141953.535856536@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gshan@redhat.com>

commit e3ba51ab24fddef79fc212f9840de54db8fd1685 upstream.

KVM/arm64 relies on TLBI RANGE feature to flush TLBs when the dirty
pages are collected by VMM and the page table entries become write
protected during live migration. Unfortunately, the operand passed
to the TLBI RANGE instruction isn't correctly sorted out due to the
commit 117940aa6e5f ("KVM: arm64: Define kvm_tlb_flush_vmid_range()").
It leads to crash on the destination VM after live migration because
TLBs aren't flushed completely and some of the dirty pages are missed.

For example, I have a VM where 8GB memory is assigned, starting from
0x40000000 (1GB). Note that the host has 4KB as the base page size.
In the middile of migration, kvm_tlb_flush_vmid_range() is executed
to flush TLBs. It passes MAX_TLBI_RANGE_PAGES as the argument to
__kvm_tlb_flush_vmid_range() and __flush_s2_tlb_range_op(). SCALE#3
and NUM#31, corresponding to MAX_TLBI_RANGE_PAGES, isn't supported
by __TLBI_RANGE_NUM(). In this specific case, -1 has been returned
from __TLBI_RANGE_NUM() for SCALE#3/2/1/0 and rejected by the loop
in the __flush_tlb_range_op() until the variable @scale underflows
and becomes -9, 0xffff708000040000 is set as the operand. The operand
is wrong since it's sorted out by __TLBI_VADDR_RANGE() according to
invalid @scale and @num.

Fix it by extending __TLBI_RANGE_NUM() to support the combination of
SCALE#3 and NUM#31. With the changes, [-1 31] instead of [-1 30] can
be returned from the macro, meaning the TLBs for 0x200000 pages in the
above example can be flushed in one shoot with SCALE#3 and NUM#31. The
macro TLBI_RANGE_MASK is dropped since no one uses it any more. The
comments are also adjusted accordingly.

Fixes: 117940aa6e5f ("KVM: arm64: Define kvm_tlb_flush_vmid_range()")
Cc: stable@kernel.org # v6.6+
Reported-by: Yihuang Yu <yihyu@redhat.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Link: https://lore.kernel.org/r/20240405035852.1532010-2-gshan@redhat.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/tlbflush.h |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -152,12 +152,18 @@ static inline unsigned long get_trans_gr
 #define MAX_TLBI_RANGE_PAGES		__TLBI_RANGE_PAGES(31, 3)
 
 /*
- * Generate 'num' values from -1 to 30 with -1 rejected by the
- * __flush_tlb_range() loop below.
- */
-#define TLBI_RANGE_MASK			GENMASK_ULL(4, 0)
-#define __TLBI_RANGE_NUM(pages, scale)	\
-	((((pages) >> (5 * (scale) + 1)) & TLBI_RANGE_MASK) - 1)
+ * Generate 'num' values from -1 to 31 with -1 rejected by the
+ * __flush_tlb_range() loop below. Its return value is only
+ * significant for a maximum of MAX_TLBI_RANGE_PAGES pages. If
+ * 'pages' is more than that, you must iterate over the overall
+ * range.
+ */
+#define __TLBI_RANGE_NUM(pages, scale)					\
+	({								\
+		int __pages = min((pages),				\
+				  __TLBI_RANGE_PAGES(31, (scale)));	\
+		(__pages >> (5 * (scale) + 1)) - 1;			\
+	})
 
 /*
  *	TLB Invalidation
@@ -359,10 +365,6 @@ static inline void arch_tlbbatch_flush(s
  *    Start from scale = 0, flush the corresponding number of pages
  *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
  *    until no pages left.
- *
- * Note that certain ranges can be represented by either num = 31 and
- * scale or num = 0 and scale + 1. The loop below favours the latter
- * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
  */
 #define __flush_tlb_range_op(op, start, pages, stride,			\
 				asid, tlb_level, tlbi_user)		\


