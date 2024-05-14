Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD80213AA5F;
	Tue, 14 May 2024 11:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686310; cv=none; b=LqPhNz4xqrqOGlzkl4gk/xyPBGa4VeZb9BBsZjp4AWsiVbyVTpZpLVsJJ6lSTBpUQH+/Pux1ecd2iS8q7RBcDbHJ73HhfLx8Ax7OXPBPrxEDrVI2ccgWbg+2tpN2NLEzDqQEVB2wjr6GO2fpNj4h27OyZDRdKmwcC7kjnTj4zyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686310; c=relaxed/simple;
	bh=veic3/KKTZlKzrxiMoCoDTSXVffV84ZbgLndlqcdn+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2iMf7BoFhTW2yDJugkujgU8UYH7LCoIWQL7GsJKPjunaayUapKJW8YUKWBD0xB6B+AMIkebweGoazK9cnmq6DuB7ZT0D5sZv1yq1QWgiNfjfJ2M/Orh1zeH0/QgpCImetpDRlBnvwJTFSjrOiSRuSRmHCLJVJy8TMYkPMX+wXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Rnh6vCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Rnh6vCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1E4C2BD10;
	Tue, 14 May 2024 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686309;
	bh=veic3/KKTZlKzrxiMoCoDTSXVffV84ZbgLndlqcdn+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Rnh6vCLlanhm4RzrpIleytZV+N7D4zHFzMoGfrECJpFq4RZYMsA9ilj/vI8HBHKP
	 AYGdOBh2amgfJBs34Br92hgXauYfcMBN+bKZrwFku/DjBdyptFI5/PUmzUCPjN23Xg
	 CSwfDB3MUNxrWAoPFWK8GeIdr/k0T4A6QtI3cFnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/236] scsi: lpfc: Update lpfc_ramp_down_queue_handler() logic
Date: Tue, 14 May 2024 12:17:36 +0200
Message-ID: <20240514101023.941001253@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit bb011631435c705cdeddca68d5c85fd40a4320f9 ]

Typically when an out of resource CQE status is detected, the
lpfc_ramp_down_queue_handler() logic is called to help reduce I/O load by
reducing an sdev's queue_depth.

However, the current lpfc_rampdown_queue_depth() logic does not help reduce
queue_depth.  num_cmd_success is never updated and is always zero, which
means new_queue_depth will always be set to sdev->queue_depth.  So,
new_queue_depth = sdev->queue_depth - new_queue_depth always sets
new_queue_depth to zero.  And, scsi_change_queue_depth(sdev, 0) is
essentially a no-op.

Change the lpfc_ramp_down_queue_handler() logic to set new_queue_depth
equal to sdev->queue_depth subtracted from number of times num_rsrc_err was
incremented.  If num_rsrc_err is >= sdev->queue_depth, then set
new_queue_depth equal to 1.  Eventually, the frequency of Good_Status
frames will signal SCSI upper layer to auto increase the queue_depth back
to the driver default of 64 via scsi_handle_queue_ramp_up().

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240305200503.57317-5-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h      |  1 -
 drivers/scsi/lpfc/lpfc_scsi.c | 13 ++++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index dc5ac3cc70f6d..6f08fbe103cb9 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1355,7 +1355,6 @@ struct lpfc_hba {
 	struct timer_list fabric_block_timer;
 	unsigned long bit_flags;
 	atomic_t num_rsrc_err;
-	atomic_t num_cmd_success;
 	unsigned long last_rsrc_error_time;
 	unsigned long last_ramp_down_time;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0bb7e164b525f..2a81a42de5c14 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -167,11 +167,10 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 	struct Scsi_Host  *shost;
 	struct scsi_device *sdev;
 	unsigned long new_queue_depth;
-	unsigned long num_rsrc_err, num_cmd_success;
+	unsigned long num_rsrc_err;
 	int i;
 
 	num_rsrc_err = atomic_read(&phba->num_rsrc_err);
-	num_cmd_success = atomic_read(&phba->num_cmd_success);
 
 	/*
 	 * The error and success command counters are global per
@@ -186,20 +185,16 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
 			shost_for_each_device(sdev, shost) {
-				new_queue_depth =
-					sdev->queue_depth * num_rsrc_err /
-					(num_rsrc_err + num_cmd_success);
-				if (!new_queue_depth)
-					new_queue_depth = sdev->queue_depth - 1;
+				if (num_rsrc_err >= sdev->queue_depth)
+					new_queue_depth = 1;
 				else
 					new_queue_depth = sdev->queue_depth -
-								new_queue_depth;
+						num_rsrc_err;
 				scsi_change_queue_depth(sdev, new_queue_depth);
 			}
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 	atomic_set(&phba->num_rsrc_err, 0);
-	atomic_set(&phba->num_cmd_success, 0);
 }
 
 /**
-- 
2.43.0



