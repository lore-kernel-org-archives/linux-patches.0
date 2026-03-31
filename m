Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD0F31714F;
	Tue, 31 Mar 2026 16:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975393; cv=none; b=M/vwaBP0Sb6jPZOvbZxejsykkC+XYgBWX/iuCG9lR/uffe4o2T7s4Hg/20nKx5IeuZT8tXX6eg/C7m+99l307Z6Hcf+6d3w/nrmk9m34Q8Z7I9sNd2sK+J3fx9yegCx02CzeEfeE2bXqHs+0oNUsWg3hbnQxuguPTwbDkq3+Kwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975393; c=relaxed/simple;
	bh=aQO3PtaSQtqOwaJgJAE/3CtUKgfLsoVc4ki/9697UJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UalvN4gbJbcXJ/yNqMjqZTDxV0Aq2iXemJ6PcXP2tVPIUTchKvNfEsVcawUqvZ3Ep7qBK320om8hVe2TR1BcnhjdIFjoFmv9aUhRO0ZuvxjetEMV4LfdoHQ53ZSrDOoHNj6Gfa9QajKTLmoWR6Iss14QQsrs3JOKLzW9wCV0668=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoaW91De; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoaW91De"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A72C19423;
	Tue, 31 Mar 2026 16:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975393;
	bh=aQO3PtaSQtqOwaJgJAE/3CtUKgfLsoVc4ki/9697UJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoaW91De2+wDjW517mhGoUKnn5wVB+dewwHjMjo9tWj3zAjY6HuuZWjT3ZJx5BwEM
	 cfBXHFNJNWlb0QfPNaMKaqLYQCXLTs81AL6sqNHm5YKPDYzpTRzSipOgRvfowjs9TI
	 lsjsc/phzmJbMFB7m777zNiGXagInNETCt67CtgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Antonius <antonius@bluedragonsec.com>,
	"David Hildenbrand (ARM)" <david@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 278/342] mm/mseal: update VMA end correctly on merge
Date: Tue, 31 Mar 2026 18:21:51 +0200
Message-ID: <20260331161809.167794779@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

commit 2697dd8ae721db4f6a53d4f4cbd438212a80f8dc upstream.

Previously we stored the end of the current VMA in curr_end, and then upon
iterating to the next VMA updated curr_start to curr_end to advance to the
next VMA.

However, this doesn't take into account the fact that a VMA might be
updated due to a merge by vma_modify_flags(), which can result in curr_end
being stale and thus, upon setting curr_start to curr_end, ending up with
an incorrect curr_start on the next iteration.

Resolve the issue by setting curr_end to vma->vm_end unconditionally to
ensure this value remains updated should this occur.

While we're here, eliminate this entire class of bug by simply setting
const curr_[start/end] to be clamped to the input range and VMAs, which
also happens to simplify the logic.

Link: https://lkml.kernel.org/r/20260327173104.322405-1-ljs@kernel.org
Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reported-by: Antonius <antonius@bluedragonsec.com>
Closes: https://lore.kernel.org/linux-mm/CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com/
Suggested-by: David Hildenbrand (ARM) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mseal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -56,7 +56,6 @@ static int mseal_apply(struct mm_struct
 		unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma, *prev;
-	unsigned long curr_start = start;
 	VMA_ITERATOR(vmi, mm, start);
 
 	/* We know there are no gaps so this will be non-NULL. */
@@ -66,6 +65,7 @@ static int mseal_apply(struct mm_struct
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
+		const unsigned long curr_start = MAX(vma->vm_start, start);
 		const unsigned long curr_end = MIN(vma->vm_end, end);
 
 		if (!(vma->vm_flags & VM_SEALED)) {
@@ -79,7 +79,6 @@ static int mseal_apply(struct mm_struct
 		}
 
 		prev = vma;
-		curr_start = curr_end;
 	}
 
 	return 0;


