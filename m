Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481D034EEEE;
	Tue, 16 Dec 2025 11:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885626; cv=none; b=WgdgxDVs5Wx/e4KurSZhhgW5AQ0wK6hBQ+o46UWS99k+m83bDXmyQZcNPh6FbcW5zj4q70FGQSKdroBmWiWzk2hR9l/UwGOYLrzvVpi6ehs1Kq2CVIc8HzBrovwopsdcEr4rX8F4bY6reZDK3X1D4tZC01uJv0oHN045x3mQT30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885626; c=relaxed/simple;
	bh=7IPIlzPYMh6lmc5boU6X2He+9MsExdAqaCUXxU53Pmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWsy5Mc3nvgapaL+g6DPn1aChXVjtytVs1YjfXSuFxp0W55fJj3B4/wm1ZTpDz74B7CLuRLBzHFRAjyutHhNUU59Mi6dreptP0XrxYrGupyM7oRO7DlgONyXWhZ29JUIbQ8xGrG0TU87MJweZ1ZOioo3kLA2K1vFiD568dICC9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2DQ975G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2DQ975G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA52C4CEF1;
	Tue, 16 Dec 2025 11:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885626;
	bh=7IPIlzPYMh6lmc5boU6X2He+9MsExdAqaCUXxU53Pmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2DQ975Gz8ZkKNSLEYRb6BrWj6Io58zsod3XHHxk2CqOZ+DPgf5DTKuiLlvVoNYN4
	 rTtrDmtEF1oKU+PKDZWy0lRo1Ltxl9pAvx2yrgCJ02hBR1omVLYaG8AiLXUhJMGA2r
	 mjrcLg7+hoT+zbgoo6S5VFKZA7YR8L96YpV6JcDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Teel <scott.teel@microchip.com>,
	Scott Benesh <scott.benesh@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 195/507] scsi: smartpqi: Fix device resources accessed after device removal
Date: Tue, 16 Dec 2025 12:10:36 +0100
Message-ID: <20251216111352.574473947@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Mike McGowen <mike.mcgowen@microchip.com>

[ Upstream commit b518e86d1a70a88f6592a7c396cf1b93493d1aab ]

Correct possible race conditions during device removal.

Previously, a scheduled work item to reset a LUN could still execute
after the device was removed, leading to use-after-free and other
resource access issues.

This race condition occurs because the abort handler may schedule a LUN
reset concurrently with device removal via sdev_destroy(), leading to
use-after-free and improper access to freed resources.

  - Check in the device reset handler if the device is still present in
    the controller's SCSI device list before running; if not, the reset
    is skipped.

  - Cancel any pending TMF work that has not started in sdev_destroy().

  - Ensure device freeing in sdev_destroy() is done while holding the
    LUN reset mutex to avoid races with ongoing resets.

Fixes: 2d80f4054f7f ("scsi: smartpqi: Update deleting a LUN via sysfs")
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://patch.msgid.link/20251106163823.786828-3-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 125944941601e..9f4f6e74f3e38 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6409,10 +6409,22 @@ static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev
 
 static int pqi_device_reset_handler(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device, u8 lun, struct scsi_cmnd *scmd, u8 scsi_opcode)
 {
+	unsigned long flags;
 	int rc;
 
 	mutex_lock(&ctrl_info->lun_reset_mutex);
 
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+	if (pqi_find_scsi_dev(ctrl_info, device->bus, device->target, device->lun) == NULL) {
+		dev_warn(&ctrl_info->pci_dev->dev,
+			"skipping reset of scsi %d:%d:%d:%u, device has been removed\n",
+			ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
+		spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+		mutex_unlock(&ctrl_info->lun_reset_mutex);
+		return 0;
+	}
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+
 	dev_err(&ctrl_info->pci_dev->dev,
 		"resetting scsi %d:%d:%d:%u SCSI cmd at %p due to cmd opcode 0x%02x\n",
 		ctrl_info->scsi_host->host_no, device->bus, device->target, lun, scmd, scsi_opcode);
@@ -6593,7 +6605,9 @@ static void pqi_sdev_destroy(struct scsi_device *sdev)
 {
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_scsi_dev *device;
+	struct pqi_tmf_work *tmf_work;
 	int mutex_acquired;
+	unsigned int lun;
 	unsigned long flags;
 
 	ctrl_info = shost_to_hba(sdev->host);
@@ -6620,8 +6634,13 @@ static void pqi_sdev_destroy(struct scsi_device *sdev)
 
 	mutex_unlock(&ctrl_info->scan_mutex);
 
+	for (lun = 0, tmf_work = device->tmf_work; lun < PQI_MAX_LUNS_PER_DEVICE; lun++, tmf_work++)
+		cancel_work_sync(&tmf_work->work_struct);
+
+	mutex_lock(&ctrl_info->lun_reset_mutex);
 	pqi_dev_info(ctrl_info, "removed", device);
 	pqi_free_device(device);
+	mutex_unlock(&ctrl_info->lun_reset_mutex);
 }
 
 static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
-- 
2.51.0



