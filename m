Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A401E22E9;
	Wed,  7 May 2025 19:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644481; cv=none; b=g5gqklU51GSBN+UAO82pbeOJxuSyqoefXvVQ4qaYC2+gLnt5kZz31mMs29N3O+EW4AX0ECh08ouKg4pUfdAZivyKUFD5EDbkUe3w7hF3fFRGXqi6bC/xBQ51rVEmoI5sAsm/Dk4KYPj1Y5u4up4NUeAc05B5FmLc95hDqqS15uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644481; c=relaxed/simple;
	bh=W/MDSvhMkZcKvUfPjFP3Q3vkibbJR7cp1/3zW5HLx/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NK/GsclYdOmEeBuddWTmRSBY8NhkI+eTTdFvaHGzz0WLiZNiwhY+OVRf3j7IrHckrMi35X7WwfCAKRHd8gFtV9vraPC/r6XLliFJk6XdCw7ZXRt7DC5eKdqBpJQboJH3LAAbFd4+CRXuQYXbAbc1NoAIAPYvLcQFeEBPXS48u5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ec54N2mN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ec54N2mN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE38BC4CEE2;
	Wed,  7 May 2025 19:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644478;
	bh=W/MDSvhMkZcKvUfPjFP3Q3vkibbJR7cp1/3zW5HLx/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ec54N2mNY9L/j8XvKmx7PG9t2BoTEd52s8VlDhVrwsZ/QI0xJjUJqs/y3VDWX0QHh
	 RSD6/kUv6tJ9rbiRi5DAAs/wzol1er4RZzNRW1tbAieMQXnoUUz5IHffaGQ+7xIe05
	 MBvkeGvdXKI+Sa0TsNW5GCmLOLZp2aDup+18Or1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH 6.12 026/164] mm/memblock: repeat setting reserved region nid if array is doubled
Date: Wed,  7 May 2025 20:38:31 +0200
Message-ID: <20250507183821.928003093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2160,11 +2160,14 @@ static void __init memmap_init_reserved_
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
@@ -2175,6 +2178,13 @@ static void __init memmap_init_reserved_
 
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


