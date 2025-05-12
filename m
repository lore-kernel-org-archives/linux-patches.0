Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F3D1519B8;
	Mon, 12 May 2025 18:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072852; cv=none; b=gPc14O0XWwJwU7YxfHFGNG7FjkKkZ8jiyqRFNuCy7C8/JD5roiT81xN0QC6I1pafuuWgWAO4mZtvYUF/4VlFRb/XGv9jHTv+kjcPQrxyFCfoFyT4KGFRC2CmCoE911g6q4/9EZ1mFzqcXrTOhBWoSxnut0b2vKOaUMiKWuvL8kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072852; c=relaxed/simple;
	bh=C7NFKrmVYyCg51kJ67jug8Ag7HkIJZrQkLRpywzwzGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsqIKeR8LNHxP7R6eBzKAsyszFvTh76y4I2PPuVgeYFTIFkdoLHmWjT8io1zGfxu7DNCDtBMEsCnImDisTQ9i4cm3CFBlhElNFiK5uhQTvOGEciMLKIxz2nPJIJ72swyPOKejueeflXVOgTJQDn1woEJalWAimZwrv8lBJv4auI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qfi6QxHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qfi6QxHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB333C4CEE7;
	Mon, 12 May 2025 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072852;
	bh=C7NFKrmVYyCg51kJ67jug8Ag7HkIJZrQkLRpywzwzGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qfi6QxHSqP1+CJyBvVIOyhYHUB7bHU80K0wSEKT0JTk5Eh1E99xwEBq16fgU2SgJj
	 gYaHEj/OW1EAM6sYUrzbDRxuW36wEa89SKrolQeErCV5gFh5yF+x7XU+jJr/4LETAU
	 X5lWLVDZyvu07kSkODRW+1IS82li17+eK94p7NAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 076/184] mm/userfaultfd: fix uninitialized output field for -EAGAIN race
Date: Mon, 12 May 2025 19:44:37 +0200
Message-ID: <20250512172044.922617074@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Xu <peterx@redhat.com>

commit 95567729173e62e0e60a1f8ad9eb2e1320a8ccac upstream.

While discussing some userfaultfd relevant issues recently, Andrea noticed
a potential ABI breakage with -EAGAIN on almost all userfaultfd ioctl()s.

Quote from Andrea, explaining how -EAGAIN was processed, and how this
should fix it (taking example of UFFDIO_COPY ioctl):

  The "mmap_changing" and "stale pmd" conditions are already reported as
  -EAGAIN written in the copy field, this does not change it. This change
  removes the subnormal case that left copy.copy uninitialized and required
  apps to explicitly set the copy field to get deterministic
  behavior (which is a requirement contrary to the documentation in both
  the manpage and source code). In turn there's no alteration to backwards
  compatibility as result of this change because userland will find the
  copy field consistently set to -EAGAIN, and not anymore sometime -EAGAIN
  and sometime uninitialized.

  Even then the change only can make a difference to non cooperative users
  of userfaultfd, so when UFFD_FEATURE_EVENT_* is enabled, which is not
  true for the vast majority of apps using userfaultfd or this unintended
  uninitialized field may have been noticed sooner.

Meanwhile, since this bug existed for years, it also almost affects all
ioctl()s that was introduced later.  Besides UFFDIO_ZEROPAGE, these also
get affected in the same way:

  - UFFDIO_CONTINUE
  - UFFDIO_POISON
  - UFFDIO_MOVE

This patch should have fixed all of them.

Link: https://lkml.kernel.org/r/20250424215729.194656-2-peterx@redhat.com
Fixes: df2cc96e7701 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
Fixes: f619147104c8 ("userfaultfd: add UFFDIO_CONTINUE ioctl")
Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/userfaultfd.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1585,8 +1585,11 @@ static int userfaultfd_copy(struct userf
 	user_uffdio_copy = (struct uffdio_copy __user *) arg;
 
 	ret = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
+	if (unlikely(atomic_read(&ctx->mmap_changing))) {
+		if (unlikely(put_user(ret, &user_uffdio_copy->copy)))
+			return -EFAULT;
 		goto out;
+	}
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_copy, user_uffdio_copy,
@@ -1641,8 +1644,11 @@ static int userfaultfd_zeropage(struct u
 	user_uffdio_zeropage = (struct uffdio_zeropage __user *) arg;
 
 	ret = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
+	if (unlikely(atomic_read(&ctx->mmap_changing))) {
+		if (unlikely(put_user(ret, &user_uffdio_zeropage->zeropage)))
+			return -EFAULT;
 		goto out;
+	}
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_zeropage, user_uffdio_zeropage,
@@ -1744,8 +1750,11 @@ static int userfaultfd_continue(struct u
 	user_uffdio_continue = (struct uffdio_continue __user *)arg;
 
 	ret = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
+	if (unlikely(atomic_read(&ctx->mmap_changing))) {
+		if (unlikely(put_user(ret, &user_uffdio_continue->mapped)))
+			return -EFAULT;
 		goto out;
+	}
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_continue, user_uffdio_continue,
@@ -1801,8 +1810,11 @@ static inline int userfaultfd_poison(str
 	user_uffdio_poison = (struct uffdio_poison __user *)arg;
 
 	ret = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
+	if (unlikely(atomic_read(&ctx->mmap_changing))) {
+		if (unlikely(put_user(ret, &user_uffdio_poison->updated)))
+			return -EFAULT;
 		goto out;
+	}
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_poison, user_uffdio_poison,
@@ -1870,8 +1882,12 @@ static int userfaultfd_move(struct userf
 
 	user_uffdio_move = (struct uffdio_move __user *) arg;
 
-	if (atomic_read(&ctx->mmap_changing))
-		return -EAGAIN;
+	ret = -EAGAIN;
+	if (unlikely(atomic_read(&ctx->mmap_changing))) {
+		if (unlikely(put_user(ret, &user_uffdio_move->move)))
+			return -EFAULT;
+		goto out;
+	}
 
 	if (copy_from_user(&uffdio_move, user_uffdio_move,
 			   /* don't copy "move" last field */


