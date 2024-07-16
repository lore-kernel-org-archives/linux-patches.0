Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE3A19D8A8;
	Tue, 16 Jul 2024 16:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146010; cv=none; b=QGlkxd80WIi+jxSNo68pcLH6hPoOJ6hR0wAe+AVKSSiFkugNgd6VdaOmEYtisMjRWFEd/W3Nt/GdcLs3gWyJ/x6PqKkpb9fUQr9ByBAW2aOse3Q75EvAmhVM5B0smWGMem1/fjhmb6Bp5vlTe2bVefyKw3vJyeVgDGuEXt4k/+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146010; c=relaxed/simple;
	bh=+ob5VK95PE8wNKqTHhd9vjswDCOHSEKElBpYw9TQ248=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxrh0YlG4YlKwQgQYV/M4e/Sy50i3bKNa+8MQn1n5lDOVYSXQTO/waopdipWdLLpDQbtA4H0/uWH8zrOQDlfvWYkzYBO8fjmhvmci5SZaD1fEwkEsmWGbRJO+jgyRtSjZ6brdXXEYFxPZ7WZlKKGlalepx4GLT5YvgPOnAQ6bb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzaWHK2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzaWHK2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540F6C116B1;
	Tue, 16 Jul 2024 16:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146010;
	bh=+ob5VK95PE8wNKqTHhd9vjswDCOHSEKElBpYw9TQ248=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzaWHK2fPVNxEagLnYZvOxWY3nIDCsB1svcpwg3IJsyYofjXRgveo0dSLmjLcA0DX
	 PNUrEhb9rVJXO93COz/VPtKQWSJ7deDZh2IiCO2VAmDkWrJqkRzuP8km5/2weEeyn5
	 coL0kJ8M9yEp9smrG3Cg5fzREbpdf0VAcB1xMeZ8=
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
Subject: [PATCH 5.15 006/144] scsi: qedf: Make qedf_execute_tmf() non-preemptible
Date: Tue, 16 Jul 2024 17:31:15 +0200
Message-ID: <20240716152752.775249304@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a1a1f4e466609..450b2baf1fd14 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2340,9 +2340,6 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 	io_req->fcport = fcport;
 	io_req->cmd_type = QEDF_TASK_MGMT_CMD;
 
-	/* Record which cpu this request is associated with */
-	io_req->cpu = smp_processor_id();
-
 	/* Set TM flags */
 	io_req->io_req_flags = QEDF_READ;
 	io_req->data_xfer_len = 0;
@@ -2364,6 +2361,9 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 
 	spin_lock_irqsave(&fcport->rport_lock, flags);
 
+	/* Record which cpu this request is associated with */
+	io_req->cpu = smp_processor_id();
+
 	sqe_idx = qedf_get_sqe_idx(fcport);
 	sqe = &fcport->sq[sqe_idx];
 	memset(sqe, 0, sizeof(struct fcoe_wqe));
-- 
2.43.0



