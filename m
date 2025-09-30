Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A594303CBF;
	Tue, 30 Sep 2025 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245651; cv=none; b=HQoJxGbTjHBoNPWQNzazhy+zdhmZfVi8e/C0PQ0YhTNJw309gaN88w41CI/OGEv04/yRqAH3ksHwfuK/FT3CvqDMsJZEWa6iD8r8GVj9sikRzMBgDtSgT0IP+vNsTgLAPXThCeZeBUxbwTUGw8NP7yIds7+9y6bRnOS5oRoDOEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245651; c=relaxed/simple;
	bh=de0tEuzZZRzU5Bl6B/5u/+H0ewRaNBD7L9C7dhNxVpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNI2H0NWe5nsc+vpHJdoByi25ZTBYQbNzTn3DZdMDEzPex5W2y2F3WP76BF43Igjcb6AQ7QN+SGEBmFQi8w2Z0TQXXTRmewSxEekTbPQ6UQu+f8O7BLISYg3+0Xt58zZPBs+1iRQRAKfKR7W/Q685u4kpGJSpCgJ4AxXU3ILrBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOHom88J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOHom88J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130CCC4CEF0;
	Tue, 30 Sep 2025 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245651;
	bh=de0tEuzZZRzU5Bl6B/5u/+H0ewRaNBD7L9C7dhNxVpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOHom88JvhNeToefyW034UOAJ8HXv9jtWeRCB8JWe6N31T+sGwvvSw9JHB6mpE0VR
	 4uGEaBojKbwO+MkWah8RKFFWSKsEv76qGSd1b1GYZ/1PPKtI/aK8wFALkN8AtIn1iD
	 r9opv0iSSIZiJKA46eMtOAZFeO+Z5gbM1n++/2uU=
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
Subject: [PATCH 6.6 01/91] scsi: ufs: mcq: Fix memory allocation checks for SQE and CQE
Date: Tue, 30 Sep 2025 16:47:00 +0200
Message-ID: <20250930143821.179898015@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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
index 14864cfc24223..cb8f0652a4bee 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -209,7 +209,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 		hwq->sqe_base_addr = dmam_alloc_coherent(hba->dev, utrdl_size,
 							 &hwq->sqe_dma_addr,
 							 GFP_KERNEL);
-		if (!hwq->sqe_dma_addr) {
+		if (!hwq->sqe_base_addr) {
 			dev_err(hba->dev, "SQE allocation failed\n");
 			return -ENOMEM;
 		}
@@ -218,7 +218,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
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



