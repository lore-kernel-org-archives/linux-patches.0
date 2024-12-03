Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052B71DE8A5;
	Tue,  3 Dec 2024 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241445; cv=none; b=HoABy+1AWKOENP4tD1Vxb41G3mTBP2N+62TNu9jggu02h42crFCksvFys1fJgihu3HsrLPeEuA4WxTj8VFt/ZTryqgLnkU5s7XqAqO6efuclzjDU1iF1l1+mqxcyHDJ/5pc7plN7d8yNrsxWxCmSZFuk4dYgvQIA28eIx1/KotY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241445; c=relaxed/simple;
	bh=/eeBdXXH2rBqkBXotio49krV+Yn4n225PFNMkFtklY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8SY6r2ZpakbUjRk5SV8r95LA3k4t2Vtrv0Wyg8G46UGQSrE9D9joGTxVz1KpPCBNnIiT7MN6+5CmTJ0nXM9ykxK7sk+zYluEtTqdPx8pjisxBqpomRdRIrWuG12GzsgbU4MJUBcndz1kZGH6Fn+IYDIGvv+ddRyaMEx9UgsBJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBZz8o8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBZz8o8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686B6C4CECF;
	Tue,  3 Dec 2024 15:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241444;
	bh=/eeBdXXH2rBqkBXotio49krV+Yn4n225PFNMkFtklY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBZz8o8tts/ydXzLHQfnMvNp7pXJ8mHpeR+iig+4/7oVF4ePfbsq1Ij0P+P1D7wrP
	 QHSITMF68TfoeKoPy+gENJbOE+Eqj/FKP7MOjooO3T8ogZCBOzXKrImlEmI4zifNJt
	 5mVBQYHnANqEO/88HlAqeVqUk2gtLdnNFn9XVIqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 421/826] scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
Date: Tue,  3 Dec 2024 15:42:28 +0100
Message-ID: <20241203144800.184654938@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c5aec26019d6a..628d59dda20cc 100644
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



