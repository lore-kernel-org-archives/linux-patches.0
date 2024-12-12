Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4358A20A5EE;
	Thu, 12 Dec 2024 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025232; cv=none; b=ZCmAiDqegwd0Yvefccs5kJ4z5p5pwBUJgabn9NcXLNJkSGnoh5h4wZopzPg7fn4ZBzZygH+OolsdNX/TY83dBlsnwUKvnBfJQSs7XGAl+EtbNVhuzNN+6MEKL3NzD/0vrdf7Mw3KzHHHhlbsBmueomCzzmU15aXlKZTs0/94JD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025232; c=relaxed/simple;
	bh=4As/Dmpa9sBNQpTnQraNaytGtC13vDgx2diHbaPtPkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLEsLECBqVRex3bafxa0nOAiPOKWe6TkyopSoQkjbT0012odNXc2MwUWH/U9aH0lLPw0sZcBNXwoKQs8Mip7/FhMc0W7jqhyb9VjchfT6Rt7kuO1+PrY2lTzuDvrxExhlbQRfOLuMkjiWmGw7/+3BJikETanGoYIF43gYJwHCFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNPCY/94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNPCY/94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD118C4CECE;
	Thu, 12 Dec 2024 17:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025232;
	bh=4As/Dmpa9sBNQpTnQraNaytGtC13vDgx2diHbaPtPkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNPCY/94RXSVfXPBS0EDey/8jJPJAIKNSI5eax4CGvsZp/hZPbtlHDwFY3rTQpywl
	 5LJRO3sWX2fGgTTCgE9XJ0O6KHBbP8e7XVksLBO6L+ZZWnTi8w7H/0M5iaz8J3/jvB
	 rEBq7QT7Uxsh75Nv3gUN+eiQ02x3ChGX3Z2ZvyZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/321] scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()
Date: Thu, 12 Dec 2024 16:00:18 +0100
Message-ID: <20241212144233.941467232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit c62c30429db3eb4ced35c7fcf6f04a61ce3a01bb ]

Hook "qed_ops->common->sb_init = qed_sb_init" does not release the DMA
memory sb_virt when it fails. Add dma_free_coherent() to free it. This
is the same way as qedr_alloc_mem_sb() and qede_alloc_mem_sb().

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20241026125711.484-2-thunder.leizhen@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index e0601b5520b78..3f137ca650388 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2596,6 +2596,7 @@ static int qedf_alloc_and_init_sb(struct qedf_ctx *qedf,
 	    sb_id, QED_SB_TYPE_STORAGE);
 
 	if (ret) {
+		dma_free_coherent(&qedf->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDF_ERR(&qedf->dbg_ctx,
 			 "Status block initialization failed (0x%x) for id = %d.\n",
 			 ret, sb_id);
-- 
2.43.0



