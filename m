Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065223;
	b=XrudTQFrMK0xZvMbvJzD0Cj/ZX4XmM0HgsRh0SN92T7AkaVyeBdtlqOW9+xgttIK9gqe
	 iVYWJMnAHxKq2nxW5SP/B0LlF9Lrkgz0Dg5XyKr3Xkk63zeh0tbKJtLwaMZE88/JiCGNd
	 Gw0fHBGjHkbPLGxj2reFsyoiGu6NRIVAnJt4f5tYmsDwryqZ0c3yD0JBPlj0Z+CubdkFZ
	 3d3UrrGc6WtcZDzRvKPhA6kk0+3GTnzE2FhCHRnVurZcFXVKYH6L0rJ23AnH3rxI/QMXW
	 CX6cs/FX8zl2gadUz/2W4DNUjUev1fAnEhCpt3r41EMzWV7bVZ12uMxgVOrqVplKefA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qRE3a11SwexEY0ZXErZ9u8uOMqziQOqYduOluuKcKa8=;
	b=xp6810FPcRwtcZyFwQRwhHLTaDjH3YvBM8GV+gDuPM1ZvRLozxjayGyrUZKs0qCa1jM6
	 Lc7sBcXT06tTv6KWw1k2uIxMqiGlREoEghjIr2TM1MfynB+K73C5TpNL5sOFEFKeaKo2u
	 SIjpcFJVPV8JfEqK1b6TEQ00PUrxiocol4q8IUCXqaLMaNk13juFYWxcAVCO/qG72MMlj
	 Ewz9yfr0rwbNX+nOKAzNqQYKbDrRSm9j65zd5BXf1kpuOo6a3iAUQyjCjv28BjaSf+o92
	 NEi4W9PjqmLpUoDUjX8uOa2pPqyoh7eTV9fGz93bnlrYL6/9o93lQ6vjeRq41B5zDew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCccJg9l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D97606D805;
	Sat,  7 Nov 2026 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCccJg9l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BB61F0089F;
	Sat,  7 Nov 2026 15:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065223;
	bh=qRE3a11SwexEY0ZXErZ9u8uOMqziQOqYduOluuKcKa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCccJg9l+xwNhjM3HgPL8qwbynOcSACHZ99H/fLmON0GTqRxIQKEUC7+NbXUiJRvv
	 aBF/X18ssF+hNttUsNDJRJyX9ofWleIsagQN4UFpJYh5vO0vTOR0/mIlAoQdyw/v0x
	 ugYtDFEYJ0SOTraphmNlwJtIkz+eViOXEjjv9S+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1014/1257] ata: libata-sff: fix race between IRQ deferral and ata_sff_flush_pio_task()
Date: Sat,  7 Nov 2026 08:55:10 -0500
Message-ID: <20261107135007.342194555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 69be770908ae57354a41d7e1cc99ab46278d2e86 ]

Commit 4a2e5409472e ("ata: libata-sff: don't busy-wait for PIO data-in
command completion") allowed the interrupt handler to queue
ap->sff_pio_task from ata_sff_hsm_move() when a PIO data-in command is
still busy after its final data block.

ata_sff_flush_pio_task(), however, was written under the assumption that
cancel_delayed_work_sync() is enough to prevent sff_pio_task from being
queued again before the HSM state is reset to HSM_ST_IDLE and
sff_pio_task_link is cleared.

The flush runs early during error handling, at a point where the timed
out command is still active, the port is not frozen yet, and interrupts
are still being serviced.  If the final data-block interrupt of a PIO
data-in command is serviced in the window between
cancel_delayed_work_sync() and the reset of hsm_task_state, the
interrupt handler queues sff_pio_task after the cancel has completed.
When that work item then executes on ata_sff_wq after the flush cleared
ap->sff_pio_task_link, ata_sff_pio_task() hits
BUG_ON(ap->sff_pio_task_link == NULL) while holding the host lock with
interrupts disabled; alternatively it proceeds on a stale link while
error handling owns the port.

Fix this by resetting hsm_task_state to HSM_ST_IDLE before cancelling
the work item.  Once the state is IDLE, __ata_sff_port_intr() can no
longer enter ata_sff_hsm_move(), so the interrupt handler can no longer
queue the pio task, and cancel_delayed_work_sync() drains whatever was
queued before the reset.

Also make ata_sff_pio_task() bail out quietly when the HSM state was
marked idle by the flush, both at entry and after re-acquiring the port
lock following ata_msleep(), since a work item can already be running
when the flush resets the state.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/linux-ide/sashiko-outbox-177477@kernel.org/
Fixes: 4a2e5409472e ("ata: libata-sff: don't busy-wait for PIO data-in command completion")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261020101107.1449635-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sff.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index d5ef0338735c3..c2aad525010cd 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1196,8 +1196,6 @@ void ata_sff_flush_pio_task(struct ata_port *ap)
 {
 	trace_ata_sff_flush_pio_task(ap);
 
-	cancel_delayed_work_sync(&ap->sff_pio_task);
-
 	/*
 	 * We wanna reset the HSM state to IDLE.  If we do so without
 	 * grabbing the port lock, critical sections protected by it which
@@ -1205,11 +1203,26 @@ void ata_sff_flush_pio_task(struct ata_port *ap)
 	 * example, we may set IDLE in between the time
 	 * __ata_sff_port_intr() checks for HSM_ST_IDLE and before it calls
 	 * ata_sff_hsm_move() causing ata_sff_hsm_move() to BUG().
+	 *
+	 * Reset the state before cancelling the work item: once the state
+	 * is IDLE, __ata_sff_port_intr() can no longer enter
+	 * ata_sff_hsm_move(), which prevents the interrupt handler from
+	 * queueing sff_pio_task when deferring the completion of a PIO
+	 * data-in command.  The SCSI error handler cannot dispatch new
+	 * commands while error handling is in progress, so issue-time
+	 * queuing is not possible either.
 	 */
 	spin_lock_irq(ap->lock);
 	ap->hsm_task_state = HSM_ST_IDLE;
 	spin_unlock_irq(ap->lock);
 
+	/*
+	 * Now that the interrupt handler can no longer queue the pio task,
+	 * cancel it.  This also drains a work item that the interrupt
+	 * handler managed to queue before the HSM state was reset.
+	 */
+	cancel_delayed_work_sync(&ap->sff_pio_task);
+
 	ap->sff_pio_task_link = NULL;
 }
 
@@ -1233,7 +1246,13 @@ static void ata_sff_pio_task(struct work_struct *work)
 	}
 
 fsm_start:
-	WARN_ON_ONCE(ap->hsm_task_state == HSM_ST_IDLE);
+	/*
+	 * ata_sff_flush_pio_task() may have marked the HSM idle after this
+	 * work item was queued or while it was running.  There is nothing
+	 * left to do.
+	 */
+	if (ap->hsm_task_state == HSM_ST_IDLE)
+		goto out_unlock;
 
 	wait_mask = ATA_BUSY;
 	if (ap->hsm_task_state == HSM_ST_LAST)
@@ -1252,6 +1271,13 @@ static void ata_sff_pio_task(struct work_struct *work)
 		ata_msleep(ap, 2);
 		spin_lock_irq(ap->lock);
 
+		/*
+		 * ata_sff_flush_pio_task() may have marked the HSM idle
+		 * while the port lock was dropped for ata_msleep().
+		 */
+		if (ap->hsm_task_state == HSM_ST_IDLE)
+			goto out_unlock;
+
 		status = ata_sff_busy_wait(ap, wait_mask, 10);
 		if (status & wait_mask) {
 			ata_sff_queue_pio_task(link, ATA_SHORT_PAUSE);
-- 
2.53.0



