Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D38C346E6C;
	Tue, 11 Nov 2025 01:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823703; cv=none; b=DSR4AZw+drYbNQnOAV3HFsOtyZfW730OMsCTPEbo/dXmFKeMjCEo1W3sj+CUmceS9G6GDQqngjpUuwOdE2oFcqBb8Bq1GptgvjlFkaSRmlU4zVTT0H7v3ZRH9OXLJ0sZzPrPx2/8nJq3no+M8tZsTVFrBlOcyI8R7QEjyliYO4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823703; c=relaxed/simple;
	bh=PZHIm+hXJR6GF0PX/1ws4MM0WvurwfqkNbX+EHxSKMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLxLT0pVbOIJWBqcA9Kvzya+/Zrb4VHhxi8iKLKj/DmX25j3SA2Tewip5+7s1QqdbeOPv9K6GQVdb7AzlV48VugpfCEI3w3FNn6kIbm86/BFbEsLOZPcBy6eLpQHTWTaz1ynGfChEwQ5riTXDxA5LQd5Ew+gpAVmY6NQ6JANoUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEQEsj0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEQEsj0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F05BC4CEFB;
	Tue, 11 Nov 2025 01:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823703;
	bh=PZHIm+hXJR6GF0PX/1ws4MM0WvurwfqkNbX+EHxSKMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEQEsj0t9v7dlZTI6z+if/Fk7v/DMxp1H15Ataf9oEGAdiIo+7HDr6EApLFEwkigd
	 Y5VV7d8H4Dv+kUnJ73sS10b2yc4if46mddrV6MsysnIT/obA8z2ju1y/LULhKZ4gu0
	 djPBJotlZP8JuLF//KoOHdSM8IWZ+rBxnvZkDjTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 353/849] scsi: mpi3mr: Fix device loss during enclosure reboot due to zero link speed
Date: Tue, 11 Nov 2025 09:38:43 +0900
Message-ID: <20251111004544.955175215@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit d6c8e8b7c98c3cb326515ef4bc5c57e16ac5ae4e ]

During enclosure reboot or expander reset, firmware may report a link
speed of 0 in "Device Add" events while the link is still coming up.
The driver drops such devices, leaving them missing even after the link
recovers.

Fix this by treating link speed 0 as 1.5 Gbps during device addition so
the device is exposed to the OS. The actual link speed will be updated
later when link-up events arrive.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://lore.kernel.org/r/20250820084138.228471-2-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  8 ++++----
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 11 +++++++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e467b56949e98..1582cdbc66302 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2049,8 +2049,8 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	if (!fwevt->process_evt)
 		goto evt_ack;
 
-	dprint_event_bh(mrioc, "processing event(0x%02x) in the bottom half handler\n",
-	    fwevt->event_id);
+	dprint_event_bh(mrioc, "processing event(0x%02x) -(0x%08x) in the bottom half handler\n",
+			fwevt->event_id, fwevt->evt_ctx);
 
 	switch (fwevt->event_id) {
 	case MPI3_EVENT_DEVICE_ADDED:
@@ -3076,8 +3076,8 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	}
 	if (process_evt_bh || ack_req) {
 		dprint_event_th(mrioc,
-			"scheduling bottom half handler for event(0x%02x),ack_required=%d\n",
-			evt_type, ack_req);
+		    "scheduling bottom half handler for event(0x%02x) - (0x%08x), ack_required=%d\n",
+		    evt_type, le32_to_cpu(event_reply->event_context), ack_req);
 		sz = event_reply->event_data_length * 4;
 		fwevt = mpi3mr_alloc_fwevt(sz);
 		if (!fwevt) {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index c8d6ced5640e9..d70f002d6487d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -413,9 +413,11 @@ static void mpi3mr_remove_device_by_sas_address(struct mpi3mr_ioc *mrioc,
 			 sas_address, hba_port);
 	if (tgtdev) {
 		if (!list_empty(&tgtdev->list)) {
-			list_del_init(&tgtdev->list);
 			was_on_tgtdev_list = 1;
-			mpi3mr_tgtdev_put(tgtdev);
+			if (tgtdev->state == MPI3MR_DEV_REMOVE_HS_STARTED) {
+				list_del_init(&tgtdev->list);
+				mpi3mr_tgtdev_put(tgtdev);
+			}
 		}
 	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
@@ -2079,6 +2081,8 @@ int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
 				link_rate = (expander_pg1.negotiated_link_rate &
 				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
 				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
+				if (link_rate < MPI3_SAS_NEG_LINK_RATE_1_5)
+					link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
 				mpi3mr_update_links(mrioc, sas_address_parent,
 				    handle, i, link_rate, hba_port);
 			}
@@ -2388,6 +2392,9 @@ int mpi3mr_report_tgtdev_to_sas_transport(struct mpi3mr_ioc *mrioc,
 
 	link_rate = mpi3mr_get_sas_negotiated_logical_linkrate(mrioc, tgtdev);
 
+	if (link_rate < MPI3_SAS_NEG_LINK_RATE_1_5)
+		link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
+
 	mpi3mr_update_links(mrioc, sas_address_parent, tgtdev->dev_handle,
 	    parent_phy_number, link_rate, hba_port);
 
-- 
2.51.0



