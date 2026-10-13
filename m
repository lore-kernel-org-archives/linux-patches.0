Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1F74F4736;
	Tue, 13 Oct 2026 12:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895866; cv=none; b=ZgDn7LYqSj8HgX3h27Y81OQx7cK672Wqffqfo96f3S35ZqyyXhRaajxFqng+9tlRdXa6Dp7tIUMODtcGW1X59XDnSFsa4KMsVQusUbHwweLTCQODontaZRl/TzrFFwHg4D9qu/E2YpydCxn9wgqrpNKA7eGT5zIh4zOQif+5XTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895866; c=relaxed/simple;
	bh=YslqZXKr9/ZlS9pL1+8u4IQbzMEu7d/2kxMe9xF2xrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxFlRvNUZTdDoBus4frmm8erfP8DeG+Ho3gDo63DCggl41/zQBDDq4ZrKXDAvkPYn9HBT17XgUCPd9G63Wys0ARroAkegP0D9r1hXwaMEQzNp+XAGG2Aw4cbkR34RoyE2wyjrsFGxHTJwqwW2O3+fYMEjJXkfjNGFiD7ePKbM8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PST/mfnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PST/mfnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F202C1F000FF;
	Tue, 13 Oct 2026 12:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895865;
	bh=yPG5/3C3wIMdemmqtXga3iZdkTgorx8sR6Lef5t2gUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PST/mfnPIJ3bSkf6ugNmpJIsBqDY4PBCx8iD4P/yZFEJHPYMWs9hdk68Sn/mk8uvp
	 M3Ezrm3FymZwSdLlMFL11/vvgnecCzlXs5gGVsaYqbfak+0RX2MWaf1Li76t/1KNdY
	 dAHX84i5GlgxT1qjskHHcMFIVm6nn8kvBVCdclFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Greve <andreas.greve@a-greve.de>,
	James Dingwall <james@dingwall.me.uk>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Claude Opus 5.5 (1M context)" <noreply@anthropic.com>
Subject: [PATCH 6.12 375/497] swiotlb: fix default_swiotlb_limit() for non-growable default pool
Date: Tue, 13 Oct 2026 13:39:02 +0200
Message-ID: <20261013112916.799891438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


