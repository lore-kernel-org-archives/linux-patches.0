Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8255D7603F;
	Mon, 15 Apr 2024 14:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191052; cv=none; b=H/JGDHHfXhsL1dG8ABvge7kyVKgG74tUUR5Jq0NypLVTzBs3u83YrgHGgPM1W5Fyqguz8u/I582xw/uCYbq4AG28Xcrg5ln5sq9Rpf4X0rHbYHLKTzUR9ap99XSi8pdNYXwo4kMvyzNNKMT9erNeYHPnq2vws3XM+LP5hFno21I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191052; c=relaxed/simple;
	bh=948NeArI2lV3y23NS54Dr7OurpN9ANVbH/cVuxHROmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+0biE2gJ96jiyD5nq05rN8gF0U5jNWLJLzOd+FBhtw2+VlH5XCgp/sWBbGxsvwX5cF2TI4r35CfiVKUiMBRU+OJT07gYV8Y18wUeq2CHpPm/q5iYixccQY1j25xvtOKKgB4zO7Krtze5M3Tq2lktxksvejp0ZYlDQS1KiWgMsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S08Yv2SZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S08Yv2SZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05827C113CC;
	Mon, 15 Apr 2024 14:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191052;
	bh=948NeArI2lV3y23NS54Dr7OurpN9ANVbH/cVuxHROmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S08Yv2SZBcm8V2W3UZxk4uOgZnn4nMeTct3OJLmpJwfW29LZLysL7CS+rJwSnHEYU
	 4U4XgW3zvT2lFK31xCUw2+bllMwfPK8f3N43zRizPWrSk4I6jDPYNiFUrY4wM2D5Jk
	 n8KqJRnstyT9McvMERMbXi0qWWaH4eV+2P1VHFio=
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
Subject: [PATCH 6.8 009/172] arm64: tlb: Fix TLBI RANGE operand
Date: Mon, 15 Apr 2024 16:18:28 +0200
Message-ID: <20240415142000.265909144@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -161,12 +161,18 @@ static inline unsigned long get_trans_gr
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
@@ -379,10 +385,6 @@ static inline void arch_tlbbatch_flush(s
  * 3. If there is 1 page remaining, flush it through non-range operations. Range
  *    operations can only span an even number of pages. We save this for last to
  *    ensure 64KB start alignment is maintained for the LPA2 case.
- *
- * Note that certain ranges can be represented by either num = 31 and
- * scale or num = 0 and scale + 1. The loop below favours the latter
- * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
  */
 #define __flush_tlb_range_op(op, start, pages, stride,			\
 				asid, tlb_level, tlbi_user, lpa2)	\


