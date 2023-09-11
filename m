Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2DD11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C756C433C7;
	Mon, 11 Sep 2023 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444657;
	bh=diVL1xdfMuE+AdqaLqNYD/8jHq/RmIr4mbo8yS0tK7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW+w/lEiqs/OWEvaTmugqqGrfOIV9cQ/ZLjfcJi28pruoFKNptyBcy98ti3u1RuGl
	 rwd8BM230Sq00p1v6sSsN/O1nRXW9af0ljTTFGMJbVu/uEdBLJP6YxmVsX6M6TzVMP
	 D1aN3giq1SJMbZ19AEQ2f/rwqBhoONMlrb8wgdQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilbert Wu <gilbert.wu@microchip.com>,
	Sagar Biradar <Sagar.Biradar@microchip.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/600] scsi: aacraid: Reply queue mapping to CPUs based on IRQ affinity
Date: Mon, 11 Sep 2023 15:41:42 +0200
Message-ID: <20230911134635.658046716@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagar Biradar <sagar.biradar@microchip.com>

[ Upstream commit 9dc704dcc09eae7d21b5da0615eb2ed79278f63e ]

Fix the I/O hang that arises because of the MSIx vector not having a mapped
online CPU upon receiving completion.

SCSI cmds take the blk_mq route, which is setup during init. Reserved cmds
fetch the vector_no from mq_map after init is complete. Before init, they
have to use 0 - as per the norm.

Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20230519230834.27436-1-sagar.biradar@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/aacraid.h |  1 +
 drivers/scsi/aacraid/commsup.c |  6 +++++-
 drivers/scsi/aacraid/linit.c   | 14 ++++++++++++++
 drivers/scsi/aacraid/src.c     | 25 +++++++++++++++++++++++--
 4 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 5e115e8b2ba46..7c6efde75da66 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1678,6 +1678,7 @@ struct aac_dev
 	u32			handle_pci_error;
 	bool			init_reset;
 	u8			soft_reset_support;
+	u8			use_map_queue;
 };
 
 #define aac_adapter_interrupt(dev) \
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index deb32c9f4b3e6..3f062e4013ab6 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -223,8 +223,12 @@ int aac_fib_setup(struct aac_dev * dev)
 struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 {
 	struct fib *fibptr;
+	u32 blk_tag;
+	int i;
 
-	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
+	blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+	i = blk_mq_unique_tag_to_tag(blk_tag);
+	fibptr = &dev->fibs[i];
 	/*
 	 *	Null out fields that depend on being zero at the start of
 	 *	each I/O
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 5ba5c18b77b46..bff49b8ab057d 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -19,6 +19,7 @@
 
 #include <linux/compat.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq-pci.h>
 #include <linux/completion.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -505,6 +506,15 @@ static int aac_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+static void aac_map_queues(struct Scsi_Host *shost)
+{
+	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
+
+	blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+			      aac->pdev, 0);
+	aac->use_map_queue = true;
+}
+
 /**
  *	aac_change_queue_depth		-	alter queue depths
  *	@sdev:	SCSI device we are considering
@@ -1489,6 +1499,7 @@ static struct scsi_host_template aac_driver_template = {
 	.bios_param			= aac_biosparm,
 	.shost_groups			= aac_host_groups,
 	.slave_configure		= aac_slave_configure,
+	.map_queues			= aac_map_queues,
 	.change_queue_depth		= aac_change_queue_depth,
 	.sdev_groups			= aac_dev_groups,
 	.eh_abort_handler		= aac_eh_abort,
@@ -1776,6 +1787,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_lun = AAC_MAX_LUN;
 
 	pci_set_drvdata(pdev, shost);
+	shost->nr_hw_queues = aac->max_msix;
+	shost->host_tagset = 1;
 
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
@@ -1908,6 +1921,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	aac_cancel_rescan_worker(aac);
+	aac->use_map_queue = false;
 	scsi_remove_host(shost);
 
 	__aac_shutdown(aac);
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 11ef58204e96f..61949f3741886 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -493,6 +493,10 @@ static int aac_src_deliver_message(struct fib *fib)
 #endif
 
 	u16 vector_no;
+	struct scsi_cmnd *scmd;
+	u32 blk_tag;
+	struct Scsi_Host *shost = dev->scsi_host_ptr;
+	struct blk_mq_queue_map *qmap;
 
 	atomic_inc(&q->numpending);
 
@@ -505,8 +509,25 @@ static int aac_src_deliver_message(struct fib *fib)
 		if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
 			&& dev->sa_firmware)
 			vector_no = aac_get_vector(dev);
-		else
-			vector_no = fib->vector_no;
+		else {
+			if (!fib->vector_no || !fib->callback_data) {
+				if (shost && dev->use_map_queue) {
+					qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+					vector_no = qmap->mq_map[raw_smp_processor_id()];
+				}
+				/*
+				 *	We hardcode the vector_no for
+				 *	reserved commands as a valid shost is
+				 *	absent during the init
+				 */
+				else
+					vector_no = 0;
+			} else {
+				scmd = (struct scsi_cmnd *)fib->callback_data;
+				blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+				vector_no = blk_mq_unique_tag_to_hwq(blk_tag);
+			}
+		}
 
 		if (native_hba) {
 			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {
-- 
2.40.1



