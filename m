Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3AC292B4B;
	Fri,  3 Oct 2025 16:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507599; cv=none; b=BSKYm7jhECiFtZdrqTOvo2J47aF4aPT7ixD8DPlmmnMKc38ZzhiPgdo6eqaCatbcsvzlQ8ZOSI+egJw7i7K8aYzb2Wa+7uFZvNL5VuG6hZaL+xMcWvz+JvoTsPDV2mMWnbOc+M3SN/UjAJPLD27U887kiG3rS65+x6moSCvqdQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507599; c=relaxed/simple;
	bh=3590jyp8FGq4teNtAa7tQyQco7YjrO1Z9QVcR7oe6t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw8McNYjkE8fGuaykXak9U/A4V9ObgI0i7YuirP2+0w7d8LKDPj2rZrIdlGCBVNXiONl9ns1+RoJXKGhwljFlIee94B/AAzotJc7UZuXIAJUZWBJO9ltBuBXllbaU4FmKHY3rgxQjTRIUgEonG8XN6+/cR6hC5bm/Ut7P4nFBuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWAIRo2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWAIRo2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279EAC4CEF5;
	Fri,  3 Oct 2025 16:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507598;
	bh=3590jyp8FGq4teNtAa7tQyQco7YjrO1Z9QVcR7oe6t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWAIRo2lBpU8WByVxfybX30imqUBIioTQyXYZE7alrCHRwrrQD0+uHKWWj9AfAeep
	 9RDoC/Ac/Ny5b4GNlnQMZyaI5KHyJbOAFAW8GeAHMv9MA7NadxXS5JymmBnG8ZSXwL
	 M5EjFQxI4oRRmuLvjyDsvoyg4Dupp0k5/+CrPtLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charan Teja Kalla <charan.kalla@oss.qualcomm.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 11/15] mm: swap: check for stable address space before operating on the VMA
Date: Fri,  3 Oct 2025 18:05:35 +0200
Message-ID: <20251003160400.320506100@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
References: <20251003160359.831046052@linuxfoundation.org>
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

From: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>

commit 1367da7eb875d01102d2ed18654b24d261ff5393 upstream.

It is possible to hit a zero entry while traversing the vmas in unuse_mm()
called from swapoff path and accessing it causes the OOPS:

Unable to handle kernel NULL pointer dereference at virtual address
0000000000000446--> Loading the memory from offset 0x40 on the
XA_ZERO_ENTRY as address.
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault

The issue is manifested from the below race between the fork() on a
process and swapoff:
fork(dup_mmap())			swapoff(unuse_mm)
---------------                         -----------------
1) Identical mtree is built using
   __mt_dup().

2) copy_pte_range()-->
	copy_nonpresent_pte():
       The dst mm is added into the
    mmlist to be visible to the
    swapoff operation.

3) Fatal signal is sent to the parent
process(which is the current during the
fork) thus skip the duplication of the
vmas and mark the vma range with
XA_ZERO_ENTRY as a marker for this process
that helps during exit_mmap().

				     4) swapoff is tried on the
					'mm' added to the 'mmlist' as
					part of the 2.

				     5) unuse_mm(), that iterates
					through the vma's of this 'mm'
					will hit the non-NULL zero entry
					and operating on this zero entry
					as a vma is resulting into the
					oops.

The proper fix would be around not exposing this partially-valid tree to
others when droping the mmap lock, which is being solved with [1].  A
simpler solution would be checking for MMF_UNSTABLE, as it is set if
mm_struct is not fully initialized in dup_mmap().

Thanks to Liam/Lorenzo/David for all the suggestions in fixing this
issue.

Link: https://lkml.kernel.org/r/20250924181138.1762750-1-charan.kalla@oss.qualcomm.com
Link: https://lore.kernel.org/all/20250815191031.3769540-1-Liam.Howlett@oracle.com/ [1]
Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2243,6 +2243,8 @@ static int unuse_mm(struct mm_struct *mm
 	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_read_lock(mm);
+	if (check_stable_address_space(mm))
+		goto unlock;
 	for_each_vma(vmi, vma) {
 		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
 			ret = unuse_vma(vma, type);
@@ -2252,6 +2254,7 @@ static int unuse_mm(struct mm_struct *mm
 
 		cond_resched();
 	}
+unlock:
 	mmap_read_unlock(mm);
 	return ret;
 }


