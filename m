Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C08A173334;
	Wed,  3 Jul 2024 11:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005388; cv=none; b=ikQtrexSN87SXo05O1Uhr6bDTatm2ehLTmITdd9MYZHnzyzZEoLZF9bJxLdl0tgUX3mU9V6cNz3r4sP1SeqjwjaZL4Dl29UIvCcZB8EuCCwLjKRrc+wTDZiWoJlwOf/IDe0nVWw1o9gcn5QI5DTlCCUsJPUcOSRfdaNxMhi0Jtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005388; c=relaxed/simple;
	bh=d4/cFBEAK2LH77jBc0HPQKLv/Hf4rt/4UjtPXjANk70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EI80UY0qMqZeGWRiP9Xp7WuHNZGv2IgTfE/kfwZhE/oGOSEqbvXFq7SziGxV9gW6t7c71ba8j0Z4DpO6CngLS3kqeFdIArmhlr2mxy4CiX3BbNCJWfKDIOYu7eYHhNDzOGWxzZo2vdz8OUe4PU07SahDI7kc661fOlvPqWJj3yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMNNhKjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMNNhKjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF191C2BD10;
	Wed,  3 Jul 2024 11:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005388;
	bh=d4/cFBEAK2LH77jBc0HPQKLv/Hf4rt/4UjtPXjANk70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMNNhKjoEwv4tmmMVslBMpCOyHukJbIWjqUYN6L+QO5WWm7+PzEAVow7RWxrpCZAN
	 CXmcRvTG6n5JHxKyR3ANQ5a7l9FkKNcuSi+S8M8r/oDI8NKoj8yO+S62JipLxdhwZF
	 YrJi7Bxz02lO6fy4kkBxYSv7g8a9p/0Q97OpxI8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank van der Linden <fvdl@google.com>,
	David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/356] mm/cma: drop incorrect alignment check in cma_init_reserved_mem
Date: Wed,  3 Jul 2024 12:36:40 +0200
Message-ID: <20240703102915.522157395@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank van der Linden <fvdl@google.com>

[ Upstream commit b174f139bdc8aaaf72f5b67ad1bd512c4868a87e ]

cma_init_reserved_mem uses IS_ALIGNED to check if the size represented by
one bit in the cma allocation bitmask is aligned with
CMA_MIN_ALIGNMENT_BYTES (pageblock size).

However, this is too strict, as this will fail if order_per_bit >
pageblock_order, which is a valid configuration.

We could check IS_ALIGNED both ways, but since both numbers are powers of
two, no check is needed at all.

Link: https://lkml.kernel.org/r/20240404162515.527802-1-fvdl@google.com
Fixes: de9e14eebf33 ("drivers: dma-contiguous: add initialization from device tree")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 5208aee4f45ad..88fbd4f8124d3 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -179,10 +179,6 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
-	/* alignment should be aligned with order_per_bit */
-	if (!IS_ALIGNED(CMA_MIN_ALIGNMENT_PAGES, 1 << order_per_bit))
-		return -EINVAL;
-
 	/* ensure minimal alignment required by mm core */
 	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
 		return -EINVAL;
-- 
2.43.0



