Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76941B0F30;
	Mon, 23 Dec 2024 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970142; cv=none; b=Bsn2PxNwqmUcZ7oYXOeHkUvbMFNGNs5+YTgY/JTaDOYpDS2NNi3bXawDugYDod2Xpu2dWsiyMpRPcMOKlQehtpt4LtpcbRc5qTr/qLu+l6sltCt1sXEytCcolaHF1MA+sgin9Z2AqTIAmnjAclT/AEWQ1a+qmd/ox/vL9DUsMRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970142; c=relaxed/simple;
	bh=NsZR7XyCx93oX5pX4NKgkNebQB7EYtKnspcnBuWJCqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsSY0PUThQdeRURnM2lNk+PyTuz0R7Z3ikUt3Ivyka3jjVEFBS9jK08RYFF/79e+jDFf4WxsyGI7UeKxKkqNLfu5aNQ/6eAE83N55ucaXaS5gT223zkcGNzPGTurX8Ni6Uz2HZ7saxAhePle0NrfMTglnQdb4zHDcB8AgnEwJec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSYQKCBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSYQKCBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF583C4CED3;
	Mon, 23 Dec 2024 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970142;
	bh=NsZR7XyCx93oX5pX4NKgkNebQB7EYtKnspcnBuWJCqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSYQKCBxLVidGebNgUoYUUlnNnPC5RPOCvnLFrtP4rO2h1V3g9NHiOgi3UFfSQNcD
	 ebaVfr7CerqC/cvvuuXDf9/SqMjenu1l1OOCihvtFEV6uZHGVCaPEVUZYr+s0DzR03
	 YD718Wq6xQtmBQPiBKc0wORbd/1u9TZ5yCgN9BgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosryahmed@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 158/160] mm: shmem: fix ShmemHugePages at swapout
Date: Mon, 23 Dec 2024 16:59:29 +0100
Message-ID: <20241223155414.924886846@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit dad2dc9c92e0f93f33cebcb0595b8daa3d57473f upstream.

/proc/meminfo ShmemHugePages has been showing overlarge amounts (more than
Shmem) after swapping out THPs: we forgot to update NR_SHMEM_THPS.

Add shmem_update_stats(), to avoid repetition, and risk of making that
mistake again: the call from shmem_delete_from_page_cache() is the bugfix;
the call from shmem_replace_folio() is reassuring, but not really a bugfix
(replace corrects misplaced swapin readahead, but huge swapin readahead
would be a mistake).

Link: https://lkml.kernel.org/r/5ba477c8-a569-70b5-923e-09ab221af45b@google.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -779,6 +779,14 @@ static bool shmem_huge_global_enabled(st
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static void shmem_update_stats(struct folio *folio, int nr_pages)
+{
+	if (folio_test_pmd_mappable(folio))
+		__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr_pages);
+	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	__lruvec_stat_mod_folio(folio, NR_SHMEM, nr_pages);
+}
+
 /*
  * Somewhat like filemap_add_folio, but error if expected item has gone.
  */
@@ -813,10 +821,7 @@ static int shmem_add_to_page_cache(struc
 		xas_store(&xas, folio);
 		if (xas_error(&xas))
 			goto unlock;
-		if (folio_test_pmd_mappable(folio))
-			__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr);
-		__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
-		__lruvec_stat_mod_folio(folio, NR_SHMEM, nr);
+		shmem_update_stats(folio, nr);
 		mapping->nrpages += nr;
 unlock:
 		xas_unlock_irq(&xas);
@@ -844,8 +849,7 @@ static void shmem_delete_from_page_cache
 	error = shmem_replace_entry(mapping, folio->index, folio, radswap);
 	folio->mapping = NULL;
 	mapping->nrpages -= nr;
-	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
-	__lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
+	shmem_update_stats(folio, -nr);
 	xa_unlock_irq(&mapping->i_pages);
 	folio_put_refs(folio, nr);
 	BUG_ON(error);
@@ -1944,10 +1948,8 @@ static int shmem_replace_folio(struct fo
 	}
 	if (!error) {
 		mem_cgroup_replace_folio(old, new);
-		__lruvec_stat_mod_folio(new, NR_FILE_PAGES, nr_pages);
-		__lruvec_stat_mod_folio(new, NR_SHMEM, nr_pages);
-		__lruvec_stat_mod_folio(old, NR_FILE_PAGES, -nr_pages);
-		__lruvec_stat_mod_folio(old, NR_SHMEM, -nr_pages);
+		shmem_update_stats(new, nr_pages);
+		shmem_update_stats(old, -nr_pages);
 	}
 	xa_unlock_irq(&swap_mapping->i_pages);
 


