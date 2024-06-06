Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E185B1A2574;
	Thu,  6 Jun 2024 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683198; cv=none; b=tXMVP8ptF2e3on8lWc4IMa0B0CiiSBsHAXAyhK5WTUtEqDqa4b/yNuRUpb7aVJ5j1C+bVOHNJSD8dILfq3uigrw8AKupSVEBKx2zCPdK6RDYNsatouJzganBT+vbz4w5bJyJJjisKfDiw2R2qeGtEO84h0c6myqzoII/UMlE560=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683198; c=relaxed/simple;
	bh=6NFcfyrlXvINNwk3nxT7Hytc9ZyKvZ0OYAo1pdDBkAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mK32QZ2JoRbVngodxTUtpIIvNY3adUXQDHuVuRTYNYQJHFIOpmFD4OJ2duCNAaLOtqeeeHjAiC51vn1n2PB0HGl5/fvIbgPlxNFuBjKi/Js82R5c3l7Ha4K28aM9p9YqQ5YzP0gqJhKODHfxmUN/MZ8fhMVgrbXLXR/uRtbdL/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVFISvC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVFISvC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE49DC2BD10;
	Thu,  6 Jun 2024 14:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683197;
	bh=6NFcfyrlXvINNwk3nxT7Hytc9ZyKvZ0OYAo1pdDBkAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVFISvC7Er5ln48G1bysZ0WVeifCQ8Gq7pJByc6Yh5xZ4Bx0SqZPHxzWPR1jnKssw
	 cfyOXskFh6OCPvI/nyH49YYbczTZy8podv5AbwDALX1DHsCO29DO6cyx0AhHEj+o5Z
	 8E7jWj9BNLdbGpyrYq/DFh3heW0JWw/f+sDXnX7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/744] mm/userfaultfd: Do not place zeropages when zeropages are disallowed
Date: Thu,  6 Jun 2024 15:56:23 +0200
Message-ID: <20240606131735.962297843@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 90a7592da14951bd21f74a53246ba30955a648aa ]

s390x must disable shared zeropages for processes running VMs, because
the VMs could end up making use of "storage keys" or protected
virtualization, which are incompatible with shared zeropages.

Yet, with userfaultfd it is possible to insert shared zeropages into
such processes. Let's fallback to simply allocating a fresh zeroed
anonymous folio and insert that instead.

mm_forbids_zeropage() was introduced in commit 593befa6ab74 ("mm: introduce
mm_forbids_zeropage function"), briefly before userfaultfd went
upstream.

Note that we don't want to fail the UFFDIO_ZEROPAGE request like we do
for hugetlb, it would be rather unexpected. Further, we also
cannot really indicated "not supported" to user space ahead of time: it
could be that the MM disallows zeropages after userfaultfd was already
registered.

[ agordeev: Fixed checkpatch complaints ]

Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
Reviewed-by: Peter Xu <peterx@redhat.com>
Link: https://lore.kernel.org/r/20240411161441.910170-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/userfaultfd.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index cd5ad448ac2f0..e76faba102797 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -213,6 +213,38 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
 	goto out;
 }
 
+static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
+					 struct vm_area_struct *dst_vma,
+					 unsigned long dst_addr)
+{
+	struct folio *folio;
+	int ret = -ENOMEM;
+
+	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
+	if (!folio)
+		return ret;
+
+	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
+		goto out_put;
+
+	/*
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
+	 * zeroing out the folio become visible before mapping the page
+	 * using set_pte_at(). See do_anonymous_page().
+	 */
+	__folio_mark_uptodate(folio);
+
+	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
+				       &folio->page, true, 0);
+	if (ret)
+		goto out_put;
+
+	return 0;
+out_put:
+	folio_put(folio);
+	return ret;
+}
+
 static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
 				     struct vm_area_struct *dst_vma,
 				     unsigned long dst_addr)
@@ -221,6 +253,9 @@ static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
 	spinlock_t *ptl;
 	int ret;
 
+	if (mm_forbids_zeropage(dst_vma->vm_mm))
+		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
+
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
 	ret = -EAGAIN;
-- 
2.43.0



