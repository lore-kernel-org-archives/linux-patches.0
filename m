Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA984F4CF5;
	Tue, 13 Oct 2026 12:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894069; cv=none; b=dCLMBQeTqzxYu7YYMlakHbh/Fk5+EZXtFDW6KPhJLHk7jteuZ1lnU40qqv6CYkPAwYEnOX+G5MV5ZgGJemq2l7TGI8yDMf/xriDhCJ48aK+WUJM3z9JAhfdso9cBdbVv74SWscDMatuu3mX0PtnTLWtxKnoE85QBjJVLyJxcTLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894069; c=relaxed/simple;
	bh=wQhrgW8ZvPybOSdXWYVmU1SrdzsJpFUxRNvVxenS2eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfWlWmcvyD8lZ34rINeUW+Uz4ZaFlUdEXikTBdEKLy3mIvPPV8vlXf0oQMeoER1wsrYECIxfo7R2VE5d6Nn1DSISaCHMVKLfDods2TSKbW6UE9G3AD0THfXfQ5W/tw1HvEerDVzDfC6UbLxAaZD6Ihn2nvxbF99i4uv21MNdobg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDw0eUDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDw0eUDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A5B1F000FF;
	Tue, 13 Oct 2026 12:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894068;
	bh=mPJnv8r74lv58Bo0ZR5EHwRF7CuaTMSmkKn4Va/OG4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xDw0eUDOEghQ7BtHwZ0zttRDdsGUVeU03KfbLjeOmYzUTtyAKJGm8gRCNcKjZ+Odc
	 L5RXUgIFUObp+abApSmpOf3KODltu0KdHxd5qBl4XcGQcs8HiCNhnTbMzSenvPYVxn
	 8tZCJpZKGgDtdhPRfz47MU/sNIsMwkw3Saf9zSG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 434/621] scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails
Date: Tue, 13 Oct 2026 13:37:09 +0200
Message-ID: <20261013112931.133294986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/scsi/sd.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 73e2a96bd338f..385e50b79c92c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -889,6 +889,17 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 	return protect;
 }
 
+static void sd_uninit_command(struct scsi_cmnd *cmd)
+{
+	struct request *rq = scsi_cmd_to_rq(cmd);
+
+	if (!(rq->rq_flags & RQF_SPECIAL_PAYLOAD))
+		return;
+
+	mempool_free(rq->special_vec.bv_page, sd_page_pool);
+	rq->rq_flags &= ~RQF_SPECIAL_PAYLOAD;
+}
+
 static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
 {
 	struct page *page;
@@ -911,6 +922,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	unsigned int data_len = 24;
 	char *buf;
+	blk_status_t ret;
 
 	buf = sd_set_special_bvec(rq, data_len);
 	if (!buf)
@@ -929,7 +941,10 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = data_len;
 	rq->timeout = SD_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
@@ -1000,6 +1015,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
+	blk_status_t ret;
 
 	if (!sd_set_special_bvec(rq, data_len))
 		return BLK_STS_RESOURCE;
@@ -1015,7 +1031,10 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
@@ -1027,6 +1046,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
+	blk_status_t ret;
 
 	if (!sd_set_special_bvec(rq, data_len))
 		return BLK_STS_RESOURCE;
@@ -1042,7 +1062,10 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
@@ -1471,14 +1494,6 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 	}
 }
 
-static void sd_uninit_command(struct scsi_cmnd *SCpnt)
-{
-	struct request *rq = scsi_cmd_to_rq(SCpnt);
-
-	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
-		mempool_free(rq->special_vec.bv_page, sd_page_pool);
-}
-
 static bool sd_need_revalidate(struct gendisk *disk, struct scsi_disk *sdkp)
 {
 	if (sdkp->device->removable || sdkp->write_prot) {
-- 
2.53.0



