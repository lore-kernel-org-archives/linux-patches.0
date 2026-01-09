Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A5635A952;
	Fri,  9 Jan 2026 12:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961660; cv=none; b=dVm37qPzcd+PR9xs1u7rtpI6iDegAraRbtcoryvtZFQTX1NeIq24HhksqjYGrV6gaGAgy283faAUSpWbk2mEZl37SuAl1EYKFl+rPfGf89zwOxJBmM3aLdvHjG/pJmHG53oDDJ3PqJoRNbsNfDB5nw+a/+VfQNMkzvmuhMXn7Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961660; c=relaxed/simple;
	bh=T4mrYBYUfz16Neb7b8prB0f0KInDA04stdkl2Mq7Ztw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9l7hImqegkZSm3N9HJshLW0djWS2H7JvrMD6vbDioz8YsU/zDk+xuVP9NcUFCrfWIS9utJnvt5wTrRIwgq3rmHfndewID/KCYYxfTX8NuubW1eBKTvKKrQQY7fil+vCHAQ2byVBWRmHEhIpFij4p9fm1S5kqA50KMvENFb4NQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbSHTpNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbSHTpNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0116EC4CEF1;
	Fri,  9 Jan 2026 12:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961660;
	bh=T4mrYBYUfz16Neb7b8prB0f0KInDA04stdkl2Mq7Ztw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbSHTpNqvQoZeZ1kpmcwUMpe+BR11qCcsqqBpPjMssI+ni7VWMYnlyC8Xt6H74C6l
	 2gWGSp822hq39UoGrBMf7rqmWj50ZyIjpfp+Mei8wDZDNXOjYXgtVWJ+IHRNWSmZXb
	 jHWQY9KjNaZfh6uMq0EuW1lFlA4HO2cmPnbpte0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>,
	Mike McGowen <Mike.McGowen@microchip.com>,
	Kevin Barnett <kevin.barnett@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/634] scsi: smartpqi: Convert to host_tagset
Date: Fri,  9 Jan 2026 12:36:09 +0100
Message-ID: <20260109112120.859135959@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Don Brace <don.brace@microchip.com>

[ Upstream commit b27ac2faa2fc0b2677cf1cbd270af734a1f5fd95 ]

Add support for host_tagset.

Also move the reserved command slots to the end of the pool to eliminate an
addition operation for every SCSI request.

This patch was originally authored by Hannes Reinecke here:

Link: https://lore.kernel.org/linux-block/20191126131009.71726-8-hare@suse.de/

But we NAKed this patch because we wanted to fully test multipath
failover operations.

Suggested-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>
Reviewed-by: Mike McGowen <Mike.McGowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/166793529811.322537.3294617845448383948.stgit@brunhilda
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: b518e86d1a70 ("scsi: smartpqi: Fix device resources accessed after device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi.h      |  3 --
 drivers/scsi/smartpqi/smartpqi_init.c | 68 +++++++++++++++++----------
 2 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index c8235f15728bb..af27bb0f3133e 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1307,7 +1307,6 @@ struct pqi_ctrl_info {
 	dma_addr_t	error_buffer_dma_handle;
 	size_t		sg_chain_buffer_length;
 	unsigned int	num_queue_groups;
-	u16		max_hw_queue_index;
 	u16		num_elements_per_iq;
 	u16		num_elements_per_oq;
 	u16		max_inbound_iu_length_per_firmware;
@@ -1369,8 +1368,6 @@ struct pqi_ctrl_info {
 	u64		sas_address;
 
 	struct pqi_io_request *io_request_pool;
-	u16		next_io_request_slot;
-
 	struct pqi_event events[PQI_NUM_SUPPORTED_EVENTS];
 	struct work_struct event_work;
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0b3aa91b46ffb..d97946a09f646 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -678,23 +678,36 @@ static inline void pqi_reinit_io_request(struct pqi_io_request *io_request)
 	io_request->raid_bypass = false;
 }
 
-static struct pqi_io_request *pqi_alloc_io_request(
-	struct pqi_ctrl_info *ctrl_info)
+static inline struct pqi_io_request *pqi_alloc_io_request(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
 {
 	struct pqi_io_request *io_request;
-	u16 i = ctrl_info->next_io_request_slot;	/* benignly racy */
+	u16 i;
 
-	while (1) {
+	if (scmd) { /* SML I/O request */
+		u32 blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
+
+		i = blk_mq_unique_tag_to_tag(blk_tag);
 		io_request = &ctrl_info->io_request_pool[i];
-		if (atomic_inc_return(&io_request->refcount) == 1)
-			break;
-		atomic_dec(&io_request->refcount);
-		i = (i + 1) % ctrl_info->max_io_slots;
+		if (atomic_inc_return(&io_request->refcount) > 1) {
+			atomic_dec(&io_request->refcount);
+			return NULL;
+		}
+	} else { /* IOCTL or driver internal request */
+		/*
+		 * benignly racy - may have to wait for an open slot.
+		 * command slot range is scsi_ml_can_queue -
+		 *         [scsi_ml_can_queue + (PQI_RESERVED_IO_SLOTS - 1)]
+		 */
+		i = 0;
+		while (1) {
+			io_request = &ctrl_info->io_request_pool[ctrl_info->scsi_ml_can_queue + i];
+			if (atomic_inc_return(&io_request->refcount) == 1)
+				break;
+			atomic_dec(&io_request->refcount);
+			i = (i + 1) % PQI_RESERVED_IO_SLOTS;
+		}
 	}
 
-	/* benignly racy */
-	ctrl_info->next_io_request_slot = (i + 1) % ctrl_info->max_io_slots;
-
 	pqi_reinit_io_request(io_request);
 
 	return io_request;
@@ -4579,7 +4592,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 		goto out;
 	}
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, NULL);
 
 	put_unaligned_le16(io_request->index,
 		&(((struct pqi_raid_path_request *)request)->request_id));
@@ -5226,7 +5239,6 @@ static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 	}
 
 	ctrl_info->num_queue_groups = num_queue_groups;
-	ctrl_info->max_hw_queue_index = num_queue_groups - 1;
 
 	/*
 	 * Make sure that the max. inbound IU length is an even multiple
@@ -5560,7 +5572,9 @@ static inline int pqi_raid_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 {
 	struct pqi_io_request *io_request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	return pqi_raid_submit_scsi_cmd_with_io_request(ctrl_info, io_request,
 		device, scmd, queue_group);
@@ -5664,7 +5678,9 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device;
 
 	device = scmd->device->hostdata;
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
 	io_request->io_complete_callback = pqi_aio_io_complete;
 	io_request->scmd = scmd;
 	io_request->raid_bypass = raid_bypass;
@@ -5736,7 +5752,10 @@ static  int pqi_aio_submit_r1_write_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_io_request *io_request;
 	struct pqi_aio_r1_path_request *r1_request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	io_request->io_complete_callback = pqi_aio_io_complete;
 	io_request->scmd = scmd;
 	io_request->raid_bypass = true;
@@ -5794,7 +5813,9 @@ static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_io_request *io_request;
 	struct pqi_aio_r56_path_request *r56_request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
 	io_request->io_complete_callback = pqi_aio_io_complete;
 	io_request->scmd = scmd;
 	io_request->raid_bypass = true;
@@ -5853,13 +5874,10 @@ static int pqi_aio_submit_r56_write_io(struct pqi_ctrl_info *ctrl_info,
 static inline u16 pqi_get_hw_queue(struct pqi_ctrl_info *ctrl_info,
 	struct scsi_cmnd *scmd)
 {
-	u16 hw_queue;
-
-	hw_queue = blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(scsi_cmd_to_rq(scmd)));
-	if (hw_queue > ctrl_info->max_hw_queue_index)
-		hw_queue = 0;
-
-	return hw_queue;
+	/*
+	 * We are setting host_tagset = 1 during init.
+	 */
+	return blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(scsi_cmd_to_rq(scmd)));
 }
 
 static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
@@ -6261,7 +6279,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd
 	struct pqi_scsi_dev *device;
 
 	device = scmd->device->hostdata;
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, NULL);
 	io_request->io_complete_callback = pqi_lun_reset_complete;
 	io_request->context = &wait;
 
-- 
2.51.0



