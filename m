Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97888280A22;
	Wed, 23 Apr 2025 14:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419834; cv=none; b=W7RD2Lk/cwIfcnmUigoEp6KDONSfUnXj+AwClQRPXNvfHg356FZibz6LrhYPvWER3Q7LDQMXY8aFpK4ihmO+BWs92e2xqKMoY42FEiLyQaCvDOrl7Dhya4sZtgr10wuElhuhoAGf1BTe6v+9KoJKtER9eA8SLrmc3gv9Hl7t32M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419834; c=relaxed/simple;
	bh=oU4Q8rt6ZHz+MuAFV4vT69/EOzM00ND841wPhJAVj60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCWtC4gVUEdsrQERcoakd+2o7poXxrKlbw+Si64D+M8BDrSuY9mcd9E6UNvTQEYcn/+XYn4sIRBSkCxk+V1/LvsbAqd8Beq7/QfJLK1sPiZBrEe+ff0k+FC5CDz0IO5O8Ju4huiDMbrP1Saj9FqSg7FZ1QitZ2/qPBdYCzleOCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXmA2Q/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXmA2Q/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2E3C4CEE8;
	Wed, 23 Apr 2025 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419834;
	bh=oU4Q8rt6ZHz+MuAFV4vT69/EOzM00ND841wPhJAVj60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXmA2Q/Lb+NNV+rF+XfRrHJ3tEqFpH1XX4Xjjdj9q+6FzoK3N1ko5o4EpC22sI3mt
	 3yUjQ/rzvoNhHh/D+t6h6vF0rWfDwVjuWHrCHpVRQsgYKk0CXpKxsfD039HnLIvgR5
	 Nj+7kHfVID9aEoML6rYenF8zUyRTXYRFRH/lMeCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Randy Wright <rwright@hpe.com>,
	Don Brace <don.brace@microchip.com>,
	Lee Duncan <lduncan@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 008/241] scsi: smartpqi: Use is_kdump_kernel() to check for kdump
Date: Wed, 23 Apr 2025 16:41:12 +0200
Message-ID: <20250423142620.867720666@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit a2d5a0072235a69749ceb04c1a26dc75df66a31a ]

The smartpqi driver checks the reset_devices variable to determine
whether special adjustments need to be made for kdump. This has the
effect that after a regular kexec reboot, some driver parameters such as
max_transfer_size are much lower than usual. More importantly, kexec
reboot tests have revealed memory corruption caused by the driver log
being written to system memory after a kexec.

Fix this by testing is_kdump_kernel() rather than reset_devices where
appropriate.

Fixes: 058311b72f54 ("scsi: smartpqi: Add fw log to kdump")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Link: https://lore.kernel.org/r/20250321223319.109250-1-mwilck@suse.com
Cc: Randy Wright <rwright@hpe.com>
Acked-by: Don Brace <don.brace@microchip.com>
Tested-by: Don Brace <don.brace@microchip.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0da7be40c9258..e790b5d4e3c70 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -19,6 +19,7 @@
 #include <linux/bcd.h>
 #include <linux/reboot.h>
 #include <linux/cciss_ioctl.h>
+#include <linux/crash_dump.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -5246,7 +5247,7 @@ static void pqi_calculate_io_resources(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->error_buffer_length =
 		ctrl_info->max_io_slots * PQI_ERROR_BUFFER_ELEMENT_LENGTH;
 
-	if (reset_devices)
+	if (is_kdump_kernel())
 		max_transfer_size = min(ctrl_info->max_transfer_size,
 			PQI_MAX_TRANSFER_SIZE_KDUMP);
 	else
@@ -5275,7 +5276,7 @@ static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 	u16 num_elements_per_iq;
 	u16 num_elements_per_oq;
 
-	if (reset_devices) {
+	if (is_kdump_kernel()) {
 		num_queue_groups = 1;
 	} else {
 		int num_cpus;
@@ -8288,12 +8289,12 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	u32 product_id;
 
 	if (reset_devices) {
-		if (pqi_is_fw_triage_supported(ctrl_info)) {
+		if (is_kdump_kernel() && pqi_is_fw_triage_supported(ctrl_info)) {
 			rc = sis_wait_for_fw_triage_completion(ctrl_info);
 			if (rc)
 				return rc;
 		}
-		if (sis_is_ctrl_logging_supported(ctrl_info)) {
+		if (is_kdump_kernel() && sis_is_ctrl_logging_supported(ctrl_info)) {
 			sis_notify_kdump(ctrl_info);
 			rc = sis_wait_for_ctrl_logging_completion(ctrl_info);
 			if (rc)
@@ -8344,7 +8345,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->product_id = (u8)product_id;
 	ctrl_info->product_revision = (u8)(product_id >> 8);
 
-	if (reset_devices) {
+	if (is_kdump_kernel()) {
 		if (ctrl_info->max_outstanding_requests >
 			PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
 				ctrl_info->max_outstanding_requests =
@@ -8480,7 +8481,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	if (rc)
 		return rc;
 
-	if (ctrl_info->ctrl_logging_supported && !reset_devices) {
+	if (ctrl_info->ctrl_logging_supported && !is_kdump_kernel()) {
 		pqi_host_setup_buffer(ctrl_info, &ctrl_info->ctrl_log_memory, PQI_CTRL_LOG_TOTAL_SIZE, PQI_CTRL_LOG_MIN_SIZE);
 		pqi_host_memory_update(ctrl_info, &ctrl_info->ctrl_log_memory, PQI_VENDOR_GENERAL_CTRL_LOG_MEMORY_UPDATE);
 	}
-- 
2.39.5



