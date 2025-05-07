Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672FF42A83;
	Wed,  7 May 2025 18:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643894; cv=none; b=LiHwcTFmoCqR3ZoFKR7MvEGABCytfNrOx8vRvLa+e3U7W13toDsh7IsoWdG0Pkb15ItVoPwLJ2RTg4hplfbhm1k3gJQjuTFuev91gsm0t2xIZouPBO6Xj/bcKuABHwR4vAycPxOm947hcTKtYNXWk94VmB659rifrQ1lWObkCoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643894; c=relaxed/simple;
	bh=eI9o/0B2HiM28Z77TbRv8TxdHEGF9y3kOzy0BedGId8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgXvT5tCJ1uZnlHzNMomwWGWoOS5iXXRbNFDpzTO8Du4SdRp7+Hh5eP5Z0BuyYXcX/xFOeeV2QHehnI0kgFVQK+DNRzePPdaNUm67jwr5XXTT4DPQ4h4fOnqKr6fbIxphfgmU8UCxxoSQ8LsfVN/ofMbyKxstK2dvYSw7KXLVKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWV2tnf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWV2tnf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82BBC4CEE2;
	Wed,  7 May 2025 18:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643894;
	bh=eI9o/0B2HiM28Z77TbRv8TxdHEGF9y3kOzy0BedGId8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWV2tnf19aEmgb6BXgyF4/yIre74wI0uGTTFOIn0ZP68ezx9/bvZqX9M2vD68aiUY
	 2RcN8fhMayRGJHHwcjgq5BEUIwTq7kAnFevGOJDOu5VmoHzrmZESz2oNPMIt8ytRjf
	 yCy3YvStFdLYJqdMgsUbJ1MznsV9GeJgGu8lqAV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH 6.14 022/183] mm/memblock: repeat setting reserved region nid if array is doubled
Date: Wed,  7 May 2025 20:37:47 +0200
Message-ID: <20250507183825.588383384@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

commit eac8ea8736ccc09513152d970eb2a42ed78e87e8 upstream.

Commit 61167ad5fecd ("mm: pass nid to reserve_bootmem_region()") introduce
a way to set nid to all reserved region.

But there is a corner case it will leave some region with invalid nid.
When memblock_set_node() doubles the array of memblock.reserved, it may
lead to a new reserved region before current position. The new region
will be left with an invalid node id.

Repeat the process when detecting it.

Fixes: 61167ad5fecd ("mm: pass nid to reserve_bootmem_region()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
CC: Mike Rapoport <rppt@kernel.org>
CC: Yajun Deng <yajun.deng@linux.dev>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250318071948.23854-3-richard.weiyang@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memblock.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2180,11 +2180,14 @@ static void __init memmap_init_reserved_
 	struct memblock_region *region;
 	phys_addr_t start, end;
 	int nid;
+	unsigned long max_reserved;
 
 	/*
 	 * set nid on all reserved pages and also treat struct
 	 * pages for the NOMAP regions as PageReserved
 	 */
+repeat:
+	max_reserved = memblock.reserved.max;
 	for_each_mem_region(region) {
 		nid = memblock_get_region_node(region);
 		start = region->base;
@@ -2195,6 +2198,13 @@ static void __init memmap_init_reserved_
 
 		memblock_set_node(start, region->size, &memblock.reserved, nid);
 	}
+	/*
+	 * 'max' is changed means memblock.reserved has been doubled its
+	 * array, which may result a new reserved region before current
+	 * 'start'. Now we should repeat the procedure to set its node id.
+	 */
+	if (max_reserved != memblock.reserved.max)
+		goto repeat;
 
 	/*
 	 * initialize struct pages for reserved regions that don't have


