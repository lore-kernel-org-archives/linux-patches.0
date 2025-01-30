Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5D51E522;
	Thu, 30 Jan 2025 14:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247163; cv=none; b=FH/Q+nTApM62mMtR+hHwZzTFBcQ6a8iRiFJpwlf4RATuJYqbrrMvqoVUxYapXGkMyRasv9kJdOu7wfQo8ebR7lzxAdvou/isa2/uG0pnnniStGBOc2g/iuJ9iJUiyvYHjlWAgjTHuG4ijLMbMYZ00Qnf2rx9VtJ346Sm3n+La74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247163; c=relaxed/simple;
	bh=ZIx7ZsTxr30LxoiUHcY23T4E6V2b78pnQVp0SBAh1Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnIr/SZF3tEJz4Ii0oDX4sMfvSEf5H5r/ziGdz2gEfGjhf5lko19Pg81MrmcSgLtE2550jaa/xE27Kb3/5mx9beAbQb2E+BJs2J8quKKxx/+N8GenLy61eYUl8nqq+lYMOLKe9h0DDEWzbNLtzU7OroK2h4EI3eD+ral2WwJP+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEMD5EOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEMD5EOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C036C4CED2;
	Thu, 30 Jan 2025 14:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247162;
	bh=ZIx7ZsTxr30LxoiUHcY23T4E6V2b78pnQVp0SBAh1Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEMD5EOc2keGUQIgrVIr8beM6cruKkasgeBJiSc+msgyITJk1M651oaIUPXAksmVT
	 ZqKBziJisiAQ6lYi72LzlL9Y4wh1VkkNIqtOKQEMuCfxsYkdsYNq1RS1mizNc12Xej
	 D1Jkw2u3D0H8F0hjFgSKt3NQgXrWTOujzqulAKt8=
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
Subject: [PATCH 5.10 104/133] vmalloc: fix accounting with i915
Date: Thu, 30 Jan 2025 15:01:33 +0100
Message-ID: <20250130140146.726599748@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2269,7 +2269,8 @@ static void __vunmap(const void *addr, i
 			BUG_ON(!page);
 			__free_pages(page, 0);
 		}
-		atomic_long_sub(area->nr_pages, &nr_vmalloc_pages);
+		if (!(area->flags & VM_MAP_PUT_PAGES))
+			atomic_long_sub(area->nr_pages, &nr_vmalloc_pages);
 
 		kvfree(area->pages);
 	}


