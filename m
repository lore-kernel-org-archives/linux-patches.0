Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57FE52B1FF;
	Wed,  9 Sep 2026 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962162; cv=none; b=IIiGpPjk1Yn01R09Sg+PMq36n0D8A7vExRBJP7qdVZX+JYSzn6Acyj0YtMSpkjuaLnCjy+JGkcoN1Ymilk1Ueo+6wnC742M7+cLequ+PllyqvPIC5Q0+WchMr1Lki9TVirqo7Mt6ICRsN8MOc3vIcwxBryLHy/3fxGt4VF/X9Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962162; c=relaxed/simple;
	bh=d8Qw4AeSnxAElw5JudegJH8nCdICT3snap3p2Z/XrZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chRhqN3LwIwzFqUuCDsy4vHNdoYmqr5Kgx9lyFOnJZ+7wB2B9tIqIxFBYMIMNPqo+rhbRJwfofORKUCJG8gcx5VaM+Fx/CH93qDZK0J6DrSqD8kPnBDg3Y3WNQYBudC+1T+TcnBsjfKvWhag6RbqDgVF/9mwtD1q/unYmkTCDTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8BxzLGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8BxzLGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0815B1F00A3A;
	Wed,  9 Sep 2026 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962161;
	bh=dMF2iV7HIlK3mEq5aXVMpF1WMlxoDpozCsSlNuovygg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8BxzLGP7qwgZwQbhHiyVWBEzeUBDBzumpott1PvohTWbF34O8dgGh3Kzpxnkmg4t
	 KRnRV8JOt/or54iMg83Wt8AQcur3bBvUhUZxo98ZZbPilfnkq5S4rz7dR6DPPB+pmK
	 h/mt6oJfpmDYSQynN7PrqWoPMSLYtDZtIEMnZCrs=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 168/556] mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs
Date: Wed,  9 Sep 2026 15:37:28 +0200
Message-ID: <20260909134236.331380387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit 2fd4e7693674b17807a6d082feb01a3fbf86f5f8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/khugepaged.c |    6 ------
 mm/madvise.c    |    8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -452,12 +452,6 @@ int hugepage_madvise(struct vm_area_stru
 	case MADV_HUGEPAGE:
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
@@ -177,6 +177,14 @@ static int madvise_update_vma(vm_flags_t
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
 	vma->flags = new_vma_flags;
+	/*
+	 * If the vma become good for khugepaged to scan,
+	 * register it here without waiting a page fault that
+	 * may not happen any time soon.
+	 */
+	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
+		khugepaged_enter_vma(vma, vma_flags_to_legacy(new_vma_flags));
+
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
 


