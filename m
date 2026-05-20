Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA8030567F;
	Wed, 20 May 2026 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295522; cv=none; b=GRV+kA2sdsE5/A1xbhsrz4SDAHUt+nB8fTedxvuH0lO0komqkLGlg+xdev3sGCGjm2gB7ksHVlO8XcxgT1Vpl2uogvHx6cmxHR8rmzCoWkqNJtjvdl12lHAA+tS63dUmoMWMb5boDn5xFQN20gSNFeoDQtVZzH/Oq5lJ6R9J4Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295522; c=relaxed/simple;
	bh=0erGHXYNKhQg98VrRFdnCrNJKt4Xi4BktqnsIbAhNg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eO6jwUY5J8AXt6x+21y7GnxKsdOlSL9lvwqzIlyGQF3r1TChNNUNtiag8h9r/bOspCaMQdAUnRIhq3fNgwgaUuMZ395vQVf81B4b1g6ttq65z7APzSADQ1mSa8d03Nbg7rlF9WcacfPdVkmcRzqp+2ovyqHq+AHh/XtWBxW3fRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIlDtzj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIlDtzj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED46C1F000E9;
	Wed, 20 May 2026 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295521;
	bh=VqtYGTv5AjPKb2h2EPjKXQG7tRJdnB537DUGOyq4eRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIlDtzj+dwqbXSIgBY+4+IzQy57uDI12Z32PHWToLkarLivoPS31q077bjWYPJH7p
	 BkdOKPmLueYAC/C9BFdqUDH5gRgO8pJPfN6cMFYYXSdpRH1TtcbMUQlq0jOA1C4gmU
	 +vfuwdwLHhBr2P2b0kgFAZ3u8ysbr7pNu3EW64JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Mastro <amastro@fb.com>,
	David Matlack <dmatlack@google.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0451/1146] vfio: selftests: fix crash in vfio_dma_mapping_mmio_test
Date: Wed, 20 May 2026 18:11:41 +0200
Message-ID: <20260520162158.404873972@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Mastro <amastro@fb.com>

[ Upstream commit f183963891b4b0126f19aa0993ed931f3f3f9520 ]

Remove the __iommu_unmap() call on a region that was never mapped.
When __iommu_map() fails (expected for MMIO vaddrs in non-VFIO
modes), the region is not added to the dma_regions list, leaving its
list_head zero-initialized. If the unmap ioctl returns success,
__iommu_unmap() calls list_del_init() on this zeroed node and crashes.

This fixes the iommufd_compat_type1 and iommufd_compat_type1v2
test variants.

Fixes: 080723f4d4c3 ("vfio: selftests: Add vfio_dma_mapping_mmio_test")
Signed-off-by: Alex Mastro <amastro@fb.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Link: https://lore.kernel.org/r/20260303-fix-mmio-test-v1-1-78b4a9e46a4e@fb.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
index 957a89ce7b3a0..d7f25ef776715 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
@@ -100,7 +100,6 @@ static void do_mmio_map_test(struct iommu *iommu,
 		iommu_unmap(iommu, &region);
 	} else {
 		VFIO_ASSERT_NE(__iommu_map(iommu, &region), 0);
-		VFIO_ASSERT_NE(__iommu_unmap(iommu, &region, NULL), 0);
 	}
 }
 
-- 
2.53.0



