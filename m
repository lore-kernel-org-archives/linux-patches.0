Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2F2281375;
	Wed, 23 Apr 2025 14:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419702; cv=none; b=pY7LPa/udEKvtCsChcHXz3W+qS0J86sL/2ekxg5Ktm5ArALAoH8j/4EG77bPgdRb1By2v8JUKo6K5+WO7Oo2N3GRI7Wcd5c/JzXGb0uuU8sg52xZYgdTKUeqeCkzx5Pg6RW+lavZX+qjHe7WXApUo/aEeeYH6u2CaMRI5wW1dCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419702; c=relaxed/simple;
	bh=rI+Ht9TvLc6sYUCdRdMIczU3BkQ0SzeDD7shiHC/u0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+reKElckoH98nM5Eb8jNr+uEoPxdWdrcI/5fAIcSmUwLd4qatoHNmkB8y2iBCAPtglNrAy376lumcSLQ5S9mUTCSLsRwankc56CjPHWf1OUNO7XonufFwId2czLqFFXQ9OH6O7kcWgXmvuPcwAhN1KElkG3I5Rd7QA+LQbIl3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aceNkFKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aceNkFKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB4EC4CEE3;
	Wed, 23 Apr 2025 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419702;
	bh=rI+Ht9TvLc6sYUCdRdMIczU3BkQ0SzeDD7shiHC/u0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aceNkFKDG6SsLPw8YUGyssW1127JnS7y/fKcEOM8jtZluPZDzhPvlerAOT0jPtBi7
	 gTNOyyu/eI/tcWTeGihsGVvTbjZfrdjQghJ38rrm69E/sNrTcJwkPUoX36ghvuAXWn
	 9Uq2RDnD8PdS18NtoLVnnZAn/iZlNLpBb4yvlrFk=
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
Subject: [PATCH 6.12 010/223] scsi: smartpqi: Use is_kdump_kernel() to check for kdump
Date: Wed, 23 Apr 2025 16:41:22 +0200
Message-ID: <20250423142617.541191209@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 04fb24d77e9b5..d919a74746a05 100644
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
@@ -8287,12 +8288,12 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
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
@@ -8343,7 +8344,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->product_id = (u8)product_id;
 	ctrl_info->product_revision = (u8)(product_id >> 8);
 
-	if (reset_devices) {
+	if (is_kdump_kernel()) {
 		if (ctrl_info->max_outstanding_requests >
 			PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
 				ctrl_info->max_outstanding_requests =
@@ -8479,7 +8480,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	if (rc)
 		return rc;
 
-	if (ctrl_info->ctrl_logging_supported && !reset_devices) {
+	if (ctrl_info->ctrl_logging_supported && !is_kdump_kernel()) {
 		pqi_host_setup_buffer(ctrl_info, &ctrl_info->ctrl_log_memory, PQI_CTRL_LOG_TOTAL_SIZE, PQI_CTRL_LOG_MIN_SIZE);
 		pqi_host_memory_update(ctrl_info, &ctrl_info->ctrl_log_memory, PQI_VENDOR_GENERAL_CTRL_LOG_MEMORY_UPDATE);
 	}
-- 
2.39.5



