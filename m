Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE3024BBFD;
	Thu, 17 Apr 2025 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915998; cv=none; b=FmKORuRprbRUe8Cj+kYoUacjvMhAkzdJb9I6XPflUefiWp3LT8iyjj7roPqNfFmgnL1+4gV2njeBFj28pA+yVtR+5ZoUa8aIlxbKdmBc13XDwK0IUnjvtXZ25rdF64PjrS2MuFKA2J4xPzh1WV5m2knV3lI3BzBLzOKIojvZWJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915998; c=relaxed/simple;
	bh=dIvgEyjblBNGSuqTUS4egqqRDhI6Sni9i0Ea94PmfoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+A66bPXCBTbv9gJdb2x1tL4be/v8QNuGy+IIjT7XvfUo3II+MHe70jj3QBQPJJ4Zs8cNg5KUYiK8lq1grWhruSAj6nbEwFNjkPv8/9oo17bY3XTAEGav6R8/BPfasmLE1VNQS7qo6zEXamYgy6kwnSB5VacbGSdxRG6ZfjLeMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYVstaR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYVstaR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02080C4CEE7;
	Thu, 17 Apr 2025 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915998;
	bh=dIvgEyjblBNGSuqTUS4egqqRDhI6Sni9i0Ea94PmfoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYVstaR3cFFzmOgfxL+MRCykdbtCpnQ2YBWDAw6Z3s1vAhh2/uh0EG1l9yuXYrieM
	 KCapwW92uHtvgloQyLYUBMNjONx57Tlgm7M5FmlpPVR4VLDiAZY6nZ8dVIFvlQI40t
	 Ajr4mmfS3hDed7xX0WGeqiJtE/PdbUfFBoo+Hkow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Dimitris Siakavaras <jimsiak@cslab.ece.ntua.gr>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 309/393] mm/userfaultfd: fix release hang over concurrent GUP
Date: Thu, 17 Apr 2025 19:51:58 +0200
Message-ID: <20250417175120.042694024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

commit fe4cdc2c4e248f48de23bc778870fd71e772a274 upstream.

This patch should fix a possible userfaultfd release() hang during
concurrent GUP.

This problem was initially reported by Dimitris Siakavaras in July 2023
[1] in a firecracker use case.  Firecracker has a separate process
handling page faults remotely, and when the process releases the
userfaultfd it can race with a concurrent GUP from KVM trying to fault in
a guest page during the secondary MMU page fault process.

A similar problem was reported recently again by Jinjiang Tu in March 2025
[2], even though the race happened this time with a mlockall() operation,
which does GUP in a similar fashion.

In 2017, commit 656710a60e36 ("userfaultfd: non-cooperative: closing the
uffd without triggering SIGBUS") was trying to fix this issue.  AFAIU,
that fixes well the fault paths but may not work yet for GUP.  In GUP, the
issue is NOPAGE will be almost treated the same as "page fault resolved"
in faultin_page(), then the GUP will follow page again, seeing page
missing, and it'll keep going into a live lock situation as reported.

This change makes core mm return RETRY instead of NOPAGE for both the GUP
and fault paths, proactively releasing the mmap read lock.  This should
guarantee the other release thread make progress on taking the write lock
and avoid the live lock even for GUP.

When at it, rearrange the comments to make sure it's uptodate.

[1] https://lore.kernel.org/r/79375b71-db2e-3e66-346b-254c90d915e2@cslab.ece.ntua.gr
[2] https://lore.kernel.org/r/20250307072133.3522652-1-tujinjiang@huawei.com

Link: https://lkml.kernel.org/r/20250312145131.1143062-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Dimitris Siakavaras <jimsiak@cslab.ece.ntua.gr>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/userfaultfd.c |   51 +++++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -396,32 +396,6 @@ vm_fault_t handle_userfault(struct vm_fa
 		goto out;
 
 	/*
-	 * If it's already released don't get it. This avoids to loop
-	 * in __get_user_pages if userfaultfd_release waits on the
-	 * caller of handle_userfault to release the mmap_lock.
-	 */
-	if (unlikely(READ_ONCE(ctx->released))) {
-		/*
-		 * Don't return VM_FAULT_SIGBUS in this case, so a non
-		 * cooperative manager can close the uffd after the
-		 * last UFFDIO_COPY, without risking to trigger an
-		 * involuntary SIGBUS if the process was starting the
-		 * userfaultfd while the userfaultfd was still armed
-		 * (but after the last UFFDIO_COPY). If the uffd
-		 * wasn't already closed when the userfault reached
-		 * this point, that would normally be solved by
-		 * userfaultfd_must_wait returning 'false'.
-		 *
-		 * If we were to return VM_FAULT_SIGBUS here, the non
-		 * cooperative manager would be instead forced to
-		 * always call UFFDIO_UNREGISTER before it can safely
-		 * close the uffd.
-		 */
-		ret = VM_FAULT_NOPAGE;
-		goto out;
-	}
-
-	/*
 	 * Check that we can return VM_FAULT_RETRY.
 	 *
 	 * NOTE: it should become possible to return VM_FAULT_RETRY
@@ -457,6 +431,31 @@ vm_fault_t handle_userfault(struct vm_fa
 	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
 		goto out;
 
+	if (unlikely(READ_ONCE(ctx->released))) {
+		/*
+		 * If a concurrent release is detected, do not return
+		 * VM_FAULT_SIGBUS or VM_FAULT_NOPAGE, but instead always
+		 * return VM_FAULT_RETRY with lock released proactively.
+		 *
+		 * If we were to return VM_FAULT_SIGBUS here, the non
+		 * cooperative manager would be instead forced to
+		 * always call UFFDIO_UNREGISTER before it can safely
+		 * close the uffd, to avoid involuntary SIGBUS triggered.
+		 *
+		 * If we were to return VM_FAULT_NOPAGE, it would work for
+		 * the fault path, in which the lock will be released
+		 * later.  However for GUP, faultin_page() does nothing
+		 * special on NOPAGE, so GUP would spin retrying without
+		 * releasing the mmap read lock, causing possible livelock.
+		 *
+		 * Here only VM_FAULT_RETRY would make sure the mmap lock
+		 * be released immediately, so that the thread concurrently
+		 * releasing the userfault would always make progress.
+		 */
+		release_fault_lock(vmf);
+		goto out;
+	}
+
 	/* take the reference before dropping the mmap_lock */
 	userfaultfd_ctx_get(ctx);
 


