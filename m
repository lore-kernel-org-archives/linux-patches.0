Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C1423645F;
	Mon,  2 Jun 2025 15:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877521; cv=none; b=pSc685W1kcLhs46xGkwdH8Y/Hj/1XdfNCn2OSut17WTaQte/GT1h/oxahW8JcsvKKfybFGrXHndhIDBkfPgrfSdtD/98qV6Rmgdg4yUR8hL3bOmmJf8NOtG2ADqsPOfkMkZwJrIgOsmf3bflXfo31d3nCm1Q4jsK8yDLizSzbnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877521; c=relaxed/simple;
	bh=xyb8a7VBaR+kJL69E5DxKNbWVOzbl/VPL1rvwifDYR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V26olgmavOeASMKlOivbcSmw0xDVaoLGUv3K7bivJvcBn6i1kAydlJgdTVJOFcMF3Srjg2eMOHLBKblRXzpsNGt+k919xkwceOHCd8lcPWh2b7k5HDyHdZuKyoi26D5tOrAucFVFcXafTixQY8OkLnvYqkOwpwQqzhZcnuBSLgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZdG4Idw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZdG4Idw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B479C4CEEE;
	Mon,  2 Jun 2025 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877521;
	bh=xyb8a7VBaR+kJL69E5DxKNbWVOzbl/VPL1rvwifDYR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZdG4IdwkdZnGRRn+ClrWukOsL1lbc5a1rlwh8BAC/O8oEtQLryEirqzBzeDBP/14
	 4AXgpZtsKdtfs0waksp21bi1pbObwIMJjO+j1qRSHPwbwwFMIr9oG2ieQfD9h0Q5hN
	 iMKbxebO8EkDtHIPwLfQCiQ4Lq+03M6vYpTTeFYA=
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
	Simona Vetter <simona@ffwll.ch>
Subject: [PATCH 6.1 274/325] x86/mm/init: Handle the special case of device private pages in add_pages(), to not increase max_pfn and trigger dma_addressing_limited() bounce buffers bounce buffers
Date: Mon,  2 Jun 2025 15:49:10 +0200
Message-ID: <20250602134330.898123708@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balbir Singh <balbirs@nvidia.com>

commit 7170130e4c72ce0caa0cb42a1627c635cc262821 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/init_64.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -959,9 +959,18 @@ int add_pages(int nid, unsigned long sta
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


