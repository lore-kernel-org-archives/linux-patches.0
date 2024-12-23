Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2104519E98B;
	Mon, 23 Dec 2024 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970451; cv=none; b=qloeCwiDxfeNUWJ02YOMIQNkCUMybJ8r+OJVO+jg4+5CCiAZ6Un/spl87K60wpVXujGhv3fDjymoCRuO1xlWMBQs1dDqp+1cHgyFAm03pZXRX8+bw6yd9Fv0q6yVMw6T0PBk2NR8jkuMeukgkE9meyZd+V0BYSk/OjUBjiVTzLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970451; c=relaxed/simple;
	bh=yZZh1jJDUgTfzZtAsmdU2JuwBIfW3vq4nr4MkrOb3lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/D59ByA/WV2XNzSyLNcc8SJSYW7fvZa2OKnKYsersGfkJ8/9PvF7y+7TT27eAPd3MbHhPjmrPTxqjf9Cot7mnX8PFlfmBBqGCqhE16tVSoeBjgpIJjEfrZvPJRsOwh/+zUrAAVkYQgysNhPLTLOQB/RLQXNy3t10I4UKLL+25A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2aZo78h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2aZo78h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0E8C4CED3;
	Mon, 23 Dec 2024 16:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970451;
	bh=yZZh1jJDUgTfzZtAsmdU2JuwBIfW3vq4nr4MkrOb3lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2aZo78httDjOvsWF6awq7w1+ZSUOIweKbaXwOyOsv6pyxWVcZq/FHetoCOJ/61Oe
	 s0+h2S0BPJx5Igz4jKcMPHX+v/mqS4EdZ6+/YrTZGO//Mu6iaUHQh+Yhojyjp/3NXQ
	 L5dkvqO+IOWhWdRQKntmFLHZSrLDq6jGGvfOhYGk=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 087/116] vmalloc: fix accounting with i915
Date: Mon, 23 Dec 2024 16:59:17 +0100
Message-ID: <20241223155402.943868423@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit a2e740e216f5bf49ccb83b6d490c72a340558a43 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2851,7 +2851,8 @@ void vfree(const void *addr)
 		struct page *page = vm->pages[i];
 
 		BUG_ON(!page);
-		mod_memcg_page_state(page, MEMCG_VMALLOC, -1);
+		if (!(vm->flags & VM_MAP_PUT_PAGES))
+			mod_memcg_page_state(page, MEMCG_VMALLOC, -1);
 		/*
 		 * High-order allocs for huge vmallocs are split, so
 		 * can be freed as an array of order-0 allocations
@@ -2859,7 +2860,8 @@ void vfree(const void *addr)
 		__free_page(page);
 		cond_resched();
 	}
-	atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
+	if (!(vm->flags & VM_MAP_PUT_PAGES))
+		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }


