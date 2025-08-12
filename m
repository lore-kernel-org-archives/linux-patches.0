Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F124D2EE5E8;
	Tue, 12 Aug 2025 18:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023615; cv=none; b=JC1wuR0duJEg1FMhm+zqcjFUy6Q2nfHTznBz3D9hnBTTiHyOVFd7/GeG9tSqxpQNlvfWsZVx9eiO/i18Twy1TMctATw1v6QoMJ1Mvu9mhCRG41UuIxVmCMLViXKlfffrYbNMB6wLqX5whmx5FghxuLdwUc4QqUTg16bBsoHhvQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023615; c=relaxed/simple;
	bh=fc0DOE4LXmYg4yr1Sb39nVQaBHb/uAs4zqhqPMx3YFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6vVhClfgr+/LCuknCpdgWyjZFrgJIlDNxcKq35nQ2AQ/9tYzxuZYsN6IKJLWp82wzyw1Ucc0ANOxEJirpr0Zax+ullY65siRHp0upeGOTxebH1+D+kr819mPstwHTehXldbOcDGNuZXdAbzDh61mwTCrmV45e4gMVI5fVBSm8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hq/IflG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hq/IflG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22472C4CEF0;
	Tue, 12 Aug 2025 18:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023614;
	bh=fc0DOE4LXmYg4yr1Sb39nVQaBHb/uAs4zqhqPMx3YFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hq/IflG5FvU9lwMGSY5F7S9e+1oge28P+4qw62y4luW2L81A0b+NU0BuvlykMimIF
	 0UFLQxc7fbU2G66B70Et/hPYsMrEAArVbu9sB0eibIJf+VoKAde4U8x7QehCao1Ums
	 wZqMKvcpN7J0P8XvmLCSgUyyQbvRf23bVWHD7VVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huan Yang <link@vivo.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Bingbu Cao <bingbu.cao@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 130/627] Revert "udmabuf: fix vmap_udmabuf error page set"
Date: Tue, 12 Aug 2025 19:27:05 +0200
Message-ID: <20250812173424.263255354@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huan Yang <link@vivo.com>

[ Upstream commit ceb7b62eaaaacfcf87473bd2e99ac73a758620cb ]

This reverts commit 18d7de823b7150344d242c3677e65d68c5271b04.

We cannot use vmap_pfn() in vmap_udmabuf() as it would fail the pfn_valid()
check in vmap_pfn_apply(). This is because vmap_pfn() is intended to be
used for mapping non-struct-page memory such as PCIe BARs. Since, udmabuf
mostly works with pages/folios backed by shmem/hugetlbfs/THP, vmap_pfn()
is not the right tool or API to invoke for implementing vmap.

Signed-off-by: Huan Yang <link@vivo.com>
Suggested-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Reported-by: Bingbu Cao <bingbu.cao@linux.intel.com>
Closes: https://lore.kernel.org/dri-devel/eb7e0137-3508-4287-98c4-816c5fd98e10@vivo.com/T/#mbda4f64a3532b32e061f4e8763bc8e307bea3ca8
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://lore.kernel.org/r/20250428073831.19942-2-link@vivo.com
Stable-dep-of: a26fd92b7223 ("udmabuf: fix vmap missed offset page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/Kconfig   |  1 -
 drivers/dma-buf/udmabuf.c | 22 +++++++---------------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index fee04fdb0822..b46eb8a552d7 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -36,7 +36,6 @@ config UDMABUF
 	depends on DMA_SHARED_BUFFER
 	depends on MEMFD_CREATE || COMPILE_TEST
 	depends on MMU
-	select VMAP_PFN
 	help
 	  A driver to let userspace turn memfd regions into dma-bufs.
 	  Qemu can use this to create host dmabufs for guest framebuffers.
diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index c9d0c68d2fcb..4cc342fb28f4 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -109,29 +109,21 @@ static int mmap_udmabuf(struct dma_buf *buf, struct vm_area_struct *vma)
 static int vmap_udmabuf(struct dma_buf *buf, struct iosys_map *map)
 {
 	struct udmabuf *ubuf = buf->priv;
-	unsigned long *pfns;
+	struct page **pages;
 	void *vaddr;
 	pgoff_t pg;
 
 	dma_resv_assert_held(buf->resv);
 
-	/**
-	 * HVO may free tail pages, so just use pfn to map each folio
-	 * into vmalloc area.
-	 */
-	pfns = kvmalloc_array(ubuf->pagecount, sizeof(*pfns), GFP_KERNEL);
-	if (!pfns)
+	pages = kvmalloc_array(ubuf->pagecount, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
 		return -ENOMEM;
 
-	for (pg = 0; pg < ubuf->pagecount; pg++) {
-		unsigned long pfn = folio_pfn(ubuf->folios[pg]);
-
-		pfn += ubuf->offsets[pg] >> PAGE_SHIFT;
-		pfns[pg] = pfn;
-	}
+	for (pg = 0; pg < ubuf->pagecount; pg++)
+		pages[pg] = &ubuf->folios[pg]->page;
 
-	vaddr = vmap_pfn(pfns, ubuf->pagecount, PAGE_KERNEL);
-	kvfree(pfns);
+	vaddr = vm_map_ram(pages, ubuf->pagecount, -1);
+	kvfree(pages);
 	if (!vaddr)
 		return -EINVAL;
 
-- 
2.39.5



