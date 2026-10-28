Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216481;
	b=aZ4Y+Wm8/GR4oKsuqEm8EyYB+6D15OCKrrhCzGmvXJ57l1jiPfMQLdntmvexfkdx2GEQ
	 5X4ekg+dMhitZNJnCEyNwfsU+RfPXAXMQwdYcSkAbkZoRJbNewRcwvTtFwcAlImGOpRkH
	 YPoe4MbqDUadHM13aM/LRHYMdA7jSiGXp7NLAjiVkXdpoTLzOpeqvlFH2+c4Niz5dPywi
	 rcWPWUTT0j2fs2ROdUfDInlKRAxcSSshiDi88h83gUpDP9eiJWlD8DLWAqgk+vtjWVFrl
	 BYKOufHsBXqftYL74o6G4QLXfK7pl9Kq1N3RUESeNDQjSaEn77oZYzAb1WM7uDVeekg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i6AduQXx5AfatnVf93qlgvpsFv3Bpiv1dWPRaG7g6DM=;
	b=cqH2SpNwGlvUrqq91EFIyR4PI1jV670/8IEVhKQE8X3APsVjkEYCSrfZ8xW/1wqF6E4Y
	 LlO/Pm78pF0F4F58UqcIZ9U2RU1pV4byP2U9Ddb8pvUUUP8u5OIsTSjgXSlS+nMnp3rbH
	 32giHdun/W7dOHzz9R/mUk1T3sJDd7PLw/YyaMW4liUU44uqYZBTsVi1JR0w24ap3kHAc
	 PrNsTs9QjsN/unKnW0tBb4eptqJFhd0Q1fTUtctRTJNDiinvf3DGBdtXWiOMIEk2T59Rg
	 Du6R50yAO9lcDbjD3jdeQwk8sND+b9MWSEYDtJlZyfibnklDEbpPJNkI4mHNRwAQNwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWApHttc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4C6606A324;
	Wed, 28 Oct 2026 19:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWApHttc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308141F01825;
	Wed, 28 Oct 2026 19:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216480;
	bh=i6AduQXx5AfatnVf93qlgvpsFv3Bpiv1dWPRaG7g6DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWApHttcLsJEhizLRW9CE4ZoQcAovULNWsniCOew8Ud3E4TQz72TiNEVC51yDa19P
	 i4knPxM4YWQseXuFU8nCg6PXhqXafTtBxO7J4Nw+lhnNHYHfD+EJeTDfHRqNosNQGH
	 xKAfN/YX6vApbk9rHtw4aOLjjrmDQi0Oe2RU/jMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1571/1887] scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails
Date: Wed, 28 Oct 2026 18:01:07 +0100
Message-ID: <20261028170535.217445509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/scsi/sd.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5e6e5753387d1..32f850c6be114 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -920,6 +920,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	unsigned int data_len = 24;
 	char *buf;
+	blk_status_t ret;
 
 	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!rq->special_vec.bv_page)
@@ -943,7 +944,10 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = data_len;
 	rq->timeout = SD_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
@@ -955,6 +959,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
+	blk_status_t ret;
 
 	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!rq->special_vec.bv_page)
@@ -975,7 +980,10 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
@@ -987,6 +995,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
+	blk_status_t ret;
 
 	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!rq->special_vec.bv_page)
@@ -1007,7 +1016,10 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
@@ -1352,8 +1364,11 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = scsi_cmd_to_rq(SCpnt);
 
-	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
-		mempool_free(rq->special_vec.bv_page, sd_page_pool);
+	if (!(rq->rq_flags & RQF_SPECIAL_PAYLOAD))
+		return;
+
+	mempool_free(rq->special_vec.bv_page, sd_page_pool);
+	rq->rq_flags &= ~RQF_SPECIAL_PAYLOAD;
 }
 
 static bool sd_need_revalidate(struct block_device *bdev,
-- 
2.53.0



