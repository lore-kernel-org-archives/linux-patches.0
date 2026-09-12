Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F208122A7F6;
	Sat, 12 Sep 2026 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221984; cv=none; b=DxskhJakkc0rsE1NLLcnF1MjClacKVYCqjmGpIHJ+7zzIHJw1IVheOzMRsXIae5DCN+O85U34qKikij52fKBbpXBEkGaYYL038dfoufqYDmDHBdNoaUCVSKKuHH63oir+Lz79emPqfEOVgYu553zqnyLQwcoqRjoX7iq1vfuleI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221984; c=relaxed/simple;
	bh=/FQ3K/H27Gn14+SrjRcyjH54KbdwSfz1LiVVPzhgjoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKYpe07jVuyZF1mwFmi9uhzMsZxY8viyAOpmGNeLH+J/NOLYGQL9yZBFgYL1EkrBRKp9qDrXBVyNabTxY7TA+E+SYTPSszwCpDRbmXZ9uLkDp1DSkOOvmI0xvWcVy2Dp9ZhVJ4VYhlGFdivRQ7+4Xcf971YosLO+KILUz8hq5i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vra/kDgp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vra/kDgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAE41F000FF;
	Sat, 12 Sep 2026 14:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221982;
	bh=mbEgxyEAtWiOT58ZgIVAIWEma6zRU5XFbSYrWxvLfYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vra/kDgptFo1+RYWXqLvtKbEdvR1B1VVw5tgRogJrYVNufyWE/S2dZ3RlUomGmwpV
	 JLNMcUb6z/TENNJQvZVJO51JvO05bj9vRlH4VnSuKe8qWDUWpy8k3iwt9u0fhOIP3B
	 DVjPuyDW4k9C2hYmhvs2E2L6KwxHlmCoGL6Xq7FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 0495/1424] scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort
Date: Sat, 12 Sep 2026 08:48:47 +0200
Message-ID: <20260912065618.376930558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -467,7 +467,8 @@ static void qla_nvme_ls_abort(struct nvm
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
@@ -549,7 +550,8 @@ static void qla_nvme_fcp_abort(struct nv
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static inline int qla2x00_start_nvme_mq(srb_t *sp)


