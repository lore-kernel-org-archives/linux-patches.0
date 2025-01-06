Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA1F200A3;
	Mon,  6 Jan 2025 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177598; cv=none; b=KQw6J75tfPDJ8TTobVWkb4/e33I1Z/kvJur57txpEoeC0G7Iu3IAZimxVUk8Hp6zLzhVGHOM4AOvRvkLep1dInwmebQ8i/u6MKoY5hQOaKXQsWwBxtOuAxrGcQ61nAKuP/79+2o+evzTe1NnJHqck7fBMyi/etl7yCBsv0EZd78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177598; c=relaxed/simple;
	bh=61GNXp472Va3sXLv+8qxcue5sWjSY5MMY9tif4iJnhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dr7lTgRfp/4BhSRhChmZvs3LaTgoFrPHJAvAK7FCyGps5kOPU1//wyBEqA5bbP6JPCYp0gRTIoSJ4TdBgcblUuQbyEuYPzrqYtgo3STta6pdaWx+jiY0Xej5eFPiW0dFm/9oNGshuUsFRW56SqGyiBHyP5T7QYIBuLgOsWV5Q0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dg/IIWIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dg/IIWIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D132C4CED2;
	Mon,  6 Jan 2025 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177596;
	bh=61GNXp472Va3sXLv+8qxcue5sWjSY5MMY9tif4iJnhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dg/IIWIshkoyZsN3ebtTSnfiKcly7he4afDK95FwJi9G8kCGsijM73BBBiwLE90CF
	 pH1JAnSZnOKrFZ2vVAW0egAZJR/3r0CRscu+jiaO9BvtzjVK/XnCbbk7iNVUbbBDDT
	 uAJpgzS0kOUal6FFPe90Czg82tcuvEcgX+pf1scg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	kernel test robot <oliver.sang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 215/222] mm/readahead: fix large folio support in async readahead
Date: Mon,  6 Jan 2025 16:16:59 +0100
Message-ID: <20250106151158.906353517@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -580,7 +580,11 @@ static void ondemand_readahead(struct re
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


