Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039042;
	b=M0bo1u+Tbleinpa/08WMxFn0Eq/3CXIl2+Kv2Thv4lF4L7m5rSTvtqLpZq8xCz05Xs5P
	 b0pFs8c2vRxBFqZkZVXzMDroSMPthuksy01cRbIzi6c5SSBQejQwe1dlkPklsbGJOLSOf
	 tLtLlPtof4qvcAdKhtSYHMzPWIP8U0U63EfD6BOrfNQ+kyFDg6K/rooKJ7h/OSgSWbBll
	 ZuvjYgaPDXLZnUtFKs5HrYnr/K6ZbxYQkysuMiZIHfrg7UNuVeUz3MY6bzNWPzkwdCiPY
	 H7K/KMsS6z4FU/YXQc5E0rewLCWFyuPr+gnCJ62r3xzyx1LoauamFG1Mu+E5g91Co/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QbFW64sP9uLd+2v+mF5jqvMn+MHR/kYNQpn8rzMPVHY=;
	b=hvG7HimOWeAlDIOf8SjIQsgT04VmSMHC3+kabyIBwnOBbFsrw56c6bACcgrhqxfeDJBg
	 uTyEvc8u3mZUtfq1g+2tuaeas/nWUEZ7vACYfvT81fJkjJtTWETMB/Ko01vUOXQ6lhd9u
	 3qlMAzOwyppem+tsRRfUD4KSEsyutbfRAQkgn3BZiH49TtfJfOu6WJHWIs7jkjqQjPIKD
	 d7U2PO80dKks5xtgQ/KqBRUSap83RKYpd8krb+tsq4nfA+bfXFTI8v/3qDG9FDLBSnSJp
	 zwKIYvJgkzMw4j6Gloo9wO/YBm9ASE6nMdITRy+uzLJc51nezfTK+hngTwJlFZX2VyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1u169QB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD6F606A31C;
	Wed, 18 Nov 2026 21:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1u169QB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F0C1F000C5;
	Wed, 18 Nov 2026 21:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039042;
	bh=QbFW64sP9uLd+2v+mF5jqvMn+MHR/kYNQpn8rzMPVHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1u169QBtPkuMZZ/FyhT2rQdOVnDdS0bYBd44m6ziGj4nXOVFxo+b3+dFkVbwaDkG
	 Z0uqzr7i9yeLD3jF5/XxxNWNKh5ZU+JYtcFm/qWdzEqsKCe+l8ueq59tMsPLyzg9Zs
	 HHYEVpx1NQlfKjOF6TR5UKBYHSYJMFKbKwH87fX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1956/3318] mm: make lock_folio_maybe_drop_mmap() VMA lock aware
Date: Wed, 18 Nov 2026 15:42:58 +0100
Message-ID: <20261118150420.762354570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 5d74b2ab2c15d596c470bae6626f345d5575a9d0 ]

Patch series "Handle more faults under the VMA lock", v2.

At this point, we're handling the majority of file-backed page faults
under the VMA lock, using the ->map_pages entry point.  This patch set
attempts to expand that for the following siutations:

 - We have to do a read.  This could be because we've hit the point in
   the readahead window where we need to kick off the next readahead,
   or because the page is simply not present in cache.
 - We're handling a write fault.  Most applications don't do I/O by writes
   to shared mmaps for very good reasons, but some do, and it'd be nice
   to not make that slow unnecessarily.
 - We're doing a COW of a private mapping (both PTE already present
   and PTE not-present).  These are two different codepaths and I handle
   both of them in this patch set.

There is no support in this patch set for drivers to mark themselves as
being VMA lock friendly; they could implement the ->map_pages
vm_operation, but if they do, they would be the first.  This is probably
something we want to change at some point in the future, and I've marked
where to make that change in the code.

There is very little performance change in the benchmarks we've run;
mostly because the vast majority of page faults are handled through the
other paths.  I still think this patch series is useful for workloads that
may take these paths more often, and just for cleaning up the fault path
in general (it's now clearer why we have to retry in these cases).

This patch (of 6):

Drop the VMA lock instead of the mmap_lock if that's the one which
is held.

Link: https://lkml.kernel.org/r/20231006195318.4087158-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231006195318.4087158-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 97156a6c355c ("mm/filemap: finish fault cleanup before dropping the fault lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index db9499f6abd3d..26a42e34e9b59 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3157,7 +3157,7 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 
 	/*
 	 * NOTE! This will make us return with VM_FAULT_RETRY, but with
-	 * the mmap_lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
+	 * the fault lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
 	 * is supposed to work. We have way too many special cases..
 	 */
 	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
@@ -3167,13 +3167,14 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 	if (vmf->flags & FAULT_FLAG_KILLABLE) {
 		if (__folio_lock_killable(folio)) {
 			/*
-			 * We didn't have the right flags to drop the mmap_lock,
-			 * but all fault_handlers only check for fatal signals
-			 * if we return VM_FAULT_RETRY, so we need to drop the
-			 * mmap_lock here and return 0 if we don't have a fpin.
+			 * We didn't have the right flags to drop the
+			 * fault lock, but all fault_handlers only check
+			 * for fatal signals if we return VM_FAULT_RETRY,
+			 * so we need to drop the fault lock here and
+			 * return 0 if we don't have a fpin.
 			 */
 			if (*fpin == NULL)
-				mmap_read_unlock(vmf->vma->vm_mm);
+				release_fault_lock(vmf);
 			return 0;
 		}
 	} else
-- 
2.53.0



