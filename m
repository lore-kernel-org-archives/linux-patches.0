Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212598;
	b=e1laA8Nlekx0FUNafvgI/fYq6aNQZ2lQC4i/jfB/pujxmzoQ+1ugMe9GH6q/0rMs3XZx
	 YhyQKOkX1Ra5AScyfJBr4IqHl0p1vdHuns+LOQewbZes7Rdi7i4pVYtDeP5Mu+7MN+aqB
	 maAWjXP3PgnzFYXYNYwekq5T6rETiKbuB6mV1nM662QmceRilZgUPdAfwOty1V5ZoDY+c
	 KR0P2XKtSYuqAf3eik/pKtZC5qKAscmm8U17bZSn5THbeb5QjU+jmm7+cc6LiWF22Ae+x
	 AW3Fi6mJpuXyJ/HklZMhlxuJ0i9UchG/u4PO8thJY27mCnSMIZd2ho1huzCwzi+nRbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jIhnowrRP7jx47+O4BRVHpUHfu0RZcBjJ6xZKQ9ilcw=;
	b=NboN3uHLuHK8KjSyT59nHyfCE/20djdFVJWapgCmr8AsHwKUeMfNqFOrzCpL/M8a5YcZ
	 Gb68R9Y6yv3UaF+Y6favn/hkmqT0fWvIXpKuJ7syb8aZ54oldMGPlldv8c4N7c8zvneeb
	 IhStJ73v4pWMgZ5PIvik+WrV1MQctZuKwyu41+jIlVndtGfkP2TtgRcQwSccHQt+FkYBs
	 me2askWO2nP9WTxylOPFCURLWXT96F3ww6LixCK4jYHskdPKzWyaIrvmG6dJmfuikhZfH
	 DziA1IcH+49kMuPWtKOCHXLLvU1hPndBb+eYbWYYckgFSjDkWvqECRveHJMJDSODXSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06kMW4SH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA74606A31A;
	Wed, 28 Oct 2026 18:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06kMW4SH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B901F01825;
	Wed, 28 Oct 2026 18:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212598;
	bh=jIhnowrRP7jx47+O4BRVHpUHfu0RZcBjJ6xZKQ9ilcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06kMW4SHPDkwNnjLlnP9/roLzyj2G7v2JmoFj1ISvvT8E5pKYcEm1CLZIjE+Jyywq
	 rePHc9DzXb0DSJX9pet2DEGGR0eS+dVdAI4iUOWb8uwdoNsthTayrckui/g+uGh63u
	 ej6qQLZXIeGL+xKs9X54PxppZRNjiGvnYPDfpsFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0211/1887] scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort
Date: Wed, 28 Oct 2026 17:38:27 +0100
Message-ID: <20261028170504.034967076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2c1b17a594206..20a904142810c 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -309,7 +309,8 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
@@ -391,7 +392,8 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static inline int qla2x00_start_nvme_mq(srb_t *sp)
-- 
2.53.0



