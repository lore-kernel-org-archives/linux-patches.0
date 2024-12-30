Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE97715E8B;
	Mon, 30 Dec 2024 15:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573594; cv=none; b=McRi+y9SglWi9TVDXcJMl1cu/7P5oE2jMpy73/jSTpCAbQLsbbs6q3ciJYKtar16vk92J839Hn4glF6ePpMVwemcmUiVFjXx1Htp9DNS9SbocLP8i1QJU66sF1UUphEMNxeeQWQkY7fjgtqi/7ZrNVSCJ1BVKLwX+a1cQ1LtvnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573594; c=relaxed/simple;
	bh=UJ2rcV1C47nyHWg6xYpuARYobeM1TrZoCCU6nGTL90A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEpAOS09CqrFfLzBBsULASenCPYrmAFVQ9QTJ9mdegrvujKfojqodvTMSgjymH+p/b1xZgLeH0PR7n9AibFuL1Psv8yX1gkMkIyw6HQ+8Tb4rYctVq9NwBn9dud3e19JwupI9tKUlrfLHmLLrOVN+O026L3mWY3WGsk55rxs6S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fe0xqwg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fe0xqwg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB85C4CED0;
	Mon, 30 Dec 2024 15:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573593;
	bh=UJ2rcV1C47nyHWg6xYpuARYobeM1TrZoCCU6nGTL90A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fe0xqwg0BWhEOmpEUQG498cligz5E2GSXumVAOz0HoN/fzaaHofgbbJSCfK/suhTp
	 1Jwcl853RJnd3oUfHrlgM3QIp4fEjo9mUDBurcXapeKn9LrdbiztuO1vehHdMSq5ni
	 IbiPP4zML63KZpC2Thv0bYpXKFcINHBD1iec60+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Balbir Singh <balbirs@nvidia.com>,
	Michal Hocko <mhocko@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/60] vmalloc: fix accounting with i915
Date: Mon, 30 Dec 2024 16:42:49 +0100
Message-ID: <20241230154208.764122823@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit a2e740e216f5bf49ccb83b6d490c72a340558a43 ]

If the caller of vmap() specifies VM_MAP_PUT_PAGES (currently only the
i915 driver), we will decrement nr_vmalloc_pages and MEMCG_VMALLOC in
vfree().  These counters are incremented by vmalloc() but not by vmap() so
this will cause an underflow.  Check the VM_MAP_PUT_PAGES flag before
decrementing either counter.

Link: https://lkml.kernel.org/r/20241211202538.168311-1-willy@infradead.org
Fixes: b944afc9d64d ("mm: add a VM_MAP_PUT_PAGES flag for vmap")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmalloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a0b650f50faa..7c6694514606 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2709,7 +2709,8 @@ static void __vunmap(const void *addr, int deallocate_pages)
 			struct page *page = area->pages[i];
 
 			BUG_ON(!page);
-			mod_memcg_page_state(page, MEMCG_VMALLOC, -1);
+			if (!(area->flags & VM_MAP_PUT_PAGES))
+				mod_memcg_page_state(page, MEMCG_VMALLOC, -1);
 			/*
 			 * High-order allocs for huge vmallocs are split, so
 			 * can be freed as an array of order-0 allocations
@@ -2717,7 +2718,8 @@ static void __vunmap(const void *addr, int deallocate_pages)
 			__free_pages(page, 0);
 			cond_resched();
 		}
-		atomic_long_sub(area->nr_pages, &nr_vmalloc_pages);
+		if (!(area->flags & VM_MAP_PUT_PAGES))
+			atomic_long_sub(area->nr_pages, &nr_vmalloc_pages);
 
 		kvfree(area->pages);
 	}
-- 
2.39.5



