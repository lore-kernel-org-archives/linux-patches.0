Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFAF27701;
	Mon, 24 Feb 2025 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408702; cv=none; b=u7n3k3jtaY4ezKgPVfHg3JEP/6m8taaHclOMFReGUf+nyXLxTvhlAMbxW/HYDlZLRqiIRzTGNyblkVi8yDnGDXlFtXSAB+5rFuZTEBPKU1i6WyeCvv6XQoRJNzfp3h56iyiiEJrt5nehGsMuMRazAVjffpk/KaceyXpm/JuLnB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408702; c=relaxed/simple;
	bh=k1yNl6pTyLWeYG3D+iDmO7vlyj160OfEuQld7dUK5J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K37fHh/gZty3e2zvlGC5fA6wviwcQc1makisIpKap6vezc2jsCOm0KkeTqLZmtTdjJugay7mYfUp+EONb+tIs+I9YJBYuY1imvsBXLmkTk3RwKv0Xezg+mbiGqJtr6hI4TJewTSkB3drOd1J/IPQymizUh4ygkZXylLESJTmgj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZ5lExLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZ5lExLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8497C4CED6;
	Mon, 24 Feb 2025 14:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408702;
	bh=k1yNl6pTyLWeYG3D+iDmO7vlyj160OfEuQld7dUK5J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZ5lExLkh3qUqBHP0raqVm2CTgaDF+psLQYfIxWsR7dlvEsaKjPfzd9nV/hbu03At
	 DXP3U7MFHu+HR7IWMQbTsCg0FyxfgyvxOjTGer6/9pRHWb2D97PNxJDkquJInC5/Gb
	 QdyGtpm2zPQPl2XpljIdodlk5ha0JUEm8BoeMTs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ricardo=20Ca=C3=B1uelo=20Navarro?= <rcn@igalia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Florent Revest <revest@google.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 136/154] mm,madvise,hugetlb: check for 0-length range after end address adjustment
Date: Mon, 24 Feb 2025 15:35:35 +0100
Message-ID: <20250224142612.375586519@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -920,7 +920,16 @@ static long madvise_dontneed_free(struct
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


