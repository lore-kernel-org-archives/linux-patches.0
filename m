Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C16D50E59C;
	Thu, 17 Sep 2026 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666928; cv=none; b=Bv7awGmvq4nRdil8DilR/97qK6O4X53AxVIWPkt9S/daMItcW/FBdVdFlxGndZKjId/agXJ6M+Ncp24ms8ZBZn/ukGW+yopFi4Kt3IcSsMtCG59OgdfHFlQCU30Qv37mqv6j3yFOuOm5mx0J2hGY/lWpaG0QXTDFdOULDgHkwpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666928; c=relaxed/simple;
	bh=VXaNbm2tF5FZM6SFYRjyRtzSjiwCBF3fmDgnRp7N/Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8WKV/uEtNje4eu2DQnPDWL5GuBqj7+y/4W9+YQ7ubqw14zgrvWCRQvcFLzKcc+zHJXB+9/GNq601wtkTGeWWWvDneIcE+bZICEERZdvkB/72HEuON0Ti1ute33GGZFZSCcBHu9zayaV1QrC+foQhbNGaq8t38/VJLch4Dqpl0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKI3JI9k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKI3JI9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35631F000FF;
	Thu, 17 Sep 2026 17:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666926;
	bh=tJUdwxDjF/sgWQxeqnB2Enms5vxvQxkbl6IF1euy2f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKI3JI9kidcmxFWYoS7bwTrPbTUlZM8ljYtE9TS7d5fI+Bwrr4nMU9bFUNqJAxh7a
	 nRpfM5WMO3t6tXs9dNcOfytqrcUmt9uyTLodeuu5O83jlxanIbQ6x/PAu+KHb1oeao
	 18juXBVR4bcpFErb3ULOaSKAZa69KT0Ic+/ey3gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1171/1250] scsi: qla2xxx: Serialize NVMe unsol ctx list with a per-fcport lock
Date: Thu, 17 Sep 2026 16:16:06 +0100
Message-ID: <20260917151624.024563124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 76da0c43c63eb0496649e372ac64466364d0fe7d ]

The fcport->unsol_ctx_head list is modified from several contexts without
a common lock. Entries are added in qla2xxx_process_purls_iocb() from the
response queue ISR (under the qpair qp_lock), while they are removed from
qla2xxx_process_purls_pkt() (DPC/purex worker), qla_nvme_xmt_ls_rsp()
(NVMe-FC transport callback) and qla_nvme_release_lsrsp_cmd_kref() (SRB
completion). The qpair qp_lock cannot serialize this per-fcport list since
multiqueue adapters add entries through different qpairs, so a concurrent
add and delete (or two concurrent deletes) can corrupt the list pointers.

Introduce a dedicated per-fcport spinlock, unsol_ctx_lock, initialized in
qla2x00_alloc_fcport(), and take it around every list_add_tail()/list_del()
on unsol_ctx_head. The add nests under the existing qp_lock; no delete path
takes qp_lock, so the lock order is consistent and deadlock free.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-28-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_init.c |    1 +
 drivers/scsi/qla2xxx/qla_nvme.c |    9 +++++++++
 3 files changed, 12 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2570,6 +2570,8 @@ typedef struct fc_port {
 	struct list_head list;
 	struct scsi_qla_host *vha;
 	struct list_head unsol_ctx_head;
+	/* Serializes unsol_ctx_head against ISR, DPC and NVMe transport. */
+	spinlock_t unsol_ctx_lock;
 
 	unsigned int conf_compl_supported:1;
 	unsigned int deleted:2;
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5649,6 +5649,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vh
 	INIT_LIST_HEAD(&fcport->gnl_entry);
 	INIT_LIST_HEAD(&fcport->list);
 	INIT_LIST_HEAD(&fcport->unsol_ctx_head);
+	spin_lock_init(&fcport->unsol_ctx_lock);
 
 	INIT_LIST_HEAD(&fcport->sess_cmd_list);
 	spin_lock_init(&fcport->sess_cmd_lock);
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -257,7 +257,9 @@ static void qla_nvme_release_lsrsp_cmd_k
 
 	fd_rsp = uctx->fd_rsp;
 
+	spin_lock_irqsave(&uctx->fcport->unsol_ctx_lock, flags);
 	list_del(&uctx->elem);
+	spin_unlock_irqrestore(&uctx->fcport->unsol_ctx_lock, flags);
 
 	fd_rsp->done(fd_rsp);
 	kfree(uctx);
@@ -446,7 +448,9 @@ out:
 		qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
 		spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
 	}
+	spin_lock_irqsave(&uctx->fcport->unsol_ctx_lock, flags);
 	list_del(&uctx->elem);
+	spin_unlock_irqrestore(&uctx->fcport->unsol_ctx_lock, flags);
 	kfree(uctx);
 	return rval;
 }
@@ -1216,7 +1220,9 @@ qla2xxx_process_purls_pkt(struct scsi_ql
 			spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr,
 					       flags);
 		}
+		spin_lock_irqsave(&uctx->fcport->unsol_ctx_lock, flags);
 		list_del(&uctx->elem);
+		spin_unlock_irqrestore(&uctx->fcport->unsol_ctx_lock, flags);
 		kfree(uctx);
 	}
 }
@@ -1258,6 +1264,7 @@ void qla2xxx_process_purls_iocb(void **p
 	struct purex_item *item;
 	port_id_t d_id = {0};
 	port_id_t id = {0};
+	unsigned long flags;
 	u8 *opcode;
 	bool xmt_reject = false;
 
@@ -1323,7 +1330,9 @@ void qla2xxx_process_purls_iocb(void **p
 	uctx->ox_id = p->ox_id;
 	qla_rport->uctx = uctx;
 	INIT_LIST_HEAD(&uctx->elem);
+	spin_lock_irqsave(&fcport->unsol_ctx_lock, flags);
 	list_add_tail(&uctx->elem, &fcport->unsol_ctx_head);
+	spin_unlock_irqrestore(&fcport->unsol_ctx_lock, flags);
 	item->purls_context = (void *)uctx;
 
 	ql_dbg(ql_dbg_unsol, vha, 0x2121,


