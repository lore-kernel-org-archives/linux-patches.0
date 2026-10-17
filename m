Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DD438F950;
	Sat, 17 Oct 2026 17:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259546; cv=none; b=pJJSCtTvfx6Fo6LKBxcaeFiEgRPEP3alBdDK4dKPbZ+PAdohn7WN3yOnIGRyBjf4u3Oq0ios1MJ5NA2GiSyoei0UJHk8/j0/Cxd+Ot/tXaGLYVt3k8w5xRIqlU+mjNU3tyLhpA4c9E59Bh8y/QerCAvhYucAnH/b7JPJn6UjaPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259546; c=relaxed/simple;
	bh=n1fZg0TmH4x3kYz1On6e2JJh+DcG68jxbMEhCyTfbpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VB799VPqbyJYxeZVIR0/aTxRF3/+DITsF0lGnGVHi4YcDaYvho9jzcZ3IItdLK+oPppLbmmfS26dskPVLT7FkA7rRT+GS9genJKLNoOpQnRVOWSvBtOkrH2V8CDykmzLfU5Spb3WiTCfM6fWfledoqLsTbo18Rg5U/gNCsrqgtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsGRNaf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsGRNaf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F6E1F000C4;
	Sat, 17 Oct 2026 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259545;
	bh=O441+QfxldUGhN7ejQ3yoneBkOvAAUYXI8lSgMYATAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsGRNaf9U0rXHbRtzOUC3Zoff/r8Vt3Wc2rwieSt4pgfZlckTBcK8nHs1uVIZ1Gpk
	 ejY0Dp+EH0EDI9Ag98+otKEW6ZMUxOdu1dshdJwpJzCB6YxErzjAnjllC3X6GanJcB
	 jPElSQOh0+v+8jxxpDMpO2PNmEewKhm+IEACZRC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1251/1674] NTB: ntb_transport: Use ntb_get_dma_dev() for DMA buffers
Date: Sat, 17 Oct 2026 17:58:43 +0200
Message-ID: <20261017160503.249590042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 852b94ff92cbe26a0dbb15eed9474f5493767f3b ]

ntb_transport currently uses ndev->pdev->dev for coherent allocations
and frees.

Switch the coherent buffer allocation/free paths to use
ntb_get_dma_dev(), so ntb_transport can work with NTB implementations
where the NTB PCI function is not the right device to use for DMA
mappings.

Suggested-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260306031443.1911860-3-den@valinux.co.jp
Stable-dep-of: da6d997ac556 ("ntb: Store original DMA address for future release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/ntb_transport.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 43785f02f310d..afefbe557f727 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -791,13 +791,13 @@ static void ntb_transport_msi_desc_changed(void *data)
 static void ntb_free_mw(struct ntb_transport_ctx *nt, int num_mw)
 {
 	struct ntb_transport_mw *mw = &nt->mw_vec[num_mw];
-	struct pci_dev *pdev = nt->ndev->pdev;
+	struct device *dma_dev = ntb_get_dma_dev(nt->ndev);
 
 	if (!mw->virt_addr)
 		return;
 
 	ntb_mw_clear_trans(nt->ndev, PIDX, num_mw);
-	dma_free_coherent(&pdev->dev, mw->alloc_size,
+	dma_free_coherent(dma_dev, mw->alloc_size,
 			  mw->alloc_addr, mw->dma_addr);
 	mw->xlat_size = 0;
 	mw->buff_size = 0;
@@ -867,7 +867,7 @@ static int ntb_set_mw(struct ntb_transport_ctx *nt, int num_mw,
 		      resource_size_t size)
 {
 	struct ntb_transport_mw *mw = &nt->mw_vec[num_mw];
-	struct pci_dev *pdev = nt->ndev->pdev;
+	struct device *dma_dev = ntb_get_dma_dev(nt->ndev);
 	size_t xlat_size, buff_size;
 	resource_size_t xlat_align;
 	resource_size_t xlat_align_size;
@@ -896,12 +896,12 @@ static int ntb_set_mw(struct ntb_transport_ctx *nt, int num_mw,
 	mw->buff_size = buff_size;
 	mw->alloc_size = buff_size;
 
-	rc = ntb_alloc_mw_buffer(mw, &pdev->dev, xlat_align);
+	rc = ntb_alloc_mw_buffer(mw, dma_dev, xlat_align);
 	if (rc) {
 		mw->alloc_size *= 2;
-		rc = ntb_alloc_mw_buffer(mw, &pdev->dev, xlat_align);
+		rc = ntb_alloc_mw_buffer(mw, dma_dev, xlat_align);
 		if (rc) {
-			dev_err(&pdev->dev,
+			dev_err(dma_dev,
 				"Unable to alloc aligned MW buff\n");
 			mw->xlat_size = 0;
 			mw->buff_size = 0;
@@ -914,7 +914,7 @@ static int ntb_set_mw(struct ntb_transport_ctx *nt, int num_mw,
 	rc = ntb_mw_set_trans(nt->ndev, PIDX, num_mw, mw->dma_addr,
 			      mw->xlat_size);
 	if (rc) {
-		dev_err(&pdev->dev, "Unable to set mw%d translation", num_mw);
+		dev_err(dma_dev, "Unable to set mw%d translation", num_mw);
 		ntb_free_mw(nt, num_mw);
 		return -EIO;
 	}
-- 
2.53.0



