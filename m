Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F028473;
	Sat, 30 Dec 2023 12:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+g0Etaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E62C433C8;
	Sat, 30 Dec 2023 12:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938285;
	bh=2efLaDGnrk99nxzlLh/Q4O/PpS6eLYRhfcmPE4NZkGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+g0Etaj/WV6QH2mFkJTRc/hzOeESbi1J9KXwIcUiyHP24Apf5GGuct74RNNfVdOn
	 hiJM95dOkScgNFbRE5NaerYM3c0FuanzQfLrYd2mMC/qQYm963jiqVPUvtOr5Itjlw
	 YHYH0ATrlE8RzdzoE6AuSr8v50K22uLJPlnqYiHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Atanasov <alexander.atanasov@virtuozzo.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 097/112] scsi: core: Always send batch on reset or error handling command
Date: Sat, 30 Dec 2023 12:00:10 +0000
Message-ID: <20231230115809.908552941@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: Alexander Atanasov <alexander.atanasov@virtuozzo.com>

commit 066c5b46b6eaf2f13f80c19500dbb3b84baabb33 upstream.

In commit 8930a6c20791 ("scsi: core: add support for request batching") the
block layer bd->last flag was mapped to SCMD_LAST and used as an indicator
to send the batch for the drivers that implement this feature. However, the
error handling code was not updated accordingly.

scsi_send_eh_cmnd() is used to send error handling commands and request
sense. The problem is that request sense comes as a single command that
gets into the batch queue and times out. As a result the device goes
offline after several failed resets. This was observed on virtio_scsi
during a device resize operation.

[  496.316946] sd 0:0:4:0: [sdd] tag#117 scsi_eh_0: requesting sense
[  506.786356] sd 0:0:4:0: [sdd] tag#117 scsi_send_eh_cmnd timeleft: 0
[  506.787981] sd 0:0:4:0: [sdd] tag#117 abort

To fix this always set SCMD_LAST flag in scsi_send_eh_cmnd() and
scsi_reset_ioctl().

Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
Link: https://lore.kernel.org/r/20231215121008.2881653-1-alexander.atanasov@virtuozzo.com
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_error.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1108,6 +1108,7 @@ retry:
 
 	scsi_log_send(scmd);
 	scmd->submitter = SUBMITTED_BY_SCSI_ERROR_HANDLER;
+	scmd->flags |= SCMD_LAST;
 
 	/*
 	 * Lock sdev->state_mutex to avoid that scsi_device_quiesce() can
@@ -2402,6 +2403,7 @@ scsi_ioctl_reset(struct scsi_device *dev
 	scsi_init_command(dev, scmd);
 
 	scmd->submitter = SUBMITTED_BY_SCSI_RESET_IOCTL;
+	scmd->flags |= SCMD_LAST;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 
 	scmd->cmd_len			= 0;


