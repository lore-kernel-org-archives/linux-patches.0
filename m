Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208540;
	b=U7G19VQrUvBPfcRCxDPCQMU1ZxQlU5wdlccUcfBgdjyqTGn7cIdEMgyyOyXdzEzaf1bx
	 t84evCKFljZ3/XK9RzhLDhsMTjlMKqskhUs3h4UlrKSLpHrwVH/N/puf0MifjUQ3Vj8DG
	 1r7PJGU/IttVn0kn9GB0fzwsxSkzdApVdyHFT+lAi1mlNb+exo2zUUnxPeaz8xWSzafOd
	 JrT7QkmA/fZY3TKlJfRErl61+ABeDVZLsqrqTV1rKoAKAONUwd9X55uVTgmQLvjfuyjbv
	 FgUI+G4FhpdKjep6wJLSTPXhjtIkEUpEPE+SvfiURd1sQ1brItjKLcJrmFpIg33V2bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XyFhPBVKvIizCGoH6MkVPbuMIzSHe7AfNHIEfc1yNnQ=;
	b=DXyHK26l8imczNo78Qm4hpqZo202MAeIuAz1DMLbrf9S3OAaNrIAktUnMS5KnxkS0gdI
	 gmwhQUZ7NVF8ffsrqmmMvyRgCQJ0LMBKOMgZ93O29TReEPBexefysrLcfSsnQi/K81Ic3
	 Y3PeVqTS7cCwOsOPePJtxDcY38FYi+gSHfgC84adExlUzfO0d0Oe7t0nnRAxYv+W+91/3
	 x8UVaqWWfgqyplBYXUe/T5wm+Ev/0/rJ6P/BdWicsuhHteU8ZLd5Z2mKK3lW+pyC0qIFL
	 bposehasugPdpAa0V5jIcYA9C9ISvJe3e5fRE7XIiG6c0gf4Yz5gHza+MwPN7zXLhLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T/yySRW9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE7A606A31C;
	Wed, 28 Oct 2026 17:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T/yySRW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0751F01825;
	Wed, 28 Oct 2026 17:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208539;
	bh=XyFhPBVKvIizCGoH6MkVPbuMIzSHe7AfNHIEfc1yNnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/yySRW9pyJFCPZVzWQoRdCS9IAFUm2hmWn4OpzK0e36oSGxglzAkt+OArkiO7j+0
	 CrPoD/bKdCSPKXeC9SYIFm3VFR5LvRNJ4xK0Ctz6SojsI8745wfNaLaBmlAaDMcHQc
	 LisRponcfihH+EyyTQOSFmFQaI5xYaTJDawaFPLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/516] scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort
Date: Wed, 28 Oct 2026 17:55:08 +0100
Message-ID: <20261028170007.202039303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 45fa0e2b78353..f00227de9c67d 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -278,7 +278,8 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
@@ -361,7 +362,8 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	}
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
-	schedule_work(&priv->abort_work);
+	if (!schedule_work(&priv->abort_work))
+		kref_put(&priv->sp->cmd_kref, priv->sp->put_fn);
 }
 
 static inline int qla2x00_start_nvme_mq(srb_t *sp)
-- 
2.53.0



