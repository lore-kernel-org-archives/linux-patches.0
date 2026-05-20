Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868693F23BF;
	Wed, 20 May 2026 17:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296577; cv=none; b=rUCOqPEloQ0Je3ZlOlXBREa5aYj7lujjU8OVHegZppOGSTRrJwgBnv5x+JlC64Yba7UzoF6tQLIcoNvTAwYA/T8pMIQtddKi9l0vzB+SmbOP94M7X38FQuCxCyQVb2pZqNtPeNXzWSR4M0VkPlStMRBPoDdj0NAyUKFzwKzapj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296577; c=relaxed/simple;
	bh=a8S7sE0bP8n1TbrPfH6QY2kH7AzavAy7FIHtVLd4eSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeDp+bPmEFnV8ghwaWP56aYY3kx1Ur0OkMOHcNb/LYs+b2j3/e7xLaQJNnwQ2jY0049dDVal/Ax2Np2SCqrYr5nek0kTx46Psu2tYVG0FZ7cX6mJWFvSmBVUcoWvbzDIm5aLIw3WnicbGNF3kswJkMMVdy5YYd2pOc63+V7xXlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dHx6Xk1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dHx6Xk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4461F00893;
	Wed, 20 May 2026 17:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296575;
	bh=Ue7GHfyNDnFmxPvueT0po7z5oGlT1TypUDkAoa56oLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dHx6Xk1zriQDWrX8QU9qErsG2V2VEP84Oh5UgWTZ5D+jYpRoh1UvyYwyuGi2OlAn
	 1Tdf27ZyLG0jrpkK2XRYbn358dvbTEzeA4cvNpE2aJnGWoySWAoOppl8S5i3O2pJsM
	 MBfktTqp9CBBRjuNfr+BAvyKFKTJhszWx0WigErQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Evans <mattev@meta.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0824/1146] vfio/pci: Clean up DMABUFs before disabling function
Date: Wed, 20 May 2026 18:17:54 +0200
Message-ID: <20260520162206.879155455@linuxfoundation.org>
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

From: Matt Evans <mattev@meta.com>

[ Upstream commit d97708701434ce72968e771976aaf9d3438fcafd ]

On device shutdown, make vfio_pci_core_close_device() call
vfio_pci_dma_buf_cleanup() before the function is disabled via
vfio_pci_core_disable().  This ensures that all access via DMABUFs is
revoked before the function's BARs become inaccessible.

This fixes an issue where, if the function is disabled first, a tiny
window exists in which the function's MSE is cleared and yet BARs
could still be accessed via the DMABUF.  The resources would also be
freed and up for grabs by a different driver.

Fixes: 5d74781ebc86c ("vfio/pci: Add dma-buf export support for MMIO regions")
Signed-off-by: Matt Evans <mattev@meta.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20260415181752.1027604-1-mattev@meta.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 3fea064d00de2..e34c7e1ba1c81 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -734,10 +734,10 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 #if IS_ENABLED(CONFIG_EEH)
 	eeh_dev_release(vdev->pdev);
 #endif
-	vfio_pci_core_disable(vdev);
-
 	vfio_pci_dma_buf_cleanup(vdev);
 
+	vfio_pci_core_disable(vdev);
+
 	mutex_lock(&vdev->igate);
 	vfio_pci_eventfd_replace_locked(vdev, &vdev->err_trigger, NULL);
 	vfio_pci_eventfd_replace_locked(vdev, &vdev->req_trigger, NULL);
-- 
2.53.0



