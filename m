Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348C257E8
	for <patches@lists.linux.dev>; Fri, 11 Mar 2022 17:46:04 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id yy13so20707315ejb.2
        for <patches@lists.linux.dev>; Fri, 11 Mar 2022 09:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=09Pa4q2b4vX67JHZNNkgoh3+KCy7fCLjcgKDWwRT+M0=;
        b=DLAOcfyY4RSMcyqKyRAYZJw4xE61oYMJpgI+6BgAA5I8tDn6gOw/xkp0RylEQ+BNG+
         X39US6T7op8ybAYMVIohzhKnlFqbUyGI1nmeDVMJu4r0EFookP8UKAVCn0b9I0S4r9EG
         zRr2tJSNzseIfWg5zifBxJn5RpDYyC6hTMj1hhMmGpTKHVIS5wJ6w834mHZiFJgkcJED
         zLZiHIeQa0DH1RPSwXLHUOxDA+GJzV6U8W0o4sDbKCiRwu/qAd9UKUu8cIULaI1Hjfp9
         o9zV7HGVWbHNVSdUBl4Wu+d+et3xkhKh96P8usb+0UMW6piuQlF2y+YZWK1gs2rGV1Dw
         CVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=09Pa4q2b4vX67JHZNNkgoh3+KCy7fCLjcgKDWwRT+M0=;
        b=WdiuOG+1J56DhObbz1SPnLdgSd1M5RrD0KHgdz+iDn2U58ZBGfXTR7IKUQW7B17PA7
         6Zf5Sa8kOw1+rVh1vxjzeVAoEEcnHGc/ep26BDEHIsMT2T/QDVSvkm8TNpuFf9orR4o0
         sfxZqlog3n7com4eKoUyiMDT1uFpfWVq9xm4/Qy7bdAh1uk17m4KAFouHMZv6FIJZnku
         8rzR3dQLuNIDxnTw22CTTK5bTBhxYx8XFFItj8NBGu4w+E9iQ8pohUisMg+gfatBSCWb
         5/1u1deTQdzHcpNUApwMcUi43107hfNfYnkjYD17QjGTAFVMyIT+dZxTDINP4uORez0d
         pDZg==
X-Gm-Message-State: AOAM530G+22582AWFRVDNfqCpoLOTd2SfQOUgAoOGvQi58X0oqqOY3/J
	KeMXPndKffihyfHLTQy4rdI=
X-Google-Smtp-Source: ABdhPJyHfDu2o5XZ2wRtC0e82YeqMCLO+OmeSyH71sQYMclcdq3RHn7j70Faw1aLHMPlviZ/+d4w2w==
X-Received: by 2002:a17:906:9b95:b0:6db:38fc:5ff4 with SMTP id dd21-20020a1709069b9500b006db38fc5ff4mr9143643ejc.114.1647020762408;
        Fri, 11 Mar 2022 09:46:02 -0800 (PST)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id i21-20020a1709061cd500b006da62ab503csm3159886ejh.157.2022.03.11.09.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 09:46:01 -0800 (PST)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 814DCA00A8; Fri, 11 Mar 2022 18:46:03 +0100 (CET)
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
Subject: [RFC PATCH v2 1/4] [PATCH 1/4] mm: refactor of vma_merge()
Date: Fri, 11 Mar 2022 18:45:59 +0100
Message-Id: <20220311174602.288010-2-matenajakub@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220311174602.288010-1-matenajakub@gmail.com>
References: <20220311174602.288010-1-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Refactor vma_merge() to make it shorter, more understandable and
suitable for tracing of successful merges that are made possible by
following patches in the series. Main change is the elimination of code
duplicity in the case of merge next check. This is done by first doing
checks and caching the results before executing the merge itself. Exit
paths are also unified.

Signed-off-by: Jakub Matěna <matenajakub@gmail.com>
---
 mm/mmap.c | 81 +++++++++++++++++++++++++------------------------------
 1 file changed, 36 insertions(+), 45 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 1e8fdb0b51ed..8d817b11c656 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1171,7 +1171,9 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	struct vm_area_struct *area, *next;
-	int err;
+	int err = -1;
+	bool merge_prev = false;
+	bool merge_next = false;
 
 	/*
 	 * We later require that vma->vm_flags == vm_flags,
@@ -1190,66 +1192,55 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 	VM_WARN_ON(area && end > area->vm_end);
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
+		area = prev;
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
+	} else if (merge_prev) {			/* cases 2, 5, 7 */
+		err = __vma_adjust(prev, prev->vm_start,
+					end, prev->vm_pgoff, NULL, prev);
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
+		/*
+		 * In case 3 and 4 area is already equal to next and
+		 * this is a noop, but in case 8 "area" has
+		 * been removed and next was expanded over it.
+		 */
+		area = next;
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

