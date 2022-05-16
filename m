Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E58ED2
	for <patches@lists.linux.dev>; Mon, 16 May 2022 12:53:47 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id n6so914701wms.0
        for <patches@lists.linux.dev>; Mon, 16 May 2022 05:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1zMWiBKrxJRt4dm7AECg/jq1FaXgoQHTOEXoqP7ndjs=;
        b=mZvVdyV4R2NcvGq9PkFdJMQvHTRv8eCR1cvl/UDrc9cP/TP6x0tncRCcBuir+2FIdK
         ZxTdX/iI8L9vq2skwvMtr/gCeUCuGpaAuhNu6q5UvR9CSxtwi99hwLYDmkxcHe00t6ew
         6Zlr/N+Ko8pCvL44oTBUHUbtvTel3xc3XVycs6ybFhIZTQtMLHry6Ehj8oSBsjUKEMg5
         20Taq3qqMX3qqjoT18hnG05xQ0gVV/pttQErniIEaCnO/+DXYisblcvK+B/0Gi+6BRCa
         KZSCqQcW8MKFlWmybnuiVfeSrIkjVcaMrgVTl1uSSL9UGZUDcC827xITl6iJcZaVSe+9
         oU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1zMWiBKrxJRt4dm7AECg/jq1FaXgoQHTOEXoqP7ndjs=;
        b=t0Njmd7LXwIWeqZYMYbdkCJJk9GBj6EZ1lninPuPPRsE2gPZ48zepsL6LXPGjQhWG6
         vmHMBHjNxQn6ZJQRqRzqtbnSa5SMs2hyyJVJthvxInZ8dBNMfMVu52nihMInHGr5y1BH
         kPq7HSBXkmiTDCovhlNbfJDtPqxmllCBfqNTOaMWZDKL2xf7Ae1/gt5DgdFsnwrdCZJ7
         iEjT0FTvdEmB+3ZI2mAsDC4polhOgi7VePAvBiGVvAzlmyjnoFyV+1i2ntdyp9LfRV9p
         CR29ozZnmQeCv4xb99uNiaQK5iXMa3U4BjJgpx/SKd6UYgPhCEU/A/sRJlMhv8RRsyD2
         mxPA==
X-Gm-Message-State: AOAM531Xx9PzRY+JJ34hxBUxBknQNlXDYXGeu0JGWd+1eD0WfomMyMyG
	oZh6nABPRI45MPzMYGiujks=
X-Google-Smtp-Source: ABdhPJw8lMmpeW5ADElTuWJi8C91ciKJd0nw+e53cYaNTI5gWF8KbPB3ZQGhRbb9YDktYFilc2BG8A==
X-Received: by 2002:a05:600c:3d8c:b0:394:6097:9994 with SMTP id bi12-20020a05600c3d8c00b0039460979994mr26918715wmb.29.1652705625931;
        Mon, 16 May 2022 05:53:45 -0700 (PDT)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id u23-20020a05600c00d700b003942a244ec2sm9958565wmm.7.2022.05.16.05.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 05:53:45 -0700 (PDT)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 8BBBCA0E76; Mon, 16 May 2022 14:54:07 +0200 (CEST)
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
	david@redhat.com,
	=?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
Subject: [RFC PATCH v3 1/6] [PATCH 1/6] mm: refactor of vma_merge()
Date: Mon, 16 May 2022 14:54:00 +0200
Message-Id: <20220516125405.1675-2-matenajakub@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220516125405.1675-1-matenajakub@gmail.com>
References: <20220516125405.1675-1-matenajakub@gmail.com>
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
index 3aa839f81e63..4a4611443593 100644
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
2.35.1

