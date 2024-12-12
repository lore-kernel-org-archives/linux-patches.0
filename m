Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2435216E2D;
	Thu, 12 Dec 2024 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024082; cv=none; b=DZ+Q/prIMnKSStkkpj+54rn4jpxJLVDkr+EizkbeJX09j8xZ64VwJpRnPAyoi+oDEqhRgI+SF10ip796+5GTF6tz6vCQ7H6UI0UfNnc/CWcq/bZ59ujT+s5aG4kyDx6mY3bX6Ptxb/EpgPgDGBuioYxC+kO2YoRh/5YKtl2OG08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024082; c=relaxed/simple;
	bh=SWpvaHfx0npzIOs9QZM8dshFOb5pM0Y76bM+6ieXT10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0Yu0ME/XbSMFPL5SWF2a0b2r2ch+Cw4kuBc+RK62T9vH/Gxv369PIP/VtvTjpR1qHCewvgaVf0R5VD2xefB6hvBPxsGH6oBBEQh/WdDWV2NJDdE7b82Sv3siN6untkpxIJguwSiNuo1AoX5Xw0rB/qGUZ7UmLNBKKOshnmM8Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bd+UCc2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bd+UCc2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F588C4CECE;
	Thu, 12 Dec 2024 17:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024081;
	bh=SWpvaHfx0npzIOs9QZM8dshFOb5pM0Y76bM+6ieXT10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bd+UCc2+1iEXl7x6dPABh4dA0zyIp/XHPdfZCFkrCj1/DX60uhehltV5In7IFmy7W
	 gBUfrWYEUWcode77u/00iCzDW4X2bOwbTlIM2zPDfuPc0CO8X6SOs2uOJYb4VPiR4a
	 IpE/do9lGlx6dfpJ/12gaVTSOT9Rv7O5dLWzU5eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/459] scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
Date: Thu, 12 Dec 2024 15:58:37 +0100
Message-ID: <20241212144300.617223124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 95bbdca4999bc59a72ebab01663d421d6ce5775d ]

Hook "qedi_ops->common->sb_init = qed_sb_init" does not release the DMA
memory sb_virt when it fails. Add dma_free_coherent() to free it. This
is the same way as qedr_alloc_mem_sb() and qede_alloc_mem_sb().

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20241026125711.484-3-thunder.leizhen@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 96e470746767a..3bf75d466b2c6 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -371,6 +371,7 @@ static int qedi_alloc_and_init_sb(struct qedi_ctx *qedi,
 	ret = qedi_ops->common->sb_init(qedi->cdev, sb_info, sb_virt, sb_phys,
 				       sb_id, QED_SB_TYPE_STORAGE);
 	if (ret) {
+		dma_free_coherent(&qedi->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Status block initialization failed for id = %d.\n",
 			  sb_id);
-- 
2.43.0



