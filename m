Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529C52F691F;
	Thu, 28 May 2026 20:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998868; cv=none; b=axwBIP6mypPxtFxryLrytCnH8tzSI85ZLm8DOwdRo+crM77adhC/DFMI5ldj4pRTJoO3FENHO22mRImE8KurTswCWLhPbGLLV79RT2lrBIMWbU5rRFmNQvtRFZbn4DzUoqTVpEbpDl4+QDl9tgxtwOvPEUqEVRlkkufrrq1xPqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998868; c=relaxed/simple;
	bh=X0CECoGtcAUEQj7SPkdqTQV5z7nY8FBh5Lu+iWuRnfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWdjsMmgBwRRQNabk4KybLaDrjo9uciAnB+RPdy+40DaRiV3poiHatDMDmwGO+7KBSeAQ62jXFS0CLEmF2PgYSTO4U5zWJzQVvezICXCgMOyt6M8JhZ8bu0FLwDfPJFRk0VT9hSM4tx/dTpL3osTQiXZTsrA5/5Vu+tiFjnF/dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vthTvg2Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vthTvg2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE90E1F000E9;
	Thu, 28 May 2026 20:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998867;
	bh=soc7RQZRCO8uvdrCwM/FoRsIHGMrOuBsl73UC7cItq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vthTvg2YkNENBLcxiYTY7TiBJWq1lQiXrUYRLOF6gHjBzZjj68uzYpImlsja585jT
	 EegUK09bXRe3FaQreOhDKjNcDOACpMcjqp2ImFusXrSmKPB8hkIL93ASw/SCrbt0Do
	 5Kj41x1lA3P4KRp4XXGS7REdX0BlQ1QXCGVPrpgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Evans <mattev@meta.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 327/461] vfio/pci: Check BAR resources before exporting a DMABUF
Date: Thu, 28 May 2026 21:47:36 +0200
Message-ID: <20260528194656.813361603@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

[ Upstream commit 702809dabdecca807bdd50cfdcc1c980feb2ba62 ]

A DMABUF exports access to BAR resources and, although they are
requested at startup time, we need to ensure they really were reserved
before exporting.  Otherwise, it's possible to access unreserved
resources through the export.

Add a check to the DMABUF-creation path.

Fixes: 5d74781ebc86c ("vfio/pci: Add dma-buf export support for MMIO regions")
Signed-off-by: Matt Evans <mattev@meta.com>
Link: https://lore.kernel.org/r/20260511145829.2993601-3-mattev@meta.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index b1d658b8f7b51..05385b63e2baf 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -232,9 +232,11 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
 		return -EINVAL;
 
 	/*
-	 * For PCI the region_index is the BAR number like everything else.
+	 * For PCI the region_index is the BAR number like everything
+	 * else.  Check that PCI resources have been claimed for it.
 	 */
-	if (get_dma_buf.region_index >= VFIO_PCI_ROM_REGION_INDEX)
+	if (get_dma_buf.region_index >= VFIO_PCI_ROM_REGION_INDEX ||
+	    vfio_pci_core_setup_barmap(vdev, get_dma_buf.region_index))
 		return -ENODEV;
 
 	dma_ranges = memdup_array_user(&arg->dma_ranges, get_dma_buf.nr_ranges,
-- 
2.53.0



