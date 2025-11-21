Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50A5264612;
	Fri, 21 Nov 2025 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731401; cv=none; b=OtYWdrjKkRSfITZtFn2KIhbNu+JubzQVhEqX3F0eBLtKECQGhLs9A8AQ3V8aFk9tNrS2IMsudr+OjgmCOoqPks2WNNrqeylcTGug7zMHjZOpNREjiWFO8Oa3fzkjymi4nfENRz+DC4tp8Z+DObo3OAzegM5jORhPqyI79WxRvZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731401; c=relaxed/simple;
	bh=Q+TyeNao4gtVh56UtbKYKg/RA5pDrHZi/+s45PS1Xxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sD2+MH6DLxQ+Lb1TUnQYBy9kSwO6Y7RavI6gP1rkouv9IkjCKYr9U7Ch20t9Vtv2akRx23cKiDHFh57R5mWFs9+8HhqSRRcyfYO3B0oPUZjSmjfl4AzDbYOGONe9ugyZaQBW62eieJ9sR5iHzARL3rJ+LQ8cyMKA4ryyqaAJAh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqAOILMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqAOILMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE1CC4CEF1;
	Fri, 21 Nov 2025 13:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731401;
	bh=Q+TyeNao4gtVh56UtbKYKg/RA5pDrHZi/+s45PS1Xxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqAOILMzBIsVsRV0jRZFyx2tUt5cXVv3feZmHfK9GbgU3jbpYqwAOvV0E7vgbjCk3
	 PjxlUsiu165l5V5tL08d1LAsEFqzPpJR0TqIkYnNxer4kZXY9vSemAg12iQDnTrsHE
	 ts3Hqv2NrUjS3nZxivDVjyfwYlwvxfPJ3Rn77iQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 188/247] mm, swap: fix potential UAF issue for VMA readahead
Date: Fri, 21 Nov 2025 14:12:15 +0100
Message-ID: <20251121130201.470915647@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

commit 1c2a936edd71e133f2806e68324ec81a4eb07588 upstream.

Since commit 78524b05f1a3 ("mm, swap: avoid redundant swap device
pinning"), the common helper for allocating and preparing a folio in the
swap cache layer no longer tries to get a swap device reference
internally, because all callers of __read_swap_cache_async are already
holding a swap entry reference.  The repeated swap device pinning isn't
needed on the same swap device.

Caller of VMA readahead is also holding a reference to the target entry's
swap device, but VMA readahead walks the page table, so it might encounter
swap entries from other devices, and call __read_swap_cache_async on
another device without holding a reference to it.

So it is possible to cause a UAF when swapoff of device A raced with
swapin on device B, and VMA readahead tries to read swap entries from
device A.  It's not easy to trigger, but in theory, it could cause real
issues.

Make VMA readahead try to get the device reference first if the swap
device is a different one from the target entry.

Link: https://lkml.kernel.org/r/20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com
Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swap_state.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -746,6 +746,8 @@ static struct folio *swap_vma_readahead(
 
 	blk_start_plug(&plug);
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
+		struct swap_info_struct *si = NULL;
+
 		if (!pte++) {
 			pte = pte_offset_map(vmf->pmd, addr);
 			if (!pte)
@@ -759,8 +761,19 @@ static struct folio *swap_vma_readahead(
 			continue;
 		pte_unmap(pte);
 		pte = NULL;
+		/*
+		 * Readahead entry may come from a device that we are not
+		 * holding a reference to, try to grab a reference, or skip.
+		 */
+		if (swp_type(entry) != swp_type(targ_entry)) {
+			si = get_swap_device(entry);
+			if (!si)
+				continue;
+		}
 		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
+		if (si)
+			put_swap_device(si);
 		if (!folio)
 			continue;
 		if (page_allocated) {


