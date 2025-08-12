Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADA226FA77;
	Tue, 12 Aug 2025 19:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025237; cv=none; b=AKuXajCv9yzYgcTU3fI9PMisf7I3A7YgYUgdicw/d9I+u5gwJKFl5aF/qaNkCcyNwG2O0h2ui9O1ZvwnccbEBEeGpxM/m6RSbdfj2Te4Wrhy0wPTXg2HAw2vpGLe4oLNe4gprb2BUooEsB5S6hTFeM9Gsqx9LA93k37ytf4nH/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025237; c=relaxed/simple;
	bh=fVmDxRqceSoaLOEn6NZO1qs4bhza3yPr6YhfvI9MJO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXL7LQt18giK9M6TYfHzup+V+Wh2nqABxdxGx9CKcRmQkWFG4jAFBnfLlKosO2x27a+SjslZv5gmJ0AtSG4yt5s4zqM9kaklDVWw2Oq3zfjN+MKcKx0M5pe/qwhWDEYx/57lWuAbUAbxtDyTF/M6fI1X2scGQH2u+VdzqabfUc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8+2L8Lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8+2L8Lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5C8C4CEF0;
	Tue, 12 Aug 2025 19:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025237;
	bh=fVmDxRqceSoaLOEn6NZO1qs4bhza3yPr6YhfvI9MJO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8+2L8LzP0s8ZvHI/FNYzGRcK//odPrC+CVJutxBpPqnyNDa7ocuxtXHgeGX3fQ69
	 QPtEgOoa+rU8SqSFT4FfZEIvunH4oAOaXiH8mPOQjmkiEZBQ3kt/jC4QnpS56FJJQz
	 MsfTM14nWQunCyhNmyhPNd93HTvpJbWskf6QEJwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: [PATCH 6.16 610/627] s390/mm: Remove possible false-positive warning in pte_free_defer()
Date: Tue, 12 Aug 2025 19:35:05 +0200
Message-ID: <20250812173455.077205519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit 5647f61ad9171e8f025558ed6dc5702c56a33ba3 upstream.

Commit 8211dad627981 ("s390: add pte_free_defer() for pgtables sharing
page") added a warning to pte_free_defer(), on our request. It was meant
to warn if this would ever be reached for KVM guest mappings, because
the page table would be freed w/o a gmap_unlink(). THP mappings are not
allowed for KVM guests on s390, so this should never happen.

However, it is possible that the warning is triggered in a valid case as
false-positive.

s390_enable_sie() takes the mmap_lock, marks all VMAs as VM_NOHUGEPAGE and
splits possibly existing THP guest mappings. mm->context.has_pgste is set
to 1 before that, to prevent races with the mm_has_pgste() check in
MADV_HUGEPAGE.

khugepaged drops the mmap_lock for file mappings and might run in parallel,
before a vma is marked VM_NOHUGEPAGE, but after mm->context.has_pgste was
set to 1. If it finds file mappings to collapse, it will eventually call
pte_free_defer(). This will trigger the warning, but it is a valid case
because gmap is not yet set up, and the THP mappings will be split again.

Therefore, remove the warning and the comment.

Fixes: 8211dad627981 ("s390: add pte_free_defer() for pgtables sharing page")
Cc: <stable@vger.kernel.org> # 6.6+
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/pgalloc.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -173,11 +173,6 @@ void pte_free_defer(struct mm_struct *mm
 	struct ptdesc *ptdesc = virt_to_ptdesc(pgtable);
 
 	call_rcu(&ptdesc->pt_rcu_head, pte_free_now);
-	/*
-	 * THPs are not allowed for KVM guests. Warn if pgste ever reaches here.
-	 * Turn to the generic pte_free_defer() version once gmap is removed.
-	 */
-	WARN_ON_ONCE(mm_has_pgste(mm));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 


