Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9535914A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB70C433C8;
	Thu, 24 Aug 2023 17:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897377;
	bh=K7HnzxQeUq/q3pA0ZWLvkA8K+JKKPcn+weo7L1qBoTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDk7OkyjxslLTH0VikbLA5vgJgcl8+kBBMyvZ/wwr+oqqW0I9AOaVA563iHUZmpmA
	 XWKhlh3J7bVSDsD3BInCfCE5MNoEGA9Non6JRHGVDx6Hqmgx8gPY1pbeFOVZXSwdVZ
	 znegf3J/JGUF1/9XDZsxeiOUmqqe3HFNMGqfImPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xu <gaoxu2@hihonor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/135] dma-remap: use kvmalloc_array/kvfree for larger dma memory remap
Date: Thu, 24 Aug 2023 19:08:09 +0200
Message-ID: <20230824170617.879970419@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gaoxu <gaoxu2@hihonor.com>

[ Upstream commit 51ff97d54f02b4444dfc42e380ac4c058e12d5dd ]

If dma_direct_alloc() alloc memory in size of 64MB, the inner function
dma_common_contiguous_remap() will allocate 128KB memory by invoking
the function kmalloc_array(). and the kmalloc_array seems to fail to try to
allocate 128KB mem.

Call trace:
[14977.928623] qcrosvm: page allocation failure: order:5, mode:0x40cc0
[14977.928638] dump_backtrace.cfi_jt+0x0/0x8
[14977.928647] dump_stack_lvl+0x80/0xb8
[14977.928652] warn_alloc+0x164/0x200
[14977.928657] __alloc_pages_slowpath+0x9f0/0xb4c
[14977.928660] __alloc_pages+0x21c/0x39c
[14977.928662] kmalloc_order+0x48/0x108
[14977.928666] kmalloc_order_trace+0x34/0x154
[14977.928668] __kmalloc+0x548/0x7e4
[14977.928673] dma_direct_alloc+0x11c/0x4f8
[14977.928678] dma_alloc_attrs+0xf4/0x138
[14977.928680] gh_vm_ioctl_set_fw_name+0x3c4/0x610 [gunyah]
[14977.928698] gh_vm_ioctl+0x90/0x14c [gunyah]
[14977.928705] __arm64_sys_ioctl+0x184/0x210

work around by doing kvmalloc_array instead.

Signed-off-by: Gao Xu <gaoxu2@hihonor.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/remap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index 905c3fa005f10..5bff061993102 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -43,13 +43,13 @@ void *dma_common_contiguous_remap(struct page *page, size_t size,
 	void *vaddr;
 	int i;
 
-	pages = kmalloc_array(count, sizeof(struct page *), GFP_KERNEL);
+	pages = kvmalloc_array(count, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		return NULL;
 	for (i = 0; i < count; i++)
 		pages[i] = nth_page(page, i);
 	vaddr = vmap(pages, count, VM_DMA_COHERENT, prot);
-	kfree(pages);
+	kvfree(pages);
 
 	return vaddr;
 }
-- 
2.40.1



