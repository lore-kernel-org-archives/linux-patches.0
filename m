Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D281372B57;
	Sat, 12 Sep 2026 12:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217642; cv=none; b=Qa7XYqQ89Ds08CmVYFUmFXXe7VBVSPkzkDiFLhpx++w5CUy+1TSHLZ39VuBn0AYHetL4DM111/1CLOQQsfX4TSIwbWQ+ujX6SF1o75c1X695ZAmQN7Zl1t4a9ijFUjlChEFvfI1MrE69gBMxgfTcqOw7DXupXWV/jQeiRE5Qxv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217642; c=relaxed/simple;
	bh=0UG5Cr3QPM17+cizOJCyppn7/vFzaPFNeVnYtXQ+5UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nureMXiFTbK06iVv3zAHYekTy5gYpgsUxsCNJpyMec8yXSozr/pCf3GsInkHNuSPdEiiFtdCFYihKx8i3PMCBzi7rN7RQN1+8qt3iqwwi0woCm0XZmXyXDDAF//bQSakFBR/ufOecGj3Lkx529je6nCcqEpPyO3XBC30T/qxRI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmrDluVt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmrDluVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FF81F000FF;
	Sat, 12 Sep 2026 12:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217641;
	bh=iTEdiEuyvPlR3Xje61vj2KgQY0HuOicM1206v5RamBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LmrDluVt+s8uBtf4538d16rrc+PmSWfLDkUzzyG9r2NaZvzpnrXUzmaJyughcczzz
	 GIY7GwcgTaa4nzTLWAk0V7NAi8744HxzR47B1S1hhqE+aRYJuRDZdq3+mg39ZaaE38
	 EknzYd5dGNjnm7tBt7OvqGmu/pS0ev2gUzGEzUcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0982/1376] scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails
Date: Sat, 12 Sep 2026 08:56:48 +0200
Message-ID: <20260912065629.455142744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit bb31844d88b77138b67aa20c3600203baff40140 ]

sd_set_special_bvec() allocates a special payload page for UNMAP and
WRITE SAME commands. If scsi_alloc_sgtables() fails afterward in
sd_setup_unmap_cmnd() or sd_setup_write_same{10,16}_cmnd(), the SCSI
midlayer does not call uninit_command() because RQF_DONTPREP is not set
yet, leaking the page.

Call sd_uninit_command() on error, and clear RQF_SPECIAL_PAYLOAD after
freeing the page.

Fixes: 81d926e8b552 ("sd: split sd_setup_discard_cmnd")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260707030333.22245-3-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f963b9374e0af..3edb2518a1852 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -919,6 +919,21 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 	return protect;
 }
 
+static void sd_uninit_command(struct scsi_cmnd *cmd)
+{
+	struct request *rq = scsi_cmd_to_rq(cmd);
+	struct scsi_device *sdp = cmd->device;
+
+	if (!(rq->rq_flags & RQF_SPECIAL_PAYLOAD))
+		return;
+
+	if (sdp->sector_size > PAGE_SIZE)
+		mempool_free(rq->special_vec.bv_page, sd_large_page_pool);
+	else
+		mempool_free(rq->special_vec.bv_page, sd_page_pool);
+	rq->rq_flags &= ~RQF_SPECIAL_PAYLOAD;
+}
+
 static void *sd_set_special_bvec(struct scsi_cmnd *cmd, unsigned int data_len)
 {
 	struct page *page;
@@ -951,6 +966,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	unsigned int data_len = 24;
 	char *buf;
+	blk_status_t ret;
 
 	buf = sd_set_special_bvec(cmd, data_len);
 	if (!buf)
@@ -969,7 +985,10 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = data_len;
 	rq->timeout = SD_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
@@ -1039,6 +1058,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
+	blk_status_t ret;
 
 	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
@@ -1054,7 +1074,10 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
@@ -1066,6 +1089,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
+	blk_status_t ret;
 
 	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
@@ -1081,7 +1105,10 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
@@ -1505,20 +1532,6 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 	}
 }
 
-static void sd_uninit_command(struct scsi_cmnd *SCpnt)
-{
-	struct request *rq = scsi_cmd_to_rq(SCpnt);
-	struct scsi_device *sdp = SCpnt->device;
-	unsigned sector_size = sdp->sector_size;
-
-	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD) {
-		if (sector_size > PAGE_SIZE)
-			mempool_free(rq->special_vec.bv_page, sd_large_page_pool);
-		else
-			mempool_free(rq->special_vec.bv_page, sd_page_pool);
-	}
-}
-
 static bool sd_need_revalidate(struct gendisk *disk, struct scsi_disk *sdkp)
 {
 	if (sdkp->device->removable || sdkp->write_prot) {
-- 
2.53.0



