Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1985A4F4745;
	Tue, 13 Oct 2026 12:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892902; cv=none; b=VaWmRyZgyikFBGVgJUAkD8DOjzbexLGnj4dpjyes87tXkeM/PxNJKwFXlQG8gqygEY38GwCO0cYzPLj2rl2Q+ldpmxmwxktaeEEMkbvuo9pG6ghTkDg0sOxkTjo+lglSRQ2njy0TI6yRzGCc5u3JhHw51Vsr4FMLJG7B+BINor8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892902; c=relaxed/simple;
	bh=NEwoZDX1xYsgN4OMcTDvku236R+Ce9zXZxok/vsbQSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drjPDTsnrNFI3D9qB9zfig1u/zK30SEPi4zvLNi/xImzg02c5cLaWA2smH6fuk+ODq9MKIks0cBNPI3vxrnE1fyvjKiu/CqYVaSLUqBUD43JUnKhZ1vBtng1fc39CvbqDiwT9HCkXnSeV01UnkMJjflvXxR2vFopqfueW5goHpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mahx5oTA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mahx5oTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D01A1F000FF;
	Tue, 13 Oct 2026 12:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892901;
	bh=XEp/iYfdTZIeeiFQQWZqbNyG2sLGquxRrVAbNDV4D6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mahx5oTAS9P5HwtFMPzleTSgEgk5Fr4HbsJ0xYaB+FEkSX+uxVMr8lgtzTKYPqj0g
	 j7L36KWuBOXRSNXOO7M529kbKvNlPm+N20RzgNgwADQV5PkW6PXdU7SSAiJk4GHXNR
	 dSWFGdqQI3WfDv4La6EDSTH/I6eOlbclRJDYfGdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Greve <andreas.greve@a-greve.de>,
	James Dingwall <james@dingwall.me.uk>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Claude Opus 5.5 (1M context)" <noreply@anthropic.com>
Subject: [PATCH 6.18 045/621] swiotlb: fix default_swiotlb_limit() for non-growable default pool
Date: Tue, 13 Oct 2026 13:30:40 +0200
Message-ID: <20261013112921.933575481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 911655ab1dfb9d526978a75df3b210132620d30a upstream.

Commit ad96ce3252db ("swiotlb: determine potential physical address
limit") changed default_swiotlb_limit() to return the maximum physical
address that could ever be used by dynamically allocated pools, so that
the value stays constant when CONFIG_SWIOTLB_DYNAMIC=y. However,
io_tlb_default_mem.phys_limit is returned even when the default pool
cannot grow, e.g. when swiotlb_init_remap() is called with a remap
callback.

This breaks Xen dom0 on x86: pci_xen_swiotlb_init() passes SWIOTLB_ANY
and xen_swiotlb_fixup(), so phys_limit is set to the top of dom0 memory,
although xen_swiotlb_fixup() makes the default pool below the 32-bit
boundary. xen_swiotlb_dma_supported() then rejects 32-bit DMA masks,
even though the bounce buffer is perfectly usable by such devices.

Return phys_limit only if the default pool can actually grow, otherwise
report the real end of the default pool, like in the
!CONFIG_SWIOTLB_DYNAMIC case.

Reported-by: Andreas Greve <andreas.greve@a-greve.de>
Reported-by: James Dingwall <james@dingwall.me.uk>
Fixes: ad96ce3252db ("swiotlb: determine potential physical address limit")
Closes: https://lore.kernel.org/xen-devel/f74668db-52fd-4575-8372-7bfdf10d62ac@a-greve.de/
Cc: stable@vger.kernel.org
Assisted-by: Claude Opus 5.5 (1M context) <noreply@anthropic.com>
Tested-by: James Dingwall <james@dingwall.me.uk>
Link: https://lore.kernel.org/all/20261005070518.1590097-1-m.szyprowski@samsung.com/
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1677,10 +1677,10 @@ phys_addr_t default_swiotlb_base(void)
 phys_addr_t default_swiotlb_limit(void)
 {
 #ifdef CONFIG_SWIOTLB_DYNAMIC
-	return io_tlb_default_mem.phys_limit;
-#else
-	return io_tlb_default_mem.defpool.end - 1;
+	if (io_tlb_default_mem.can_grow)
+		return io_tlb_default_mem.phys_limit;
 #endif
+	return io_tlb_default_mem.defpool.end - 1;
 }
 
 #ifdef CONFIG_DEBUG_FS


