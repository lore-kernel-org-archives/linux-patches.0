Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F66152CCE2;
	Wed, 30 Sep 2026 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789918; cv=none; b=KyA/4MTQ0rTqJjt8SfgUt8Er7vdQ72TfNAyNGlg6lT39e8kNaqMi9mWqdu5T5qoewLnTrEYhXQCa1gdvYOm8kcaGf5xkswaeLzO9vNf5af4KN3duM1UPD8E+G6iNMdd+ncywxmkrE5tfRoXd8GSXFfKKUiNm4hrxN4Ghmsa3pdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789918; c=relaxed/simple;
	bh=CnEnEYntQXIiv3eiSaUFMSF34mgdlo8DvxNt4IuekBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dTPtgS5szVC4cCpPqpPMXZ4nBF4f0hIrZuz/u92EZxnFanKUB00ZdpOCWIT9TLH3RQsDJReWtui+T1ubrMJuc+kpQ6MV/zf1dxh/dWZMt6sP9D7mjKdrPheyExIk8plru0bEIQJI2A26+vh3OYQgdlyjuGw/VX4gBxdruklO6bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+ziN7zm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+ziN7zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DD51F000FF;
	Wed, 30 Sep 2026 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789916;
	bh=Rq2SUDilH9PYvC9gNHMXdEVtM05eSYE3vnXjzqJm6oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+ziN7zmJU4YbwQvzEU7wxBwIgEHpr8y9vCPafYYBVuoBtPZcHKx7cjCHHO89w3cj
	 S801RLxh9YQTaXGOql08XD21W6+bAEs8YrMpBWGi7VPmSPb0G8+pSVEjRg9MiiX0ei
	 XZCxhbMKw/bBCpjZGKW6QpDTuoAx8qES9JUzFIb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 647/877] mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs
Date: Wed, 30 Sep 2026 17:25:58 +0200
Message-ID: <20260930152428.620701149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 2fd4e7693674b17807a6d082feb01a3fbf86f5f8 ]

Lance reported that when nothing else causes the mm to be considered for
khugepaged collapse, an MADV_HUGEPAGE-advised tmpfs VMA alone does not
trigger scanning.

After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled()
into shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order
check reads vma->flags directly.  However, when MADV_HUGEPAGE is handled,
khugepaged_enter_vma() is called before the VMA's flags have been updated,
so the check uses stale flags and incorrectly rejects the VMA for
collapse.  As a result, khugepaged does not collapse the tmpfs file into
PMD order in time.

Fix this by calling khugepaged_enter_vma() with the new VMA flags in
madvise_update_vma().  Meanwhile we can remove the khugepaged_enter_vma()
in hugepage_madvise().

Link: https://lore.kernel.org/7d5b5eb27be798f89d563b06254c947ff53db0b2.1787020910.git.baolin.wang@linux.alibaba.com
Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@linux.dev/
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ adapted newer VMA flag helpers to the branch’s legacy new_flags bitmask API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    6 ------
 mm/madvise.c    |    8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -369,12 +369,6 @@ int hugepage_madvise(struct vm_area_stru
 #endif
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
-		/*
-		 * If the vma become good for khugepaged to scan,
-		 * register it here without waiting a page fault that
-		 * may not happen any time soon.
-		 */
-		khugepaged_enter_vma(vma, *vm_flags);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -158,6 +158,14 @@ static int madvise_update_vma(struct vm_
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
 	vm_flags_reset(vma, new_flags);
+	/*
+	 * If the vma become good for khugepaged to scan,
+	 * register it here without waiting a page fault that
+	 * may not happen any time soon.
+	 */
+	if (new_flags & VM_HUGEPAGE)
+		khugepaged_enter_vma(vma, new_flags);
+
 	if (!vma->vm_file || vma_is_anon_shmem(vma)) {
 		error = replace_anon_vma_name(vma, anon_name);
 		if (error)


