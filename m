Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811754C3D0;
	Mon, 14 Oct 2024 15:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920077; cv=none; b=Yg3/+mN+xXePMtjxDcX+4aVjYLpCiTyu0xT/CA8HS2voz71zE5zMl7+fv2ig4p/Y+t7e37cHhgcARMDl7ZuThN4PDD+opwACWxrMRFNbm5yog96G6h9o3h690Od2CjUGoVw5hu8u+RCaiwW4AzpNRg5xB82u12EvbUt5EbFlLYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920077; c=relaxed/simple;
	bh=UY4Td1fC/ivHksuIFBThF8zOQqgqNwBwBhT4UmbHrYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CfDeUixGskHqddpbW+nk8wWU7t9uGhoJWxPPtn4wK4awGJ0nV2Fln6diKJZTu3Dsb4u+YSR7YxbxamSoSlq2QhUcZezJNiI1FRnMjMvpeKsGdCkqH0h1PWhZvktEObldmZKDKaHy8oRsZNb5AcdjXPnSSBdD04hDDy8s4wS1l8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWRCBv/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWRCBv/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46EDC4CEC3;
	Mon, 14 Oct 2024 15:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920077;
	bh=UY4Td1fC/ivHksuIFBThF8zOQqgqNwBwBhT4UmbHrYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWRCBv/DnRtNIU3IDjJpNHMs+P4x5bvHuop9geMuKUTPwd2o6/mXk0kr7dA57Vgpy
	 A2d9StEZ+WXAX6q0601p+8iO/XNGuIh8/P9v/kM9XHjbWvJnGhVUOydO3sGOIogszf
	 3FKPZqZoinmzh4q7SZ54iWFiwNQpYRSALm86vreI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kun(llfl)" <llfl@linux.alibaba.com>,
	JianXiong Zhao <zhaojianxiong.zjx@alibaba-inc.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 791/798] device-dax: correct pgoff align in dax_set_mapping()
Date: Mon, 14 Oct 2024 16:22:25 +0200
Message-ID: <20241014141249.147568876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kun(llfl) <llfl@linux.alibaba.com>

commit 7fcbd9785d4c17ea533c42f20a9083a83f301fa6 upstream.

pgoff should be aligned using ALIGN_DOWN() instead of ALIGN().  Otherwise,
vmf->address not aligned to fault_size will be aligned to the next
alignment, that can result in memory failure getting the wrong address.

It's a subtle situation that only can be observed in
page_mapped_in_vma() after the page is page fault handled by
dev_dax_huge_fault.  Generally, there is little chance to perform
page_mapped_in_vma in dev-dax's page unless in specific error injection
to the dax device to trigger an MCE - memory-failure.  In that case,
page_mapped_in_vma() will be triggered to determine which task is
accessing the failure address and kill that task in the end.


We used self-developed dax device (which is 2M aligned mapping) , to
perform error injection to random address.  It turned out that error
injected to non-2M-aligned address was causing endless MCE until panic.
Because page_mapped_in_vma() kept resulting wrong address and the task
accessing the failure address was never killed properly:


[ 3783.719419] Memory failure: 0x200c9742: recovery action for dax page:
Recovered
[ 3784.049006] mce: Uncorrected hardware memory error in user-access at
200c9742380
[ 3784.049190] Memory failure: 0x200c9742: recovery action for dax page:
Recovered
[ 3784.448042] mce: Uncorrected hardware memory error in user-access at
200c9742380
[ 3784.448186] Memory failure: 0x200c9742: recovery action for dax page:
Recovered
[ 3784.792026] mce: Uncorrected hardware memory error in user-access at
200c9742380
[ 3784.792179] Memory failure: 0x200c9742: recovery action for dax page:
Recovered
[ 3785.162502] mce: Uncorrected hardware memory error in user-access at
200c9742380
[ 3785.162633] Memory failure: 0x200c9742: recovery action for dax page:
Recovered
[ 3785.461116] mce: Uncorrected hardware memory error in user-access at
200c9742380
[ 3785.461247] Memory failure: 0x200c9742: recovery action for dax page:
Recovered
[ 3785.764730] mce: Uncorrected hardware memory error in user-access at
200c9742380
[ 3785.764859] Memory failure: 0x200c9742: recovery action for dax page:
Recovered
[ 3786.042128] mce: Uncorrected hardware memory error in user-access at
200c9742380
[ 3786.042259] Memory failure: 0x200c9742: recovery action for dax page:
Recovered
[ 3786.464293] mce: Uncorrected hardware memory error in user-access at
200c9742380
[ 3786.464423] Memory failure: 0x200c9742: recovery action for dax page:
Recovered
[ 3786.818090] mce: Uncorrected hardware memory error in user-access at
200c9742380
[ 3786.818217] Memory failure: 0x200c9742: recovery action for dax page:
Recovered
[ 3787.085297] mce: Uncorrected hardware memory error in user-access at
200c9742380
[ 3787.085424] Memory failure: 0x200c9742: recovery action for dax page:
Recovered

It took us several weeks to pinpoint this problem,  but we eventually
used bpftrace to trace the page fault and mce address and successfully
identified the issue.


Joao added:

; Likely we never reproduce in production because we always pin
: device-dax regions in the region align they provide (Qemu does
: similarly with prealloc in hugetlb/file backed memory).  I think this
: bug requires that we touch *unpinned* device-dax regions unaligned to
: the device-dax selected alignment (page size i.e.  4K/2M/1G)

Link: https://lkml.kernel.org/r/23c02a03e8d666fef11bbe13e85c69c8b4ca0624.1727421694.git.llfl@linux.alibaba.com
Fixes: b9b5777f09be ("device-dax: use ALIGN() for determining pgoff")
Signed-off-by: Kun(llfl) <llfl@linux.alibaba.com>
Tested-by: JianXiong Zhao <zhaojianxiong.zjx@alibaba-inc.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dax/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 9c1a729cd77e..6d74e62bbee0 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -86,7 +86,7 @@ static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
 		nr_pages = 1;
 
 	pgoff = linear_page_index(vmf->vma,
-			ALIGN(vmf->address, fault_size));
+			ALIGN_DOWN(vmf->address, fault_size));
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
-- 
2.47.0



