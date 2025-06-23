Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BD1225A23;
	Mon, 23 Jun 2025 22:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717597; cv=none; b=dEcGtUe7bpmUtZCmtPyRQLKdWrG8IArRJmvkEfpkWfE6v21apvnFym9vdjgv8/m7JzfqjIV6JwsCF39t5obtCfo+oP1UMVviFIKAnfx642pz3dTp0eQ+HX4nb6fv/TgiVbgesViiDfIAVly1fm4pvepq01mgGKImbvGJXlSQDps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717597; c=relaxed/simple;
	bh=X0M7VkEWuKZhv2yMZzXllbI3iarWkJ66V+MjJwBE1DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZA9lTbYT2sQHkdjsGQ5prrQcY7Q01ldZ48EPb2QQDxT7+/8QngK6LZ2TqHuOyK66CJIO7n4OO6M5GOUlHTgmsb7oLeVceu4YKSKb6vKS4T/3qRPQBqNvqTXzumGSWm5AsSJCcSJSRcvUQ0LOsGQuSBUmVaIrDLHESoa6O+vNLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CF0g1uj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CF0g1uj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDD0C4CEF3;
	Mon, 23 Jun 2025 22:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717597;
	bh=X0M7VkEWuKZhv2yMZzXllbI3iarWkJ66V+MjJwBE1DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CF0g1uj322o+acWq6dzwe3ajqslUXrrw9FzzbJ2KhMVebtubz5xp80IxmS/JOU+d7
	 4yt7fingkB4MBHQ4ew/XqjwJkrbvr86S9CCmQVT5fddsFP9coSb3CQt+xBVXIDszQS
	 EbkpaYeMJIHhnAm2yuIwnkvkIMFX9Rh4YMw4RXLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 465/508] mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race
Date: Mon, 23 Jun 2025 15:08:30 +0200
Message-ID: <20250623130656.551708083@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 1013af4f585fccc4d3e5c5824d174de2257f7d6d upstream.

huge_pmd_unshare() drops a reference on a page table that may have
previously been shared across processes, potentially turning it into a
normal page table used in another process in which unrelated VMAs can
afterwards be installed.

If this happens in the middle of a concurrent gup_fast(), gup_fast() could
end up walking the page tables of another process.  While I don't see any
way in which that immediately leads to kernel memory corruption, it is
really weird and unexpected.

Fix it with an explicit broadcast IPI through tlb_remove_table_sync_one(),
just like we do in khugepaged when removing page tables for a THP
collapse.

Link: https://lkml.kernel.org/r/20250528-hugetlb-fixes-splitrace-v2-2-1329349bad1a@google.com
Link: https://lkml.kernel.org/r/20250527-hugetlb-fixes-splitrace-v1-2-f4136f5ec58a@google.com
Fixes: 39dde65c9940 ("[PATCH] shared page table for hugetlb page")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7162,6 +7162,13 @@ int huge_pmd_unshare(struct mm_struct *m
 		return 0;
 
 	pud_clear(pud);
+	/*
+	 * Once our caller drops the rmap lock, some other process might be
+	 * using this page table as a normal, non-hugetlb page table.
+	 * Wait for pending gup_fast() in other threads to finish before letting
+	 * that happen.
+	 */
+	tlb_remove_table_sync_one();
 	atomic_dec(&virt_to_page(ptep)->pt_share_count);
 	mm_dec_nr_pmds(mm);
 	return 1;


