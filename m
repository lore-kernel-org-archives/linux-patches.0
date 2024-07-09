Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6101586C6;
	Tue,  9 Jul 2024 11:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523924; cv=none; b=N/+ya8tG1zZ4b8DxkMxbwYzLINtKCw2IgXsUlX3pv+oPsxiwQP8wGXv9bUUPkMU2PZbsW5llu9qBmHfDj8W6+/tRtqHusWyuWZtYX93ImKhB/FJNb5bU/Usl9nilfh6tpeEqAASUqkM5UOIr7mTU0jFbYGrAwlTWtTJBvkYEAyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523924; c=relaxed/simple;
	bh=hedHnNLBWWQXJr0VmUvp/5/hYQGkJgCwXRycRRsTV2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUEpaUJtE2N9Wn8BjLZM8fDS7gUDnl5/7JmKqfbsH6qG/Qeyub+ORohHzwN4tM6/um7gO3r5SYNe+XKSEQ8y2AzvTt01qCOIW0HVg+2g3dyXbpmHFSlcxZiDZe5sK1i/Hv8ShgLOvDC1FoHLYba+6XydLvZj6o9lU+2GwRiBK3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxvvsD/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxvvsD/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DA7C3277B;
	Tue,  9 Jul 2024 11:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523924;
	bh=hedHnNLBWWQXJr0VmUvp/5/hYQGkJgCwXRycRRsTV2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxvvsD/YQv7OdqKDbYQSNbQaG4E6B3eEVoMGq27VPcHaFRFTlpzzau0Is6fjoAsAe
	 oF+j9ktmv9bK6XOVuz/l7OZATpI4UpGEQoNILNph64MToL6lKfKTAU0wWWiQXLhrh5
	 lOLHFIbVnkx7urmXTzq9DETs35EethNvwxRc0lbY=
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
Subject: [PATCH 6.9 014/197] scsi: qedf: Make qedf_execute_tmf() non-preemptible
Date: Tue,  9 Jul 2024 13:07:48 +0200
Message-ID: <20240709110709.465597402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index bf921caaf6aea..054a51713d556 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2324,9 +2324,6 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, u64 tm_lun,
 	io_req->fcport = fcport;
 	io_req->cmd_type = QEDF_TASK_MGMT_CMD;
 
-	/* Record which cpu this request is associated with */
-	io_req->cpu = smp_processor_id();
-
 	/* Set TM flags */
 	io_req->io_req_flags = QEDF_READ;
 	io_req->data_xfer_len = 0;
@@ -2349,6 +2346,9 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, u64 tm_lun,
 
 	spin_lock_irqsave(&fcport->rport_lock, flags);
 
+	/* Record which cpu this request is associated with */
+	io_req->cpu = smp_processor_id();
+
 	sqe_idx = qedf_get_sqe_idx(fcport);
 	sqe = &fcport->sq[sqe_idx];
 	memset(sqe, 0, sizeof(struct fcoe_wqe));
-- 
2.43.0



