Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085883921FB;
	Sat, 17 Oct 2026 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257658; cv=none; b=Uw3YNsL8hw+ieRneN2DgRijo03Rl9uDctH0etdsKS6J7U2CEezKPifoGlZQvb7Kzi72geVCqoZn28r3cgn2CwFwLg+SNMZjVlM4tdkpddFs/k61aF44ujoNNfOjC0JJIS+0GVNYRhivyQd4mKFSSALwZ8/M704hUIFWJT90sloU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257658; c=relaxed/simple;
	bh=KDAPfA183i/PteITCUhJc3EOhUU+9HroAjlyd+loxhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+kaa6DW0WaFWx9nMh6GHWgqDyxl6oVpB0FNjKNHQ/Vg2q2dvWGlEOQvPz7QP4U4aLixSzRP2AWhXQZ19Kb/LTTS47or9eezKgwIEQy4xu3PuN5Y1inpUmsUKvFR+/qR2nH9YMur0GBku1dHH7OdMAT2X5Y70t2+VJEcWbdcsM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0o+FDdn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0o+FDdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABA81F000C4;
	Sat, 17 Oct 2026 17:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257656;
	bh=wtIBzIBOKZSA0yu5xFI3q8lGtWMQzTqS5aNzU1hQYDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0o+FDdnY4UFiLTKP3DfnakQNn8ZrKnreDDaTDe3t+SKHMlzfx8KMJcvvjK4HOstS
	 RGR4oufieZDerH/ydI+X8WN9muzMK1m32zmMwcGgFGB1Np7n17iKT4qFY4N4Uxsovs
	 Z2Awy2F14P8pUPZpRl3UtXw3zen8V2KqdbDIQkhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Singh Sengar <ssengar@microsoft.com>,
	Zach OKeefe <zokeefe@google.com>,
	Yang Shi <shy828301@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0630/1674] mm/thp: fix "mm: thp: kill __transhuge_page_enabled()"
Date: Sat, 17 Oct 2026 17:48:22 +0200
Message-ID: <20261017160447.263765014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zach O'Keefe <zokeefe@google.com>

[ Upstream commit 7a81751fcdeb833acc858e59082688e3020bfe12 ]

The 6.0 commits:

commit 9fec51689ff6 ("mm: thp: kill transparent_hugepage_active()")
commit 7da4e2cb8b1f ("mm: thp: kill __transhuge_page_enabled()")

merged "can we have THPs in this VMA?" logic that was previously done
separately by fault-path, khugepaged, and smaps "THPeligible" checks.

During the process, the semantics of the fault path check changed in two
ways:

1) A VM_NO_KHUGEPAGED check was introduced (also added to smaps path).
2) We no longer checked if non-anonymous memory had a vm_ops->huge_fault
   handler that could satisfy the fault.  Previously, this check had been
   done in create_huge_pud() and create_huge_pmd() routines, but after
   the changes, we never reach those routines.

During the review of the above commits, it was determined that in-tree
users weren't affected by the change; most notably, since the only
relevant user (in terms of THP) of VM_MIXEDMAP or ->huge_fault is DAX,
which is explicitly approved early in approval logic.  However, this was a
bad assumption to make as it assumes the only reason to support
->huge_fault was for DAX (which is not true in general).

Remove the VM_NO_KHUGEPAGED check when not in collapse path and give any
->huge_fault handler a chance to handle the fault.  Note that we don't
validate the file mode or mapping alignment, which is consistent with the
behavior before the aforementioned commits.

Link: https://lkml.kernel.org/r/20230925200110.1979606-1-zokeefe@google.com
Fixes: 7da4e2cb8b1f ("mm: thp: kill __transhuge_page_enabled()")
Reported-by: Saurabh Singh Sengar <ssengar@microsoft.com>
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: d659b715e94a ("mm/huge_memory: avoid PMD-size page cache if needed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8df057bbe1bca..820e67ff8beb3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -88,11 +88,11 @@ bool hugepage_vma_check(struct vm_area_struct *vma, unsigned long vm_flags,
 		return in_pf;
 
 	/*
-	 * Special VMA and hugetlb VMA.
+	 * khugepaged special VMA and hugetlb VMA.
 	 * Must be checked after dax since some dax mappings may have
 	 * VM_MIXEDMAP set.
 	 */
-	if (vm_flags & VM_NO_KHUGEPAGED)
+	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
 		return false;
 
 	/*
@@ -120,12 +120,18 @@ bool hugepage_vma_check(struct vm_area_struct *vma, unsigned long vm_flags,
 					   !hugepage_flags_always())))
 		return false;
 
-	/* Only regular file is valid */
-	if (!in_pf && file_thp_enabled(vma))
-		return true;
-
-	if (!vma_is_anonymous(vma))
+	if (!vma_is_anonymous(vma)) {
+		/*
+		 * Trust that ->huge_fault() handlers know what they are doing
+		 * in fault path.
+		 */
+		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
+			return true;
+		/* Only regular file is valid in collapse path */
+		if (((!in_pf || smaps)) && file_thp_enabled(vma))
+			return true;
 		return false;
+	}
 
 	if (vma_is_temporary_stack(vma))
 		return false;
-- 
2.53.0



