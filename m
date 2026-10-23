Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774024;
	b=YbZr7FOiieC+4aBNzYk8zd0NMii/iGIdQ/4zzn9CjLUd1N40UXFSiM0MqDbtgiNGhhMo
	 vu90fDAb8XrMxPH/lt9Au84JePr4jpzthvSTclBzF2a0d4jKK8iGptCKw+xHhsafHMB3g
	 1vmVHHeyFtcKUBpkxhp8Xp3ijoumUHj0dXOWbVkvurh5u6e6oMmcSEeSC7ucsEeZLFn7G
	 Ktvsp7Dlq+vrmeOqcoQ5BUV96kKgHqWXrakcUcqtV97gmh2tsAXQtG0ZhA1bblxrIRWnz
	 L7rQoYfI5ypo20ojt3qPfCmsc9M2QeUJkHEgxYFC/BDfPcEfsonW+/5K/xlWRCnAbAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2qr4MTUXV9qCWNkHGcflOSNcvBe4DwviaGYNVtW2yO4=;
	b=DMWS/j6yZMwFdVeI8AyCl2lLrvuoNAPzCoiSujt1YCAATH7u2uyrQUU8rxpV0nZUKlZO
	 3CQrs/K2z4a4dEc77jJVp4+cQwB5inBI+5fDRymZxhlsWDvf5me/4Aw/eZTx5rpFyKkck
	 sRoCrlu+Nmj74DorfjIjoqPg8N31K72tCcungF54UuevkltzZkQx7gEcQVD0i5/fdKAYy
	 v6MClIMHyt7or8mp3osjTjoOy4gfWm7FXSXg0itP7zU5Pr02a3Gc7R/YjR3cGba/n+4nF
	 yvDH7U0O13qvF27bZVlSPBK0Epmw3+Fdg3Pvf3WdWPuCJtO5wBtH2PfOEYytg0Q3owQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WE5VZpEk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CAB606A31D;
	Fri, 23 Oct 2026 16:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WE5VZpEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2181F01825;
	Fri, 23 Oct 2026 16:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774023;
	bh=2qr4MTUXV9qCWNkHGcflOSNcvBe4DwviaGYNVtW2yO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WE5VZpEkoTuVqWfboSsOS6I07WM3+cGLkWKQcQC7gBODVKvCuSXfUITx3PKHeqHDJ
	 Iaoj4YnG/tJDF/UBpZt+aLHCUkEDNNTSUOUR7hQe3OKAj20Yc4S8p0LeEBhz1eiQ6J
	 yQM1bOj8DLn7fWxX8A3J+2FXPeITDrWP7cnQtFJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	John Garry <john.garry@linux.dev>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/193] scsi: libsas: Fix SMP IO deadlock during HA resume
Date: Fri, 23 Oct 2026 18:35:34 +0200
Message-ID: <20261023163715.553740834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 81e097a064b28b4a1f6ca1a8b433e659c1bd64c0 ]

smp_execute_task_sg() calls pm_runtime_get_sync() on the host before
issuing an SMP command. When that command is itself issued from the HA
resume path, the get_sync() deadlocks: it waits for the ongoing resume
(the device is RPM_RESUMING), while the resume is blocked in
sas_drain_work() waiting for that same SMP IO to complete.

The deadlock needs an expander-attached SATA disk. During
sas_resume_ha() -> sas_drain_work(), DISCE_RESUME -> sas_resume_sata()
-> ata_sas_port_resume() requests ATA_EH_RESET, and the hard reset for
such a disk is done via SMP PHY CONTROL (sas_ata_hard_reset() ->
sas_phy_reset() -> sas_smp_phy_control() ->
smp_execute_task_sg()). Direct-attached SATA resets through
lldd_control_phy() and SSP devices use TMFs, so neither hits this.

Replace the get_sync()/put_sync() pair with
pm_runtime_get_noresume()/pm_runtime_put(). smp_execute_task_sg() only
needs to hold off autosuspend while the SMP is in flight, and it must
not try to resume the host: a sync resume issued from the HA resume path
itself is what deadlocks, and by the time sas_resume_ha() runs, hw_init
has already reinitialized the hardware, so the device is accessible
without one.

The usage reference is still required. Discovery work normally runs
inside an event worker's PM reference, taken at sas_notify_port_event()
notify time and held until the handler has flushed the disco
queue. sas_rediscover_ex_phy() however requeues DISCE_REVALIDATE_DOMAIN
from within the revalidation worker itself, and flush_workqueue() does
not wait for work items queued during execution, so that chained
revalidation runs with no outer PM reference - without the
get_noresume(), its SMP could race autosuspend.

For the BSG path, sas_smp_handler() is the only caller which may find
the host autosuspended: expander SMP requests do not go through any SCSI
device request queue, so nothing else in that path holds the host
awake. Resume it there with pm_runtime_resume_and_get() and check the
result.

Fixes: 3dbbbf656b850 ("scsi: libsas: Fix HA resume deadlock and hisi_sas disk-wake race")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: John Garry <john.garry@linux.dev>
Link: https://patch.msgid.link/20260928040234.992912-1-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index d953225f6cc24..c9a7a55a5917f 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -62,7 +62,11 @@ static int smp_execute_task_sg(struct domain_device *dev,
 		to_sas_internal(dev->port->ha->shost->transportt);
 	struct sas_ha_struct *ha = dev->port->ha;
 
-	pm_runtime_get_sync(ha->dev);
+	/*
+	 * Non-blocking: a sync resume here would deadlock against
+	 * sas_drain_work() during HA resume.
+	 */
+	pm_runtime_get_noresume(ha->dev);
 	mutex_lock(&dev->ex_dev.cmd_mutex);
 	for (retry = 0; retry < 3; retry++) {
 		if (test_bit(SAS_DEV_GONE, &dev->state)) {
@@ -135,7 +139,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
 		}
 	}
 	mutex_unlock(&dev->ex_dev.cmd_mutex);
-	pm_runtime_put_sync(ha->dev);
+	pm_runtime_put(ha->dev);
 
 	BUG_ON(retry == 3 && task != NULL);
 	sas_free_task(task);
@@ -2162,6 +2166,11 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		goto out;
 	}
 
+	/* The host may have autosuspended, resume it here. */
+	ret = pm_runtime_resume_and_get(dev->port->ha->dev);
+	if (ret)
+		goto out;
+
 	ret = smp_execute_task_sg(dev, job->request_payload.sg_list,
 			job->reply_payload.sg_list);
 	if (ret >= 0) {
@@ -2169,6 +2178,7 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		rcvlen = job->reply_payload.payload_len - ret;
 		ret = 0;
 	}
+	pm_runtime_put(dev->port->ha->dev);
 
 out:
 	bsg_job_done(job, ret, rcvlen);
-- 
2.53.0



