Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA31A0BFD;
	Sun,  7 Sep 2025 20:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277281; cv=none; b=Bwp4+JjguwDL9fxS4yKx1p/vwEQm0az7s4Fjk3gE/1WYA2MP1F02Mx2B0J0VxBANUYU8c+I009hXBz18/TMv3sn1R8EVHSIGD6WFreTp6WDkeOGL+yNBWkwdxtxbQNTkEPz+DgWxr9ueWnyMIZ1ZaInYTG7iEyE8IKmqZrFHHmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277281; c=relaxed/simple;
	bh=x+faFj5wZ+rhLzhf57xzUAPVUnYAjgH9jtAKhMTfoa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPPteL7IcDpByBDEXwZUWR1EOzas3SJFb+Db2ABCyOG0+m1FRCrhLFTt0RkNjveWFZ0GQvfeBrquckfQf+L8VJl+GOkbV9guUms6os+xupgpHYNkjTyGVEH5n7kqNZPAJyI8tXrZ9cGEsXOkYvS9kyhechhGiC3yLaVbN4K8ny4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KM3esfmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KM3esfmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B029BC4CEF0;
	Sun,  7 Sep 2025 20:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277281;
	bh=x+faFj5wZ+rhLzhf57xzUAPVUnYAjgH9jtAKhMTfoa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KM3esfmdFoahySw6D1iHdN0dagiSLKXbuRZ2Ic3l4cZR7oS0Q6Wsnzj6c06tQYuJB
	 J48cvGh07tn4ZOgOtrDAGwxl24yD9xkoPjBZJKiHlhtXe08vftyhHPlUEDRP9YOXzB
	 iaVdpw0RhcqkqHvAXQQNFWhU26TjZ5MDZEbtSkWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/175] mm: fix accounting of memmap pages
Date: Sun,  7 Sep 2025 21:58:58 +0200
Message-ID: <20250907195618.238241517@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

[ Upstream commit c3576889d87b603cb66b417e08844a53c1077a37 ]

For !CONFIG_SPARSEMEM_VMEMMAP, memmap page accounting is currently done
upfront in sparse_buffer_init().  However, sparse_buffer_alloc() may
return NULL in failure scenario.

Also, memmap pages may be allocated either from the memblock allocator
during early boot or from the buddy allocator.  When removed via
arch_remove_memory(), accounting of memmap pages must reflect the original
allocation source.

To ensure correctness:
* Account memmap pages after successful allocation in sparse_init_nid()
  and section_activate().
* Account memmap pages in section_deactivate() based on allocation
  source.

Link: https://lkml.kernel.org/r/20250807183545.1424509-1-sumanthk@linux.ibm.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/sparse-vmemmap.c |    5 -----
 mm/sparse.c         |   15 +++++++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -474,10 +474,5 @@ struct page * __meminit __populate_secti
 	if (r < 0)
 		return NULL;
 
-	if (system_state == SYSTEM_BOOTING)
-		memmap_boot_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
-	else
-		memmap_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
-
 	return pfn_to_page(pfn);
 }
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -462,9 +462,6 @@ static void __init sparse_buffer_init(un
 	 */
 	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
 	sparsemap_buf_end = sparsemap_buf + size;
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-	memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
-#endif
 }
 
 static void __init sparse_buffer_fini(void)
@@ -532,6 +529,8 @@ static void __init sparse_init_nid(int n
 			sparse_buffer_fini();
 			goto failed;
 		}
+		memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+						   PAGE_SIZE));
 		check_usemap_section_nr(nid, usage);
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
 				SECTION_IS_EARLY);
@@ -643,7 +642,6 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
 static void free_map_bootmem(struct page *memmap)
@@ -819,10 +817,14 @@ static void section_deactivate(unsigned
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early)
+	if (!section_is_early) {
+		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	else if (memmap)
+	} else if (memmap) {
+		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
+							  PAGE_SIZE)));
 		free_map_bootmem(memmap);
+	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -867,6 +869,7 @@ static struct page * __meminit section_a
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }


