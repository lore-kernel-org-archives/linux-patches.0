Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26FE13AD20;
	Mon,  6 Jan 2025 15:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178765; cv=none; b=L6SFk8qTtvlEl9sgsC1mjvBL/H2l7N/XgpzixjzMHSiu0KrSBSPur5OzloLE88KiR1eqhAoEoTHOiEJz/j0NtRxhHqa1j67WC/ibnvcv+n2w6d0RRwOxoJYW5Sij3ifZgmPR55RxEOQc7h1lwI4O8xWurzv06738WWwXgeqmqpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178765; c=relaxed/simple;
	bh=xqDlUtYyrFxzP8MuulD+AbLL06Z85YOCgLj7DBHtnFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ct7jB3dor9WUUSpx6COVMmejtrF+rtgv6JhoZoNG9EpBMRkfpKDwNCG8+7A2HgDjNewUlYCE2vqibwmdBUxLCObADPckAaQW9D9Hn014Dl+NvW1G8+Y40FeeLjV3P8Ustt3Po6Pbsgqb4thcs83N7/8va5tMPkgRX54x1d1/mI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnXYGHnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnXYGHnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47326C4CED2;
	Mon,  6 Jan 2025 15:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178764;
	bh=xqDlUtYyrFxzP8MuulD+AbLL06Z85YOCgLj7DBHtnFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnXYGHnLsXB54Lu1wgSgw1UH1fjjtbSEo8awAGXs9WVvzshczVvj7XpktqcZunXOE
	 OxhR7rkNCQAHFCgpiQsHs7I8gpdQTX5Dy4U6az49QXhNgkNy6NnTqVv3A/lwnSdZEA
	 0nIwOc5lzxK2cFDOFikX8EryVYtQQisc6U22f0r8=
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
Subject: [PATCH 5.15 085/168] vmalloc: fix accounting with i915
Date: Mon,  6 Jan 2025 16:16:33 +0100
Message-ID: <20250106151141.674309190@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 mm/vmalloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index cd434f0ec47f..3cb1f59d1b53 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2621,7 +2621,8 @@ static void __vunmap(const void *addr, int deallocate_pages)
 			__free_pages(page, page_order);
 			cond_resched();
 		}
-		atomic_long_sub(area->nr_pages, &nr_vmalloc_pages);
+		if (!(area->flags & VM_MAP_PUT_PAGES))
+			atomic_long_sub(area->nr_pages, &nr_vmalloc_pages);
 
 		kvfree(area->pages);
 	}
-- 
2.39.5



