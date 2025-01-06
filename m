Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B998634A;
	Mon,  6 Jan 2025 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176934; cv=none; b=bXpvibliV9jM6UvuBoH8D1QSCWVJPrKIYM3si6mKRYQ5NLqWxJjlp7vtUFcHOsOn23JERagbQtY9sRzVaUIHVDzdVZ6dWbajmnfiUGwcIOT/B/4O81RTG7ejOl4H9dMteEEXwlo4lk5IcgVC+hsWBZg6tljbnSJmw07T67OPCdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176934; c=relaxed/simple;
	bh=CQSHYMaIdfgNA7jiv++gRMA5/5rxaBzmjbMmZDGTZ8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlCxFSk7LS7gznRDq2nunoSKV2XZobpQJdc9Ly5ypwUUcQbbwd2v9uciZrYEPojv1h71YJbGLZFhwzPv4GJbg6eFKSTlAuVuDEVVdxz81NLW44nAdBLNW6mNYXfLWIbvm/6AiDH/BlGUO+NGvcF4E2uqMwO8VEgcAdt3R/msz1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLJgIDaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLJgIDaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345ADC4CED2;
	Mon,  6 Jan 2025 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176933;
	bh=CQSHYMaIdfgNA7jiv++gRMA5/5rxaBzmjbMmZDGTZ8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLJgIDaBZSN9V30ew/s/Hj3NmB/lDVEAJbMynhGGgIKCFKYSomO2GCbgWYsqdXwMw
	 09i6jz0ezS0shBEEbVUZXM4s46HLTkGVqjMxtek2RPyRXuMhPVGvwI6Y3XGH/Nyk8h
	 n8A8KbppNmG2mV5imMOYhj/407uqj8jjXA2G0Gls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	kernel test robot <oliver.sang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 77/81] mm/readahead: fix large folio support in async readahead
Date: Mon,  6 Jan 2025 16:16:49 +0100
Message-ID: <20250106151132.334164998@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

commit 158cdce87c8c172787063998ad5dd3e2f658b963 upstream.

When testing large folio support with XFS on our servers, we observed that
only a few large folios are mapped when reading large files via mmap.
After a thorough analysis, I identified it was caused by the
`/sys/block/*/queue/read_ahead_kb` setting.  On our test servers, this
parameter is set to 128KB.  After I tune it to 2MB, the large folio can
work as expected.  However, I believe the large folio behavior should not
be dependent on the value of read_ahead_kb.  It would be more robust if
the kernel can automatically adopt to it.

With /sys/block/*/queue/read_ahead_kb set to 128KB and performing a
sequential read on a 1GB file using MADV_HUGEPAGE, the differences in
/proc/meminfo are as follows:

- before this patch
  FileHugePages:     18432 kB
  FilePmdMapped:      4096 kB

- after this patch
  FileHugePages:   1067008 kB
  FilePmdMapped:   1048576 kB

This shows that after applying the patch, the entire 1GB file is mapped to
huge pages.  The stable list is CCed, as without this patch, large folios
don't function optimally in the readahead path.

It's worth noting that if read_ahead_kb is set to a larger value that
isn't aligned with huge page sizes (e.g., 4MB + 128KB), it may still fail
to map to hugepages.

Link: https://lkml.kernel.org/r/20241108141710.9721-1-laoar.shao@gmail.com
Link: https://lkml.kernel.org/r/20241206083025.3478-1-laoar.shao@gmail.com
Fixes: 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Tested-by: kernel test robot <oliver.sang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/readahead.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -599,7 +599,11 @@ static void ondemand_readahead(struct re
 			1UL << order);
 	if (index == expected || index == (ra->start + ra->size)) {
 		ra->start += ra->size;
-		ra->size = get_next_ra_size(ra, max_pages);
+		/*
+		 * In the case of MADV_HUGEPAGE, the actual size might exceed
+		 * the readahead window.
+		 */
+		ra->size = max(ra->size, get_next_ra_size(ra, max_pages));
 		ra->async_size = ra->size;
 		goto readit;
 	}


