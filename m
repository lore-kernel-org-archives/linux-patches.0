Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDD62F7ABF;
	Wed, 17 Sep 2025 12:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113198; cv=none; b=D8glskFCpMulc1SEr/sDiWKA+FFCbFj5n612tAdrNwPdDysTixOmuJLy4aYQinTHMCDJnRAdDCoT71rClThOjKSKvDWc8tZvVbXb8iN/up33QyuY5knMObYKX6Wdjne7rwgsvPFnE2K52LBgzjNcZ7P5tbEJttqFjPWdQmFcWmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113198; c=relaxed/simple;
	bh=wo/GE1SJ32GXEVYrkDJSwgkYJyTw2KY1/RkDE6TqajU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJDF/2QEhAFYE9A0BBVAJku4Ej6AUMwbGHt0y6ZOnOLDZaUTaQrFaqQrWxfs4myVcoS+BAK3HJw79voVppmHY1D9imZVTPKrSA2lSVvA9k5ZU7o1WnHYKQqy2zKg7XDfeoLi7FrDVWWdJAXiAIcD8VJW4YGTlTkIDhRJb7X4obU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNTDqqIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNTDqqIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD75C4CEF5;
	Wed, 17 Sep 2025 12:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113198;
	bh=wo/GE1SJ32GXEVYrkDJSwgkYJyTw2KY1/RkDE6TqajU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNTDqqIreT1gOK2w12+4OOR7i0+wzEcNkUBo0HJaV2dORWmgeGyk/u/wMxEuynnL5
	 xr8mEQzN34rcZr6dPPOzL8dfgujine+FzMbPiO4j3hEBIT17WqvlLD5KGi2lZH6V5/
	 BcnVuIG/dr4AlmhlG55sMwaiabxKbqQzmqoVxJlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huan Yang <link@vivo.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Bingbu Cao <bingbu.cao@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/140] Revert "udmabuf: fix vmap_udmabuf error page set"
Date: Wed, 17 Sep 2025 14:33:05 +0200
Message-ID: <20250917123344.639004775@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/Kconfig   |  1 -
 drivers/dma-buf/udmabuf.c | 22 +++++++---------------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index fee04fdb08220..b46eb8a552d7b 100644
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
index 959f690b12260..0e127a9109e75 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -74,29 +74,21 @@ static int mmap_udmabuf(struct dma_buf *buf, struct vm_area_struct *vma)
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
2.51.0



