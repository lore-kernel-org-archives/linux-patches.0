Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DEE37A84C;
	Thu,  2 Jul 2026 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009591; cv=none; b=DbFURfgw7/K93ICYx5rX8WGArYJaQN8DQhUQJwy/oudsAFje35XyVjcRyWpVo6ChgS8R1GSwxl98/2aZseYZs5IERCkuK4+20oFwzz9yozTOGs/L7OHS/4LJI45ASWUiVjYbxjG26XUEHb2FmeE2oYITfG3CXU0CfG4Xi9mLBzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009591; c=relaxed/simple;
	bh=lduNFFY9V800NeNLy56p0rwwiXG9hRxL0sMwQzu+CeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruu1M/b+ZwV6pKKfeQJcKXHRQCeur8VpoEMkhacZmXJj/+Hkk1x3fHW9QOs3FEsxzz+m+WA2gPVTtiaREcfb6OphxTevZ35QKEzv6ZkiGFHGtan/5SHzRpvd3fFLOClvTW6ZLmWrJkaaWH2YBeKGN1xDEDarKGYGiidDfA5rkPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1jMZTu9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1jMZTu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69461F00A3A;
	Thu,  2 Jul 2026 16:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009589;
	bh=GsJp4QIweRXqok4ZwMfIrMp04CtLbS+86Ewkqi0QUDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1jMZTu9toJwXL06K2DVFjHgNa7inY3YbzmpqJGriKjotYX9e/zgWsPa6+u7Lj89w
	 Ne5DE6aICMXi0w7Ug9RrzePRCL4+XsYqU4mg1rk/Xm+AXy4pULeHyMWZJYcXrTyHVd
	 40pxCDxEw8AUjiaXDiTL61OMDv5ph90PCY56JEpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Shi <billsjc@sjtu.edu.cn>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/95] vfio/iommu_type1: replace kfree with kvfree
Date: Thu,  2 Jul 2026 18:19:16 +0200
Message-ID: <20260702155109.485592152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiacheng Shi <billsjc@sjtu.edu.cn>

[ Upstream commit 2bed2ced40c97b8540ff38df0149e8ecb2bf4c65 ]

Variables allocated by kvzalloc should not be freed by kfree.
Because they may be allocated by vmalloc.
So we replace kfree with kvfree here.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Jiacheng Shi <billsjc@sjtu.edu.cn>
Link: https://lore.kernel.org/r/20211212091600.2560-1-billsjc@sjtu.edu.cn
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 6a89bbec738f62..2bc79eee63d524 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -262,7 +262,7 @@ static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
 
 static void vfio_dma_bitmap_free(struct vfio_dma *dma)
 {
-	kfree(dma->bitmap);
+	kvfree(dma->bitmap);
 	dma->bitmap = NULL;
 }
 
-- 
2.53.0



