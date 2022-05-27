Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D00523AF
	for <patches@lists.linux.dev>; Fri, 27 May 2022 21:16:43 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id rs12so10836386ejb.13
        for <patches@lists.linux.dev>; Fri, 27 May 2022 14:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ru3bkI46cGQXTo5hSsyPFl2jKgUjs/czASVw2IToYVQ=;
        b=EKUNVPeMnRd274p6w7NzjRvrzG+1Vzb7NNsyThVrB39jtt3BmGdNB/FDIDQ8Je0Wkx
         79yb+Ur+1BNH3EWYCuXMnj0n4tKugWeTV/s6bQcmOjS/M4BzSwrdWhCKYflx5cS6JWwZ
         6DG2nqaH9HMKivoo/hcCev2L4qhr4MGxmXJuLLmrTD17/fsjm24k+7Z6PCvgZjDVyqex
         Bx2LBogNAW2x+xspwzeZH54qtfWtb71D/v7ScGfgxdAqBegWi/gd0KzBvqIG2+af8VY0
         kcnb24+Fo8IxXa+Yi9DSTzWv7OhloaWyqJX/a0queK5D4HGlSoS2mC1nVepbi8KmB/pm
         bUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ru3bkI46cGQXTo5hSsyPFl2jKgUjs/czASVw2IToYVQ=;
        b=d9IWYni2VI9Q4Rkwb73xR2YfN1sMgl6/qzkpiirQ/zOP7ihsWOQZhgMkEbVRqV1hNo
         /aR+u8QssYz7Qg3LXvn1qGb4YaekAamsrrWjlwXEjiRmK/lVjgz40bbjtj0qHcpJfY88
         MubxWqvMF3lJaqzNKyBBe8lYM0VPB9VyY3vwMlgFHQWhxHy7Sj9mtbxbFSDBJkrff73F
         8wTDbza9zTMMjNVtnaVDgm9xWcLkONAqGu4/2YoORxnD2rv/GCbH8lQDJtI3F+lvQjQL
         PwOxbtpU/ckOhJFE95voW3yooVw1zs7GKqfDB70iLS3h+G6LDo2VXbvG8x9bXDyzO0ZL
         GwGg==
X-Gm-Message-State: AOAM530xRVbLPqbOI8c7srBOoP8i8ot+jWqUAI0+L5G+fl2+R+1k2JY6
	Xqf8hbz38Fzt5wj8eMjuMqc=
X-Google-Smtp-Source: ABdhPJw7il9s5g0FRdrNg4rA7uzSJ8eWBPX96AILajtYjt+pBgDXP+GyifzqQ2lxEqw4rM0JJ4VDpA==
X-Received: by 2002:a17:907:3e09:b0:6ff:20f:9b1a with SMTP id hp9-20020a1709073e0900b006ff020f9b1amr19318212ejc.679.1653686201666;
        Fri, 27 May 2022 14:16:41 -0700 (PDT)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id m22-20020a17090679d600b006f3ef214da9sm1814854ejo.15.2022.05.27.14.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 14:16:40 -0700 (PDT)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 11BDFA0018; Fri, 27 May 2022 23:17:10 +0200 (CEST)
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
Subject: [PATCH v2 1/2] [PATCH 1/2] mm: refactor of vma_merge()
Date: Fri, 27 May 2022 23:17:07 +0200
Message-Id: <20220527211708.839033-2-matenajakub@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220527211708.839033-1-matenajakub@gmail.com>
References: <20220527211708.839033-1-matenajakub@gmail.com>
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
index 3aa839f81e63..bd0dde2ad3e2 100644
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
 
 	next = vma_next(mm, prev);
-	area = next;
-	if (area && area->vm_end == end)		/* cases 6, 7, 8 */
+	mid = next;
+	if (next && next->vm_end == end)		/* cases 6, 7, 8 */
 		next = next->vm_next;
 
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
-		khugepaged_enter_vma_merge(prev, vm_flags);
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
-		khugepaged_enter_vma_merge(area, vm_flags);
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
+	khugepaged_enter_vma_merge(res, vm_flags);
+	return res;
 }
 
 /*
-- 
2.35.1

