Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210814;
	b=ess4baiORiUzlHUCEni308euKwxsBi+xQwTHosUmHKEfvc/BF2en6Gorlzo5HJOx+xl/
	 KAyLvfNPZA+f4E3Htrs6KVONlX5Ybk1n2JW6mJzTqrMPXc0L7resC0poY5Q0Zn+ISN9s+
	 5eNldJIwJznnO411JB/rnxICPwJU2O7CTgER8vtuE+UiW+0zCYQf+S0DJPFOTyNs08DlC
	 QuMKflRqZDxtJDckJaq+aWIHxmenVeglyOxD8OWnvzY8T3YIH5rLZ2C/Me4A0flKa148T
	 fVe4a2RsxECWi2aNMc8wzAQS+0lTddKDmlR0JKJIULDFr7Q6VBBiyfBS+9bjQLL/jqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nMXlOsFAEirtTcSrNKFyUah+nAF3Cd0mSDQHtGrdcgE=;
	b=1J+i00vgwGvUwiI0Vi7tdNbIs2sXFObf8OqlAIMieblK453rtSQ/7xbKh4ZSG1C7JOVC
	 nBjAKjhleQcsGTdvRu8vjZqd/zg9/mFQSHzHjeTNh/4LpNJDHQxC1HYLYqgoJX2lBs67o
	 p56k+m7ZtS6FJjIiEui1R5zvTmfVX09rxGqT3cvgjLLrzIR46RVh3jfTe71TMTEyJZYnX
	 D/z26GqARHqSMbw9tud8uFDpv3MML+34a3hGGTIdqGjUOSsR0q5pzVeqBxy22vJWDA2W8
	 eCfe4hXo9n5Ug1N1qzOZS79cAg0HHfTmWU0L7iEZtr/lAChEwiJfTA8aSQ0hbGnFROA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4d99ahg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6885D606A31A;
	Wed, 28 Oct 2026 18:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4d99ahg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A091F031E0;
	Wed, 28 Oct 2026 18:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210814;
	bh=nMXlOsFAEirtTcSrNKFyUah+nAF3Cd0mSDQHtGrdcgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4d99ahgz+jqTd4DOD8Ku0mLI81xEo6L52X/h6aBNTjCC3cfbvu9usWVtUnlAdi6D
	 MLd7xfe1C3NKZP8FEx9OPeSCCDavVtHhp9WGoC+MH1ujC4tAkPZYmFuajla4GrzymS
	 V2ZjIJq6tWpgkLkXgNTFGpFaBuCFvZcKAqhz4Qls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/571] scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort
Date: Wed, 28 Oct 2026 17:55:04 +0100
Message-ID: <20261028170011.741410948@linuxfoundation.org>
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

[ Upstream commit 06b5b2a5d499323f1c3256ead35798e8e3d15e60 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index f286254ec7750..84caaa188000b 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -304,7 +304,8 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
@@ -386,7 +387,8 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static inline int qla2x00_start_nvme_mq(srb_t *sp)
-- 
2.53.0



