Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF80215795;
	Thu, 12 Dec 2024 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016469; cv=none; b=aymnomhaNmchG8Mwqej+mgsJahcPBk90T/hJGxXyAac8/L8nnZ0YT4LSZMp4dC3WOaeRkz92j9a0lH01Dt61EUrSI/h5XwmtDm+vYVVhsVT8eidtye7O4H2AbOfxHdjuJIzbKkb82FJcoUO9N8FInZiserI0JitiQOii66X9xbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016469; c=relaxed/simple;
	bh=WtP09eks2fxyBdJDIzIUVaWc+2zzbFd0N4vuxretJnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDYOxLEcfZEhSWW1AdpnidwtvNYv1G4a+XhNu+JZpwtVi/rFyJlo/NyygWkMgDLkwivrcKroApljSP3+DoOzy/yh1vNDFkFUOCamPzxv3/urOGMyF/tl+NezO8W+8T2/plqd0+ERzB+BcfItzT5XhP97XG1bvhplO7CQYusfDww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I704p4G9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I704p4G9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45F0C4CECE;
	Thu, 12 Dec 2024 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016469;
	bh=WtP09eks2fxyBdJDIzIUVaWc+2zzbFd0N4vuxretJnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I704p4G909Xty5DUqQVAUHVUQKqpe96OGDzi6MC2kz4244bD8MCTR6Hh1NH8RiN4t
	 2CwgDDIlQcugE33YqePHeZe1jRbRnsKakN2/JG5gaj1oWqBQtovDLOXUem4Ip/Ui51
	 OnZO48YlnfLC+sEQZmU+5QzYhwe4BfXBYFhFQqWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh Singh <kaleshsingh@google.com>,
	Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Hans Boehm <hboehm@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 208/466] mm: respect mmap hint address when aligning for THP
Date: Thu, 12 Dec 2024 15:56:17 +0100
Message-ID: <20241212144315.005037555@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh Singh <kaleshsingh@google.com>

commit 249608ee47132cab3b1adacd9e463548f57bd316 upstream.

Commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") updated __get_unmapped_area() to align the start address for
the VMA to a PMD boundary if CONFIG_TRANSPARENT_HUGEPAGE=y.

It does this by effectively looking up a region that is of size,
request_size + PMD_SIZE, and aligning up the start to a PMD boundary.

Commit 4ef9ad19e176 ("mm: huge_memory: don't force huge page alignment on
32 bit") opted out of this for 32bit due to regressions in mmap base
randomization.

Commit d4148aeab412 ("mm, mmap: limit THP alignment of anonymous mappings
to PMD-aligned sizes") restricted this to only mmap sizes that are
multiples of the PMD_SIZE due to reported regressions in some performance
benchmarks -- which seemed mostly due to the reduced spatial locality of
related mappings due to the forced PMD-alignment.

Another unintended side effect has emerged: When a user specifies an mmap
hint address, the THP alignment logic modifies the behavior, potentially
ignoring the hint even if a sufficiently large gap exists at the requested
hint location.

Example Scenario:

Consider the following simplified virtual address (VA) space:

    ...

    0x200000-0x400000 --- VMA A
    0x400000-0x600000 --- Hole
    0x600000-0x800000 --- VMA B

    ...

A call to mmap() with hint=0x400000 and len=0x200000 behaves differently:

  - Before THP alignment: The requested region (size 0x200000) fits into
    the gap at 0x400000, so the hint is respected.

  - After alignment: The logic searches for a region of size
    0x400000 (len + PMD_SIZE) starting at 0x400000.
    This search fails due to the mapping at 0x600000 (VMA B), and the hint
    is ignored, falling back to arch_get_unmapped_area[_topdown]().

In general the hint is effectively ignored, if there is any existing
mapping in the below range:

     [mmap_hint + mmap_size, mmap_hint + mmap_size + PMD_SIZE)

This changes the semantics of mmap hint; from ""Respect the hint if a
sufficiently large gap exists at the requested location" to "Respect the
hint only if an additional PMD-sized gap exists beyond the requested
size".

This has performance implications for allocators that allocate their heap
using mmap but try to keep it "as contiguous as possible" by using the end
of the exisiting heap as the address hint.  With the new behavior it's
more likely to get a much less contiguous heap, adding extra fragmentation
and performance overhead.

To restore the expected behavior; don't use
thp_get_unmapped_area_vmflags() when the user provided a hint address, for
anonymous mappings.

Note: As Yang Shi pointed out: the issue still remains for filesystems
which are using thp_get_unmapped_area() for their get_unmapped_area() op.
It is unclear what worklaods will regress for if we ignore THP alignment
when the hint address is provided for such file backed mappings -- so this
fix will be handled separately.

Link: https://lkml.kernel.org/r/20241118214650.3667577-1-kaleshsingh@google.com
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hans Boehm <hboehm@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -901,6 +901,7 @@ __get_unmapped_area(struct file *file, u
 	if (get_area) {
 		addr = get_area(file, addr, len, pgoff, flags);
 	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
+		   && !addr /* no hint */
 		   && IS_ALIGNED(len, PMD_SIZE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
 		addr = thp_get_unmapped_area_vmflags(file, addr, len,


