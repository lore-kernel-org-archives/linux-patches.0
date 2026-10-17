Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5767404E;
	Sat, 17 Oct 2026 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254777; cv=none; b=usm9nM6i94Lwm+/vBxCTC17m8Fz3c0TqAJ/OEzrXLmQM5XHNBSKBroMs8iI9L327kf+8f2fzO8xF6aKo9Prk6mwWbsvk+0n6dbcWau///pceYT4by7RmFYpj9wRH/BqNpQIY7JJ2dN16rpHSB2hGtjkgwPHaIZGYCh7oaGUYK4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254777; c=relaxed/simple;
	bh=CC8K8FBa3TlXC5N3CjK2lCfumwuCI5Inx2/EkCbSQR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIlV3ge6WFcU32l33oS/oE61v733cDSeuFrdd3j9yEmPGS1hhcvrO3bUJ0oKX/mZFoFsTO+rjDJ3yVGO+KsmAiI50N2MEwDbSCNng90LfdWMHGfs4PH6CYD/24L3IYqUNw3DIj5DsWK9vnShur4ryl13XbOIjsjr5DB4j09U23I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3Gl7br/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3Gl7br/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21141F000C4;
	Sat, 17 Oct 2026 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254776;
	bh=rnct8qn1bfvkJt0cKVWRk7ROON3irw+TQRvNNvL3BPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3Gl7br/RO201WM4aA7hosUt2v8aql0zfdp+kFnAjsQZNQDI9JBFPlxZIi/C7TIPU
	 nGTVYJPHz+7Qca5TpFFDrs/8aROx24URwrAkG3nDEsc00MVlQNfX1i+vum8VaruWCI
	 dYFw0jMzLi7A+hfLSu3laBVLzB4Hri5EZudHV0O8=
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
Subject: [PATCH 6.12 556/869] NTB: ntb_transport: Use ntb_get_dma_dev() for DMA buffers
Date: Sat, 17 Oct 2026 17:56:37 +0200
Message-ID: <20261017160051.338513937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b9e465db20159..3928bcbc830d0 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -793,13 +793,13 @@ static void ntb_transport_msi_desc_changed(void *data)
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
@@ -869,7 +869,7 @@ static int ntb_set_mw(struct ntb_transport_ctx *nt, int num_mw,
 		      resource_size_t size)
 {
 	struct ntb_transport_mw *mw = &nt->mw_vec[num_mw];
-	struct pci_dev *pdev = nt->ndev->pdev;
+	struct device *dma_dev = ntb_get_dma_dev(nt->ndev);
 	size_t xlat_size, buff_size;
 	resource_size_t xlat_align;
 	resource_size_t xlat_align_size;
@@ -898,12 +898,12 @@ static int ntb_set_mw(struct ntb_transport_ctx *nt, int num_mw,
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
@@ -916,7 +916,7 @@ static int ntb_set_mw(struct ntb_transport_ctx *nt, int num_mw,
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



