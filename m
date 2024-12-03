Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ACC1F890D;
	Tue,  3 Dec 2024 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238966; cv=none; b=JHn6A0vD9VoOHyqWrdO26ppkAREChNoAMn0+YHyZL8vdBRcg9YDcVOOViXeWbhWay9/lR1VIhPt3j9niiocsI60UTSE/WWke0ixv2DeZGkH7hguk6icLURoX0nGUF/GjJUck7C+cVpSdrPUj8eW3mDO9+NtuHHVeQNGfF6UodCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238966; c=relaxed/simple;
	bh=8QTb2hh2bWvzDrhDa2pk8M2bmZ5qCp/s1qdf9XkK4qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw8ZbZLPFETa2ayeUo04pDqucsQNxVgza332Wbm5jMFDiUlcnlDFfn8lJk6ZkLDHsPPUfvsTyDEFHmTSqcrpp33tJxe9cv95wBk8gjPS7BT8bhaegUQH8Q46p5+Lu0hqdoLa6dz31vUlZ4rmLsEVdsImd4jbVVVUq75sN3cQyMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adN7ZSAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adN7ZSAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AE2C4CECF;
	Tue,  3 Dec 2024 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238966;
	bh=8QTb2hh2bWvzDrhDa2pk8M2bmZ5qCp/s1qdf9XkK4qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adN7ZSAHOELjKepsKSY1RYoJ6sbtKooLjpT8oWJn9Hb/1W7e7ZS+1JSf3tvkTozYg
	 o90u7o1cVr0j66ti+rKDXyM3FHMFOqkDvsX/Jg+U7gbpdvEu4aJzEP7Zeor1Kn2QrA
	 TG8v/kw7vRXhHlHDmA3n6oPCe89tP4k25nRUBhG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 441/817] scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
Date: Tue,  3 Dec 2024 15:40:13 +0100
Message-ID: <20241203144013.094142297@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



