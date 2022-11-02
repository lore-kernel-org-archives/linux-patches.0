Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409A07E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B205C433D7;
	Wed,  2 Nov 2022 02:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357005;
	bh=vUyht6DAVYUdK2f3KtZP8O/w9PQLCthvU2aQYG94Uq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYyRaBi0OJpqHqzR+PPUQo0x4KisBiX6AT0UvMlORLHFWasJwZ46+Vq5FvEjKRrOU
	 pR3zKgX63uoXV0gSY/6sjGo6FLT8LLvpPWD5BGVT2SOqs+0gjU5POuwVEXXuN26qfn
	 B6blAGh76IVY1JhVKjJqCcWkaPpEA/Pme+fHB3iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 089/240] mm,madvise,hugetlb: fix unexpected data loss with MADV_DONTNEED on hugetlbfs
Date: Wed,  2 Nov 2022 03:31:04 +0100
Message-Id: <20221102022113.410496793@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rik van Riel <riel@surriel.com>

commit 8ebe0a5eaaeb099de03d09ad20f54ed962e2261e upstream.

A common use case for hugetlbfs is for the application to create
memory pools backed by huge pages, which then get handed over to
some malloc library (eg. jemalloc) for further management.

That malloc library may be doing MADV_DONTNEED calls on memory
that is no longer needed, expecting those calls to happen on
PAGE_SIZE boundaries.

However, currently the MADV_DONTNEED code rounds up any such
requests to HPAGE_PMD_SIZE boundaries. This leads to undesired
outcomes when jemalloc expects a 4kB MADV_DONTNEED, but 2MB of
memory get zeroed out, instead.

Use of pre-built shared libraries means that user code does not
always know the page size of every memory arena in use.

Avoid unexpected data loss with MADV_DONTNEED by rounding up
only to PAGE_SIZE (in do_madvise), and rounding down to huge
page granularity.

That way programs will only get as much memory zeroed out as
they requested.

Link: https://lkml.kernel.org/r/20221021192805.366ad573@imladris.surriel.com
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/madvise.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -811,7 +811,14 @@ static bool madvise_dontneed_free_valid_
 	if (start & ~huge_page_mask(hstate_vma(vma)))
 		return false;
 
-	*end = ALIGN(*end, huge_page_size(hstate_vma(vma)));
+	/*
+	 * Madvise callers expect the length to be rounded up to PAGE_SIZE
+	 * boundaries, and may be unaware that this VMA uses huge pages.
+	 * Avoid unexpected data loss by rounding down the number of
+	 * huge pages freed.
+	 */
+	*end = ALIGN_DOWN(*end, huge_page_size(hstate_vma(vma)));
+
 	return true;
 }
 
@@ -826,6 +833,9 @@ static long madvise_dontneed_free(struct
 	if (!madvise_dontneed_free_valid_vma(vma, start, &end, behavior))
 		return -EINVAL;
 
+	if (start == end)
+		return 0;
+
 	if (!userfaultfd_remove(vma, start, end)) {
 		*prev = NULL; /* mmap_lock has been dropped, prev is stale */
 


