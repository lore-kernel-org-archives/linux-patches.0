Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BEE14A4D2;
	Tue, 20 Feb 2024 21:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464654; cv=none; b=B2CTbpzeV32oMdUPb6ybb1f9H75v2mwxY1tLMeo6vSasWwKZMpt09UDSgDjUSSRTwVcp2XcbOpNN5Mfun3ADpoNoGblo5U0DXWmNK7tcj5bIuorjHq8RvXdi958dwsNE/qqbkP2L7JlC3FqLPDI11qKvvSD4t26M+zWni9SL9xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464654; c=relaxed/simple;
	bh=Sr5deQc3A+uPPQLB/XOcz7Za7NxJchoDdo7kL4pZwW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVkydDduZ7erB8tha2QwwclaG/N1WvwSkdZrf9FIZibX6fpdJS7Mslkh5Dpxzt9/o6SqclRkoF0xLxMwmo0YpmVahhysfGhVn9w25gC2kqLLL7SiOkUVdhWNpoeMf0fJQwOnAJVOTA/v6O9Eqgdffo5YwnNV5HGS22BZSwva5p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vioQCIzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vioQCIzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B481C433C7;
	Tue, 20 Feb 2024 21:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464654;
	bh=Sr5deQc3A+uPPQLB/XOcz7Za7NxJchoDdo7kL4pZwW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vioQCIzy/2+DOK+QylAc2xodgwNvxn5rCG59MqTSDFlddMUyWuyTbTLo0LA2AOSfE
	 EtVdd2PxQYCPNSQgvJxu/lYzHevtepwfggF8K9JUxGw+iQmaCBg80674xS3fzKAyZA
	 qi3ch951yovMCp84NjiFX4ZlIsi1sIkWZxJPVBCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <shy828301@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 063/309] mm: thp_get_unmapped_area must honour topdown preference
Date: Tue, 20 Feb 2024 21:53:42 +0100
Message-ID: <20240220205635.190935245@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit 96204e15310c218fd9355bdcacd02fed1d18070e upstream.

The addition of commit efa7df3e3bb5 ("mm: align larger anonymous mappings
on THP boundaries") caused the "virtual_address_range" mm selftest to
start failing on arm64.  Let's fix that regression.

There were 2 visible problems when running the test; 1) it takes much
longer to execute, and 2) the test fails.  Both are related:

The (first part of the) test allocates as many 1GB anonymous blocks as it
can in the low 256TB of address space, passing NULL as the addr hint to
mmap.  Before the faulty patch, all allocations were abutted and contained
in a single, merged VMA.  However, after this patch, each allocation is in
its own VMA, and there is a 2M gap between each VMA.  This causes the 2
problems in the test: 1) mmap becomes MUCH slower because there are so
many VMAs to check to find a new 1G gap.  2) mmap fails once it hits the
VMA limit (/proc/sys/vm/max_map_count).  Hitting this limit then causes a
subsequent calloc() to fail, which causes the test to fail.

The problem is that arm64 (unlike x86) selects
ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT.  But __thp_get_unmapped_area()
allocates len+2M then always aligns to the bottom of the discovered gap.
That causes the 2M hole.

Fix this by detecting cases where we can still achive the alignment goal
when moved to the top of the allocated area, if configured to prefer
top-down allocation.

While we are at it, fix thp_get_unmapped_area's use of pgoff, which should
always be zero for anonymous mappings.  Prior to the faulty change, while
it was possible for user space to pass in pgoff!=0, the old
mm->get_unmapped_area() handler would not use it.  thp_get_unmapped_area()
does use it, so let's explicitly zero it before calling the handler.  This
should also be the correct behavior for arches that define their own
get_unmapped_area() handler.

Link: https://lkml.kernel.org/r/20240123171420.3970220-1-ryan.roberts@arm.com
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Closes: https://lore.kernel.org/linux-mm/1e8f5ac7-54ce-433a-ae53-81522b2320e1@arm.com/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   10 ++++++++--
 mm/mmap.c        |    6 ++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -633,7 +633,7 @@ static unsigned long __thp_get_unmapped_
 {
 	loff_t off_end = off + len;
 	loff_t off_align = round_up(off, size);
-	unsigned long len_pad, ret;
+	unsigned long len_pad, ret, off_sub;
 
 	if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
 		return 0;
@@ -662,7 +662,13 @@ static unsigned long __thp_get_unmapped_
 	if (ret == addr)
 		return addr;
 
-	ret += (off - ret) & (size - 1);
+	off_sub = (off - ret) & (size - 1);
+
+	if (current->mm->get_unmapped_area == arch_get_unmapped_area_topdown &&
+	    !off_sub)
+		return ret + size;
+
+	ret += off_sub;
 	return ret;
 }
 
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1825,15 +1825,17 @@ get_unmapped_area(struct file *file, uns
 		/*
 		 * mmap_region() will call shmem_zero_setup() to create a file,
 		 * so use shmem's get_unmapped_area in case it can be huge.
-		 * do_mmap() will clear pgoff, so match alignment.
 		 */
-		pgoff = 0;
 		get_area = shmem_get_unmapped_area;
 	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
 		get_area = thp_get_unmapped_area;
 	}
 
+	/* Always treat pgoff as zero for anonymous memory. */
+	if (!file)
+		pgoff = 0;
+
 	addr = get_area(file, addr, len, pgoff, flags);
 	if (IS_ERR_VALUE(addr))
 		return addr;


