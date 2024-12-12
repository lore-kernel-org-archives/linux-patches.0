Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4E8218592;
	Thu, 12 Dec 2024 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022388; cv=none; b=K9SrZ4zNPiQBN3uKdUI2xtJYhlgduFAYYQVjb7yyzYvaBjmsOYoWdi04iSDxkzXuDbRp8BzIh/qHIBwm86UKHUPcpJ2YDg4ZfunWY9xAe/TwXNKQCz29HlsuJQYNoE+Du67qfsp/w+uY15cOpQE0slvNEyXSpwBpcdhInjcLTNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022388; c=relaxed/simple;
	bh=NIOR6pEcUwoADhr73+EBCCdFFPVyVEGkzmCxHapOjIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSa3Jj4TQuC3QtA5+t0c9QfznheroQiaqOXRqFrr2ej+7offy9MvP663nklHWOmq8a3h9xtklKUVPSnGxyh1veyGy/ESPWM/CkIR3iLhvpsxABBLTJGV/olAjowugkNTXM3UbYSk0agiSdHb9WNb3LKCbEcyWT3Zt0rfnMOAP5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOLd7F6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOLd7F6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F510C4CECE;
	Thu, 12 Dec 2024 16:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022387;
	bh=NIOR6pEcUwoADhr73+EBCCdFFPVyVEGkzmCxHapOjIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOLd7F6Abfjo7Bq4UqxcKy+nyLrGJt6U5Nkzd9/FPPGjIJcIC5/w9zIrkr1spLiHm
	 w3qtbOITcPoAP6GqQKINyQpsgOqP7IPqqg1MtICZZfSu1jHlf9TfIkwYyeYUgxCQpS
	 Z58evKr6gd0MGadL/KFFNSiqb4HyXb7gvHHF6088=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/565] scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()
Date: Thu, 12 Dec 2024 15:57:03 +0100
Message-ID: <20241212144320.499261152@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 690d3464f8766..93b55e3264866 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2739,6 +2739,7 @@ static int qedf_alloc_and_init_sb(struct qedf_ctx *qedf,
 	    sb_id, QED_SB_TYPE_STORAGE);
 
 	if (ret) {
+		dma_free_coherent(&qedf->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDF_ERR(&qedf->dbg_ctx,
 			 "Status block initialization failed (0x%x) for id = %d.\n",
 			 ret, sb_id);
-- 
2.43.0



