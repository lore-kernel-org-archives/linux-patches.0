Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FEC6AA0;
	Tue,  5 Dec 2023 03:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeMn4FSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80357C433C7;
	Tue,  5 Dec 2023 03:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746440;
	bh=PRZA+OmWeo4Jov5hB/weaXaSAURfj5re8J4cAMJMMx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeMn4FSUJgEz8Z1DHaJ4mr6mts0xcB/7jW3xry+RgQBmU7t10kktQ3YNKbxDbOB3+
	 hRPQ1t/PPDpHKwVmrMpVIWc2JldRFTZlzTzgVl3mkD1ZMikPSmWfh9BOaB0JvSeE46
	 p3BE1RlpRkcayt22swVJaEMQWfSIBG4HBXRVlyRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 024/134] scsi: sd: Fix system start for ATA devices
Date: Tue,  5 Dec 2023 12:14:56 +0900
Message-ID: <20231205031536.914732145@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit b09d7f8fd50f6e93cbadd8d27fde178f745b42a1 upstream.

It is not always possible to keep a device in the runtime suspended state
when a system level suspend/resume cycle is executed. E.g. for ATA devices
connected to AHCI adapters, system resume resets the ATA ports, which
causes connected devices to spin up. In such case, a runtime suspended disk
will incorrectly be seen with a suspended runtime state because the device
is not resumed by sd_resume_system(). The power state seen by the user is
different than the actual device physical power state.

Fix this issue by introducing the struct scsi_device flag
force_runtime_start_on_system_start. When set, this flag causes
sd_resume_system() to request a runtime resume operation for runtime
suspended devices. This results in the user seeing the device runtime_state
as active after a system resume, thus correctly reflecting the device
physical power state.

Fixes: 9131bff6a9f1 ("scsi: core: pm: Only runtime resume if necessary")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20231120225631.37938-3-dlemoal@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c  |    5 +++++
 drivers/scsi/sd.c          |    9 ++++++++-
 include/scsi/scsi_device.h |    6 ++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1055,9 +1055,14 @@ int ata_scsi_dev_config(struct scsi_devi
 		 * Ask the sd driver to issue START STOP UNIT on runtime suspend
 		 * and resume and shutdown only. For system level suspend/resume,
 		 * devices power state is handled directly by libata EH.
+		 * Given that disks are always spun up on system resume, also
+		 * make sure that the sd driver forces runtime suspended disks
+		 * to be resumed to correctly reflect the power state of the
+		 * device.
 		 */
 		sdev->manage_runtime_start_stop = 1;
 		sdev->manage_shutdown = 1;
+		sdev->force_runtime_start_on_system_start = 1;
 	}
 
 	/*
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3953,8 +3953,15 @@ static int sd_resume(struct device *dev,
 
 static int sd_resume_system(struct device *dev)
 {
-	if (pm_runtime_suspended(dev))
+	if (pm_runtime_suspended(dev)) {
+		struct scsi_disk *sdkp = dev_get_drvdata(dev);
+		struct scsi_device *sdp = sdkp ? sdkp->device : NULL;
+
+		if (sdp && sdp->force_runtime_start_on_system_start)
+			pm_request_resume(dev);
+
 		return 0;
+	}
 
 	return sd_resume(dev, false);
 }
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -181,6 +181,12 @@ struct scsi_device {
 	 */
 	unsigned manage_shutdown:1;
 
+	/*
+	 * If set and if the device is runtime suspended, ask the high-level
+	 * device driver (sd) to force a runtime resume of the device.
+	 */
+	unsigned force_runtime_start_on_system_start:1;
+
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
 	unsigned busy:1;	/* Used to prevent races */


