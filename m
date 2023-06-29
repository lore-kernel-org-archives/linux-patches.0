Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F23014267
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FB9C433C8;
	Thu, 29 Jun 2023 18:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064323;
	bh=j2WVlVVeInvptx0GoFQipPMaNt1fUn+tTaOTZi/gCiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1z0eqAInr0RpZ45dGjNi26byfPx3Rtz0nqVzXgvJPcdympuSaX3a6DyWZ+xLvz/rt
	 qPgQpovltNlAmc/vGEHaz39mcrEfFenwjnh5ndwleXbNXGLYEcLpmnmUDe9FvRimLc
	 UN+B+LgeLj7ZwlIemvv2/v2VXfG4+sdJz2PG4TuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Samuel Mendoza-Jonas <samjonas@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 6.1 24/30] execve: expand new process stack manually ahead of time
Date: Thu, 29 Jun 2023 20:43:43 +0200
Message-ID: <20230629184152.635247030@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.651069086@linuxfoundation.org>
References: <20230629184151.651069086@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

commit f313c51d26aa87e69633c9b46efb37a930faca71 upstream.

This is a small step towards a model where GUP itself would not expand
the stack, and any user that needs GUP to not look up existing mappings,
but actually expand on them, would have to do so manually before-hand,
and with the mm lock held for writing.

It turns out that execve() already did almost exactly that, except it
didn't take the mm lock at all (it's single-threaded so no locking
technically needed, but it could cause lockdep errors).  And it only did
it for the CONFIG_STACK_GROWSUP case, since in that case GUP has
obviously never expanded the stack downwards.

So just make that CONFIG_STACK_GROWSUP case do the right thing with
locking, and enable it generally.  This will eventually help GUP, and in
the meantime avoids a special case and the lockdep issue.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[6.1 Minor context from still having FOLL_FORCE flags set]
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -198,34 +198,39 @@ static struct page *get_arg_page(struct
 		int write)
 {
 	struct page *page;
+	struct vm_area_struct *vma = bprm->vma;
+	struct mm_struct *mm = bprm->mm;
 	int ret;
-	unsigned int gup_flags = FOLL_FORCE;
 
-#ifdef CONFIG_STACK_GROWSUP
-	if (write) {
-		/* We claim to hold the lock - nobody to race with */
-		ret = expand_downwards(bprm->vma, pos, true);
-		if (ret < 0)
+	/*
+	 * Avoid relying on expanding the stack down in GUP (which
+	 * does not work for STACK_GROWSUP anyway), and just do it
+	 * by hand ahead of time.
+	 */
+	if (write && pos < vma->vm_start) {
+		mmap_write_lock(mm);
+		ret = expand_downwards(vma, pos, true);
+		if (unlikely(ret < 0)) {
+			mmap_write_unlock(mm);
 			return NULL;
-	}
-#endif
-
-	if (write)
-		gup_flags |= FOLL_WRITE;
+		}
+		mmap_write_downgrade(mm);
+	} else
+		mmap_read_lock(mm);
 
 	/*
 	 * We are doing an exec().  'current' is the process
-	 * doing the exec and bprm->mm is the new process's mm.
+	 * doing the exec and 'mm' is the new process's mm.
 	 */
-	mmap_read_lock(bprm->mm);
-	ret = get_user_pages_remote(bprm->mm, pos, 1, gup_flags,
+	ret = get_user_pages_remote(mm, pos, 1,
+			write ? FOLL_WRITE : 0,
 			&page, NULL, NULL);
-	mmap_read_unlock(bprm->mm);
+	mmap_read_unlock(mm);
 	if (ret <= 0)
 		return NULL;
 
 	if (write)
-		acct_arg_size(bprm, vma_pages(bprm->vma));
+		acct_arg_size(bprm, vma_pages(vma));
 
 	return page;
 }


