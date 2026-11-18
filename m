Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039521;
	b=m6IUZi17RdNtNXN+eVH15Xf0ltawfmYNTC7RKbGv7fN9t9FEb5Q1a1XTDPGJRMKcNQHe
	 TxpsozkgS/zrXe5cjkKCxAYhPtI5xp1flCHHuih2k/UqfeOJOeorXAwhxbuKwhMWITpi3
	 NKNEXmKoKMMT7enqHDiq4Tgqdtq+oRbV/At6gtn1/8aZKKE10yUjs95PtfdJ/iRjGDs/Y
	 K7XpaqryM1BMRdfu+fwwHOmZH9qCexaen6jx4F37Xcq118sgcp4pSckK6J5BSL3N4P1JE
	 Olopfrn3Lg/q0Q25sOULYGrkk7cIxwFO0Eri4aCVRdWKrBHCNamF7ZManVT2jTo051w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UoeO2AdWGahrFg8vz96GMk457H7OltPnKj87w1xOGXk=;
	b=NXxl9y4ZPepTbQHA2qpSXf0Hlod0e4V+Op8zQwzgwCV+9IxkVMlw85/n40+1EuYqSlT9
	 Uhcr/zC/fD5u4tly0FzclZw4lj0EWOVeJFdDAGYcPsLSYpYQknqYBHoPXafPoYbqMBAjR
	 iP0hY/zesnHopdHwPeYleca8i7qM3eWLRmMQ2BiVASQHfCBDfMxEUH3kNSiHSOkBGdirK
	 5sQssZqnGEcAtYsSZESF+KqyFkjhJCXS/yV+gR9DpAIu/nrLe/Q29wlGyFBpVx4JPOSTM
	 7X6IOPxkP6bVfi5OICxMNgeIOKpmQB4Ju3grHKT/KI1MDIQmNBFRkaHyKABwAN+qqRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kP7zovHK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5D7606A32F;
	Wed, 18 Nov 2026 22:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kP7zovHK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C161F000C4;
	Wed, 18 Nov 2026 22:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039521;
	bh=UoeO2AdWGahrFg8vz96GMk457H7OltPnKj87w1xOGXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kP7zovHK/xYe/FdLRrw8HDTC7knmGLG0mhLJr8VHIvq5rmFOfvmK3wst0ib+7pPHn
	 iNQQ1Pw/rBJDuAFcOBn90LAf/UKtqw4pbtpGoYv0k60UrhQxvEAcaUFCvetV/7uhKz
	 5E1AlMUPJGCkHsW5KymI7JCsRAeohZHO7WAAXnxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2129/3318] scsi: mpi3mr: Fix device loss during enclosure reboot due to zero link speed
Date: Wed, 18 Nov 2026 15:45:51 +0100
Message-ID: <20261118150425.930039939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 77554f01187d ("scsi: mpi3mr: Fix out-of-bounds read of event data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  8 ++++----
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 11 +++++++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 2656c6a3de8bb..8c663d237bd91 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1952,8 +1952,8 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	if (!fwevt->process_evt)
 		goto evt_ack;
 
-	dprint_event_bh(mrioc, "processing event(0x%02x) in the bottom half handler\n",
-	    fwevt->event_id);
+	dprint_event_bh(mrioc, "processing event(0x%02x) -(0x%08x) in the bottom half handler\n",
+			fwevt->event_id, fwevt->evt_ctx);
 
 	switch (fwevt->event_id) {
 	case MPI3_EVENT_DEVICE_ADDED:
@@ -2991,8 +2991,8 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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
index 5c10713a9dabc..e717d90cc15b1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -410,9 +410,11 @@ static void mpi3mr_remove_device_by_sas_address(struct mpi3mr_ioc *mrioc,
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
@@ -2058,6 +2060,8 @@ int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
 				link_rate = (expander_pg1.negotiated_link_rate &
 				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
 				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
+				if (link_rate < MPI3_SAS_NEG_LINK_RATE_1_5)
+					link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
 				mpi3mr_update_links(mrioc, sas_address_parent,
 				    handle, i, link_rate, hba_port);
 			}
@@ -2367,6 +2371,9 @@ int mpi3mr_report_tgtdev_to_sas_transport(struct mpi3mr_ioc *mrioc,
 
 	link_rate = mpi3mr_get_sas_negotiated_logical_linkrate(mrioc, tgtdev);
 
+	if (link_rate < MPI3_SAS_NEG_LINK_RATE_1_5)
+		link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
+
 	mpi3mr_update_links(mrioc, sas_address_parent, tgtdev->dev_handle,
 	    parent_phy_number, link_rate, hba_port);
 
-- 
2.53.0



