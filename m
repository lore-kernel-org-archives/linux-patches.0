Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BE61DE3B8;
	Wed,  6 Nov 2024 12:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894977; cv=none; b=rjtMBrby4OXnAAtW0eQOfqAuyuPhuhyCVxtXIF6Q0wDjKwpXE8Vg5xXtAh8y/XH4T9gTltNI2A4sD7KGUq8jfNaJPaqLzAk0NrBBGK+YS2qw2M4fu1GIE9pPl9+r9Yc28b9TErLTsIrxlUydLQX7y7p6GtckXkb4MuURal9fj64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894977; c=relaxed/simple;
	bh=7jD7jt9H4xy1EXHds1sc522IHIs61GY9j8IzW0dLuM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcm3xhxeHp8PgDOkjEQFHt66eg2P1HRv88CH4PJh/CC7hWk8KXhbDmLO1hDJY9TjYupfwseSvoxjn8TLiHRb4loR0dHmWbQSKIiPEr5ZCGboYM/tZsW56Rd9aRTO45Jphu5fiCFT3oeB2A7UBqL5FVrOjzOvYGlH4BL+KMIYTtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCg/+bbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCg/+bbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CB3C4CECD;
	Wed,  6 Nov 2024 12:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894977;
	bh=7jD7jt9H4xy1EXHds1sc522IHIs61GY9j8IzW0dLuM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCg/+bbwVYiFmvhjWrA6VrReAEzaNsptTWEhV+FfCEZ8jjpCLPQTh+twn+Mn7Oh4S
	 IsAVBYqu4yWtti8P3fJ4iCDv7wqSc7fL9/qSGjQ0knfNvXzGsBnRvxCribO5gFbRUO
	 ZmLh4Toq0HQh9BBjF3gYZ1Az62Qqpph8pfo+Z4aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/350] xen/swiotlb: simplify range_straddles_page_boundary()
Date: Wed,  6 Nov 2024 12:59:52 +0100
Message-ID: <20241106120322.475167698@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit bf70726668c6116aa4976e0cc87f470be6268a2f ]

range_straddles_page_boundary() is open coding several macros from
include/xen/page.h. Use those instead. Additionally there is no need
to have check_pages_physically_contiguous() as a separate function as
it is used only once, so merge it into range_straddles_page_boundary().

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: 9f40ec84a797 ("xen/swiotlb: add alignment check for dma buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 3d9997595d900..2f4d4e36c7b36 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -94,34 +94,18 @@ static inline dma_addr_t xen_virt_to_bus(void *address)
 	return xen_phys_to_bus(virt_to_phys(address));
 }
 
-static int check_pages_physically_contiguous(unsigned long xen_pfn,
-					     unsigned int offset,
-					     size_t length)
+static inline int range_straddles_page_boundary(phys_addr_t p, size_t size)
 {
-	unsigned long next_bfn;
-	int i;
-	int nr_pages;
+	unsigned long next_bfn, xen_pfn = XEN_PFN_DOWN(p);
+	unsigned int i, nr_pages = XEN_PFN_UP(xen_offset_in_page(p) + size);
 
 	next_bfn = pfn_to_bfn(xen_pfn);
-	nr_pages = (offset + length + XEN_PAGE_SIZE-1) >> XEN_PAGE_SHIFT;
 
-	for (i = 1; i < nr_pages; i++) {
+	for (i = 1; i < nr_pages; i++)
 		if (pfn_to_bfn(++xen_pfn) != ++next_bfn)
-			return 0;
-	}
-	return 1;
-}
+			return 1;
 
-static inline int range_straddles_page_boundary(phys_addr_t p, size_t size)
-{
-	unsigned long xen_pfn = XEN_PFN_DOWN(p);
-	unsigned int offset = p & ~XEN_PAGE_MASK;
-
-	if (offset + size <= XEN_PAGE_SIZE)
-		return 0;
-	if (check_pages_physically_contiguous(xen_pfn, offset, size))
-		return 0;
-	return 1;
+	return 0;
 }
 
 static int is_xen_swiotlb_buffer(dma_addr_t dma_addr)
-- 
2.43.0



