Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EB3136988;
	Mon, 23 Jun 2025 13:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684448; cv=none; b=re1uumHU/XcNisSsrrAL4J+vYJRowXM25Xh+XJVW5oubsIoRrOTKQRbkVeVqzXeJxm3yhSGA/36Ja/1qTdLrtVM9DwW3+OpISY4oZQfq34RgLgycDP7FFH3xR1EZPZorHENqxc+c1hoOF0RlqitCzYguGllO1He6xqle2BIjYlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684448; c=relaxed/simple;
	bh=Xx+NL1YRsldX3VOgekdgfztRDHwTSQodVUu/ts3zKzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdz6NIQhfZRfpLfBkwr5Tnrb7JgMLaSUKLGSs9cJQEi6cEHnlf58yAADzSNzXiKxHksHpSr78OEYbdS8Xkzsmp+2OASkmTaQBP4ltH2BdS2qflU1iuHpRooGh6aXAJnIZ9Xuqt72ijLAiwn7HIBqLbSDJ4Bhf5SzRdpk+1iqas4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jb4MXJTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jb4MXJTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D691C4CEEA;
	Mon, 23 Jun 2025 13:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684448;
	bh=Xx+NL1YRsldX3VOgekdgfztRDHwTSQodVUu/ts3zKzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jb4MXJTiqEHI4dXMUjhv25EhqqLOCIfxa2/E/8oo8ITeZ3nbQvO0YUfc7Rs5srIn7
	 7CjwLNtczWDCiSgxiBkytDAVCqsdQiGgVdniXCh0uC/r5jZxNAD/LK2Wpi7NWGvtOh
	 wdZRSQy4Tu05uvVqVjxV53q2Cr9yOByue1r1fFoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 071/592] media: intel/ipu6: Fix dma mask for non-secure mode
Date: Mon, 23 Jun 2025 15:00:29 +0200
Message-ID: <20250623130701.953002541@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

commit 0209916ebe2475079ce6d8dc4114afbc0ccad1c2 upstream.

We use dma_get_mask() of auxdev device for calculate iova pfn limit.
This is always 32 bit mask as we do not initialize the mask (and we can
not do so, since dev->dev_mask is NULL anyways for auxdev).

Since we need 31 bit mask for non-secure mode use mmu_info->aperture_end
which is properly initialized to correct mask for both modes.

Fixes: daabc5c64703 ("media: ipu6: not override the dma_ops of device in driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6-dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/pci/intel/ipu6/ipu6-dma.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-dma.c
@@ -172,7 +172,7 @@ void *ipu6_dma_alloc(struct ipu6_bus_dev
 	count = PHYS_PFN(size);
 
 	iova = alloc_iova(&mmu->dmap->iovad, count,
-			  PHYS_PFN(dma_get_mask(dev)), 0);
+			  PHYS_PFN(mmu->dmap->mmu_info->aperture_end), 0);
 	if (!iova)
 		goto out_kfree;
 
@@ -398,7 +398,7 @@ int ipu6_dma_map_sg(struct ipu6_bus_devi
 		nents, npages);
 
 	iova = alloc_iova(&mmu->dmap->iovad, npages,
-			  PHYS_PFN(dma_get_mask(dev)), 0);
+			  PHYS_PFN(mmu->dmap->mmu_info->aperture_end), 0);
 	if (!iova)
 		return 0;
 


