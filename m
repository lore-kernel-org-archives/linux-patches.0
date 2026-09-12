Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8126E377ABA;
	Sat, 12 Sep 2026 18:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239216; cv=none; b=MxBkDTrXp7Ic/yffEyNHaDGhJNUk8fubs5T3ZRFfg6sfYdNNI3K6gcx7B0dECbpvbdJtbWeUHrKosSONRaXrxTnuNuwtxgRONzevcOWh1d1t3bHEmS6YabUVHmc4U9NBj3ESb+BkdEdsw74uxjKG0fRMYP6rf6FHVaK/JbV2UI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239216; c=relaxed/simple;
	bh=6U379T6WJFwhlzxE5ixYDZatsucTSWsptprYv/TjIDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCTGGgIVcwLhe/jo/2ip04JiDzBlQ92VWc0j+6xvkyKuDkG3acUQIy9VU7G2sgn/SkNvd6g2rQmomsEhIuxUBQ72H/0n9EQLmP9Y/4nrU1XimOh8qjvSrTBqBgM2EBmZazplX1bB9PPQYKqLvzppXUoZWWanknHr5f5hxaQir6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLoK6KD5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLoK6KD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B6E1F000FF;
	Sat, 12 Sep 2026 18:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239214;
	bh=a5idQ2gDOQKc26cAnlN27BiBAd5MeMtj5YYYrGi6d64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLoK6KD5T3ZQbQmEM4kD5h7nQG7lehSmuvqnQmPipNbuXn2gli6yvih2HEAAWAenQ
	 XqS0PATGRG+T0VnrcPmQhM9W41LQpT2HQP08EloXTTbvwXAr60+RD3MLLFvOGiHB9S
	 NLtC/YEeCwFot9yaQNptK7sBo7Jr1j0Xy8zM+7u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	John Donnelly <john.p.donnelly@oracle.com>,
	Murthy Bhat <Murthy.Bhat@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 618/935] scsi: smartpqi: Capture controller reason codes
Date: Sat, 12 Sep 2026 09:00:48 +0200
Message-ID: <20260912065541.013421613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murthy Bhat <Murthy.Bhat@microchip.com>

[ Upstream commit 5d1f03e6f49ae80d417dc72d1ee16a3379e2c026 ]

In some rare cases, the driver can halt the controller. Add a reason code
describing why the controller was halted.  Store this reason code in a
controller register to aid in debugging the issue.

Link: https://lore.kernel.org/r/20210928235442.201875-4-don.brace@microchip.com
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Acked-by: John Donnelly <john.p.donnelly@oracle.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 225548863f0a ("scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi.h      | 25 +++++++++++++++--
 drivers/scsi/smartpqi/smartpqi_init.c | 40 ++++++++++++++++++---------
 drivers/scsi/smartpqi/smartpqi_sis.c  |  9 ++++--
 drivers/scsi/smartpqi/smartpqi_sis.h  |  3 +-
 4 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 70eca203d72fc..d66863f8d1cfa 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -82,9 +82,11 @@ struct pqi_ctrl_registers {
 	__le32  sis_product_identifier;			/* B4h */
 	u8	reserved5[0xbc - (0xb4 + sizeof(__le32))];
 	__le32	sis_firmware_status;			/* BCh */
-	u8	reserved6[0x1000 - (0xbc + sizeof(__le32))];
+	u8	reserved6[0xcc - (0xbc + sizeof(__le32))];
+	__le32	sis_ctrl_shutdown_reason_code;		/* CCh */
+	u8	reserved7[0x1000 - (0xcc + sizeof(__le32))];
 	__le32	sis_mailbox[8];				/* 1000h */
-	u8	reserved7[0x4000 - (0x1000 + (sizeof(__le32) * 8))];
+	u8	reserved8[0x4000 - (0x1000 + (sizeof(__le32) * 8))];
 	/*
 	 * The PQI spec states that the PQI registers should be at
 	 * offset 0 from the PCIe BAR 0.  However, we can't map
@@ -102,6 +104,21 @@ struct pqi_ctrl_registers {
 
 #define PQI_DEVICE_REGISTERS_OFFSET	0x4000
 
+/* shutdown reasons for taking the controller offline */
+enum pqi_ctrl_shutdown_reason {
+	PQI_IQ_NOT_DRAINED_TIMEOUT = 1,
+	PQI_LUN_RESET_TIMEOUT = 2,
+	PQI_IO_PENDING_POST_LUN_RESET_TIMEOUT = 3,
+	PQI_NO_HEARTBEAT = 4,
+	PQI_FIRMWARE_KERNEL_NOT_UP = 5,
+	PQI_OFA_RESPONSE_TIMEOUT = 6,
+	PQI_INVALID_REQ_ID = 7,
+	PQI_UNMATCHED_REQ_ID = 8,
+	PQI_IO_PI_OUT_OF_RANGE = 9,
+	PQI_EVENT_PI_OUT_OF_RANGE = 10,
+	PQI_UNEXPECTED_IU_TYPE = 11
+};
+
 enum pqi_io_path {
 	RAID_PATH = 0,
 	AIO_PATH = 1
@@ -850,7 +867,8 @@ struct pqi_config_table_firmware_features {
 #define PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT			14
 #define PQI_FIRMWARE_FEATURE_RAID_BYPASS_ON_ENCRYPTED_NVME	15
 #define PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN	16
-#define PQI_FIRMWARE_FEATURE_MAXIMUM				16
+#define PQI_FIRMWARE_FEATURE_FW_TRIAGE				17
+#define PQI_FIRMWARE_FEATURE_MAXIMUM				17
 
 struct pqi_config_table_debug {
 	struct pqi_config_table_section_header header;
@@ -1297,6 +1315,7 @@ struct pqi_ctrl_info {
 	u8		raid_iu_timeout_supported : 1;
 	u8		tmf_iu_timeout_supported : 1;
 	u8		unique_wwid_in_report_phys_lun_supported : 1;
+	u8		firmware_triage_supported : 1;
 	u8		enable_r1_writes : 1;
 	u8		enable_r5_writes : 1;
 	u8		enable_r6_writes : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 79f122ff5197a..f1ba5087e0eed 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -54,7 +54,8 @@ MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info);
+static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info);
 static void pqi_scan_start(struct Scsi_Host *shost);
@@ -226,7 +227,7 @@ static inline void pqi_check_ctrl_health(struct pqi_ctrl_info *ctrl_info)
 {
 	if (ctrl_info->controller_online)
 		if (!sis_is_firmware_running(ctrl_info))
-			pqi_take_ctrl_offline(ctrl_info);
+			pqi_take_ctrl_offline(ctrl_info, PQI_FIRMWARE_KERNEL_NOT_UP);
 }
 
 static inline bool pqi_is_hba_lunid(u8 *scsi3addr)
@@ -3163,9 +3164,10 @@ static int pqi_interpret_task_management_response(struct pqi_ctrl_info *ctrl_inf
 	return rc;
 }
 
-static inline void pqi_invalid_response(struct pqi_ctrl_info *ctrl_info)
+static inline void pqi_invalid_response(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
 {
-	pqi_take_ctrl_offline(ctrl_info);
+	pqi_take_ctrl_offline(ctrl_info, ctrl_shutdown_reason);
 }
 
 static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue_group *queue_group)
@@ -3183,7 +3185,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 	while (1) {
 		oq_pi = readl(queue_group->oq_pi);
 		if (oq_pi >= ctrl_info->num_elements_per_oq) {
-			pqi_invalid_response(ctrl_info);
+			pqi_invalid_response(ctrl_info, PQI_IO_PI_OUT_OF_RANGE);
 			dev_err(&ctrl_info->pci_dev->dev,
 				"I/O interrupt: producer index (%u) out of range (0-%u): consumer index: %u\n",
 				oq_pi, ctrl_info->num_elements_per_oq - 1, oq_ci);
@@ -3198,7 +3200,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 
 		request_id = get_unaligned_le16(&response->request_id);
 		if (request_id >= ctrl_info->max_io_slots) {
-			pqi_invalid_response(ctrl_info);
+			pqi_invalid_response(ctrl_info, PQI_INVALID_REQ_ID);
 			dev_err(&ctrl_info->pci_dev->dev,
 				"request ID in response (%u) out of range (0-%u): producer index: %u  consumer index: %u\n",
 				request_id, ctrl_info->max_io_slots - 1, oq_pi, oq_ci);
@@ -3207,7 +3209,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 
 		io_request = &ctrl_info->io_request_pool[request_id];
 		if (atomic_read(&io_request->refcount) == 0) {
-			pqi_invalid_response(ctrl_info);
+			pqi_invalid_response(ctrl_info, PQI_UNMATCHED_REQ_ID);
 			dev_err(&ctrl_info->pci_dev->dev,
 				"request ID in response (%u) does not match an outstanding I/O request: producer index: %u  consumer index: %u\n",
 				request_id, oq_pi, oq_ci);
@@ -3243,7 +3245,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 			pqi_process_io_error(response->header.iu_type, io_request);
 			break;
 		default:
-			pqi_invalid_response(ctrl_info);
+			pqi_invalid_response(ctrl_info, PQI_UNEXPECTED_IU_TYPE);
 			dev_err(&ctrl_info->pci_dev->dev,
 				"unexpected IU type: 0x%x: producer index: %u  consumer index: %u\n",
 				response->header.iu_type, oq_pi, oq_ci);
@@ -3425,7 +3427,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
 		pqi_ofa_free_host_buffer(ctrl_info);
 		pqi_ctrl_ofa_done(ctrl_info);
 		pqi_ofa_ctrl_unquiesce(ctrl_info);
-		pqi_take_ctrl_offline(ctrl_info);
+		pqi_take_ctrl_offline(ctrl_info, PQI_OFA_RESPONSE_TIMEOUT);
 		break;
 	}
 }
@@ -3550,7 +3552,7 @@ static void pqi_heartbeat_timer_handler(struct timer_list *t)
 			dev_err(&ctrl_info->pci_dev->dev,
 				"no heartbeat detected - last heartbeat count: %u\n",
 				heartbeat_count);
-			pqi_take_ctrl_offline(ctrl_info);
+			pqi_take_ctrl_offline(ctrl_info, PQI_NO_HEARTBEAT);
 			return;
 		}
 	} else {
@@ -3614,7 +3616,7 @@ static int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 	while (1) {
 		oq_pi = readl(event_queue->oq_pi);
 		if (oq_pi >= PQI_NUM_EVENT_QUEUE_ELEMENTS) {
-			pqi_invalid_response(ctrl_info);
+			pqi_invalid_response(ctrl_info, PQI_EVENT_PI_OUT_OF_RANGE);
 			dev_err(&ctrl_info->pci_dev->dev,
 				"event interrupt: producer index (%u) out of range (0-%u): consumer index: %u\n",
 				oq_pi, PQI_NUM_EVENT_QUEUE_ELEMENTS - 1, oq_ci);
@@ -7332,7 +7334,10 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 		ctrl_info->unique_wwid_in_report_phys_lun_supported =
 			firmware_feature->enabled;
 		break;
+	case PQI_FIRMWARE_FEATURE_FW_TRIAGE:
+		ctrl_info->firmware_triage_supported = firmware_feature->enabled;
 		pqi_save_fw_triage_setting(ctrl_info, firmware_feature->enabled);
+		break;
 	}
 
 	pqi_firmware_feature_status(ctrl_info, firmware_feature);
@@ -7428,6 +7433,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
 		.feature_bit = PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN,
 		.feature_status = pqi_ctrl_update_feature_flags,
 	},
+	{
+		.feature_name = "Firmware Triage",
+		.feature_bit = PQI_FIRMWARE_FEATURE_FW_TRIAGE,
+		.feature_status = pqi_ctrl_update_feature_flags,
+	},
 };
 
 static void pqi_process_firmware_features(
@@ -7528,6 +7538,7 @@ static void pqi_ctrl_reset_config(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->raid_iu_timeout_supported = false;
 	ctrl_info->tmf_iu_timeout_supported = false;
 	ctrl_info->unique_wwid_in_report_phys_lun_supported = false;
+	ctrl_info->firmware_triage_supported = false;
 }
 
 static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
@@ -8474,7 +8485,8 @@ static void pqi_ctrl_offline_worker(struct work_struct *work)
 	pqi_take_ctrl_offline_deferred(ctrl_info);
 }
 
-static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info)
+static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
 {
 	if (!ctrl_info->controller_online)
 		return;
@@ -8483,7 +8495,7 @@ static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->pqi_mode_enabled = false;
 	pqi_ctrl_block_requests(ctrl_info);
 	if (!pqi_disable_ctrl_shutdown)
-		sis_shutdown_ctrl(ctrl_info);
+		sis_shutdown_ctrl(ctrl_info, ctrl_shutdown_reason);
 	pci_disable_device(ctrl_info->pci_dev);
 	dev_err(&ctrl_info->pci_dev->dev, "controller offline\n");
 	schedule_work(&ctrl_info->ctrl_offline_work);
@@ -9318,6 +9330,8 @@ static void __attribute__((unused)) verify_structures(void)
 		sis_product_identifier) != 0xb4);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_firmware_status) != 0xbc);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
+		sis_ctrl_shutdown_reason_code) != 0xcc);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_mailbox) != 0x1000);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 8acd3a80f5822..d66eb8ea161c5 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -397,14 +397,17 @@ void sis_enable_intx(struct pqi_ctrl_info *ctrl_info)
 	sis_set_doorbell_bit(ctrl_info, SIS_ENABLE_INTX);
 }
 
-void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info)
+void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
 {
 	if (readl(&ctrl_info->registers->sis_firmware_status) &
 		SIS_CTRL_KERNEL_PANIC)
 		return;
 
-	writel(SIS_TRIGGER_SHUTDOWN,
-		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
+	if (ctrl_info->firmware_triage_supported)
+		writel(ctrl_shutdown_reason, &ctrl_info->registers->sis_ctrl_shutdown_reason_code);
+
+	writel(SIS_TRIGGER_SHUTDOWN, &ctrl_info->registers->sis_host_to_ctrl_doorbell);
 }
 
 int sis_pqi_reset_quiesce(struct pqi_ctrl_info *ctrl_info)
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index c1db93054c863..bd92ff49f3855 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -21,7 +21,8 @@ int sis_get_pqi_capabilities(struct pqi_ctrl_info *ctrl_info);
 int sis_init_base_struct_addr(struct pqi_ctrl_info *ctrl_info);
 void sis_enable_msix(struct pqi_ctrl_info *ctrl_info);
 void sis_enable_intx(struct pqi_ctrl_info *ctrl_info);
-void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info);
+void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info,
+	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
 int sis_pqi_reset_quiesce(struct pqi_ctrl_info *ctrl_info);
 int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info);
 void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value);
-- 
2.53.0



