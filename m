Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC4D1D271A;
	Wed,  2 Oct 2024 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877611; cv=none; b=CQrMrfQubjJbo2FJAZ88Y+kQ2WKKlav2nQnH09ZMUBwC7f359MZ7DD3QaQwEyj3FQ7HQ5AcruY1GnhpMuDjRD2nSDgwD1w1vqTuLkq7yPDc8GjZzu+E7tDA2S1sErMs8wVg0qvSa8CjAv/BGmbNp4L6dU2qshm0vBwA6UjH0tXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877611; c=relaxed/simple;
	bh=Mi5toyebAKWBAWahijWNv0hMQRUbmiBXfotPNUZg/dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sqd8Z3zi8go9CCAyyZTypcEkmwweigqoqsgybKxeWyuLvKibpcHpQrEg5am791JTmm4O24k8Z1ykwsbJUCsAkLqQ8RP3cP5uMRCB3bwpvwBhyZKL2td6aIwU5gWX/xIUdjHY3gMg5UBJarqZBIg3z91wqCOhYQqDT2YTp+hHZ4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iz0kQOQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iz0kQOQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3113BC4CEC2;
	Wed,  2 Oct 2024 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877610;
	bh=Mi5toyebAKWBAWahijWNv0hMQRUbmiBXfotPNUZg/dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iz0kQOQ/oqslB8EgXBWpeSXWu2E6i2qKo1a2Id7wV/cZUNG40QeMd7fd1eA8KG2HP
	 aXJtH00EY2KMdS3QG+CpnAPSQkI6T223Mk+qvbUc9kW5c2FjvkWGHYyQAVwR5j4Zwy
	 4ZIJ2PWjoRzZwJhyZuBw8pocv7Z9qt2e/Vl1hUiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 102/634] ublk: move zone report data out of request pdu
Date: Wed,  2 Oct 2024 14:53:22 +0200
Message-ID: <20241002125815.141032907@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 9327b51c9a9c864f5177127e09851da9d78b4943 ]

ublk zoned takes 16 bytes in each request pdu just for handling REPORT_ZONE
operation, this way does waste memory since request pdu is allocated
statically.

Store the transient zone report data into one global xarray, and remove
it after the report zone request is completed. This way is reasonable
since report zone is run in slow code path.

Fixes: 29802d7ca33b ("ublk: enable zoned storage support")
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240812013624.587587-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 62 +++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index fc001e9f95f61..d06c8ed29620b 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -71,9 +71,6 @@ struct ublk_rq_data {
 	struct llist_node node;
 
 	struct kref ref;
-	__u64 sector;
-	__u32 operation;
-	__u32 nr_zones;
 };
 
 struct ublk_uring_cmd_pdu {
@@ -214,6 +211,33 @@ static inline bool ublk_queue_is_zoned(struct ublk_queue *ubq)
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
+struct ublk_zoned_report_desc {
+	__u64 sector;
+	__u32 operation;
+	__u32 nr_zones;
+};
+
+static DEFINE_XARRAY(ublk_zoned_report_descs);
+
+static int ublk_zoned_insert_report_desc(const struct request *req,
+		struct ublk_zoned_report_desc *desc)
+{
+	return xa_insert(&ublk_zoned_report_descs, (unsigned long)req,
+			    desc, GFP_KERNEL);
+}
+
+static struct ublk_zoned_report_desc *ublk_zoned_erase_report_desc(
+		const struct request *req)
+{
+	return xa_erase(&ublk_zoned_report_descs, (unsigned long)req);
+}
+
+static struct ublk_zoned_report_desc *ublk_zoned_get_report_desc(
+		const struct request *req)
+{
+	return xa_load(&ublk_zoned_report_descs, (unsigned long)req);
+}
+
 static int ublk_get_nr_zones(const struct ublk_device *ub)
 {
 	const struct ublk_param_basic *p = &ub->params.basic;
@@ -310,7 +334,7 @@ static int ublk_report_zones(struct gendisk *disk, sector_t sector,
 		unsigned int zones_in_request =
 			min_t(unsigned int, remaining_zones, max_zones_per_request);
 		struct request *req;
-		struct ublk_rq_data *pdu;
+		struct ublk_zoned_report_desc desc;
 		blk_status_t status;
 
 		memset(buffer, 0, buffer_length);
@@ -321,20 +345,23 @@ static int ublk_report_zones(struct gendisk *disk, sector_t sector,
 			goto out;
 		}
 
-		pdu = blk_mq_rq_to_pdu(req);
-		pdu->operation = UBLK_IO_OP_REPORT_ZONES;
-		pdu->sector = sector;
-		pdu->nr_zones = zones_in_request;
+		desc.operation = UBLK_IO_OP_REPORT_ZONES;
+		desc.sector = sector;
+		desc.nr_zones = zones_in_request;
+		ret = ublk_zoned_insert_report_desc(req, &desc);
+		if (ret)
+			goto free_req;
 
 		ret = blk_rq_map_kern(disk->queue, req, buffer, buffer_length,
 					GFP_KERNEL);
-		if (ret) {
-			blk_mq_free_request(req);
-			goto out;
-		}
+		if (ret)
+			goto erase_desc;
 
 		status = blk_execute_rq(req, 0);
 		ret = blk_status_to_errno(status);
+erase_desc:
+		ublk_zoned_erase_report_desc(req);
+free_req:
 		blk_mq_free_request(req);
 		if (ret)
 			goto out;
@@ -368,7 +395,7 @@ static blk_status_t ublk_setup_iod_zoned(struct ublk_queue *ubq,
 {
 	struct ublksrv_io_desc *iod = ublk_get_iod(ubq, req->tag);
 	struct ublk_io *io = &ubq->ios[req->tag];
-	struct ublk_rq_data *pdu = blk_mq_rq_to_pdu(req);
+	struct ublk_zoned_report_desc *desc;
 	u32 ublk_op;
 
 	switch (req_op(req)) {
@@ -391,12 +418,15 @@ static blk_status_t ublk_setup_iod_zoned(struct ublk_queue *ubq,
 		ublk_op = UBLK_IO_OP_ZONE_RESET_ALL;
 		break;
 	case REQ_OP_DRV_IN:
-		ublk_op = pdu->operation;
+		desc = ublk_zoned_get_report_desc(req);
+		if (!desc)
+			return BLK_STS_IOERR;
+		ublk_op = desc->operation;
 		switch (ublk_op) {
 		case UBLK_IO_OP_REPORT_ZONES:
 			iod->op_flags = ublk_op | ublk_req_build_flags(req);
-			iod->nr_zones = pdu->nr_zones;
-			iod->start_sector = pdu->sector;
+			iod->nr_zones = desc->nr_zones;
+			iod->start_sector = desc->sector;
 			return BLK_STS_OK;
 		default:
 			return BLK_STS_IOERR;
-- 
2.43.0



