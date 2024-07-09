Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9CF155389;
	Tue,  9 Jul 2024 11:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523512; cv=none; b=Ciebuvh8jgh7/qWhtJi4r5l/LV4iRX8gPnr9UONkC4Lcb3f5QNZlCIWMK4mCvla5gH4nuUpFvFsyOiGqPWP4F6gJirchvf6Kf+ujcMq0YE92O1qEiN1D65kQy2XnKMbO/MEo95L4257CalFClK95x74Pcbd1uoVQAlcIDeCxWgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523512; c=relaxed/simple;
	bh=mbprWyM+kCKXyMJtxNI/O70X6iXY8UISBeEGReGnr8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poWiS/4PEzep8Ukdg9FXkdagcWxzYrkv9mkUlfcgbqb0O+3A6HTBgTwPAmkkntpcZZCr+DfDAO6ysk624sVldZDiS+GK5qS7Rrj/GwhRgm497gfs9aXNDnxR0E5bCagC5B4dKEZ8VLaO6MqkepU3IxfmcdPMgXJyf38HNZv2fM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVDGXtAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVDGXtAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BC7C3277B;
	Tue,  9 Jul 2024 11:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523512;
	bh=mbprWyM+kCKXyMJtxNI/O70X6iXY8UISBeEGReGnr8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVDGXtASeJlB/WbOBaI2C8hyWNSWxUK194eDsbN1tAq1hoZgyugA159BZoLvLq5cU
	 CvPsrc7vSyy3QJ1xU3ETtZKhwAi0wgMjStVJebfofXgpKrBTnFGblOPTfZi+X9+Hcg
	 aqwyd+NXohPKMYQiCOzkyyfafetBFeZL+2N5W6Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/139] scsi: qedf: Make qedf_execute_tmf() non-preemptible
Date: Tue,  9 Jul 2024 13:08:29 +0200
Message-ID: <20240709110658.512372391@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: John Meneghini <jmeneghi@redhat.com>

[ Upstream commit 0d8b637c9c5eeaa1a4e3dfb336f3ff918eb64fec ]

Stop calling smp_processor_id() from preemptible code in
qedf_execute_tmf90.  This results in BUG_ON() when running an RT kernel.

[ 659.343280] BUG: using smp_processor_id() in preemptible [00000000] code: sg_reset/3646
[ 659.343282] caller is qedf_execute_tmf+0x8b/0x360 [qedf]

Tested-by: Guangwu Zhang <guazhang@redhat.com>
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Link: https://lore.kernel.org/r/20240403150155.412954-1-jmeneghi@redhat.com
Acked-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 10fe3383855c0..031e605b3f427 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2331,9 +2331,6 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	io_req->fcport = fcport;
 	io_req->cmd_type = QEDF_TASK_MGMT_CMD;
 
-	/* Record which cpu this request is associated with */
-	io_req->cpu = smp_processor_id();
-
 	/* Set TM flags */
 	io_req->io_req_flags = QEDF_READ;
 	io_req->data_xfer_len = 0;
@@ -2355,6 +2352,9 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 
 	spin_lock_irqsave(&fcport->rport_lock, flags);
 
+	/* Record which cpu this request is associated with */
+	io_req->cpu = smp_processor_id();
+
 	sqe_idx = qedf_get_sqe_idx(fcport);
 	sqe = &fcport->sq[sqe_idx];
 	memset(sqe, 0, sizeof(struct fcoe_wqe));
-- 
2.43.0



