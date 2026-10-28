Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210809;
	b=1pRW5+kuXtxHAf5qX3y7ykfkPSR8OItVzqohzCb2f1b/MYgC8Vb7PvmtgXGLjt4eS8dh
	 Hj6ABkcUKR7a8csNEVh2iphtdPfo9ULBVPMRX9UlwXXOuGUrpXwAJPbr9PKrkTeC711z5
	 ywIiRndsY0MS11O2NWiEeV0Tzl+aozmCUzvnEevPcwwExQNwOoySTCtJp26V8BZpMHbUQ
	 JDP02QrNAWV2FdKl9yLUUvUCvPHsLhtLwH3kIn5tdth7d10YZWh/Dwgxl9i+wMGZ3NFCU
	 Gz4NAVCPGk8OcPWW35Q8dFduriwYf2tA8dJyfxNI5nOj1m6AY36s194qIJzChHBeLsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lAZ3T32kmiNlAAF15xdxx2m8c3yCVpWH5Py/8hjSI7g=;
	b=WJfe40HIbl39K+NC0q2FNlasq+/Ity7c/Cmi216Rnshhzzp7rADGviD6Gf3Sgls42gEA
	 5smUq/xPk+ZCv9INN8QtHIjAape3ItYagYfh+eCeCF0vl4JVWp7ugq0cT8pMn80E+6+AI
	 /VrpzMhT/YUIePtNcE7GpBM5qGKVSAmRqPI5qlb2VMCcTNfNXpKHsPyKTmSUGufFLkCWw
	 Jrxsp3K/QXx/3wknS0L0DV+2MnRu9rFchqFZ4LimbH84nQAL6JSJTv0Hgq+3USfbCTT89
	 P49eE0gEXiS2/Fpn7ZVRpq64AWqcb/zmvvxON/vBhmTzBqhindeo5IObG/SJrjy3YjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOuQptsO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D656F606A31C;
	Wed, 28 Oct 2026 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOuQptsO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026601F01825;
	Wed, 28 Oct 2026 18:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210808;
	bh=lAZ3T32kmiNlAAF15xdxx2m8c3yCVpWH5Py/8hjSI7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOuQptsOth1S2zLdgI1ePiX+g4TOxA4vlJg9o5Kj30FKqx7fWccdbj3v/BsYkmIXa
	 Mf0GPqX4PSQadI7UeoVTv1ZQ8vUnzUOD2AQjxQrnAgS7cuvXmB9UyHg2G6BAqeLUXy
	 tlmA2dJlDSZyVEESQQAlMGL7afuVodj7WL8yKotU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/571] scsi: qla2xxx: Initialize NVMe abort_work once at submission
Date: Wed, 28 Oct 2026 17:55:03 +0100
Message-ID: <20261028170011.717500923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 7e85f6dbc85616de2172bce8eaf84b387a723cd1 ]

qla_nvme_fcp_abort() and qla_nvme_ls_abort() ran INIT_WORK() on
priv->abort_work immediately before schedule_work(). INIT_WORK()
reinitializes the work_struct, resetting its list head and clearing the
pending bit. If an abort is issued more than once for the same command
(for example, concurrent transport teardown and a timeout-driven abort),
the second INIT_WORK() reinitializes a work item that is already queued,
which can corrupt the workqueue list and lead to crashes or a looping
worker.

Initialize priv->abort_work once at command submission, next to the
existing per-command spin_lock_init(&priv->cmd_lock), and leave only
schedule_work() in the abort paths. schedule_work() already does nothing
when the work item is still pending, so a repeated abort no longer
disturbs an in-flight work item. The command is not returned to the
transport until the final kref_put()/release callback runs after
abort_work has completed, so the work item is idle before priv is reused
and the single submission-time INIT_WORK() is safe.

Fixes: e473b3074104 ("scsi: qla2xxx: Add FC-NVMe abort processing")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-52-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 9746f6debdcb4..f286254ec7750 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -304,7 +304,6 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	schedule_work(&priv->abort_work);
 }
 
@@ -342,6 +341,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	priv->sp = sp;
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
+	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	nvme = &sp->u.iocb_cmd;
 	priv->fd = fd;
 	nvme->u.nvme.desc = fd;
@@ -386,7 +386,6 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	schedule_work(&priv->abort_work);
 }
 
@@ -646,6 +645,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
+	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	sp->priv = priv;
 	priv->sp = sp;
 	sp->type = SRB_NVME_CMD;
-- 
2.53.0



