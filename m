Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246FD53B348;
	Wed, 23 Sep 2026 14:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174905; cv=none; b=HEWbdHTR0d0PjFDRR2rET5aDv31smvK9DV6oSmXaBaJYrsWU5Yr0UzYt3kZirzCRKwmR0o0l6ZguM8wvCqjsi3gK8ckBN9fGjfCc88QhKFW7shT2HNuQlu63hAtxvdexC6lXt6sABNEXPb1JE7Xlc9XnfbOzObysRT22mvZN/oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174905; c=relaxed/simple;
	bh=rVXx3V32nD/lAwYW/MW5TnikoQHYiXETvR6LGfBqjKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRa1SSIj0J2QlG6C2d9jfBJPEb9AB6bwBruGCfF4EXrMnOfPtqY29KPn+Spyz0HlxQGYuYK/pNltXNolHjrbIdgXZYaCfQQadYxHTx02meEcp9b2S33pVKNEXGZixSzjRCl7wM8OUQeO0ByBjNucUZHhf6D+N7E3WuR3Xf4u7D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmh17upW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmh17upW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787A01F000FF;
	Wed, 23 Sep 2026 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174904;
	bh=ypv8TXmamGbUkmTHirneilpUueHIZUAsk2Oy/c1bZFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmh17upWOsR23KpZlafMnv4OaB4ynJ7ISFT+Ga0GXmK1gYnENOEHd1vseUMt2M24z
	 n8gi0PQGTjjJX9eybG/QLNDuqvClzq1id/WPpPD72mngho92dChMQkyl7J0b0RL0YW
	 ThIILWhWus/C9EEuvLqv3su6jJFYDDuisQPhgCRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 261/398] mm/mremap: account mm->locked_vm correctly for MREMAP_DONTUNMAP
Date: Wed, 23 Sep 2026 16:05:35 +0200
Message-ID: <20260923140650.177967426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
Message-ID: <20260923140535.-COOV-pavnh3Cz7UjjXOuDFyBpamei48Rwh7RkkooGo@z>

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit 397432cab17bccb600fd6c16ed593f1149042268 upstream.

When a VMA is mremap()'d with MREMAP_DONTUNMAP set, that results in the
VMA being copied, but the source VMA not being unmapped.

If the VMA is mlock()'d this is a legal operation, though the source VMA
has its VMA_LOCKED_BIT cleared.

However this is done in dontunmap_complete(), after mm->locked_vm was
incremented via vrm_stat_account(), resulting in double-counting.

Worse, this is not even corrected when source VMA is unmapped, due to the
VMA_LOCKED_BIT flag having been cleared.

This all works fine in the usual mremap() case (without MREMAP_DONTUNMAP),
as the source VMA is unmapped with VMA_LOCKED_BIT intact, at which time
mm->locked_vm is decremented accordingly.

Resolve the issue by invoking vrm_stat_account() only after
dontunmap_complete() has run.

Note that MREMAP_DONTUNMAP requires old_len == new_len, so no need to
account for a delta in size in this case.

The bug was introduced by commit b714ccb02a76 ("mm/mremap: complete
refactor of move_vma()") which incorrectly reordered the accounting and
the clearing of the VMA_LOCKED_BIT flag.

Link: https://lore.kernel.org/20260828-mremap-fix-locked-vm-v1-1-c80be7505d1e@kernel.org
Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
Closes: https://lore.kernel.org/all/20260828094823.594279-1-kunwu.chan@linux.dev/
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Tested-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1270,12 +1270,11 @@ static void dontunmap_complete(struct vm
 		if (vma_is_anonymous(vma) && !vma->vm_file)
 			vma->vm_pgoff = pgoff_unfaulted;
 	}
-
-	/* Because we won't unmap we don't need to touch locked_vm. */
 }
 
 static unsigned long move_vma(struct vma_remap_struct *vrm)
 {
+	const bool is_dontunmap = vrm->flags & MREMAP_DONTUNMAP;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *new_vma;
 	unsigned long hiwater_vm;
@@ -1316,10 +1315,10 @@ static unsigned long move_vma(struct vma
 	 */
 	hiwater_vm = mm->hiwater_vm;
 
-	vrm_stat_account(vrm, vrm->new_len);
-	if (unlikely(!err && (vrm->flags & MREMAP_DONTUNMAP)))
+	if (unlikely(is_dontunmap && !err))
 		dontunmap_complete(vrm, new_vma);
-	else
+	vrm_stat_account(vrm, vrm->new_len);
+	if (!is_dontunmap || err)
 		unmap_source_vma(vrm);
 
 	mm->hiwater_vm = hiwater_vm;


