Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030680;
	b=SowVE/bPwNqQECOLcdrUHFKPQnQhi1dY1f0xJkeLjHpee/+FOFIulOIrOTlZcUl772ms
	 vIJw03A2BNmdsqbrjYZ8oIA6jH07pQzqKVdac71zpbhov3QmMTQfTRXWTevs4tNJfx4JA
	 dunoTc8z0sZppuu4rNSdFwpp9LKEyuP9FR6UIVZzOEpBvdi7F2ZRlLjyUjNjoAC5dLi9K
	 fYEBJ2iK8spam5tkIxRZBuR+hbKJ5nOtkLS8/eiRpwd32i49GUB2NmtJu/f5t+8ufd2+B
	 bSxfeCQa4AA0RU00xl6rmdZIWOfAcSHzXc1qIEr1I0207mmrxiyAuf3ylpVg+CCT4gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oJPWSby4iZVUSOaBc7ko6iD5X+i7cM86kyDfSW+ErCI=;
	b=0TI9uGEaaSNVo73NK6cDA2wLq3bm4TMiYHLUaZwEThJChfAqXGK1XpYhfjj5rZB0zXdI
	 sntXtbEkE0+FyIdz6BaKJsGMs/0s9o9WP1DNSp0fHeD3FRA9ketQMBVteqPgEFpQvJqI2
	 7wuWZZy1IICaBFmqt4VHwahFhXm1g9BnlmDK04X3hGQC+QG+H2lhT4fCrS28jWQw+CpzY
	 DJ6HqRC/y/CjBEDXapu86WaAf2dBOPY7aHI5wSCzWzEFaT1ikyinVF/KRw9QKY7xIzCTi
	 pcEVKz1ZP+Hea3qUCIuu3Ex2qKOC3S1/4Uw3nVu7gCCUlL8xKSvX42xqrTbKEiTuXtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsdUSQdk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405B3606A7C6;
	Wed, 18 Nov 2026 19:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsdUSQdk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7435A1F000C5;
	Wed, 18 Nov 2026 19:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030680;
	bh=oJPWSby4iZVUSOaBc7ko6iD5X+i7cM86kyDfSW+ErCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsdUSQdkx9v2VK2ZTqXEvfAdH3f5aHE4N163cBqA7u+3mRClnh98QxeLyCgBsTYnO
	 Qo9A75YHBFqFJ8LOKJ0qFGarJMcBB/gLpiqcKdrq9VR9jZxpMgg9pHLgEifvgvDuLP
	 Y0feFh8w+XnFsvzmBug1MdP2EBwP93agDXEZ0arI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0748/1756] mm/memory_hotplug: fix missing rollback in __add_pages()
Date: Wed, 18 Nov 2026 15:47:55 +0100
Message-ID: <20261118150039.351399440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lance Yang <lance.yang@linux.dev>

[ Upstream commit c31bb839fb829958101250ee5acfa4f94fdb7ecd ]

__add_pages() returns on a sparse_add_section() failure without removing
the sections already added in the same request.

For memremap_pages(), the failed range is not counted in pgmap->nr_range,
so memunmap_pages() skips it. The sections already added in that range
retain their vmemmap mappings and subsection bits. Retrying a
section-aligned range can then fail with -EEXIST.

Save the initial PFN and remove [start_pfn, pfn) on failure. For a vmemmap
population failure, section_activate() already cleans up the current
section, so the rollback excludes it. If the first section fails,
__remove_pages() receives an empty range and does nothing.

Link: https://lore.kernel.org/all/BAD58999-1EDD-4A37-ABA0-DB1BD8AB3453@linux.dev/
Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
Acked-by: Muchun Song <muchun.song@linux.dev>
Link: https://patch.msgid.link/20260930160432.5564-1-lance.yang@linux.dev
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory_hotplug.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e21f59cf29d9f..28fb4587ed8b0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -388,6 +388,7 @@ EXPORT_SYMBOL_GPL(pfn_to_online_page);
 int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
 {
+	const unsigned long start_pfn = pfn;
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
 	int err;
@@ -421,8 +422,11 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
 		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
 					 params->pgmap);
-		if (err)
+		if (err) {
+			__remove_pages(start_pfn, pfn - start_pfn, altmap,
+				       params->pgmap);
 			break;
+		}
 		cond_resched();
 	}
 	vmemmap_populate_print_last();
-- 
2.53.0



