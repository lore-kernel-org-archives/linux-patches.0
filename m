Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA401D0434;
	Wed,  2 Oct 2024 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875509; cv=none; b=Diabadbkv8LVC50Uz/YeDnX6JrtrbQsJZkqqLFXNWk0EIFWtvwTdSyOg9AWvL8WYzCXqCVynZGn0ak6okVp1Vc7BfVu+hkkj3IXlOGAdhK22o2ePpuK3zpSIQWPR8e23XegPoHrpuH7nah5IKhHRUdkljN1CaPRvsJSrRuQC4OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875509; c=relaxed/simple;
	bh=PzlDVn5AhzhRHIqqr7LcS0NLuDfIdo4/kSd7Y8LgCHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETEz3RB0puJ7CM/ZZNk8WObZu5kAFPJwhuBJOBqcawdFq6FlVSFADgnWPF3Kp80gCyJK1/fhiaG95FePZa3l/k95jhKjHugGPXIcDeZCIc4AFum9I+SmBIMajQ5sV1tmzFGORfELWwLJ6d91eLxaoCqbv506YJBE6+8MaZwWEK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHL8xueb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHL8xueb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9FBC4CEC5;
	Wed,  2 Oct 2024 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875509;
	bh=PzlDVn5AhzhRHIqqr7LcS0NLuDfIdo4/kSd7Y8LgCHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHL8xuebJmX002YB0u5HzeBOWGQqc5vITr6GPpZRUMhj4pT8aUGP0Kt7NTUcJqxnI
	 zONlrkDmBa//FuVv4z2p9hJMW1OWvQZAqazz8zplsm2er8AM3K8lnAPCFEgNabfmcI
	 CTBNtKMERKseJkbRfvULViKzWyX4/Es1dQWoYpT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 118/695] ublk: move zone report data out of request pdu
Date: Wed,  2 Oct 2024 14:51:56 +0200
Message-ID: <20241002125827.183256288@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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
index 1d53a3f48a0eb..bca06bfb4bc32 100644
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
@@ -308,7 +332,7 @@ static int ublk_report_zones(struct gendisk *disk, sector_t sector,
 		unsigned int zones_in_request =
 			min_t(unsigned int, remaining_zones, max_zones_per_request);
 		struct request *req;
-		struct ublk_rq_data *pdu;
+		struct ublk_zoned_report_desc desc;
 		blk_status_t status;
 
 		memset(buffer, 0, buffer_length);
@@ -319,20 +343,23 @@ static int ublk_report_zones(struct gendisk *disk, sector_t sector,
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
@@ -366,7 +393,7 @@ static blk_status_t ublk_setup_iod_zoned(struct ublk_queue *ubq,
 {
 	struct ublksrv_io_desc *iod = ublk_get_iod(ubq, req->tag);
 	struct ublk_io *io = &ubq->ios[req->tag];
-	struct ublk_rq_data *pdu = blk_mq_rq_to_pdu(req);
+	struct ublk_zoned_report_desc *desc;
 	u32 ublk_op;
 
 	switch (req_op(req)) {
@@ -389,12 +416,15 @@ static blk_status_t ublk_setup_iod_zoned(struct ublk_queue *ubq,
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



