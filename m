Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D3E202C48;
	Tue, 30 Sep 2025 15:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244444; cv=none; b=RbAnXQKUoxPyqlviLmLvEKp9WEjjhzXePS57I6k2jBibFs/EcpbK4bje4kayP756gG0cEo7esMOAPu9JvP3SfogHgjqmJ3Iq0N1PJK7si+IPzcaNnhXJC9B0CRwXS4ZHeVqo6s5j6phsUqVOXhgm2nAYad/9XdCllZeIOSJT+DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244444; c=relaxed/simple;
	bh=kWCiriwStSHFip6Kwz1lAkJzHKxorLkDAYr4njNRH5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgCoLnGxf35uUKUGu4i3PcEUwCm7XtcBPYHyAj1mDz4WaOlDoPtw5BOhzNg3gBnoFo7YgNVfY9zIPCHOAtY3fikzNj8m2uOD+A5pXjsrWbjY5H2xxb2U/HVSGLdicTd/3vT4GGanCdSGJyCJ5QJnum3VFyBNGL+Y+dNxGY4RoD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkALXr+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkALXr+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EE8C4CEF0;
	Tue, 30 Sep 2025 15:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244444;
	bh=kWCiriwStSHFip6Kwz1lAkJzHKxorLkDAYr4njNRH5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkALXr+6MV9TloPN2ipIKBb29aktLRoAUa7HGkwkEq8KHdPw/H+2WA3l+AwHaXW9+
	 XwHTHm+y05Fo7vaecfNl9ClkTtVwt+pwPORkqNFQvPhXTCnE2DQkSaKfeEM+K8RT0N
	 9eB/MwL7cQM6+39qBKf9dH2zAWAuTemiLX7FoXg0=
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
Subject: [PATCH 6.16 001/143] scsi: ufs: mcq: Fix memory allocation checks for SQE and CQE
Date: Tue, 30 Sep 2025 16:45:25 +0200
Message-ID: <20250930143831.299690743@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 1e50675772feb..cc88aaa106da3 100644
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



