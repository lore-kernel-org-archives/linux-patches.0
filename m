Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680D83812E9;
	Thu, 20 Aug 2026 15:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239218; cv=none; b=DG9d3uEJJLB/sFfLXSE8m6eZZhoeRAtSspcRl9CSGYTj3yKM4WQo9SvRaCWAOBYuF07z6FO0cBTh076sDIwhsGTIN924qm6aTRGCHHjrObCoUo7AyMEhd9Fn9we+3pwgo5fs0qUuGuOSsll9x1bilsA+qTieH+7sGZMfk2VrhEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239218; c=relaxed/simple;
	bh=KF/9uEwG3IhMD/+RwkhpHfnJI2MJQxmvSHIve9V7R0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1TX4Pre4+jBZZijcUR3mcPaVXS2W6pdfbPW7qCi5zSpYK+H8uef+rZIta/3aJIUvRMUQNrFCVf32Ha2Zzigo9iuHAIBBuTxD3q88+4SxlqLK3DiuLZD1zyBa25uY/so+3x+fLLZ0jEJJRrtuZgapAy2azbFHKibxN4UWnxQx3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jS9Jkge4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jS9Jkge4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8522D1F000E9;
	Thu, 20 Aug 2026 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239217;
	bh=kYaKaZNkqJtjyZGQCY4mePARZsO5ks/zKvuacPLE05U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jS9Jkge43GsUjHB9wyE9kQunNs5C7Mo/B7nNGBC+geuFE+C7qyajrZNK+O5IyCU/o
	 7i+NZdTxjYhxk9FreWv+I9STOOXVibvOLGhwOJ7xAmyccZ4vtTOeEqdtRZ5qUO/iqZ
	 CKwUE0drt80Irr2H/5Rwc65SVtwL+nQiYKYRDntE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Vega <vega@nebusec.ai>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 163/217] mm/page_table_check: skip special zero mappings
Date: Thu, 20 Aug 2026 16:55:31 +0200
Message-ID: <20260820145242.657638740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 8db4bab826ccc9ec10fa41736a48031cd338d392 ]

page_table_check_set() and page_table_check_clear() account mappings based
on PageAnon().  Shared zero-page PTEs and huge zero PMDs are special
mappings, but page_table_check can still account them as file-backed
pages.

An unprivileged process can populate enough zero mappings to overflow
file_map_count and hit the existing BUG_ON().  The PTE path can do this
with the shared zero page, and the PMD path can do the same with huge zero
mappings.

Skip special zero mappings in the user page-table accounting paths.  Keep
the PTE-side pte_special() check, and identify huge zero PMDs from the
mapped folio instead of pmd_special().  That covers architectures where
pmd_special() is a no-op without adding huge_zero_pfn checks to the
generic counter helpers.

Link: https://lore.kernel.org/cover.1784717203.git.zhilinz@nebusec.ai
Link: https://lore.kernel.org/e94478e4fb7912fb7e8ebebed5ce85d00dc9a69d.1784717203.git.zhilinz@nebusec.ai
Fixes: df4e817b7108 ("mm: page table check")
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Reported-by: Vega <vega@nebusec.ai>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Assisted-by: Codex:gpt-5.4
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_table_check.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -150,18 +150,29 @@ void __page_table_check_pte_clear(struct
 	if (&init_mm == mm)
 		return;
 
-	if (pte_user_accessible_page(pte)) {
+	if (pte_user_accessible_page(pte) && !pte_special(pte)) {
 		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
 
+static inline bool page_table_check_huge_zero_pmd(pmd_t pmd)
+{
+	unsigned long pfn = pmd_pfn(pmd);
+
+	if (!pfn_valid(pfn))
+		return false;
+
+	return is_huge_zero_folio(page_folio(pfn_to_page(pfn)));
+}
+
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
 
-	if (pmd_user_accessible_page(pmd)) {
+	if (pmd_user_accessible_page(pmd) &&
+	    !page_table_check_huge_zero_pmd(pmd)) {
 		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
 	}
 }
@@ -205,7 +216,7 @@ void __page_table_check_ptes_set(struct
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
-	if (pte_user_accessible_page(pte))
+	if (pte_user_accessible_page(pte) && !pte_special(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
@@ -231,7 +242,8 @@ void __page_table_check_pmds_set(struct
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pmd_clear(mm, *(pmdp + i));
-	if (pmd_user_accessible_page(pmd))
+	if (pmd_user_accessible_page(pmd) &&
+	    !page_table_check_huge_zero_pmd(pmd))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
 EXPORT_SYMBOL(__page_table_check_pmds_set);


