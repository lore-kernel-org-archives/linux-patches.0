Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7937223A9BE;
	Mon, 23 Jun 2025 13:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685067; cv=none; b=csq9HRoM0xGjFI2jZ7NMMe0UAHhdPaoOujGJEMxE7t8p0W26xhS/w/7s6H6MwqZx0gMBX/FnKh4hMqxPtpuwws6b3qdphwbcqyhTOOwaDAIV+2KiJFbkGaP5ghQOxGJ6p8eiE67oG8wX4lapQQv3q6xswxVMjJbRwg67zDJgryQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685067; c=relaxed/simple;
	bh=oDPwD4ksy8BnKD+LRq6e3+yzgHHVckeq8oKMtC1y0cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4hgEyLTWQS6Gy8LkUXnSA/6DMrldNS1l3/qGd8OYI75zippMajxQhHef/XMOh89QNhLh78BZ959nRq2T54z5h0V9bk34958f5s6EYjEtl1dVkHMDZ3AbCU1nz8iYtEW38qqPzEI0Chem0V662ALp7m5HoHkcy5kprn2JQNPZTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mFReaP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mFReaP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC44C4CEEA;
	Mon, 23 Jun 2025 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685067;
	bh=oDPwD4ksy8BnKD+LRq6e3+yzgHHVckeq8oKMtC1y0cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mFReaP+woGcx+JTsdIUBoYaBUctiGwCDUKzukM1MfQssJSr5wfWrQNDP8xRTxkoO
	 070hkF/OWLoJEHLo3hvU5t8Q0yT4EerceVBIVsGM4e6TcUskVr+yUv8zLVM2yOkihW
	 wt6x+4lx6EFUWuf10AhPVnGwyzGFNH/STU544Ct4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/355] vfio/type1: Fix error unwind in migration dirty bitmap allocation
Date: Mon, 23 Jun 2025 15:04:12 +0200
Message-ID: <20250623130628.364618061@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 4518e5a60c7fbf0cdff393c2681db39d77b4f87e ]

When setting up dirty page tracking at the vfio IOMMU backend for
device migration, if an error is encountered allocating a tracking
bitmap, the unwind loop fails to free previously allocated tracking
bitmaps.  This occurs because the wrong loop index is used to
generate the tracking object.  This results in unintended memory
usage for the life of the current DMA mappings where bitmaps were
successfully allocated.

Use the correct loop index to derive the tracking object for
freeing during unwind.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://lore.kernel.org/r/20250521034647.2877-1-lirongqing@baidu.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9b01f88ae4762..b2a543e7cac45 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -269,7 +269,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
 			struct rb_node *p;
 
 			for (p = rb_prev(n); p; p = rb_prev(p)) {
-				struct vfio_dma *dma = rb_entry(n,
+				struct vfio_dma *dma = rb_entry(p,
 							struct vfio_dma, node);
 
 				vfio_dma_bitmap_free(dma);
-- 
2.39.5



