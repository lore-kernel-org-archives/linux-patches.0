Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08131714A1;
	Thu, 15 Aug 2024 13:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730075; cv=none; b=FnNmnwLB61oCreOGGcoStTRNal39Vnooq3LL0/2WtlDLdJRGC3ctJy7kXR8VtdQ0eDfnMz2fMU02H9ybFv7Z+whcDUht5DCSa0b15ZNmkR8avLQWtv4QQropaXjgM8M3eIRqzNQsY//5lyYP04gN+s+88xjmvftiPgUYTef085g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730075; c=relaxed/simple;
	bh=9KrbPeEVpmvjXYgypTORFMY/ANLOOjhkgj81vjHVdRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuPiipfdCikgZmmpdwTq3sIC57Dhegh6oQhA3FGU6i7OWMPQ+MvDaoqRg8hERDFxKd3rDXY6OBo8MFGhZHIDEezqYRSDvHyP+gucyNHpJC2W6FYBprtPgPxGRjAFrdUaRHPgZhMYRmPdTGYRNAkzJbgKRE8uSNaHOukac46zxGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2ccYOi1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2ccYOi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61082C32786;
	Thu, 15 Aug 2024 13:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730074;
	bh=9KrbPeEVpmvjXYgypTORFMY/ANLOOjhkgj81vjHVdRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2ccYOi1Vf1yGaJMiQcD1XnqAHUcOaKkbAWqMmBaYazSLXo7ONRNcQRCcBah2hwTY
	 /UmDv3dDbppRKaoBkV50ErhbkRmB85UoJax71ZKI2DWlIQfT1ZqS96a87d6wwsEOSn
	 ySDDTbNb7Yil9oIuPznvq0aiOVZcRCJTpPart6NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/484] nvme: split command copy into a helper
Date: Thu, 15 Aug 2024 15:22:32 +0200
Message-ID: <20240815131952.761542154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 3233b94cf842984ea7e208d5be1ad2f2af02d495 ]

We'll need it for batched submit as well. Since we now have a copy
helper, get rid of the nvme_submit_cmd() wrapper.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c31fad147038 ("nvme-pci: add missing condition check for existence of mapped data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5a3ba7e390546..04e51134165dd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -479,22 +479,13 @@ static inline void nvme_write_sq_db(struct nvme_queue *nvmeq, bool write_sq)
 	nvmeq->last_sq_tail = nvmeq->sq_tail;
 }
 
-/**
- * nvme_submit_cmd() - Copy a command into a queue and ring the doorbell
- * @nvmeq: The queue to use
- * @cmd: The command to send
- * @write_sq: whether to write to the SQ doorbell
- */
-static void nvme_submit_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
-			    bool write_sq)
+static inline void nvme_sq_copy_cmd(struct nvme_queue *nvmeq,
+				    struct nvme_command *cmd)
 {
-	spin_lock(&nvmeq->sq_lock);
 	memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
-	       cmd, sizeof(*cmd));
+		absolute_pointer(cmd), sizeof(*cmd));
 	if (++nvmeq->sq_tail == nvmeq->q_depth)
 		nvmeq->sq_tail = 0;
-	nvme_write_sq_db(nvmeq, write_sq);
-	spin_unlock(&nvmeq->sq_lock);
 }
 
 static void nvme_commit_rqs(struct blk_mq_hw_ctx *hctx)
@@ -940,7 +931,10 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	}
 
 	blk_mq_start_request(req);
-	nvme_submit_cmd(nvmeq, cmnd, bd->last);
+	spin_lock(&nvmeq->sq_lock);
+	nvme_sq_copy_cmd(nvmeq, &iod->cmd);
+	nvme_write_sq_db(nvmeq, bd->last);
+	spin_unlock(&nvmeq->sq_lock);
 	return BLK_STS_OK;
 out_unmap_data:
 	nvme_unmap_data(dev, req);
@@ -1109,7 +1103,11 @@ static void nvme_pci_submit_async_event(struct nvme_ctrl *ctrl)
 
 	c.common.opcode = nvme_admin_async_event;
 	c.common.command_id = NVME_AQ_BLK_MQ_DEPTH;
-	nvme_submit_cmd(nvmeq, &c, true);
+
+	spin_lock(&nvmeq->sq_lock);
+	nvme_sq_copy_cmd(nvmeq, &c);
+	nvme_write_sq_db(nvmeq, true);
+	spin_unlock(&nvmeq->sq_lock);
 }
 
 static int adapter_delete_queue(struct nvme_dev *dev, u8 opcode, u16 id)
-- 
2.43.0



