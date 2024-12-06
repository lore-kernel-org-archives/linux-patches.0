Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70E51474AF;
	Fri,  6 Dec 2024 15:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497480; cv=none; b=dfNefLaeo8/+YjOeNwXRb+QbDEjqDgX/hL0MMvFWEMXZ3VKLKSq3b5kOP3BMXoKGfLNWX99mRiIEizzODOGdJ9asxPNQy7XhZjnu1Rpbq2vxOJyRyOlJLjHhQj4ts/MJVBb6nk4C8KowhCEzx+MkJAbxM7hMYQxurul7pTrTCEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497480; c=relaxed/simple;
	bh=DvldD9tZBbV0G9kyJUa7iqWZNOvtWb14srRFPZUu2P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swALkpfdApsunqtkZhJOAzkcP8XiQyAlSPEltddOum8hm5bw9Ke6VOqvYtlOoHrKQ2Ju33zP5xmxXXgbD7qxSEVMdIHv5uGBOWi9EpD3JWgcgk9AZ7HGjFGW3e8yslMPHkS3BukkhizHqDJX3qYkIspx2QyhxpUFrzOOxIFOdeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNXbeMTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNXbeMTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC0FC4CED1;
	Fri,  6 Dec 2024 15:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497480;
	bh=DvldD9tZBbV0G9kyJUa7iqWZNOvtWb14srRFPZUu2P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNXbeMTjWRxLGoFabxRs2toM/6xOQm0zshf7eepeN4G6wv1Agxh9CFZy1cSoWV/Ed
	 yj7W9YusjL1Wbmh5S9EjcPZHAdO+q9sqfoOG6JSFYvpBkvoDzkE8eXYd94HjbeJS/b
	 ws1X969uttCj2+XxXVwXTySSX9msCMggfEbjvmrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/676] scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
Date: Fri,  6 Dec 2024 15:32:03 +0100
Message-ID: <20241206143705.216671094@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cd0180b1f5b9d..ede8d1f6ae236 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -369,6 +369,7 @@ static int qedi_alloc_and_init_sb(struct qedi_ctx *qedi,
 	ret = qedi_ops->common->sb_init(qedi->cdev, sb_info, sb_virt, sb_phys,
 				       sb_id, QED_SB_TYPE_STORAGE);
 	if (ret) {
+		dma_free_coherent(&qedi->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Status block initialization failed for id = %d.\n",
 			  sb_id);
-- 
2.43.0



