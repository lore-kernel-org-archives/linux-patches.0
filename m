Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6920C17BB16;
	Tue,  3 Dec 2024 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236720; cv=none; b=lCg5aI0AmIXDbdE+LV+ZDMSf0b7J22t87asEO2yUJSIBSidujxDq1sJNbeGPBINmIdKgFqEKd8gtFMaD2QAUvHlWbnGzgka6T01DS0Ur2yth4KeD97saARtxyua7NDIiLdvEReLQvBS3UI0LxmjZSIni3Tcb8FW+rzhcu2wAp00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236720; c=relaxed/simple;
	bh=QCJ0UPd41nDl/rFDhOMEbkHy653/JVAEHmoVKousizs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjYwLM9wYv7Idy3EP+5Clu9/PsNYyqOqEbSh6j8RhQo10zfZuP4qeUGsaDeSXvM584M0bvU1cujnO0RQIIf2MPwMu/PASoDcpZEmZ8WtiS+7ySYWjokQDHBkC2yQOwU71okpEloUUiyEdp/9F7q0zCJ7ybIKH3+Zd0KSQlro59U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxb3q551; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxb3q551"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F9BC4CECF;
	Tue,  3 Dec 2024 14:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236720;
	bh=QCJ0UPd41nDl/rFDhOMEbkHy653/JVAEHmoVKousizs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxb3q551YUbqV3qNnkU3ygiWkTDtAMexgXKQZ74pvx4qjHn6DtAs/9voPtyUYOiUD
	 iSg+NkIPo54WArRNqekaFmp8aIUeJGjPwpBivXQVD/JC0xC761RO04cDbTjeuYBGx8
	 h6tGAdQE6PFznqlAZLDBedX3yXIqtNZR23RYRUMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/138] scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
Date: Tue,  3 Dec 2024 15:31:36 +0100
Message-ID: <20241203141926.121766633@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7a179cfc01ed2..15567e60216ec 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -357,6 +357,7 @@ static int qedi_alloc_and_init_sb(struct qedi_ctx *qedi,
 	ret = qedi_ops->common->sb_init(qedi->cdev, sb_info, sb_virt, sb_phys,
 				       sb_id, QED_SB_TYPE_STORAGE);
 	if (ret) {
+		dma_free_coherent(&qedi->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Status block initialization failed for id = %d.\n",
 			  sb_id);
-- 
2.43.0



