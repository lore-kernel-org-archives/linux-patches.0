Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F072C08A8;
	Tue, 26 Aug 2025 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213737; cv=none; b=Q7yDdn3HfUTCNU9xlpuU1fDQd3tKTbXz/eZW+dKmpDjvpVqXT5kSR6DTjhXfpIMTv8HjjkNKwhkI2hQmLgOFc0imPwUESZbEyzH4Kz2n7VbYXc3u+qbvY9rugQTZ1o7ldCx3HkVIAU2u8dozrsuZ7S/9mie8P+KsVFL8PTm8wZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213737; c=relaxed/simple;
	bh=5PAXjjr0tXz5Pvh0aQdLBAPxlGnFj0Qjmo8Mn4vPxyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATQKZwrcJQikxUb3INoxEUewCGAu5pIF/m0jDE+wD6hrmMrzVV/vh4WdHqvglXKc8ykTXAjci+g5EPyFtQMv+OQPHMQeDG95TjdsFprOdsXsxlE70G5kvfQaC4hF//e3J5YsjX/K07UqCEEGZbRDHr3a22oOYouS34J3rggJm8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvLf1fjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvLf1fjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C87C4CEF1;
	Tue, 26 Aug 2025 13:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213736;
	bh=5PAXjjr0tXz5Pvh0aQdLBAPxlGnFj0Qjmo8Mn4vPxyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvLf1fjlEdVH+VUiuU09sE2/fsRdOV2yuuLk5aL/b0X3VlKkEyLlpxL7kb62axUxs
	 zW5h20ti2dGwX1KHR2Tw0oV957JipRYeo6H7mG/3f3FNuWIq5RTAC0g8J/Jr2pYCyY
	 yCAJEFx7wW9tGfKJ2qFnhvE6z9OhyKibe7yK80mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: [PATCH 6.6 461/587] s390/mm: Remove possible false-positive warning in pte_free_defer()
Date: Tue, 26 Aug 2025 13:10:10 +0200
Message-ID: <20250826111004.702688479@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -456,11 +456,6 @@ void pte_free_defer(struct mm_struct *mm
 	page = virt_to_page(pgtable);
 	SetPageActive(page);
 	page_table_free(mm, (unsigned long *)pgtable);
-	/*
-	 * page_table_free() does not do the pgste gmap_unlink() which
-	 * page_table_free_rcu() does: warn us if pgste ever reaches here.
-	 */
-	WARN_ON_ONCE(mm_has_pgste(mm));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 


