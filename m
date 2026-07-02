Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A796344D9D;
	Thu,  2 Jul 2026 16:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009361; cv=none; b=pCuxGgsDefrVQd2fq4O+fx2UuqMoqWlLNSP2Ll8edAybFPa6Fkh1uF6ghJ6qfae/x/6VsumSorZJka+vJTwiYVUwkD1PLcU0rPGfj6Vvwf0dzU5bXYVt0EhTBgvDh/wLGUGboBekR3RHtWbsJgyG74bQNI4j4p/3WKs8xN6to5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009361; c=relaxed/simple;
	bh=glIbvB8P5WSN+mqjCPwTqKQlyyPVlx6HC0lIkqm2Xag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/vsjlnj8NUUwzRanXVvsjVDiL7urSMDnvAQaxYE/6xJi9DhvrFXy/U+qgumXRf0L08D8tNfHEv+fcZYMAF9DoIl87hX2V5FXhhSSSC7B2i/dxOc0HMZ21I62PMcU00i9Ib5+GHjX8y5/lXZNX/JmzBlwgRHAkWbIjOnyYt80UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYCpMabk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYCpMabk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59C21F00A3E;
	Thu,  2 Jul 2026 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009358;
	bh=fDragNolE6hm6sPOJUElPn/hsxQZxMgJuQKIzmB3ij8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYCpMabkJoNBJb7kYtvhCe3R04Rl2NZRBEiosCfEuz/2v7RwChWkT7Wb7BbbBDueO
	 OsggiOWAuc5yznw4+V+CwMyje9zO1yS+OVofV1ERjFe5BZn79HzdqI8cJPlumqSjhR
	 dHkY58JcK09+6VoxTgxJd/LtVG4IWOccme9c6ybg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Shi <billsjc@sjtu.edu.cn>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/96] vfio/iommu_type1: replace kfree with kvfree
Date: Thu,  2 Jul 2026 18:19:13 +0200
Message-ID: <20260702155109.431158602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b2a543e7cac454..eee8d2ab03d683 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -228,7 +228,7 @@ static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
 
 static void vfio_dma_bitmap_free(struct vfio_dma *dma)
 {
-	kfree(dma->bitmap);
+	kvfree(dma->bitmap);
 	dma->bitmap = NULL;
 }
 
-- 
2.53.0



