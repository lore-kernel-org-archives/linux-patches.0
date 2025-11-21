Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9788231355B;
	Fri, 21 Nov 2025 13:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733454; cv=none; b=QA/8Tek2YacGeeSCiC32TSVLrwinG1qOJp7isquphIYz8t9vsPzGZNeg8PVgrBXyf/Romp81+j2m5YTuNpEqciYvUBHBDUGuzwWer+5ZhrBuflpT9IoPQvi5Q1Q3bb1ezBOve7NnA4xnSfCsvNUus+6Zrr/M1E51jIWt2jPgv3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733454; c=relaxed/simple;
	bh=npjYhgMGeUBwxXaTOmxarh4ymBKvqYZ9f6Hd61no5d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpbz4/XNSctDQ7Ggh3B0GEZOuKlfrQUYJeuDqx+hUrU2SpJXjwFlkATGIpQk1sVw3gNz62Kng0LVNnXa3GHD3Y3eUrCeRM7gk73pC1zQexIUlHmLQmoNTyT2Xwws2spKMag2fxjWSBf9n/q1md5yx+TNRZCKy2yQkVQgp4UgXqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wW5/BsRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wW5/BsRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207A0C4CEF1;
	Fri, 21 Nov 2025 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733454;
	bh=npjYhgMGeUBwxXaTOmxarh4ymBKvqYZ9f6Hd61no5d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wW5/BsRRQLfsVrXUsvdWNmny+xdtBWoDg+RtWY5hh0/x9o32UygmmCOEo7GT6ZMbb
	 qtOwMpkpcy0Zv66OsW1jutpYlzPl7kvLGEk6maOQ1s4Q8HZY3+gnN75lQvFgSIKwbf
	 lN9jL3+m1KgufQJZmmQ1SHkcx2/mUK16pQ9PXIJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 474/529] mm/mm_init: fix hash table order logging in alloc_large_system_hash()
Date: Fri, 21 Nov 2025 14:12:53 +0100
Message-ID: <20251121130247.876257094@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Isaac J. Manjarres <isaacmanjarres@google.com>

commit 0d6c356dd6547adac2b06b461528e3573f52d953 upstream.

When emitting the order of the allocation for a hash table,
alloc_large_system_hash() unconditionally subtracts PAGE_SHIFT from log
base 2 of the allocation size.  This is not correct if the allocation size
is smaller than a page, and yields a negative value for the order as seen
below:

TCP established hash table entries: 32 (order: -4, 256 bytes, linear) TCP
bind hash table entries: 32 (order: -2, 1024 bytes, linear)

Use get_order() to compute the order when emitting the hash table
information to correctly handle cases where the allocation size is smaller
than a page:

TCP established hash table entries: 32 (order: 0, 256 bytes, linear) TCP
bind hash table entries: 32 (order: 0, 1024 bytes, linear)

Link: https://lkml.kernel.org/r/20251028191020.413002-1-isaacmanjarres@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2546,7 +2546,7 @@ void *__init alloc_large_system_hash(con
 		panic("Failed to allocate %s hash table\n", tablename);
 
 	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
-		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
+		tablename, 1UL << log2qty, get_order(size), size,
 		virt ? (huge ? "vmalloc hugepage" : "vmalloc") : "linear");
 
 	if (_hash_shift)


