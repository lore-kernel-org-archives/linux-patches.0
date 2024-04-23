Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FF720B3E;
	Tue, 23 Apr 2024 21:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908536; cv=none; b=gfeZ/W/XxuagRDIbVivM5m+JAZQTEuiB/8SlaGJti30DiQj4tw5OSehRD+RhZdsxBXWVgFPo1mUuBnlU7cfo3Kb0aIaHRoWzGMMXVVQRxmaNn6RDEXXN0zm28sNG40JUhTzVRyEIpWxw3+xLW4i0jITrL74sLdF5XJWsiNb8qDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908536; c=relaxed/simple;
	bh=cTlGUYb1L0tjnl9nYCzMWTF2NKH4FD09XWXswiPySdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jlESbGQ1qiYdUpNMSoqjXpLxvG6oKyZHDaOJOGHVVjDU59BhkEogYOFPRBV8omYMaq4ZsYzvNbIuwF85eFZHwXGp9wXg5KxWKBk66kyeDnRTL1GOdhuVfnvXxBxS01pNsFYtIALQHuSpw9SbDZRBXO5ynPzVFDWjcbP1pMrP8/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CkICvgF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkICvgF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58702C3277B;
	Tue, 23 Apr 2024 21:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908536;
	bh=cTlGUYb1L0tjnl9nYCzMWTF2NKH4FD09XWXswiPySdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkICvgF5SuYBo2Fy4qVOvohfSydbBjp3ojADUHtPSGZDQkjQjGOCDnHvh7+2tWoRQ
	 c5tRHQko/cSXl2nr/myOylHrrsmqpikCPkFzXkPNeH78xAzbZIVkB4dCyQeUsFTxiR
	 5d98UMsrcImuZslrdewtMp1h8mQklv8jDVnMRUtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.8 129/158] KVM: x86/mmu: x86: Dont overflow lpage_info when checking attributes
Date: Tue, 23 Apr 2024 14:39:11 -0700
Message-ID: <20240423213900.088204315@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

commit 992b54bd083c5bee24ff7cc35991388ab08598c4 upstream.

Fix KVM_SET_MEMORY_ATTRIBUTES to not overflow lpage_info array and trigger
KASAN splat, as seen in the private_mem_conversions_test selftest.

When memory attributes are set on a GFN range, that range will have
specific properties applied to the TDP. A huge page cannot be used when
the attributes are inconsistent, so they are disabled for those the
specific huge pages. For internal KVM reasons, huge pages are also not
allowed to span adjacent memslots regardless of whether the backing memory
could be mapped as huge.

What GFNs support which huge page sizes is tracked by an array of arrays
'lpage_info' on the memslot, of ‘kvm_lpage_info’ structs. Each index of
lpage_info contains a vmalloc allocated array of these for a specific
supported page size. The kvm_lpage_info denotes whether a specific huge
page (GFN and page size) on the memslot is supported. These arrays include
indices for unaligned head and tail huge pages.

Preventing huge pages from spanning adjacent memslot is covered by
incrementing the count in head and tail kvm_lpage_info when the memslot is
allocated, but disallowing huge pages for memory that has mixed attributes
has to be done in a more complicated way. During the
KVM_SET_MEMORY_ATTRIBUTES ioctl KVM updates lpage_info for each memslot in
the range that has mismatched attributes. KVM does this a memslot at a
time, and marks a special bit, KVM_LPAGE_MIXED_FLAG, in the kvm_lpage_info
for any huge page. This bit is essentially a permanently elevated count.
So huge pages will not be mapped for the GFN at that page size if the
count is elevated in either case: a huge head or tail page unaligned to
the memslot or if KVM_LPAGE_MIXED_FLAG is set because it has mixed
attributes.

To determine whether a huge page has consistent attributes, the
KVM_SET_MEMORY_ATTRIBUTES operation checks an xarray to make sure it
consistently has the incoming attribute. Since level - 1 huge pages are
aligned to level huge pages, it employs an optimization. As long as the
level - 1 huge pages are checked first, it can just check these and assume
that if each level - 1 huge page contained within the level sized huge
page is not mixed, then the level size huge page is not mixed. This
optimization happens in the helper hugepage_has_attrs().

Unfortunately, although the kvm_lpage_info array representing page size
'level' will contain an entry for an unaligned tail page of size level,
the array for level - 1  will not contain an entry for each GFN at page
size level. The level - 1 array will only contain an index for any
unaligned region covered by level - 1 huge page size, which can be a
smaller region. So this causes the optimization to overflow the level - 1
kvm_lpage_info and perform a vmalloc out of bounds read.

In some cases of head and tail pages where an overflow could happen,
callers skip the operation completely as KVM_LPAGE_MIXED_FLAG is not
required to prevent huge pages as discussed earlier. But for memslots that
are smaller than the 1GB page size, it does call hugepage_has_attrs(). In
this case the huge page is both the head and tail page. The issue can be
observed simply by compiling the kernel with CONFIG_KASAN_VMALLOC and
running the selftest “private_mem_conversions_test”, which produces the
output like the following:

BUG: KASAN: vmalloc-out-of-bounds in hugepage_has_attrs+0x7e/0x110
Read of size 4 at addr ffffc900000a3008 by task private_mem_con/169
Call Trace:
  dump_stack_lvl
  print_report
  ? __virt_addr_valid
  ? hugepage_has_attrs
  ? hugepage_has_attrs
  kasan_report
  ? hugepage_has_attrs
  hugepage_has_attrs
  kvm_arch_post_set_memory_attributes
  kvm_vm_ioctl

It is a little ambiguous whether the unaligned head page (in the bug case
also the tail page) should be expected to have KVM_LPAGE_MIXED_FLAG set.
It is not functionally required, as the unaligned head/tail pages will
already have their kvm_lpage_info count incremented. The comments imply
not setting it on unaligned head pages is intentional, so fix the callers
to skip trying to set KVM_LPAGE_MIXED_FLAG in this case, and in doing so
not call hugepage_has_attrs().

Cc: stable@vger.kernel.org
Fixes: 90b4fe17981e ("KVM: x86: Disallow hugepages when memory attributes are mixed")
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Chao Peng <chao.p.peng@linux.intel.com>
Link: https://lore.kernel.org/r/20240314212902.2762507-1-rick.p.edgecombe@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7388,7 +7388,8 @@ bool kvm_arch_post_set_memory_attributes
 			 * by the memslot, KVM can't use a hugepage due to the
 			 * misaligned address regardless of memory attributes.
 			 */
-			if (gfn >= slot->base_gfn) {
+			if (gfn >= slot->base_gfn &&
+			    gfn + nr_pages <= slot->base_gfn + slot->npages) {
 				if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
 					hugepage_clear_mixed(slot, gfn, level);
 				else


