Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAEC2629F;
	Mon, 24 Feb 2025 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408184; cv=none; b=CK0Nm4Ucz3Aiu/8Y9ToZoLqz6/qZaTgKL3TUIdipTL9sNm9bNok1PborNQNL2cqa+4Iq11TDVRpk5Cmm19j3O83ESnaynKmk6XW/+L2gG7vwrdeG8gJaiHuT+wTwwM/dn++KYp0XvmzyTVoqQpBrmBngbZo1+7jcM7Wk6IWZZfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408184; c=relaxed/simple;
	bh=f8lkghqPwsWqfaIJh5DSt7fcejhz1GwAlOAZaZ6goOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dWiJtGirWCfJO9sk479QXplmPOdafiBctdF81ci94dNiR0FXneSWbwLVwMhZbTaJoAUdpeWcKOKOYFTZQEg581mQk57EZrEh3OzkfY+K6eqHb+Dhl+Eh9g9t9lj3s1BQ8s5alasw8HuwRt2KtKQo7LRl7eWXoClOjVmTAeFNM8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtT/6TuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtT/6TuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E036C4CED6;
	Mon, 24 Feb 2025 14:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408184;
	bh=f8lkghqPwsWqfaIJh5DSt7fcejhz1GwAlOAZaZ6goOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtT/6TuAvleYy9ImA/op7xHjfscgKrVz9cv5ryzxd0QnGDiaaU3EBTNKphfv2E2Mq
	 Oq+5J9zuDlf65uPjTaYQftTS88LbK1AQ6NKDGGMybvpbIaCHh8d10Pz/w9Yx90sNQn
	 KRAfdvohOcM9TBmll2U+egVKVVuQZ4XLZAfzK7Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ricardo=20Ca=C3=B1uelo=20Navarro?= <rcn@igalia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Florent Revest <revest@google.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 124/140] mm,madvise,hugetlb: check for 0-length range after end address adjustment
Date: Mon, 24 Feb 2025 15:35:23 +0100
Message-ID: <20250224142607.883991443@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Cañuelo Navarro <rcn@igalia.com>

commit 2ede647a6fde3e54a6bfda7cf01c716649655900 upstream.

Add a sanity check to madvise_dontneed_free() to address a corner case in
madvise where a race condition causes the current vma being processed to
be backed by a different page size.

During a madvise(MADV_DONTNEED) call on a memory region registered with a
userfaultfd, there's a period of time where the process mm lock is
temporarily released in order to send a UFFD_EVENT_REMOVE and let
userspace handle the event.  During this time, the vma covering the
current address range may change due to an explicit mmap done concurrently
by another thread.

If, after that change, the memory region, which was originally backed by
4KB pages, is now backed by hugepages, the end address is rounded down to
a hugepage boundary to avoid data loss (see "Fixes" below).  This rounding
may cause the end address to be truncated to the same address as the
start.

Make this corner case follow the same semantics as in other similar cases
where the requested region has zero length (ie.  return 0).

This will make madvise_walk_vmas() continue to the next vma in the range
(this time holding the process mm lock) which, due to the prev pointer
becoming stale because of the vma change, will be the same hugepage-backed
vma that was just checked before.  The next time madvise_dontneed_free()
runs for this vma, if the start address isn't aligned to a hugepage
boundary, it'll return -EINVAL, which is also in line with the madvise
api.

>From userspace perspective, madvise() will return EINVAL because the start
address isn't aligned according to the new vma alignment requirements
(hugepage), even though it was correctly page-aligned when the call was
issued.

Link: https://lkml.kernel.org/r/20250203075206.1452208-1-rcn@igalia.com
Fixes: 8ebe0a5eaaeb ("mm,madvise,hugetlb: fix unexpected data loss with MADV_DONTNEED on hugetlbfs")
Signed-off-by: Ricardo Cañuelo Navarro <rcn@igalia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Florent Revest <revest@google.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/madvise.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -899,7 +899,16 @@ static long madvise_dontneed_free(struct
 			 */
 			end = vma->vm_end;
 		}
-		VM_WARN_ON(start >= end);
+		/*
+		 * If the memory region between start and end was
+		 * originally backed by 4kB pages and then remapped to
+		 * be backed by hugepages while mmap_lock was dropped,
+		 * the adjustment for hugetlb vma above may have rounded
+		 * end down to the start address.
+		 */
+		if (start == end)
+			return 0;
+		VM_WARN_ON(start > end);
 	}
 
 	if (behavior == MADV_DONTNEED || behavior == MADV_DONTNEED_LOCKED)


