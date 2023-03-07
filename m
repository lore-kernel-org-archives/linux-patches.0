Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0127BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EFAC433D2;
	Tue,  7 Mar 2023 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215205;
	bh=aVaY1fbNa0zmd/iapL/iwFSwYvc3K07kbtfqAEVxxZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUplwAbeipiB73e3iDtKJw51teeMpqF5WDAvfZRvvr7VIOc4+5kw3y8AH5DqzUyWm
	 ilSyAewHn3KC6GdP3dzurCWJhCwHWbH1mkT39HUjUdvPpkR/xdWhiok9W4E3gUN8HV
	 ZtL0OCkaO5TX5szvlHP82juFITogC3xocemT9ulQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/567] scsi: qla2xxx: edif: Fix I/O timeout due to over-subscription
Date: Tue,  7 Mar 2023 17:58:40 +0100
Message-Id: <20230307165913.943389003@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 63ab6cb582fad3757a03f466db671729b97f2df8 ]

The current edif code does not keep track of FW IOCB resources.  This led
to IOCB queue full on error recovery (I/O timeout).  Make use of the
existing code that tracks IOCB resources to prevent over-subscription.

Link: https://lore.kernel.org/r/20220608115849.16693-2-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 41e5afe51f75 ("scsi: qla2xxx: Fix exchange oversubscription")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 8e9237434e8b1..a7e2118b3a841 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2898,6 +2898,12 @@ qla28xx_start_scsi_edif(srb_t *sp)
 
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+
+	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.iocb_cnt = req_cnt;
+	if (qla_get_iocbs(sp->qpair, &sp->iores))
+		goto queuing_error;
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    rd_reg_dword(req->req_q_out);
@@ -3089,6 +3095,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
 		mempool_free(sp->u.scmd.ct6_ctx, ha->ctx_mempool);
 		sp->u.scmd.ct6_ctx = NULL;
 	}
+	qla_put_iocbs(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(lock, flags);
 
 	return QLA_FUNCTION_FAILED;
-- 
2.39.2



