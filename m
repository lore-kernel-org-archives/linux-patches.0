Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1110C10E1
	for <patches@lists.linux.dev>; Fri,  3 Jun 2022 14:56:50 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id kq6so3415913ejb.11
        for <patches@lists.linux.dev>; Fri, 03 Jun 2022 07:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xDGUdvx1pZTgyR7PJdBJDYNZdw+7CJ97LAoW275dhVs=;
        b=RSfJURm0QkP/9Vq/fBoprT4aTS2dTIKLUzM/4tcnKiBXK0q++Pvc6+HW05p0AqIUYG
         BY0IZq8t7He8sycbNSRuJgs0AE4a0HsC552jBOp6reIGUO0fkfJ56KuGWF+D1Pme6BOP
         OKhRndSEHmQaxthqzxydfKYJv9CQXEjn7sm70oJNM8qD/J/8nYgw4Qy6y/DpkCnqkloS
         4cxKR8gPKRa/0Km47eUPxu3aWehYH6JGgXxX9MHVwla+IGMRIzzUzW2qftJRSjOY9uY5
         qKs6sLNbJCWBbmWAxINU/Qy2nP8+oVKt2GIBxkdUv44hb/FEtTGkohnG2sYsEm2Y16Y+
         sWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xDGUdvx1pZTgyR7PJdBJDYNZdw+7CJ97LAoW275dhVs=;
        b=OI0xzsf2cAIjt3S9+ygk37LV86+tErOPpAeshX+6ZiZP2P9blwdx4rEzV33/4gR8ep
         SWfCbohUMtknJY1V8ZbmiHwLsVUWnOKEQ1rYBuRmRguJ0v17gnV3/8Qq69mmaSxtIcay
         5x2up5KcWh6P+1pYT2+tHXdLpLb1iQgpvJ+oGuw6O9gQDNETxOlrw/2c7eZ0XIg+utDT
         e5b9hiDU7mqP9kCoBQcL+SgzE1Sn7C733AhfLnHR3I6C9kTs7z0hC5O10tHo0xfVYkw0
         mvUn34iw4QJuMUwmm84gBzxztMhUxf5SFWekWE+nUa3FdLS7koKP9CS4H8ge5bQcYrBE
         xddA==
X-Gm-Message-State: AOAM531ku4NgaCwF8oFflI0mBtgA3SwPclOeoYYUMjMIhnCh2FL1Ivl5
	g70GtJ9mChpWgCKce7iGxj0=
X-Google-Smtp-Source: ABdhPJx0+/KUkuEWOOtQ4+NUTALnnZ3ui7c8UbzzYK8djtmi4+WlxYaLTp0wVIUGCmcnTLAXkWvg0Q==
X-Received: by 2002:a17:907:3e18:b0:6fe:cf44:8692 with SMTP id hp24-20020a1709073e1800b006fecf448692mr9050521ejc.601.1654268209258;
        Fri, 03 Jun 2022 07:56:49 -0700 (PDT)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id k9-20020a1709061c0900b006fec27575f1sm2890627ejg.123.2022.06.03.07.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 07:56:46 -0700 (PDT)
Received: by orion.localdomain (Postfix, from userid 1003)
	id ABBE8A0013; Fri,  3 Jun 2022 16:57:20 +0200 (CEST)
From: =?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	patches@lists.linux.dev,
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
Subject: [PATCH v4 1/2] [PATCH 1/2] mm: refactor of vma_merge()
Date: Fri,  3 Jun 2022 16:57:18 +0200
Message-Id: <20220603145719.1012094-2-matenajakub@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220603145719.1012094-1-matenajakub@gmail.com>
References: <20220603145719.1012094-1-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Refactor vma_merge() to make it shorter and more understandable.
Main change is the elimination of code duplicity in the case of
merge next check. This is done by first doing checks and caching
the results before executing the merge itself. The variable 'area' is
divided into 'mid' and 'res' as previously it was used for two purposes,
as the middle VMA between prev and next and also as the result of the
merge itself. Exit paths are also unified.

Signed-off-by: Jakub Matěna <matenajakub@gmail.com>
---
 mm/mmap.c | 87 +++++++++++++++++++++++--------------------------------
 1 file changed, 37 insertions(+), 50 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 313b57d55a63..91100fdc400a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1170,8 +1170,10 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 			struct anon_vma_name *anon_name)
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
-	struct vm_area_struct *area, *next;
-	int err;
+	struct vm_area_struct *mid, *next, *res;
+	int err = -1;
+	bool merge_prev = false;
+	bool merge_next = false;
 
 	/*
 	 * We later require that vma->vm_flags == vm_flags,
@@ -1181,75 +1183,60 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 		return NULL;
 
 	next = find_vma(mm, prev ? prev->vm_end : 0);
-	area = next;
-	if (area && area->vm_end == end)		/* cases 6, 7, 8 */
+	mid = next;
+	if (next && next->vm_end == end)		/* cases 6, 7, 8 */
 		next = find_vma(mm, next->vm_end);
 
 	/* verify some invariant that must be enforced by the caller */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
-	VM_WARN_ON(area && end > area->vm_end);
+	VM_WARN_ON(mid && end > mid->vm_end);
 	VM_WARN_ON(addr >= end);
 
-	/*
-	 * Can it merge with the predecessor?
-	 */
+	/* Can we merge the predecessor? */
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
-		khugepaged_enter_vma(prev, vm_flags);
-		return prev;
+		merge_prev = true;
 	}
-
-	/*
-	 * Can this new request be merged in front of next?
-	 */
+	/* Can we merge the successor? */
 	if (next && end == next->vm_start &&
 			mpol_equal(policy, vma_policy(next)) &&
 			can_vma_merge_before(next, vm_flags,
 					     anon_vma, file, pgoff+pglen,
 					     vm_userfaultfd_ctx, anon_name)) {
+		merge_next = true;
+	}
+	/* Can we merge both the predecessor and the successor? */
+	if (merge_prev && merge_next &&
+			is_mergeable_anon_vma(prev->anon_vma,
+				next->anon_vma, NULL)) {	 /* cases 1, 6 */
+		err = __vma_adjust(prev, prev->vm_start,
+					next->vm_end, prev->vm_pgoff, NULL,
+					prev);
+		res = prev;
+	} else if (merge_prev) {			/* cases 2, 5, 7 */
+		err = __vma_adjust(prev, prev->vm_start,
+					end, prev->vm_pgoff, NULL, prev);
+		res = prev;
+	} else if (merge_next) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
 			err = __vma_adjust(prev, prev->vm_start,
-					 addr, prev->vm_pgoff, NULL, next);
-		else {					/* cases 3, 8 */
-			err = __vma_adjust(area, addr, next->vm_end,
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
-		khugepaged_enter_vma(area, vm_flags);
-		return area;
+					addr, prev->vm_pgoff, NULL, next);
+		else					/* cases 3, 8 */
+			err = __vma_adjust(mid, addr, next->vm_end,
+					next->vm_pgoff - pglen, NULL, next);
+		res = next;
 	}
 
-	return NULL;
+	/*
+	 * Cannot merge with predecessor or successor or error in __vma_adjust?
+	 */
+	if (err)
+		return NULL;
+	khugepaged_enter_vma(res, vm_flags);
+	return res;
 }
 
 /*
-- 
2.35.1

