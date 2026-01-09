Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9037232AAB5;
	Fri,  9 Jan 2026 11:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959120; cv=none; b=GsLY58wiZw3wsxziJ4ooPwlu7rgtSuLyeXH1D5i+ITnIpup8UEEuac97u2Ivur3WjdIS5i1kf0L4RqUZ7JjAqEq72poAGpJruRotAb99nb6cPH0EREcZmFrdQSJyfygMv2IVe7eIzlOGK5HC92EE1nBJSS8DpRtPfQew0cq+uBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959120; c=relaxed/simple;
	bh=mNId9po01GmHIXiop9AU6MdCcMn/0hkV/pc7QmQ+k44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+TREy+ycL0zXrbgG8sblCP+gYfwNRzBPEXgjTR07wipraEQtZRz8XlY7EDzvBZH4k9iz3mBiAMf9W9yuys4jHg5lKQFHDbPCikA+ZU/tBDhL+ZuU5LDoY8uQGtyvu+TGqh+rVoNM+8AJ4r4LjtdhTNaZeMm93BRS9eA9LvDe4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryXPTQiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryXPTQiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBA4C19422;
	Fri,  9 Jan 2026 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959119;
	bh=mNId9po01GmHIXiop9AU6MdCcMn/0hkV/pc7QmQ+k44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryXPTQiwa24APXGLpowa4cpEH1278swiQvHW6Pm72iWLRAm/jiUphU3cYLL3rN8Mb
	 v+LIC7Q+CaYsvinfEfkdqDw/QbXETERFRBl7ra1fkYrkbV9H/EVDYeAV6uGxE3RW6A
	 nNLMfHJfI0UfvF09kWdajG9enCv0WD8Oy9sA5deo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zorro Lang <zlang@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.18 5/5] nfs/localio: fix regression due to out-of-order __put_cred
Date: Fri,  9 Jan 2026 12:44:07 +0100
Message-ID: <20260109111950.550738956@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
References: <20260109111950.344681501@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

commit 3af870aedbff10bfed220e280b57a405e972229f upstream.

Commit f2060bdc21d7 ("nfs/localio: add refcounting for each iocb IO
associated with NFS pgio header") inadvertantly reintroduced the same
potential for __put_cred() triggering BUG_ON(cred == current->cred) that
commit 992203a1fba5 ("nfs/localio: restore creds before releasing pageio
data") fixed.

Fix this by saving and restoring the cred around each {read,write}_iter
call within the respective for loop of nfs_local_call_{read,write} using
scoped_with_creds().

NOTE: this fix started by first reverting the following commits:

 94afb627dfc2 ("nfs: use credential guards in nfs_local_call_read()")
 bff3c841f7bd ("nfs: use credential guards in nfs_local_call_write()")
 1d18101a644e ("Merge tag 'kernel-6.19-rc1.cred' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs")

followed by narrowly fixing the cred lifetime issue by using
scoped_with_creds().  In doing so, this commit's changes appear more
extensive than they really are (as evidenced by comparing to v6.18's
fs/nfs/localio.c).

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Acked-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Link: https://lore.kernel.org/linux-next/20251205111942.4150b06f@canb.auug.org.au/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/localio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -623,8 +623,6 @@ static void nfs_local_call_read(struct w
 	ssize_t status;
 	int n_iters;
 
-	save_cred = override_creds(filp->f_cred);
-
 	n_iters = atomic_read(&iocb->n_iters);
 	for (int i = 0; i < n_iters ; i++) {
 		if (iocb->iter_is_dio_aligned[i]) {
@@ -637,7 +635,10 @@ static void nfs_local_call_read(struct w
 		} else
 			iocb->kiocb.ki_flags &= ~IOCB_DIRECT;
 
+		save_cred = override_creds(filp->f_cred);
 		status = filp->f_op->read_iter(&iocb->kiocb, &iocb->iters[i]);
+		revert_creds(save_cred);
+
 		if (status != -EIOCBQUEUED) {
 			if (unlikely(status >= 0 && status < iocb->iters[i].count))
 				force_done = true; /* Partial read */
@@ -647,8 +648,6 @@ static void nfs_local_call_read(struct w
 			}
 		}
 	}
-
-	revert_creds(save_cred);
 }
 
 static int
@@ -830,7 +829,6 @@ static void nfs_local_call_write(struct
 	int n_iters;
 
 	current->flags |= PF_LOCAL_THROTTLE | PF_MEMALLOC_NOIO;
-	save_cred = override_creds(filp->f_cred);
 
 	file_start_write(filp);
 	n_iters = atomic_read(&iocb->n_iters);
@@ -845,7 +843,10 @@ static void nfs_local_call_write(struct
 		} else
 			iocb->kiocb.ki_flags &= ~IOCB_DIRECT;
 
+		save_cred = override_creds(filp->f_cred);
 		status = filp->f_op->write_iter(&iocb->kiocb, &iocb->iters[i]);
+		revert_creds(save_cred);
+
 		if (status != -EIOCBQUEUED) {
 			if (unlikely(status >= 0 && status < iocb->iters[i].count))
 				force_done = true; /* Partial write */
@@ -857,7 +858,6 @@ static void nfs_local_call_write(struct
 	}
 	file_end_write(filp);
 
-	revert_creds(save_cred);
 	current->flags = old_flags;
 }
 


