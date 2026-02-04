Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D07271A9A;
	Wed,  4 Feb 2026 14:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216388; cv=none; b=EPTU9Bz5ol3aYHztj5V5z7BEvPdFTzHQi9B4qPnGnA+XTINdg33vvPRQu3u8TJTGNd3WCnKQRizsG1v3kZgbnv6teLmEMQM0+tjGb8bkL1Pb3M8j686rHjV4JK8Oewl7ckG6lR0izJASLj2csinWaY91J7J7/HvMfqn8rfermGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216388; c=relaxed/simple;
	bh=3e1ooq9sl/MtxfamVXFVP4zGDEzuFLGad77lwpbgDVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3PMcxO9Ag/+3wtYe+nYLaOaIlEnkRtQ4M7P/eOsy5B6MYwmlmeBubbBM/o7idyP/io9cfncO5PMMogmy53+7XNMFGE0Yz0WtjRx5/OS6IWv4bEwfKjtCYTIjEqg5QGRL4Q3Wn0Ydo8MVgpQlstcgszJJUYQcMUMR6w3VFgJ2cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9SlRHU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9SlRHU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A31C4CEF7;
	Wed,  4 Feb 2026 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216388;
	bh=3e1ooq9sl/MtxfamVXFVP4zGDEzuFLGad77lwpbgDVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9SlRHU5bZk6OSa42gPh7cSAFqem1hiVpXb7O/6K65QaG8yvB31lIDULg4he5PDUb
	 mNxPRHSA0RSO3DY/O8juXdNzrlbl2NMcFiJUEFNmGjXjjYfGMX3M5Pp2bBfXOCy915
	 cm2g+PV1LBIK3J1n7KpIupIzRO9ECWmJAEKNfmFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/161] scsi: core: Wake up the error handler when final completions race against each other
Date: Wed,  4 Feb 2026 15:38:57 +0100
Message-ID: <20260204143854.417132309@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

[ Upstream commit fe2f8ad6f0999db3b318359a01ee0108c703a8c3 ]

The fragile ordering between marking commands completed or failed so
that the error handler only wakes when the last running command
completes or times out has race conditions. These race conditions can
cause the SCSI layer to fail to wake the error handler, leaving I/O
through the SCSI host stuck as the error state cannot advance.

First, there is an memory ordering issue within scsi_dec_host_busy().
The write which clears SCMD_STATE_INFLIGHT may be reordered with reads
counting in scsi_host_busy(). While the local CPU will see its own
write, reordering can allow other CPUs in scsi_dec_host_busy() or
scsi_eh_inc_host_failed() to see a raised busy count, causing no CPU to
see a host busy equal to the host_failed count.

This race condition can be prevented with a memory barrier on the error
path to force the write to be visible before counting host busy
commands.

Second, there is a general ordering issue with scsi_eh_inc_host_failed(). By
counting busy commands before incrementing host_failed, it can race with a
final command in scsi_dec_host_busy(), such that scsi_dec_host_busy() does
not see host_failed incremented but scsi_eh_inc_host_failed() counts busy
commands before SCMD_STATE_INFLIGHT is cleared by scsi_dec_host_busy(),
resulting in neither waking the error handler task.

This needs the call to scsi_host_busy() to be moved after host_failed is
incremented to close the race condition.

Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
Signed-off-by: David Jeffery <djeffery@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260113161036.6730-1-djeffery@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 11 ++++++++++-
 drivers/scsi/scsi_lib.c   |  8 ++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ffc6f3031e82b..4e9114f069832 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -241,11 +241,20 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 {
 	struct scsi_cmnd *scmd = container_of(head, typeof(*scmd), rcu);
 	struct Scsi_Host *shost = scmd->device->host;
-	unsigned int busy = scsi_host_busy(shost);
+	unsigned int busy;
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_failed++;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	/*
+	 * The counting of busy requests needs to occur after adding to
+	 * host_failed or after the lock acquire for adding to host_failed
+	 * to prevent a race with host unbusy and missing an eh wakeup.
+	 */
+	busy = scsi_host_busy(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
 	scsi_eh_wakeup(shost, busy);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fb48d47e9183e..8d570632982f3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -310,6 +310,14 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	rcu_read_lock();
 	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 	if (unlikely(scsi_host_in_recovery(shost))) {
+		/*
+		 * Ensure the clear of SCMD_STATE_INFLIGHT is visible to
+		 * other CPUs before counting busy requests. Otherwise,
+		 * reordering can cause CPUs to race and miss an eh wakeup
+		 * when no CPU sees all busy requests as done or timed out.
+		 */
+		smp_mb();
+
 		unsigned int busy = scsi_host_busy(shost);
 
 		spin_lock_irqsave(shost->host_lock, flags);
-- 
2.51.0



