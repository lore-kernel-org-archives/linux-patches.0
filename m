Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE66329E7B;
	Fri,  9 Jan 2026 12:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961663; cv=none; b=etzROxTDDPXUOnu2wjC6WFwgodiD2YSXOip53K9ncFwOIT+lZqo7GY+2wMw/GDLRnLodLGeNBpyatbNoH15+UjzjL6bgFAcDZgcYO8Ixt7ECRbJJ7KnxV1foLXxlmWJ0hZvTW2uQQpWwjQtOAuvJ4gxLJk1QciqAE5aPPlu9Qpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961663; c=relaxed/simple;
	bh=zg00ZlERC87N8xsCdU+rORLe+xPcHgFIX0qg3vAICGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQqmfUAJYAjJ4dZqoej4h0gYBD3uUEgOvsk5dTx0LmHihvKoP/mYS1tBIH4IjZ4QD0jOKm7pWmzPdLWhJOgIp2rG2rNmG0UTv7ei1WLaoI+FNLV+kB+fw1/5Lz3Bt/R7a/pRIb2B+VserkVJTNpwzJiDzw6GuMQdMR5vtRoDXS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh+D/I7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh+D/I7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B06C4CEF1;
	Fri,  9 Jan 2026 12:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961663;
	bh=zg00ZlERC87N8xsCdU+rORLe+xPcHgFIX0qg3vAICGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gh+D/I7+MVcFSIG0DYIqk69G0uhuS/GZddXZqQ7k2DjWqp5CmTfpjE/XPpFjA/oly
	 jHBjDzE7bpoSjLYpUoBcJn9QI5dszUu1jtG5/yEz5Ct/tNhh3JTP3sRbdg0HOxYxZ7
	 Dh2248RNP3VyCYjrizZsjl77djjPqqqhbQtFYStA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Kevin Barnett <kevin.barnett@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/634] scsi: smartpqi: Remove contention for raid_bypass_cnt
Date: Fri,  9 Jan 2026 12:36:10 +0100
Message-ID: <20260109112120.896964993@linuxfoundation.org>
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

From: Mike McGowen <mike.mcgowen@microchip.com>

[ Upstream commit 80d560d94fa9b28069c62e1a64ae4a03d5f43fbc ]

Reduce CPU contention when incrementing variable raid_bypass_cnt.

Remove the atomic operations for this variable by changing the atomic to an
unsigned int and replace atomic operations with standard operations. The
value is only checked that it is increasing and accuracy is not required.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20230428153712.297638-6-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: b518e86d1a70 ("scsi: smartpqi: Fix device resources accessed after device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi.h      | 2 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index af27bb0f3133e..6e2f08ac68166 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1147,7 +1147,7 @@ struct pqi_scsi_dev {
 
 	struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
 	atomic_t scsi_cmds_outstanding[PQI_MAX_LUNS_PER_DEVICE];
-	atomic_t raid_bypass_cnt;
+	unsigned int raid_bypass_cnt;
 };
 
 /* VPD inquiry pages */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d97946a09f646..4822b830ea371 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6035,7 +6035,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
 			if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
 				raid_bypassed = true;
-				atomic_inc(&device->raid_bypass_cnt);
+				device->raid_bypass_cnt++;
 			}
 		}
 		if (!raid_bypassed)
@@ -7274,7 +7274,7 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 	struct scsi_device *sdev;
 	struct pqi_scsi_dev *device;
 	unsigned long flags;
-	int raid_bypass_cnt;
+	unsigned int raid_bypass_cnt;
 
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
@@ -7290,7 +7290,7 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 		return -ENODEV;
 	}
 
-	raid_bypass_cnt = atomic_read(&device->raid_bypass_cnt);
+	raid_bypass_cnt = device->raid_bypass_cnt;
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-- 
2.51.0



