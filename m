Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72256110;
	Tue,  5 Dec 2023 03:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NqIXxRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D593C433C7;
	Tue,  5 Dec 2023 03:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746754;
	bh=s1sRSkZB8zkiz8v15N+I4Lff+9f1CYyTgZQ7R6qgKUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NqIXxRipfzzjIRWeFtJYzlSTX2rPxjYMZWLUu0IEB4OH25vbYpJHl5yvOqx2b+R+
	 MiV49oyWiU3O0Dy1WyttC1NgJcgaamMX3l/JmvujhcflJFcdQBlwb65hLHmfG6Hw4G
	 9nA3tdVkCCxu6Bu5Jj5vOLqWclCFZq1fp4UtvT+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/134] vfio/pds: Fix mutex lock->magic != lock warning
Date: Tue,  5 Dec 2023 12:16:43 +0900
Message-ID: <20231205031543.746314201@linuxfoundation.org>
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

[ Upstream commit 91aeb563bd4332e2988f8c0f64f125c4ecb5bcb3 ]

The following BUG was found when running on a kernel with
CONFIG_DEBUG_MUTEXES=y set:

DEBUG_LOCKS_WARN_ON(lock->magic != lock)
RIP: 0010:mutex_trylock+0x10d/0x120
Call Trace:
 <TASK>
 ? __warn+0x85/0x140
 ? mutex_trylock+0x10d/0x120
 ? report_bug+0xfc/0x1e0
 ? handle_bug+0x3f/0x70
 ? exc_invalid_op+0x17/0x70
 ? asm_exc_invalid_op+0x1a/0x20
 ? mutex_trylock+0x10d/0x120
 ? mutex_trylock+0x10d/0x120
 pds_vfio_reset+0x3a/0x60 [pds_vfio_pci]
 pci_reset_function+0x4b/0x70
 reset_store+0x5b/0xa0
 kernfs_fop_write_iter+0x137/0x1d0
 vfs_write+0x2de/0x410
 ksys_write+0x5d/0xd0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

As shown, lock->magic != lock. This is because
mutex_init(&pds_vfio->state_mutex) is called in the VFIO open path. So,
if a reset is initiated before the VFIO device is opened the mutex will
have never been initialized. Fix this by calling
mutex_init(&pds_vfio->state_mutex) in the VFIO init path.

Also, don't destroy the mutex on close because the device may
be re-opened, which would cause mutex to be uninitialized. Fix this by
implementing a driver specific vfio_device_ops.release callback that
destroys the mutex before calling vfio_pci_core_release_dev().

Fixes: bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20231122192532.25791-2-brett.creeley@amd.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/pds/vfio_dev.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 649b18ee394bb..8c9fb87b13e1d 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -155,6 +155,8 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 
 	pds_vfio->vf_id = vf_id;
 
+	mutex_init(&pds_vfio->state_mutex);
+
 	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
 	vdev->mig_ops = &pds_vfio_lm_ops;
 	vdev->log_ops = &pds_vfio_log_ops;
@@ -168,6 +170,16 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 	return 0;
 }
 
+static void pds_vfio_release_device(struct vfio_device *vdev)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+
+	mutex_destroy(&pds_vfio->state_mutex);
+	vfio_pci_core_release_dev(vdev);
+}
+
 static int pds_vfio_open_device(struct vfio_device *vdev)
 {
 	struct pds_vfio_pci_device *pds_vfio =
@@ -179,7 +191,6 @@ static int pds_vfio_open_device(struct vfio_device *vdev)
 	if (err)
 		return err;
 
-	mutex_init(&pds_vfio->state_mutex);
 	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
 	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 
@@ -199,14 +210,13 @@ static void pds_vfio_close_device(struct vfio_device *vdev)
 	pds_vfio_put_save_file(pds_vfio);
 	pds_vfio_dirty_disable(pds_vfio, true);
 	mutex_unlock(&pds_vfio->state_mutex);
-	mutex_destroy(&pds_vfio->state_mutex);
 	vfio_pci_core_close_device(vdev);
 }
 
 static const struct vfio_device_ops pds_vfio_ops = {
 	.name = "pds-vfio",
 	.init = pds_vfio_init_device,
-	.release = vfio_pci_core_release_dev,
+	.release = pds_vfio_release_device,
 	.open_device = pds_vfio_open_device,
 	.close_device = pds_vfio_close_device,
 	.ioctl = vfio_pci_core_ioctl,
-- 
2.42.0



