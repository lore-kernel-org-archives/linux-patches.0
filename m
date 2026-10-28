Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215464;
	b=qE122Z6EWqMQ0mROWah/3n/WwM09Jltlc84Db3X2SgUebL5v+Ubk0bRJLfdI3j1JTNxv
	 a8p6vmaxfwFyx4L6MYg9CLmFWjKLc2qFlolVRRYzten3Nv5k5O/d4xKCnuWBrsg5Tt4XA
	 ksQY56mg+ON/CcCn0ERLbNdHOfUFtX7O/pxF7Yn3BmSawy66UzLIWGL2042uDXP/JpJuS
	 DOlhGZkxRAdb8f2VcftTz6uSc/lofJnPgHftJuKhI5sN3j58ZlLGjM+ihwaChzdKsv+Wl
	 XGnsPwbNH5O3uJN43soCpEW5fkwqmvGO7sGvL82PQG7AJJRYNWeGWS4hBOBGtjYRrkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f2whT/UWWSwTn6j1+2XdBOE989yE8VkCs6jitdgQTqI=;
	b=iAid53VkUf+b5sLiipFUQuslsaWlgd8Pf69Ean/zfUcw2O6CGdqG6VlR5DhMP4NPQ2ZK
	 GcEmnbdIsXZLIaU8EBti6K9u5NvDPupYhXhM0DSTJlYp3z3dN5IN7JOcESG9qVY2lY2kG
	 m6Saklbl9eLlrIWIdkorufsnqQUX2tYjvHS8UMz+NtkgrBGkKge4VqQH1dD1St1irkebr
	 qXNed+Ltv2ku2fUo8GGhQRxgSOUMVDsEqS4PUGG9asu66/ClxCMZSF1bJobGUbcRMgyf4
	 OFDHw/8Wq9dumoKtMqVXTryGBKcKvltgulImzfG8QTZQVTk/nyxcfhBY6xLCWiRDk/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EqQ2L2oI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5001D606A31C;
	Wed, 28 Oct 2026 19:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EqQ2L2oI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F34F1F01825;
	Wed, 28 Oct 2026 19:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215464;
	bh=f2whT/UWWSwTn6j1+2XdBOE989yE8VkCs6jitdgQTqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqQ2L2oIJ1eXLBXlZTAHOcPSwxjV5OaGCou6Wwj8AqYJplaNiwCL3IFM1j8ouc91O
	 y7Ui6EdP8Jp5V9jlUh/t4O16zHKIfF4avflv9PRLFnzyPZex+Ke1OCkdQYHnwvxQq/
	 B9mc/OFACyFL4lpg3Di6QjKAZ2F+RSaq10VZDSe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1183/1887] scsi: core: wake eh reliably when using scsi_schedule_eh
Date: Wed, 28 Oct 2026 17:54:39 +0100
Message-ID: <20261028170526.326774460@linuxfoundation.org>
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

From: David Jeffery <djeffery@redhat.com>

[ Upstream commit dccf3b1798b70f94e958b3d00b83010399e6fb05 ]

Drivers which use the scsi_schedule_eh function to run the error handler
currently risk the error handler thread never waking once all commands are
timed out or inactive. There is no enforced memory order between setting
the host into error recovery state and counting busy commands. This can
result in a race with scsi_dec_host_busy where neither CPU sees both
conditions of all commands inactive and the host error state to request
waking the error handler.

To fix this, run the scsi_schedule_eh's scsi_eh_wakeup from a new work item
which will use rcu to ensure scsi_schedule_eh's call to scsi_host_busy will
occur after the error state is globally visible and will be seen by any
current scsi_dec_host_busy callers.

Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
Signed-off-by: David Jeffery <djeffery@redhat.com>
Link: https://patch.msgid.link/20260615174630.11492-1-djeffery@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c      |  2 ++
 drivers/scsi/scsi_error.c | 22 +++++++++++++++++++++-
 drivers/scsi/scsi_priv.h  |  1 +
 include/scsi/scsi_host.h  |  3 +++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 28cf473fcf96d..a280a3fd9bea2 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -344,6 +344,7 @@ static void scsi_host_dev_release(struct device *dev)
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
+	cancel_work_sync(&shost->eh_work);
 	if (shost->tmf_work_q)
 		destroy_workqueue(shost->tmf_work_q);
 	if (shost->ehandler)
@@ -409,6 +410,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
+	INIT_WORK(&shost->eh_work, scsi_rcu_eh_wakeup);
 
 	index = ida_alloc(&host_index_ida, GFP_KERNEL);
 	if (index < 0) {
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f6d3f35647636..8063ec6c82645 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -73,6 +73,26 @@ void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy)
 	}
 }
 
+void scsi_rcu_eh_wakeup(struct work_struct *work)
+{
+	struct Scsi_Host *shost = container_of(work, struct Scsi_Host, eh_work);
+	unsigned long flags;
+	unsigned int busy;
+
+	/*
+	 * Ensure any running scsi_dec_host_busy has completed its rcu section
+	 * so changes to host state and host_eh_scheduled are visible to all
+	 * future calls of scsi_dec_host_busy
+	 */
+	synchronize_rcu();
+
+	busy = scsi_host_busy(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	scsi_eh_wakeup(shost, busy);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
 /**
  * scsi_schedule_eh - schedule EH for SCSI host
  * @shost:	SCSI host to invoke error handling on.
@@ -88,7 +108,7 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
 	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
 	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
 		shost->host_eh_scheduled++;
-		scsi_eh_wakeup(shost, scsi_host_busy(shost));
+		queue_work(shost->tmf_work_q, &shost->eh_work);
 	}
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 9b5fb30e684be..459dfbdf64fde 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -87,6 +87,7 @@ extern enum blk_eh_timer_return scsi_timeout(struct request *req);
 extern int scsi_error_handler(void *host);
 extern enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy);
+extern void scsi_rcu_eh_wakeup(struct work_struct *work);
 extern void scsi_eh_scmd_add(struct scsi_cmnd *);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 149b63e3534ad..71d47d4ec04d9 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -704,6 +704,9 @@ struct Scsi_Host {
 	 */
 	struct device *dma_dev;
 
+	/* Used for an rcu-synchronizing eh wakeup */
+	struct work_struct eh_work;
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
-- 
2.53.0



