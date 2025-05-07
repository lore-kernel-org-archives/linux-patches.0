Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265E819AD5C;
	Wed,  7 May 2025 19:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644859; cv=none; b=ZAZu/Cyia771P8z0k0hU7Wg+jv7PaR+GBjTdufFwLYSnu2XGObr4Bhb81RAcXSGpLX2xPcDWd2mba4oh2EwYTvmFXZuIbd0GPRGPavKZyzgT4C5prZK1klk7AXu9q1yx5PFNT8wL4KdGRrzEPXayZXp8m2U5jUN9Zjpav5eK+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644859; c=relaxed/simple;
	bh=mXkXdeKcNdrnxmZ1kh5Wv7rOjiddH7XVQKp863EKCHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXSWRPHqv1tb+9Htosxeva6QxcjKJ6yHATt4qGvLSFSQgydtvNbYg6TdTL3W3CLN8sH5HGOuzL+jsABr5N/o919NdkxJdwprkVCRN7JSxaZQAKGZeIxcmAuxeOheU2qy9z7usGzwAFaGb3Ms2pMqipQrgSNWoJ8eAywLXPcVj/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6y2QgU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6y2QgU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10DAC4CEE2;
	Wed,  7 May 2025 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644859;
	bh=mXkXdeKcNdrnxmZ1kh5Wv7rOjiddH7XVQKp863EKCHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6y2QgU/rZE45J+v2vnfE/zqnVEFnrKSTiRcbHbSWy5m4LXMi7eXfL4DAw+Q+TpO6
	 JPYjfuRsWxYL1A2ERBi2Fm/AVXAeDUQacFZ0irDN46kIzAZ/+nTofcjmFu/TCyqHFa
	 r5QJoUyd3ZZ8EvqP8v8PRQRKiT+npdao1x46eEZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH 6.6 016/129] mm/memblock: repeat setting reserved region nid if array is doubled
Date: Wed,  7 May 2025 20:39:12 +0200
Message-ID: <20250507183814.194696070@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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
@@ -2122,11 +2122,14 @@ static void __init memmap_init_reserved_
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
@@ -2137,6 +2140,13 @@ static void __init memmap_init_reserved_
 
 		memblock_set_node(start, region->size, &memblock.reserved, nid);
 	}
+	/*
+	 * 'max' is changed means memblock.reserved has been doubled its
+	 * array, which may result a new reserved region before current
+	 * 'start'. Now we should repeat the procedure to set its node id.
+	 */
+	if (max_reserved != memblock.reserved.max)
+		goto repeat;
 
 	/* initialize struct pages for the reserved regions */
 	for_each_reserved_mem_region(region) {


