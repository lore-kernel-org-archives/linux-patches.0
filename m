Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69B26FAF;
	Tue,  5 Dec 2023 03:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4nWXUIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD5AC433C8;
	Tue,  5 Dec 2023 03:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746745;
	bh=uNd18zdkX9fUPXboyloMw6Uu2c1fLUglSeFsrN/T4dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4nWXUIU1E2k6F/bZNPwm0uqMPK8LCap5ZxpGqdd1kVG3BdCwzyMkQcD/CO26ags4
	 cCCWVk1ndUD0GWNl9PnApBNuxFPmNPOPfZpUHDLO6BLbA/Dt0mBmwW+9UUiFLm7op4
	 V274XX4evNDE0EEOKcFsyGhRzN0ixVz6AeznNp2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/134] vfio/pds: Fix possible sleep while in atomic context
Date: Tue,  5 Dec 2023 12:16:44 +0900
Message-ID: <20231205031543.810960039@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit ae2667cd8a479bb5abd6e24c12fcc9ef5bc06d75 ]

The driver could possibly sleep while in atomic context resulting
in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=y is
set:

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:283
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2817, name: bash
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
Call Trace:
 <TASK>
 dump_stack_lvl+0x36/0x50
 __might_resched+0x123/0x170
 mutex_lock+0x1e/0x50
 pds_vfio_put_lm_file+0x1e/0xa0 [pds_vfio_pci]
 pds_vfio_put_save_file+0x19/0x30 [pds_vfio_pci]
 pds_vfio_state_mutex_unlock+0x2e/0x80 [pds_vfio_pci]
 pci_reset_function+0x4b/0x70
 reset_store+0x5b/0xa0
 kernfs_fop_write_iter+0x137/0x1d0
 vfs_write+0x2de/0x410
 ksys_write+0x5d/0xd0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

This can happen if pds_vfio_put_restore_file() and/or
pds_vfio_put_save_file() grab the mutex_lock(&lm_file->lock)
while the spin_lock(&pds_vfio->reset_lock) is held, which can
happen during while calling pds_vfio_state_mutex_unlock().

Fix this by changing the reset_lock to reset_mutex so there are no such
conerns. Also, make sure to destroy the reset_mutex in the driver specific
VFIO device release function.

This also fixes a spinlock bad magic BUG that was caused
by not calling spinlock_init() on the reset_lock. Since, the lock is
being changed to a mutex, make sure to call mutex_init() on it.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/
Fixes: bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20231122192532.25791-3-brett.creeley@amd.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/pds/pci_drv.c  |  4 ++--
 drivers/vfio/pci/pds/vfio_dev.c | 14 ++++++++------
 drivers/vfio/pci/pds/vfio_dev.h |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index ab4b5958e4131..caffa1a2cf591 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -55,10 +55,10 @@ static void pds_vfio_recovery(struct pds_vfio_pci_device *pds_vfio)
 	 * VFIO_DEVICE_STATE_RUNNING.
 	 */
 	if (deferred_reset_needed) {
-		spin_lock(&pds_vfio->reset_lock);
+		mutex_lock(&pds_vfio->reset_mutex);
 		pds_vfio->deferred_reset = true;
 		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_ERROR;
-		spin_unlock(&pds_vfio->reset_lock);
+		mutex_unlock(&pds_vfio->reset_mutex);
 	}
 }
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 8c9fb87b13e1d..4c351c59d05a9 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -29,7 +29,7 @@ struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
 void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 {
 again:
-	spin_lock(&pds_vfio->reset_lock);
+	mutex_lock(&pds_vfio->reset_mutex);
 	if (pds_vfio->deferred_reset) {
 		pds_vfio->deferred_reset = false;
 		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
@@ -39,23 +39,23 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 		}
 		pds_vfio->state = pds_vfio->deferred_reset_state;
 		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
-		spin_unlock(&pds_vfio->reset_lock);
+		mutex_unlock(&pds_vfio->reset_mutex);
 		goto again;
 	}
 	mutex_unlock(&pds_vfio->state_mutex);
-	spin_unlock(&pds_vfio->reset_lock);
+	mutex_unlock(&pds_vfio->reset_mutex);
 }
 
 void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 {
-	spin_lock(&pds_vfio->reset_lock);
+	mutex_lock(&pds_vfio->reset_mutex);
 	pds_vfio->deferred_reset = true;
 	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 	if (!mutex_trylock(&pds_vfio->state_mutex)) {
-		spin_unlock(&pds_vfio->reset_lock);
+		mutex_unlock(&pds_vfio->reset_mutex);
 		return;
 	}
-	spin_unlock(&pds_vfio->reset_lock);
+	mutex_unlock(&pds_vfio->reset_mutex);
 	pds_vfio_state_mutex_unlock(pds_vfio);
 }
 
@@ -156,6 +156,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 	pds_vfio->vf_id = vf_id;
 
 	mutex_init(&pds_vfio->state_mutex);
+	mutex_init(&pds_vfio->reset_mutex);
 
 	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
 	vdev->mig_ops = &pds_vfio_lm_ops;
@@ -177,6 +178,7 @@ static void pds_vfio_release_device(struct vfio_device *vdev)
 			     vfio_coredev.vdev);
 
 	mutex_destroy(&pds_vfio->state_mutex);
+	mutex_destroy(&pds_vfio->reset_mutex);
 	vfio_pci_core_release_dev(vdev);
 }
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index b8f2d667608f3..e7b01080a1ec3 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -18,7 +18,7 @@ struct pds_vfio_pci_device {
 	struct pds_vfio_dirty dirty;
 	struct mutex state_mutex; /* protect migration state */
 	enum vfio_device_mig_state state;
-	spinlock_t reset_lock; /* protect reset_done flow */
+	struct mutex reset_mutex; /* protect reset_done flow */
 	u8 deferred_reset;
 	enum vfio_device_mig_state deferred_reset_state;
 	struct notifier_block nb;
-- 
2.42.0



