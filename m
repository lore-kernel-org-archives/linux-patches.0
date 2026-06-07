Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E69E1E98E3;
	Sun,  7 Jun 2026 10:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826985; cv=none; b=SoRqmOWW+JRML1mv5Y/S0iYWcD0ff6XYENa/57aaPVFLOj4Qtg/2SgjGHfxiZGloPQ7z5Yom7HnUfd1TDkNXMJGO554w2h+Cj76xG8sodPWuYcaR9k056WxaqVvIUHNPb/XEddpf2IXVTYMfnYHslXy//LyfnyLIWBy+FTT72g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826985; c=relaxed/simple;
	bh=iBiUnP2x21hwy3rOCuyzv2hDYC19xUxXtt58nnd4lNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcrC5ivKPeinMr3Rz4wG09u9xYcNMEx5UeFCIuUmdJViVDMl45VIFzLp82kXdE0Cts++pmg6z4dcP6V84CYO/dox3bGL/VmPO4/WtpkRQODJHkZwkJzWZypPcKbGmS2ZIL04L4gZOfPalsTlGxLw8i3DFefKrD9m0o6hikVx6bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Or2I3UTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Or2I3UTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F021F00893;
	Sun,  7 Jun 2026 10:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826984;
	bh=ol6dp+oi84BRRHqTxyeBdMxOs2ptSiqz4iLdGAx+a9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Or2I3UTzjcl/8ei7VeUibVz1s+yYVTDrAZ7b4UsNTO6YyfudPXfOOhPcvOoCLOT3A
	 gXLkXhhPeBoMvJ4/R2QIJ+6mjS+81+LAuw4c14TGljQKb+g1ze6cxRBj0o9/jm0qXo
	 uLSmX2SFS8VwYioRsjNLOYVdSs994en7831kx1Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 029/332] scsi: core: Run queues for all non-SDEV_DEL devices from scsi_run_host_queues
Date: Sun,  7 Jun 2026 11:56:38 +0200
Message-ID: <20260607095729.159355138@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

[ Upstream commit 7205b58702273baf21d6ba7992e6ba15852325f7 ]

While a SCSI host is in a recovery state, scsi_mq_requeue_cmd() will not
set the requeue list for a requeued command to be kicked in the future.
The expectation is a call to scsi_run_host_queues() will kick all SCSI
devices once the recovery state is cleared.

However, scsi_run_host_queues() uses shost_for_each_device() which uses
scsi_device_get() and so will ignore devices in a partially removed
state like SDEV_CANCEL. But these devices may also have requeued
requests, leaving their requests stuck from not being kicked and causing
the removal process of the device to hang.

scsi_run_host_queues() needs to run against more devices than the macro
shost_for_each_device() allows. Instead of using the too limiting
scsi_device_get() state checks, only ignore devices in SDEV_DEL state or
when unable to acquire a reference. Attempt to run the queues for all
other devices when scsi_run_host_queues() is called.

Fixes: 8b566edbdbfb ("scsi: core: Only kick the requeue list if necessary")
Signed-off-by: David Jeffery <djeffery@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260515180941.9698-1-djeffery@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d3a8cd4166f92f..1da52f07d299b5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -574,10 +574,33 @@ void scsi_requeue_run_queue(struct work_struct *work)
 
 void scsi_run_host_queues(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *prev = NULL;
+	unsigned long flags;
 
-	shost_for_each_device(sdev, shost)
+	spin_lock_irqsave(shost->host_lock, flags);
+	__shost_for_each_device(sdev, shost) {
+		/*
+		 * Only skip devices so deep into removal they will never need
+		 * another kick to their queues. Thus scsi_device_get() cannot
+		 * be used as it would skip devices in SDEV_CANCEL state which
+		 * may need a queue kick.
+		 */
+		if (sdev->sdev_state == SDEV_DEL ||
+		    !get_device(&sdev->sdev_gendev))
+			continue;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
+		if (prev)
+			put_device(&prev->sdev_gendev);
 		scsi_run_queue(sdev->request_queue);
+
+		prev = sdev;
+
+		spin_lock_irqsave(shost->host_lock, flags);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	if (prev)
+		put_device(&prev->sdev_gendev);
 }
 
 static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
-- 
2.53.0



