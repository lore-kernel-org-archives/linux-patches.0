Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D203250BF2;
	Wed,  9 Sep 2026 14:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964160; cv=none; b=jw+FQJog5HWhDpqixj0gt+X606T6LPH8sTuFsS0NZLArI/KX3iAPEn9H/1sLO9drP1Jgt4UCJ+UPdqd7Kw+sviwTk24C4iQbYABUyBl+jZI/TcooTC+q+7MSEbCWmIXmLAEHZBZVt2rz4v/eBa7YpSMLO+MKW0qLouYe9BTsDEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964160; c=relaxed/simple;
	bh=zKIVUDc0rrOT/cUJwR5H9C/3taE0mtv4wDdVOmU3ewQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sItBv9FMViI3oLUUtwPe3Tes66oj1RmABbsGamn/nJcxDuvtbqE/HSuucsaZT54eDitiCopy9PI6rf4hlPCsHyi1zn/+dqgDeY/j2KOjdrcbbPzcqOTD4ZJ6+KOsEfH7XdnNyskYyA5qkLAqXy/rkJSCiz8rdOLfaErDmFJLHf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Og99a2lj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Og99a2lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62601F00A3A;
	Wed,  9 Sep 2026 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964159;
	bh=3GgR0gWWhyEwONPbm8i7qL41E+fVBLVJseu9XijOTKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Og99a2ljBBgdC9vbYh5r2pBknxT2BatElS6vgi0VBMVkEXGLaDEcqRSf0S9GWEqld
	 feA8f1zsVVZ9lAocQBhruDL3+mn4LAbcczLhE/9/hCdHBBVlHtIqnDa0TRyCoPtHS8
	 fN15jS31scxuB7FzB6xvTCz6JpW2krhMLkyyU49w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 328/583] scsi: qla2xxx: Initialize NVMe abort_work once at submission
Date: Wed,  9 Sep 2026 15:40:13 +0200
Message-ID: <20260909134249.362429070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

commit 7e85f6dbc85616de2172bce8eaf84b387a723cd1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -463,7 +463,6 @@ static void qla_nvme_ls_abort(struct nvm
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	schedule_work(&priv->abort_work);
 }
 
@@ -501,6 +500,7 @@ static int qla_nvme_ls_req(struct nvme_f
 	priv->sp = sp;
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
+	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	nvme = &sp->u.iocb_cmd;
 	priv->fd = fd;
 	nvme->u.nvme.desc = fd;
@@ -545,7 +545,6 @@ static void qla_nvme_fcp_abort(struct nv
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	schedule_work(&priv->abort_work);
 }
 
@@ -811,6 +810,7 @@ static int qla_nvme_post_cmd(struct nvme
 
 	kref_init(&sp->cmd_kref);
 	spin_lock_init(&priv->cmd_lock);
+	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
 	sp->priv = priv;
 	priv->sp = sp;
 	sp->type = SRB_NVME_CMD;


