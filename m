Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BFE3203B6;
	Mon, 13 Apr 2026 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099568; cv=none; b=Q6pWAKC5JWRRhptWKZvDvnE4Gz2a8TM1504nfdI0HWfR/ptuCTJIULxI4Y6iQkXtt3U9tcWdaQtfnhkVfcOlHLPge1TTjPna2zZtIQlq+OTKfV49L548eOnHAVZtgRWhdO+YZANZ2o56uQqFp4Umus2bhAsKpjEoPkZdqANlC0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099568; c=relaxed/simple;
	bh=+S+qCoUBjQGErdO6QVEWqbM3nYgo5VvshJiyDKF65fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuPRO8IxEttd5sHFyT632t1jnhxqY9MRByoCsvwmCPpDDSktdYPDUvbW58DOL+P/GTVpM88FLNS06Gn1Xti4Tua4JJn8UTkjW8POxRiY4N3D1fBqBHPwy2ovrliRGD2OHZiWd38QmEN7V9MfRVbi+Y5fKm+VjB1L+qofZqwxmqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoxq7NoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoxq7NoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7DDC2BCAF;
	Mon, 13 Apr 2026 16:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099565;
	bh=+S+qCoUBjQGErdO6QVEWqbM3nYgo5VvshJiyDKF65fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoxq7NoFqg3ARB8Vbh3DsY+CVQj3CMYchcrXlKxlxWFL4lytiuckFab6uImGDnTJP
	 Wlpdjr1zfRZqp0OKANU2/X+5L/iQ/6Yza5aPM42HoLQh63Uc5hZyOGLF0ydjAta8HM
	 ED7aDEzkr8i8sj7VvVH7COOql5ZMGxIbDHvMpmIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 357/491] Revert "scsi: core: Wake up the error handler when final completions race against each other"
Date: Mon, 13 Apr 2026 18:00:02 +0200
Message-ID: <20260413155832.402764140@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

This reverts commit cc872e35c0df80062abc71268d690a2f749e542e.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 11 +----------
 drivers/scsi/scsi_lib.c   |  8 --------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4e9114f069832..ffc6f3031e82b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -241,20 +241,11 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 {
 	struct scsi_cmnd *scmd = container_of(head, typeof(*scmd), rcu);
 	struct Scsi_Host *shost = scmd->device->host;
-	unsigned int busy;
+	unsigned int busy = scsi_host_busy(shost);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_failed++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	/*
-	 * The counting of busy requests needs to occur after adding to
-	 * host_failed or after the lock acquire for adding to host_failed
-	 * to prevent a race with host unbusy and missing an eh wakeup.
-	 */
-	busy = scsi_host_busy(shost);
-
-	spin_lock_irqsave(shost->host_lock, flags);
 	scsi_eh_wakeup(shost, busy);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8d570632982f3..fb48d47e9183e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -310,14 +310,6 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	rcu_read_lock();
 	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 	if (unlikely(scsi_host_in_recovery(shost))) {
-		/*
-		 * Ensure the clear of SCMD_STATE_INFLIGHT is visible to
-		 * other CPUs before counting busy requests. Otherwise,
-		 * reordering can cause CPUs to race and miss an eh wakeup
-		 * when no CPU sees all busy requests as done or timed out.
-		 */
-		smp_mb();
-
 		unsigned int busy = scsi_host_busy(shost);
 
 		spin_lock_irqsave(shost->host_lock, flags);
-- 
2.53.0



