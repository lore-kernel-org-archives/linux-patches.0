Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49B413F007;
	Tue, 27 Feb 2024 13:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040547; cv=none; b=NtGe1RBWFrz4YsGkc+HhoR/YgY1CjGPa/Zkz75qbLCorLeNi2Vvnj+sM2OkpYxw8hfRnht8/+Rwc+RymoCZdTaS4cdsZdP7uYf2wNDs23S3r+D7OEeeLnvDbokBs15pGN7lutuYQHO0jnahM3UP5yn6oBEUXfQvaCtQG1wqh1W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040547; c=relaxed/simple;
	bh=KD/rAEUb0E4PWqRsLkci7evxeNoiMkhowBhrBiGVpS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faSMg6CfKUUnc8eGOi/6KESOZvgdLOKR3N5j1ubjD40Ww6y+qX8UzafCsV8Nca6e9NE4CTQ2j+wD2uas2UbRmw3hA+/P2NKmBRgeP/LImDs0ajcZEi1Kl9t4vpf/BUCdWsWPomf+8nK0wgYW0xISiRxj1JvK1Z1KmWnMxyLFUEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuWRwdT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuWRwdT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44738C433F1;
	Tue, 27 Feb 2024 13:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040547;
	bh=KD/rAEUb0E4PWqRsLkci7evxeNoiMkhowBhrBiGVpS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuWRwdT33jUGes6T5EqhvxbMrnkPFIPFe8jBjRFFVBVQHx2HN/h5z6T7bDTY1XDLk
	 /kOzKsuzoNU4DpDnnTHLJTfk8L6gZVOUeZxJhfiG0LbgPz10p69ApxYXN0nY9LvnZ5
	 HB+bnI6Q/RTKnMzy76mD4+ge6MNTqZJX7Ayiwo8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Teel <scott.teel@microchip.com>,
	Scott Benesh <scott.benesh@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Kevin Barnett <kevin.barnett@microchip.com>,
	Murthy Bhat <Murthy.Bhat@microchip.com>,
	Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 004/334] scsi: smartpqi: Fix logical volume rescan race condition
Date: Tue, 27 Feb 2024 14:17:42 +0100
Message-ID: <20240227131630.781322892@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

[ Upstream commit fb4cece17b4583f55b34a8538e27a4adc833c9d4 ]

Correct rescan flag race condition.

Multiple conditions are being evaluated before notifying OS to do a rescan.

Driver will skip rescanning the device if any one of the following
conditions are met:

 - Devices that have not yet been added to the OS or devices that have been
   removed.

 - Devices which are already marked for removal or in the phase of removal.

Under very rare conditions, after logical volume size expansion, the OS
still sees the size of the logical volume which was before expansion.

The rescan flag in the driver is used to signal the need for a logical
volume rescan. A race condition can occur in the driver, and it leads to
one thread overwriting the flag inadvertently. As a result, driver is not
notifying the OS SML to rescan the logical volume.

Move device->rescan update into new function pqi_mark_volumes_for_rescan()
and protect with a spin lock.

Move check for device->rescan into new function pqi_volume_rescan_needed()
and protect function call with a spin_lock.

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Co-developed-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20231219193653.277553-3-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi.h      |  1 -
 drivers/scsi/smartpqi/smartpqi_init.c | 43 ++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 0419401835169..cdedc271857aa 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1347,7 +1347,6 @@ struct pqi_ctrl_info {
 	bool		controller_online;
 	bool		block_requests;
 	bool		scan_blocked;
-	u8		logical_volume_rescan_needed : 1;
 	u8		inbound_spanning_supported : 1;
 	u8		outbound_spanning_supported : 1;
 	u8		pqi_mode_enabled : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d562011200877..081bb2c098063 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2093,8 +2093,6 @@ static void pqi_scsi_update_device(struct pqi_ctrl_info *ctrl_info,
 		if (existing_device->devtype == TYPE_DISK) {
 			existing_device->raid_level = new_device->raid_level;
 			existing_device->volume_status = new_device->volume_status;
-			if (ctrl_info->logical_volume_rescan_needed)
-				existing_device->rescan = true;
 			memset(existing_device->next_bypass_group, 0, sizeof(existing_device->next_bypass_group));
 			if (!pqi_raid_maps_equal(existing_device->raid_map, new_device->raid_map)) {
 				kfree(existing_device->raid_map);
@@ -2164,6 +2162,20 @@ static inline void pqi_init_device_tmf_work(struct pqi_scsi_dev *device)
 		INIT_WORK(&tmf_work->work_struct, pqi_tmf_worker);
 }
 
+static inline bool pqi_volume_rescan_needed(struct pqi_scsi_dev *device)
+{
+	if (pqi_device_in_remove(device))
+		return false;
+
+	if (device->sdev == NULL)
+		return false;
+
+	if (!scsi_device_online(device->sdev))
+		return false;
+
+	return device->rescan;
+}
+
 static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *new_device_list[], unsigned int num_new_devices)
 {
@@ -2284,9 +2296,13 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 		if (device->sdev && device->queue_depth != device->advertised_queue_depth) {
 			device->advertised_queue_depth = device->queue_depth;
 			scsi_change_queue_depth(device->sdev, device->advertised_queue_depth);
-			if (device->rescan) {
-				scsi_rescan_device(device->sdev);
+			spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+			if (pqi_volume_rescan_needed(device)) {
 				device->rescan = false;
+				spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+				scsi_rescan_device(device->sdev);
+			} else {
+				spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 			}
 		}
 	}
@@ -2308,8 +2324,6 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 		}
 	}
 
-	ctrl_info->logical_volume_rescan_needed = false;
-
 }
 
 static inline bool pqi_is_supported_device(struct pqi_scsi_dev *device)
@@ -3702,6 +3716,21 @@ static bool pqi_ofa_process_event(struct pqi_ctrl_info *ctrl_info,
 	return ack_event;
 }
 
+static void pqi_mark_volumes_for_rescan(struct pqi_ctrl_info *ctrl_info)
+{
+	unsigned long flags;
+	struct pqi_scsi_dev *device;
+
+	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+
+	list_for_each_entry(device, &ctrl_info->scsi_device_list, scsi_device_list_entry) {
+		if (pqi_is_logical_device(device) && device->devtype == TYPE_DISK)
+			device->rescan = true;
+	}
+
+	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+}
+
 static void pqi_disable_raid_bypass(struct pqi_ctrl_info *ctrl_info)
 {
 	unsigned long flags;
@@ -3742,7 +3771,7 @@ static void pqi_event_worker(struct work_struct *work)
 				ack_event = true;
 				rescan_needed = true;
 				if (event->event_type == PQI_EVENT_TYPE_LOGICAL_DEVICE)
-					ctrl_info->logical_volume_rescan_needed = true;
+					pqi_mark_volumes_for_rescan(ctrl_info);
 				else if (event->event_type == PQI_EVENT_TYPE_AIO_STATE_CHANGE)
 					pqi_disable_raid_bypass(ctrl_info);
 			}
-- 
2.43.0



