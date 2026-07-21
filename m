Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BC8403AF7;
	Tue, 21 Jul 2026 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654366; cv=none; b=s2FZnebb0wKDH+FLGMlIfs0St8nGZcW1nzwtx64zj0h52xizyAc+iauAhKtN6GnoXSzc83cSMmFmFW3FNgSQgE9RABGppIn6VAdWV5j2n3QYWdOs87R7sIjr1ixNtXK99ISb4ESi18X2+HYhKnBNBfofanRLD1C13WR304TaU/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654366; c=relaxed/simple;
	bh=UcII3p7MGdN77l8T62fAeMEUqdgYAK+5vVaWby6MrEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUeZdm17AOWvUvFbiJRtPkhMz4rqrIVXBMB9qohBUggdItCQMYyuQvzI5ebhXT66zGVmAtALKYVP2ceIX4NTrF4dONiUYnW3Gm73UM3OnCHhZyaufPRWlAapzA9PBsnFMHCyTvvplI8Ai0PfXauI2UFKDgw76Z9d5OZh4hyn6po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZfaNdIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZfaNdIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEE81F000E9;
	Tue, 21 Jul 2026 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654365;
	bh=SEZ7ed+DGDBZkLhYimEr8NUZGuG9aVseLzLrF8vhQ6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZfaNdIS8hz4/bLcb6Xbz8hYOOqreQ8lcXDefRxmLyrXdKROx0oythJ91drRQFZt9
	 aPdFTSSW4xNrsjY0zl+bNtALbzs7HUPfdecC5LpOzbfBlNYl7HsjLBRT6JD3b2gZkq
	 5rjeIffaaqPEmINjl7DtS9BT9W59aqj7+YYYMZN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Georgi Djakov <georgi.djakov@oss.qualcomm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1678/2077] mm/memory_hotplug: fix incorrect altmap passing in error path
Date: Tue, 21 Jul 2026 17:22:31 +0200
Message-ID: <20260721152632.325096318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muchun Song <songmuchun@bytedance.com>

commit 2fac4afa0e2e68841334c78c1821e49f74fbc66a upstream.

In create_altmaps_and_memory_blocks(), when arch_add_memory() succeeds
with memmap_on_memory enabled, the vmemmap pages are allocated from
params.altmap.  If create_memory_block_devices() subsequently fails, the
error path calls arch_remove_memory() with a NULL altmap instead of
params.altmap.

This is a bug that could lead to memory corruption.  Since altmap is NULL,
vmemmap_free() falls back to freeing the vmemmap pages into the system
buddy allocator via free_pages() instead of the altmap.
arch_remove_memory() then immediately destroys the physical linear mapping
for this memory.  This injects unowned pages into the buddy allocator,
causing machine checks or memory corruption if the system later attempts
to allocate and use those freed pages.

Fix this by passing params.altmap to arch_remove_memory() in the error
path.

Link: https://lore.kernel.org/20260428081855.1249045-3-songmuchun@bytedance.com
Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Liam R. Howlett <liam@infradead.org>
Reviewed-by: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1470,7 +1470,7 @@ static int create_altmaps_and_memory_blo
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, params.altmap);
 			kfree(params.altmap);
 			goto out;
 		}


