Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048102;
	b=KchyuHu0VZ903nyZ5HmLZdegmMS9aWd+TZ+rHHYypT7YpYkUuYLeBx23vM/Lm7HE3hqp
	 3QNpNSECOSjvJKK2DO/CATYAjnXuWtfL6ts/dUGA76U6QXZxC37SyY6l2eBod5o1FEvJH
	 qBwkoAY19d++Koy/s3bIYL4aXmvHc/SG+ZYoKPUALZ6j909MVpRAD78ArhP9qfkZF64qQ
	 rfzlEA7LgoftclNS6MDCR6RXEF08hp6ikXY+isISItnPrJLaeh7UOwdOgglA3iBE6wiqr
	 /teSl+3WGZvcBGSbZoPRs7JDFRli5LoKwV57dwrbI6LkLXjbzBh5I6WlPpEFWGvtLlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=08e8Oa2VoAjVKLsTARhlQXyyle4bSWZJbFqkrfhPTbE=;
	b=FDaeJDDf1/Z6iIK+amgeF6tGNlL3IDa2D2vK2arzaMz0eYlXHC2n6zi3l1LHHdXtMR7X
	 nDDw7OiyMnZGsXupk2FzzvPtqMhHsqGmEOw9v+9uhQxvHcfQ70dvgtwiVNeQypgQzlVKw
	 SGteoXGubsLHl4dgFXtS0Wabuz3ZvClRtMZau0g/3V1oAJ43N1I6dBOHORVbsFkGRs58D
	 X8WVBBbEyuX15jFrI2mBwxVfiKyuVtRr0DPJvT6AHvPXfmUM+Jtq4yT8SbrJMxXd+DRZN
	 JtF8loRNx2NfeXH2VZV0uMq/JLH1UfuUWbLsgSG7S4tsxvpViOF9hs5oKPuWV2eFKdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0p4Aztou;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0490606A32C;
	Thu, 19 Nov 2026 00:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0p4Aztou
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4191C1F000C6;
	Thu, 19 Nov 2026 00:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048101;
	bh=08e8Oa2VoAjVKLsTARhlQXyyle4bSWZJbFqkrfhPTbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0p4AztouBcPwIEAKrfracDAgRXz3pMYzC975EHvijxxWd7jXqhPIQ57PRN4YpPm/g
	 b92McNBSzLN3ZGL7WJ+fIxg5mqoBd3RG3ovp1KBKvVMyLciJYgB/asv7FNyTfVttnm
	 Y9MsLsZvnePjxsTeSeKzxq2GQiHRxHbFRYHo+FQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1858/2857] scsi: mpi3mr: Fix device loss during enclosure reboot due to zero link speed
Date: Wed, 18 Nov 2026 15:48:12 +0100
Message-ID: <20261118150308.140681914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 600f771ae1403..ef913e4432270 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1913,8 +1913,8 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	if (!fwevt->process_evt)
 		goto evt_ack;
 
-	dprint_event_bh(mrioc, "processing event(0x%02x) in the bottom half handler\n",
-	    fwevt->event_id);
+	dprint_event_bh(mrioc, "processing event(0x%02x) -(0x%08x) in the bottom half handler\n",
+			fwevt->event_id, fwevt->evt_ctx);
 
 	switch (fwevt->event_id) {
 	case MPI3_EVENT_DEVICE_ADDED:
@@ -2952,8 +2952,8 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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
index 9a25d819b417a..d6ac71e1d9e4e 100644
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



