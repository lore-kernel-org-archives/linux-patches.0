Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0D927FB10;
	Tue, 27 May 2025 17:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368226; cv=none; b=MUHZahMqnO3pXhy8PpQfkUBRdyOTopCMCQkYuwA0lQiilFaspjTq1XwjdrrrRddGL2ECVHL/BdCc3hItZyTyF8/yzzs2F1uRT44Mgo0JFDyfDE0ZhCp4Y6NC9TjcgyBZtMYKdqyYtdhj03VfOGHVl4gBmxUPoJK4LRcEgBXglyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368226; c=relaxed/simple;
	bh=cM8+DCRF+EwoH5i/l/FDiFxx6YFC95TfM4/Nzwpzejo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TawhzhDrT1pbi7X8ktlaMbHdw5ImWUcBXTHe0G3vSk3/agejWBepTVZXoERzZz6KSEO0hmA2SnyO9rlavytI48Ee9FMUzyouFTH+o0L0QD6EcVRR8Cvi5kS/AMW/94D1JoU/FrXxVoRx2guJrxyN7SRJtiLocjv+fA4P7pOsFwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/IrBVBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/IrBVBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA312C4CEE9;
	Tue, 27 May 2025 17:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368225;
	bh=cM8+DCRF+EwoH5i/l/FDiFxx6YFC95TfM4/Nzwpzejo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/IrBVBhtDBNwIygVqkTv+d+VzJh9EOplCN0lzOeeHpYpsaeaZrA7PLhxRlWh0GPR
	 WoT8xzM2miUFIEBYf0MHKUrkS7AxxdygIQzYLacPw7PHZXLbKbEnbtRrVdvML6OghX
	 8eGJCfVuPXjZXFif342Zt1tj8jOEcYw4rjowlVKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Balbir Singh <balbirs@nvidia.com>,
	Ingo Molnar <mingo@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 637/783] x86/mm/init: Handle the special case of device private pages in add_pages(), to not increase max_pfn and trigger dma_addressing_limited() bounce buffers
Date: Tue, 27 May 2025 18:27:14 +0200
Message-ID: <20250527162539.086305403@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balbir Singh <balbirs@nvidia.com>

[ Upstream commit 7170130e4c72ce0caa0cb42a1627c635cc262821 ]

As Bert Karwatzki reported, the following recent commit causes a
performance regression on AMD iGPU and dGPU systems:

  7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")

It exposed a bug with nokaslr and zone device interaction.

The root cause of the bug is that, the GPU driver registers a zone
device private memory region. When KASLR is disabled or the above commit
is applied, the direct_map_physmem_end is set to much higher than 10 TiB
typically to the 64TiB address. When zone device private memory is added
to the system via add_pages(), it bumps up the max_pfn to the same
value. This causes dma_addressing_limited() to return true, since the
device cannot address memory all the way up to max_pfn.

This caused a regression for games played on the iGPU, as it resulted in
the DMA32 zone being used for GPU allocations.

Fix this by not bumping up max_pfn on x86 systems, when pgmap is passed
into add_pages(). The presence of pgmap is used to determine if device
private memory is being added via add_pages().

More details:

devm_request_mem_region() and request_free_mem_region() request for
device private memory. iomem_resource is passed as the base resource
with start and end parameters. iomem_resource's end depends on several
factors, including the platform and virtualization. On x86 for example
on bare metal, this value is set to boot_cpu_data.x86_phys_bits.
boot_cpu_data.x86_phys_bits can change depending on support for MKTME.
By default it is set to the same as log2(direct_map_physmem_end) which
is 46 to 52 bits depending on the number of levels in the page table.
The allocation routines used iomem_resource's end and
direct_map_physmem_end to figure out where to allocate the region.

[ arch/powerpc is also impacted by this problem, but this patch does not fix
  the issue for PowerPC. ]

Testing:

 1. Tested on a virtual machine with test_hmm for zone device inseration

 2. A previous version of this patch was tested by Bert, please see:
    https://lore.kernel.org/lkml/d87680bab997fdc9fb4e638983132af235d9a03a.camel@web.de/

[ mingo: Clarified the comments and the changelog. ]

Reported-by: Bert Karwatzki <spasswolf@web.de>
Tested-by: Bert Karwatzki <spasswolf@web.de>
Fixes: 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Link: https://lore.kernel.org/r/20250401000752.249348-1-balbirs@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/init_64.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 01ea7c6df3036..17c89dad4f7ff 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -967,9 +967,18 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
 	ret = __add_pages(nid, start_pfn, nr_pages, params);
 	WARN_ON_ONCE(ret);
 
-	/* update max_pfn, max_low_pfn and high_memory */
-	update_end_of_memory_vars(start_pfn << PAGE_SHIFT,
-				  nr_pages << PAGE_SHIFT);
+	/*
+	 * Special case: add_pages() is called by memremap_pages() for adding device
+	 * private pages. Do not bump up max_pfn in the device private path,
+	 * because max_pfn changes affect dma_addressing_limited().
+	 *
+	 * dma_addressing_limited() returning true when max_pfn is the device's
+	 * addressable memory can force device drivers to use bounce buffers
+	 * and impact their performance negatively:
+	 */
+	if (!params->pgmap)
+		/* update max_pfn, max_low_pfn and high_memory */
+		update_end_of_memory_vars(start_pfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
 
 	return ret;
 }
-- 
2.39.5



