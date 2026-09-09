Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E7756852B;
	Wed,  9 Sep 2026 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962869; cv=none; b=c5QpvmROqAHQCaKdUxyCiisQNQgBnBdIApsape5u5vbJwdFCH7DYwf7PRl8R0xzjAo2evVQuC54ujuoKFZaXmdFStG2tWnK8PY0NFS1vrkBtJ7VvflVf+slnxmYWihN9ja6jpOGBBj+KYEtaQEf3FGL4Q1uSdJ5iIt+EKK+Cu1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962869; c=relaxed/simple;
	bh=+fFX/V99vh2ET8YKzfB9KqUG8hkU1h4qSrDAODM4Qu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpT7f99rUIqZrNBTHoF5zRXIbsduq5qegoROdyXx+tlTeQN7on5L7SyyzWRBISWla3m8JXkOUpxc5m/ShHYObOdaB7NF2ZlormH/Y2Lp6oOaX1O19FOVSM555XFArF1dsCLDFttKx0Em3IsmQVUU2DxA3bl2O6RPdIPKfD7tvEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmlEGHOg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmlEGHOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827A21F00AC4;
	Wed,  9 Sep 2026 14:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962868;
	bh=dHnVzPJTX1nPmbZgjxf0fyORpVK2nLg1Rxf0phtbgwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmlEGHOgk9T1pxybF9Ngj7a1kBpzpeL+td8efOJ+ArezOAj/MNP5TErrke9PvKXd2
	 O9c5IlhoC29MbE7l2cQ3ofTM2MIUgf5V99MrYFHmrO92BW4GyfUyPF3NpwbBIg4z9x
	 pL9RClDEleniBbyOVK5bbVogRihSD4Dzk1sYiGMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 440/556] scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort
Date: Wed,  9 Sep 2026 15:42:00 +0200
Message-ID: <20260909134246.085122130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit 06b5b2a5d499323f1c3256ead35798e8e3d15e60 upstream.

qla_nvme_ls_abort() and qla_nvme_fcp_abort() take a command reference with
kref_get_unless_zero() and then call schedule_work() on priv->abort_work,
ignoring its return value. qla_nvme_abort_work() runs once and drops
exactly one reference via kref_put(&sp->cmd_kref, sp->put_fn).

Since the per-abort INIT_WORK() was moved to submission time,
schedule_work() now returns false when the work is already pending, for
example on a concurrent transport teardown and timeout-driven abort of
the same command. In that case the reference taken for the second abort
is never released because the work still executes only once, leaking a
reference. The command is then never returned to the NVMe-FC transport,
which can hang the port.

Drop the reference when schedule_work() returns false, so each
kref_get_unless_zero() is balanced regardless of whether the work was
newly queued. The held reference keeps priv->sp valid for the put.

Fixes: 7e85f6dbc856 ("scsi: qla2xxx: Initialize NVMe abort_work once at submission")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-25-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -466,7 +466,8 @@ static void qla_nvme_ls_abort(struct nvm
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
@@ -548,7 +549,8 @@ static void qla_nvme_fcp_abort(struct nv
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static inline int qla2x00_start_nvme_mq(srb_t *sp)


