Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F601B4C4E;
	Tue, 27 Aug 2024 15:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771008; cv=none; b=tEpNDWT5Wk2spvxmhLqxkUCn8JQZ5sbLfwCwuM4NOF2Mgx9BvcVsvLJNXUCabTUuBF7uDK/9Mp2U2oM9wDux9Bknxzx/H9nL/2OFt9J5F02I2NbsFrcnUnxO6XONFYzcXB7aoWZPP58OYE8+cfr/0ZcwF/B3I2z0/aySm8PSw5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771008; c=relaxed/simple;
	bh=a3vOO7cFRI7UcjixrsHuy9zSUUIuvFRRoYwtqB3VCYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUfEkQPcTMwRX6ZWjCL+DbEzZ+2GzitERnTziTglA+vSQjd3mKK+cSx87CrMM0MXJx53AZIYVLQT5pfqNrbWoOz3+ISMjx6EBfxmIB6sKK6zEPjoEx28DFV/5Gm3LLh4qgcnsMUsTcWaxMrxQNnO6SRXGlW5z2gYWOPhOFIIdJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiwC7igO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiwC7igO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0109DC61049;
	Tue, 27 Aug 2024 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771008;
	bh=a3vOO7cFRI7UcjixrsHuy9zSUUIuvFRRoYwtqB3VCYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiwC7igOoud1ZxoxO+rJD67Od4cPa3UeRv0ep+DRwZjEdGgN/SEazpqZEjksU3ZYd
	 P7pXqllsLfKFstKJRhIYiPE4/wIwsEYo2x3xF4gAEHXz4c0r6tbWaMLvlKB67XiJ8y
	 4sEFQKVRGOnLcpBxefnTACmXihqtURp/mKJ14KhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hailong Liu <hailong.liu@oppo.com>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	Baoquan He <bhe@redhat.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 058/273] mm/vmalloc: fix page mapping if vm_area_alloc_pages() with high order fallback to order 0
Date: Tue, 27 Aug 2024 16:36:22 +0200
Message-ID: <20240827143835.610491487@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hailong Liu <hailong.liu@oppo.com>

commit 61ebe5a747da649057c37be1c37eb934b4af79ca upstream.

The __vmap_pages_range_noflush() assumes its argument pages** contains
pages with the same page shift.  However, since commit e9c3cda4d86e ("mm,
vmalloc: fix high order __GFP_NOFAIL allocations"), if gfp_flags includes
__GFP_NOFAIL with high order in vm_area_alloc_pages() and page allocation
failed for high order, the pages** may contain two different page shifts
(high order and order-0).  This could lead __vmap_pages_range_noflush() to
perform incorrect mappings, potentially resulting in memory corruption.

Users might encounter this as follows (vmap_allow_huge = true, 2M is for
PMD_SIZE):

kvmalloc(2M, __GFP_NOFAIL|GFP_X)
    __vmalloc_node_range_noprof(vm_flags=VM_ALLOW_HUGE_VMAP)
        vm_area_alloc_pages(order=9) ---> order-9 allocation failed and fallback to order-0
            vmap_pages_range()
                vmap_pages_range_noflush()
                    __vmap_pages_range_noflush(page_shift = 21) ----> wrong mapping happens

We can remove the fallback code because if a high-order allocation fails,
__vmalloc_node_range_noprof() will retry with order-0.  Therefore, it is
unnecessary to fallback to order-0 here.  Therefore, fix this by removing
the fallback code.

Link: https://lkml.kernel.org/r/20240808122019.3361-1-hailong.liu@oppo.com
Fixes: e9c3cda4d86e ("mm, vmalloc: fix high order __GFP_NOFAIL allocations")
Signed-off-by: Hailong Liu <hailong.liu@oppo.com>
Reported-by: Tangquan Zheng <zhengtangquan@oppo.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3583,15 +3583,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			page = alloc_pages_noprof(alloc_gfp, order);
 		else
 			page = alloc_pages_node_noprof(nid, alloc_gfp, order);
-		if (unlikely(!page)) {
-			if (!nofail)
-				break;
-
-			/* fall back to the zero order allocations */
-			alloc_gfp |= __GFP_NOFAIL;
-			order = 0;
-			continue;
-		}
+		if (unlikely(!page))
+			break;
 
 		/*
 		 * Higher order allocations must be able to be treated as


