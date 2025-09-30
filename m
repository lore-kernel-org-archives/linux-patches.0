Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0317F25FA0F;
	Tue, 30 Sep 2025 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245958; cv=none; b=twGLvwRZXoGZqvDjYyVTrvm+/U7Pg5SArpk9n7CLvjif2FnHBjuo06PxlGxlD+TGvIAimEp76l5lEVp4/q9jlm2jCgZlhreF/oXIMt6Y9XvnP2/MG4yI9rJ8Mb/4PQmZZMY51kQn9ka3/nFJ//z+/cNXRzVnIJ357VsWuW8AhyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245958; c=relaxed/simple;
	bh=YJ8H54t/tqtJVyEoDJUD7NPPWjb/7759WiMs5DQv2xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CChDUmnK3k+CkIdLNMvY3dsqAI/KMmAhU4vpdSVYpzqScWQeT/we/11xa4uI28yZvNvtp7sfoBYXY9BN7kIG0QUkrjOCakMC+BmT1XTVZZ8PQAeFrNRJweu1wn23DpNJ01w0flyLV3Z91x6p+AzWUxw492U6hGqlzl/3FZrL7VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0RKrVEXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RKrVEXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4817DC4CEF0;
	Tue, 30 Sep 2025 15:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245957;
	bh=YJ8H54t/tqtJVyEoDJUD7NPPWjb/7759WiMs5DQv2xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0RKrVEXTle77EcIW4blw8J9l7+jqAq13lSUnd8EkiGP37g4Kaus3oA450pjHbAgrI
	 fDEEdp0Zv+dCJidDii3lff3q/GfSWBSAWG0RiL1wVC1j4b3+vzjq+WMdEGUnEKr7vV
	 R8r5UkpgFI8kBeXPo9PEaCZIc+zTcuJknSUVMugY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 01/89] scsi: ufs: mcq: Fix memory allocation checks for SQE and CQE
Date: Tue, 30 Sep 2025 16:47:15 +0200
Message-ID: <20250930143821.918162565@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 5cb782ff3c62c837e4984b6ae9f5d9a423cd5088 ]

Previous checks incorrectly tested the DMA addresses (dma_handle) for
NULL. Since dma_alloc_coherent() returns the CPU (virtual) address, the
NULL check should be performed on the *_base_addr pointer to correctly
detect allocation failures.

Update the checks to validate sqe_base_addr and cqe_base_addr instead of
sqe_dma_addr and cqe_dma_addr.

Fixes: 4682abfae2eb ("scsi: ufs: core: mcq: Allocate memory for MCQ mode")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 420e943bb73a7..5e6197a6af5e2 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -243,7 +243,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 		hwq->sqe_base_addr = dmam_alloc_coherent(hba->dev, utrdl_size,
 							 &hwq->sqe_dma_addr,
 							 GFP_KERNEL);
-		if (!hwq->sqe_dma_addr) {
+		if (!hwq->sqe_base_addr) {
 			dev_err(hba->dev, "SQE allocation failed\n");
 			return -ENOMEM;
 		}
@@ -252,7 +252,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 		hwq->cqe_base_addr = dmam_alloc_coherent(hba->dev, cqe_size,
 							 &hwq->cqe_dma_addr,
 							 GFP_KERNEL);
-		if (!hwq->cqe_dma_addr) {
+		if (!hwq->cqe_base_addr) {
 			dev_err(hba->dev, "CQE allocation failed\n");
 			return -ENOMEM;
 		}
-- 
2.51.0



