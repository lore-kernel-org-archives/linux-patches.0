Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCA87C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E87C433D2;
	Mon, 24 Apr 2023 13:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342861;
	bh=7HQpbArraXO722c7LsNvEPYtRBg/Il/qB6GVgKIof3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cbSvzk/CGfR3wZLYKD0sstoXqzTVbwmaPccl/P4HbzFDeTjxUgaaTcCwoKi+2Djh
	 48vbI/tMSHRrHoFfQzUJCCO8Of4rKT09ZoUXA3+tJXP4ma7b9St8tPQqJgHOjRJaye
	 tsu5D+YS8ChxO7kqZE4/dqGYLePl+ZU6knOarSG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 78/98] mm/mmap: regression fix for unmapped_area{_topdown}
Date: Mon, 24 Apr 2023 15:17:41 +0200
Message-Id: <20230424131136.879302397@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 58c5d0d6d522112577c7eeb71d382ea642ed7be4 upstream.

The maple tree limits the gap returned to a window that specifically fits
what was asked.  This may not be optimal in the case of switching search
directions or a gap that does not satisfy the requested space for other
reasons.  Fix the search by retrying the operation and limiting the search
window in the rare occasion that a conflict occurs.

Link: https://lkml.kernel.org/r/20230414185919.4175572-1-Liam.Howlett@oracle.com
Fixes: 3499a13168da ("mm/mmap: use maple tree for unmapped_area{_topdown}")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |   48 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1565,7 +1565,8 @@ static inline int accountable_mapping(st
  */
 static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap;
+	unsigned long length, gap, low_limit;
+	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 
@@ -1574,12 +1575,29 @@ static unsigned long unmapped_area(struc
 	if (length < info->length)
 		return -ENOMEM;
 
-	if (mas_empty_area(&mas, info->low_limit, info->high_limit - 1,
-				  length))
+	low_limit = info->low_limit;
+retry:
+	if (mas_empty_area(&mas, low_limit, info->high_limit - 1, length))
 		return -ENOMEM;
 
 	gap = mas.index;
 	gap += (info->align_offset - gap) & info->align_mask;
+	tmp = mas_next(&mas, ULONG_MAX);
+	if (tmp && (tmp->vm_flags & VM_GROWSDOWN)) { /* Avoid prev check if possible */
+		if (vm_start_gap(tmp) < gap + length - 1) {
+			low_limit = tmp->vm_end;
+			mas_reset(&mas);
+			goto retry;
+		}
+	} else {
+		tmp = mas_prev(&mas, 0);
+		if (tmp && vm_end_gap(tmp) > gap) {
+			low_limit = vm_end_gap(tmp);
+			mas_reset(&mas);
+			goto retry;
+		}
+	}
+
 	return gap;
 }
 
@@ -1595,7 +1613,8 @@ static unsigned long unmapped_area(struc
  */
 static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap;
+	unsigned long length, gap, high_limit, gap_end;
+	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 	/* Adjust search length to account for worst case alignment overhead */
@@ -1603,12 +1622,31 @@ static unsigned long unmapped_area_topdo
 	if (length < info->length)
 		return -ENOMEM;
 
-	if (mas_empty_area_rev(&mas, info->low_limit, info->high_limit - 1,
+	high_limit = info->high_limit;
+retry:
+	if (mas_empty_area_rev(&mas, info->low_limit, high_limit - 1,
 				length))
 		return -ENOMEM;
 
 	gap = mas.last + 1 - info->length;
 	gap -= (gap - info->align_offset) & info->align_mask;
+	gap_end = mas.last;
+	tmp = mas_next(&mas, ULONG_MAX);
+	if (tmp && (tmp->vm_flags & VM_GROWSDOWN)) { /* Avoid prev check if possible */
+		if (vm_start_gap(tmp) <= gap_end) {
+			high_limit = vm_start_gap(tmp);
+			mas_reset(&mas);
+			goto retry;
+		}
+	} else {
+		tmp = mas_prev(&mas, 0);
+		if (tmp && vm_end_gap(tmp) > gap) {
+			high_limit = tmp->vm_start;
+			mas_reset(&mas);
+			goto retry;
+		}
+	}
+
 	return gap;
 }
 


