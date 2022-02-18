Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430453211
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 12:21:39 +0000 (UTC)
Received: by mail-ed1-f54.google.com with SMTP id s24so8751184edr.5
        for <patches@lists.linux.dev>; Fri, 18 Feb 2022 04:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hmEc5DoCLSD2DUJvNGydFX4svqDfjOrJL7x2lrpSPLk=;
        b=CcKCLBaPT80Z0Ha52pupsWCnMFYXy7bgQULIdXfwDMH9jGcQoTvbLhQ9wMsEkGrUgP
         y5KLlTAyZVa/I6W8kzmGg5ctllfTE795LOkwk/yBXxnqUVyaEbEwS0TyMmmmF/bApkW3
         JqfgOlbiYOuaouOsfd7tW1W4NndVQAwtd4xCYdp86nQ5J2uaX7Jh1226vYXxGmdRXCno
         SD/1NEm9WtU8Ex1H1w902lw0xa8IGuYrYaMM1hVIqutF7UM17ahpcD6BNJFHMqHf1x0z
         egOQh3b2d/znJRXCmaxrTdCwxJRY/z8W8f3FSvwpPrQuoQf57cpnENtcKT5nIkvJ6F21
         1xTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hmEc5DoCLSD2DUJvNGydFX4svqDfjOrJL7x2lrpSPLk=;
        b=KY2u8AhPTb4l+CJTdCqwPIJVWadm8eGP3m/Y4PbVGEa0+rnIkm+uk3Xw9e+TLsoozt
         Af+EU06U/eX9ZRAtxyRHAdMdR0o8IF9/VVqLVInM+AS2ElhAxMwNRAklRrkhPrN1TaaX
         is3k7cGmPud0qQOYlZnOYSv7s/Z7LlwV1BkDmMVE7EmwW7ORUhG+M7EiRJaD12r6x0WL
         B1hMUwnSuzeWJ6MjkQr5yRVpfGDvJxkXqWiEcLAZuE6kVL50AHSiM72MNeKW1vl/V2GT
         ZC2VxVoZc6+M9EEDjAyWc2zDunAPN14v/WpV1NmWZmWUtWf3XXNYIC1uZGvMFkFyRLE5
         1s7Q==
X-Gm-Message-State: AOAM532wNZPDHCsLM6z7sqFCx4myGmBb/R2C38yGYSNEZQIzOcEzp5Jv
	Uc0ElOF22VPvJKNOTp5lRLg=
X-Google-Smtp-Source: ABdhPJwVNqS56OqHGXAdnjOIi2ZizE0j3EbD6E/PqQm5nKLAxCraATH7mQWAOpRduhttWtSq1TRS0g==
X-Received: by 2002:a50:9b12:0:b0:410:b926:d2d3 with SMTP id o18-20020a509b12000000b00410b926d2d3mr7850271edi.331.1645186897584;
        Fri, 18 Feb 2022 04:21:37 -0800 (PST)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id 1sm2270586ejm.173.2022.02.18.04.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 04:21:35 -0800 (PST)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 435F3A7FF0; Fri, 18 Feb 2022 13:20:44 +0100 (CET)
From: =?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
To: linux-mm@kvack.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	vbabka@suse.cz,
	mhocko@kernel.org,
	mgorman@techsingularity.net,
	willy@infradead.org,
	liam.howlett@oracle.com,
	hughd@google.com,
	kirill@shutemov.name,
	riel@surriel.com,
	rostedt@goodmis.org,
	peterz@infradead.org,
	=?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
Subject: [RFC PATCH 1/4] [PATCH 1/4] mm: refactor of vma_merge()
Date: Fri, 18 Feb 2022 13:20:16 +0100
Message-Id: <20220218122019.130274-2-matenajakub@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218122019.130274-1-matenajakub@gmail.com>
References: <20220218122019.130274-1-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Refactor vma_merge() to make it shorter, more understandable and
suitable for tracing of successful merges made possible by following
patches in the series.

Signed-off-by: Jakub Matěna <matenajakub@gmail.com>
---
 mm/mmap.c | 81 +++++++++++++++++++++++++++----------------------------
 1 file changed, 39 insertions(+), 42 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 1e8fdb0b51ed..b55e11f20571 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1172,6 +1172,9 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	struct vm_area_struct *area, *next;
 	int err;
+	int merge_prev = 0;
+	int merge_both = 0;
+	int merge_next = 0;
 
 	/*
 	 * We later require that vma->vm_flags == vm_flags,
@@ -1191,65 +1194,59 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 	VM_WARN_ON(addr >= end);
 
 	/*
-	 * Can it merge with the predecessor?
+	 * Can we merge predecessor?
 	 */
 	if (prev && prev->vm_end == addr &&
 			mpol_equal(vma_policy(prev), policy) &&
 			can_vma_merge_after(prev, vm_flags,
 					    anon_vma, file, pgoff,
 					    vm_userfaultfd_ctx, anon_name)) {
-		/*
-		 * OK, it can.  Can we now merge in the successor as well?
-		 */
-		if (next && end == next->vm_start &&
-				mpol_equal(policy, vma_policy(next)) &&
-				can_vma_merge_before(next, vm_flags,
-						     anon_vma, file,
-						     pgoff+pglen,
-						     vm_userfaultfd_ctx, anon_name) &&
-				is_mergeable_anon_vma(prev->anon_vma,
-						      next->anon_vma, NULL)) {
-							/* cases 1, 6 */
-			err = __vma_adjust(prev, prev->vm_start,
-					 next->vm_end, prev->vm_pgoff, NULL,
-					 prev);
-		} else					/* cases 2, 5, 7 */
-			err = __vma_adjust(prev, prev->vm_start,
-					 end, prev->vm_pgoff, NULL, prev);
-		if (err)
-			return NULL;
-		khugepaged_enter_vma_merge(prev, vm_flags);
-		return prev;
+		merge_prev = true;
 	}
-
 	/*
-	 * Can this new request be merged in front of next?
+	 * Can we merge successor?
 	 */
 	if (next && end == next->vm_start &&
 			mpol_equal(policy, vma_policy(next)) &&
 			can_vma_merge_before(next, vm_flags,
-					     anon_vma, file, pgoff+pglen,
-					     vm_userfaultfd_ctx, anon_name)) {
+					anon_vma, file, pgoff+pglen,
+					vm_userfaultfd_ctx, anon_name)) {
+		merge_next = true;
+	}
+	/*
+	 * Can we merge both predecessor and successor?
+	 */
+	if (merge_prev && merge_next)
+		merge_both = is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL);
+
+	if (merge_both) {	 /* cases 1, 6 */
+		err = __vma_adjust(prev, prev->vm_start,
+					next->vm_end, prev->vm_pgoff, NULL,
+					prev);
+		area = prev;
+	} else if (merge_prev) {			/* cases 2, 5, 7 */
+		err = __vma_adjust(prev, prev->vm_start,
+					end, prev->vm_pgoff, NULL, prev);
+		area = prev;
+	} else if (merge_next) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
 			err = __vma_adjust(prev, prev->vm_start,
-					 addr, prev->vm_pgoff, NULL, next);
-		else {					/* cases 3, 8 */
+					addr, prev->vm_pgoff, NULL, next);
+		else					/* cases 3, 8 */
 			err = __vma_adjust(area, addr, next->vm_end,
-					 next->vm_pgoff - pglen, NULL, next);
-			/*
-			 * In case 3 area is already equal to next and
-			 * this is a noop, but in case 8 "area" has
-			 * been removed and next was expanded over it.
-			 */
-			area = next;
-		}
-		if (err)
-			return NULL;
-		khugepaged_enter_vma_merge(area, vm_flags);
-		return area;
+					next->vm_pgoff - pglen, NULL, next);
+		area = next;
+	} else {
+		err = -1;
 	}
 
-	return NULL;
+	/*
+	 * Cannot merge with predecessor or successor or error in __vma_adjust?
+	 */
+	if (err)
+		return NULL;
+	khugepaged_enter_vma_merge(area, vm_flags);
+	return area;
 }
 
 /*
-- 
2.34.1

