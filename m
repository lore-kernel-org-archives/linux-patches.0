Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F42CA40;
	Tue, 16 Jul 2024 15:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144280; cv=none; b=d5qk9Mo6gXYML52Zj9rIJ+fd5+nwM3YNW2jcZ8rT/ls+8487igvE3jWEvu5nXmpTN9Gi33SuLgqO3DZxXK+FP49tnZh2rb8Eu8DwvnsM/wakcv+Amo2YCQl8aHELZ6BpSW2Cz7lRMFekHNTgGxxnezBnbkI1jAwmCjAOahw5Qeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144280; c=relaxed/simple;
	bh=FQvebcCVfFQR5Jkpi26LMgmSf8V69eEPSz0I+kpf+GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQqeAkrLXEFAlzq4zqXCLaOXkiVyw4jSkRZdx1VR2OV4AnS1nJFcn7k9LemYIz7wIv0jzXSpityyDh8XmK9Hecryjhx/L/xIl906i76ZiipNGgM6rknn86X4fURwoji4GkOzCqpIA/nmYAh/MXJ1nKIXMk9k13kFvbnVrV11HEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CR32JVxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CR32JVxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3DEC116B1;
	Tue, 16 Jul 2024 15:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144280;
	bh=FQvebcCVfFQR5Jkpi26LMgmSf8V69eEPSz0I+kpf+GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CR32JVxEQp4XtevrL/9sZB7kYSDlCagj3EXFN3WtEBPjn21o7SkpEMzmQElJPhuhR
	 2AxJk1/gvNVQgktAM0kwidXF43npFh8jLGfxMIraeL/aUVSQ5kfrwB5Iyi9tmQ9NLG
	 SE2ZfAy6CkGkLI4R7wXMVwK1tchKXIZf3Dj8xDCw=
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
Subject: [PATCH 5.4 05/78] scsi: qedf: Make qedf_execute_tmf() non-preemptible
Date: Tue, 16 Jul 2024 17:30:37 +0200
Message-ID: <20240716152740.838502652@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d02d1ef0d0116..dc1ba29c16762 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2330,9 +2330,6 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	io_req->fcport = fcport;
 	io_req->cmd_type = QEDF_TASK_MGMT_CMD;
 
-	/* Record which cpu this request is associated with */
-	io_req->cpu = smp_processor_id();
-
 	/* Set TM flags */
 	io_req->io_req_flags = QEDF_READ;
 	io_req->data_xfer_len = 0;
@@ -2354,6 +2351,9 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 
 	spin_lock_irqsave(&fcport->rport_lock, flags);
 
+	/* Record which cpu this request is associated with */
+	io_req->cpu = smp_processor_id();
+
 	sqe_idx = qedf_get_sqe_idx(fcport);
 	sqe = &fcport->sq[sqe_idx];
 	memset(sqe, 0, sizeof(struct fcoe_wqe));
-- 
2.43.0



