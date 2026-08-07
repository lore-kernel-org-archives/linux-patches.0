Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2B72DC765;
	Fri,  7 Aug 2026 15:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115893; cv=none; b=fKrOf/UQHbA1nP2c2047GFwsEBh2AfCDW6vCFv8cnulFzVo0aifhL9qMZmw/5jjiZ0ZhJImpaINMWQhunqKyw9gaSq1z/cGtsbl6GBNNrXSl4/byOrEDG2qx81hgFmEQ0BTT4KS2wA9O7eX9aJhqUsWuq/3uzGHztraO98Ccl7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115893; c=relaxed/simple;
	bh=ZHj1Inoyg0r2snfVdMpkhhySgd2Bk/CzaDWLqS9aALo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSYvXt8apquW5/EwKxhmSkdg5Z5BgPQJHKscJ9X4Z9Jyt6L2Nls8tyQewW7xljZqjxlDDs2A21dcNXO9NykJyAU4J6vb+AHAl0d0peinjDVp1R4DRqLcpHToAImvASwQey+NswXjHBxWf6lHWgkKN3hl8ftoVLHhmybQGtZyxw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCt2lKZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCt2lKZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EC61F000E9;
	Fri,  7 Aug 2026 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115892;
	bh=ORQuMde6KhwXT5lDcfqWfjuIbRJpVNvo4ANK75tMAb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCt2lKZO/qK8lcm0tN8mbdhrFpyEHm4rs6vkMELMP5+HNRM104WSi27AYnL+NSuU8
	 g9sNp/uTVQfEWeTOAJ3TXRHDd2t85kDjS7XNDEUZJwj16Bw7F7i3Bxq9Jotyy8VuRc
	 a65OJqXUfhFSYFrrKRsItmTAT+vc60nadz+LwGps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/261] scsi: libsas: Fix HA resume deadlock and hisi_sas disk-wake race
Date: Fri,  7 Aug 2026 16:36:36 +0200
Message-ID: <20260807143416.224068396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 3dbbbf656b850c9c8de05df6ad4a1dfc6ff02845 ]

Commit fbefe22811c3 ("scsi: libsas: Don't always drain event workqueue
for HA resume") introduced sas_resume_ha_no_sync() to avoid a deadlock:
the PHYE_RESUME_TIMEOUT handler, running on the HA event workqueue,
calls sas_deform_port() -> sas_destruct_devices(), which removes SCSI
devices and waits for the host to become runtime-active. But the host
cannot resume until sas_resume_ha() -> sas_drain_work() returns, and the
drain is blocked on that very handler.

However skipping the drain reintroduces a race: hisi_sas returns from
resume before all PHY UP work and libsas discovery work finish. The
controller may then autosuspend while disks are still waking up. The
disks issue IO to a suspended controller, the IO fails, and the disks
get disabled.

Fix the deadlock at its source by moving the PHYE_RESUME_TIMEOUT
notification to after sas_drain_work(). By then the host resume is about
to complete, so device removal through device_link no longer blocks on
the resume and the cycle is broken.

With the deadlock gone, restore sas_resume_ha() (the draining variant)
in hisi_sas and remove sas_resume_ha_no_sync().

The reorder is safe for the other libsas consumers (isci, pm8001,
aic94xx, mvsas). During suspend, sas_suspend_devices() calls
sas_notify_lldd_dev_gone() for each device, which sets dev->lldd_dev to
NULL. When scsi_unblock_requests re-enables I/O in resume, any I/O to a
timed-out phy's disk is immediately rejected by the LLDD before reaching
hardware: isci returns SAS_DEVICE_UNKNOWN (mapped to DID_BAD_TARGET),
and pm8001 returns SAS_PHY_DOWN (mapped to DID_NO_CONNECT). Both
complete directly via scsi_done() without entering SCSI EH. This is
identical in both the old and new ordering since lldd_dev_gone runs
during suspend, before resume. The reorder only affects when the
PHYE_RESUME_TIMEOUT handler runs (synchronized by sas_drain_work()
vs. asynchronous after resume returns), not whether I/O can reach the
device. aic94xx and mvsas do not register any PM ops and never reach
this code path.

Fixes: fbefe22811c3 ("scsi: libsas: Don't always drain event workqueue for HA resume")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260716081145.3950172-1-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +------
 drivers/scsi/libsas/sas_init.c         | 37 +++++++++++++-------------
 include/scsi/libsas.h                  |  1 -
 3 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 7075dde4584db..d386672d59e4a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5345,15 +5345,7 @@ static int _resume_v3_hw(struct device *device)
 		return rc;
 	}
 	phys_init_v3_hw(hisi_hba);
-
-	/*
-	 * If a directly-attached disk is removed during suspend, a deadlock
-	 * may occur, as the PHYE_RESUME_TIMEOUT processing will require the
-	 * hisi_hba->device to be active, which can only happen when resume
-	 * completes. So don't wait for the HA event workqueue to drain upon
-	 * resume.
-	 */
-	sas_resume_ha_no_sync(sha);
+	sas_resume_ha(sha);
 	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
 
 	dev_warn(dev, "end of resuming controller\n");
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 8586dc79f2a0b..9fcdad2b55a8f 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -409,7 +409,7 @@ static void sas_resume_insert_broadcast_ha(struct sas_ha_struct *ha)
 	}
 }
 
-static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
+void sas_resume_ha(struct sas_ha_struct *ha)
 {
 	const unsigned long tmo = msecs_to_jiffies(25000);
 	int i;
@@ -425,6 +425,23 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n",
 			 i, i > 1 ? "s" : "");
 	wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) == 0, tmo);
+
+	/*
+	 * All phys are back up or timed out. Turn on I/O and drain
+	 * pending work.
+	 */
+	scsi_unblock_requests(ha->shost);
+	sas_drain_work(ha);
+
+	/*
+	 * Send PHYE_RESUME_TIMEOUT after sas_drain_work(). The handler
+	 * calls sas_deform_port() -> sas_destruct_devices(), which removes
+	 * SCSI devices and, for LLDDs using device_link() PM sync, waits
+	 * for the host to be runtime-active. Sending it before the drain
+	 * would deadlock: the drain waits for the handler, the handler
+	 * waits for host resume, and host resume waits for the drain to
+	 * finish.
+	 */
 	for (i = 0; i < ha->num_phys; i++) {
 		struct asd_sas_phy *phy = ha->sas_phy[i];
 
@@ -435,12 +452,6 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 		}
 	}
 
-	/* all phys are back up or timed out, turn on i/o so we can
-	 * flush out disks that did not return
-	 */
-	scsi_unblock_requests(ha->shost);
-	if (drain)
-		sas_drain_work(ha);
 	clear_bit(SAS_HA_RESUMING, &ha->state);
 
 	sas_queue_deferred_work(ha);
@@ -449,20 +460,8 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 	 */
 	sas_resume_insert_broadcast_ha(ha);
 }
-
-void sas_resume_ha(struct sas_ha_struct *ha)
-{
-	_sas_resume_ha(ha, true);
-}
 EXPORT_SYMBOL(sas_resume_ha);
 
-/* A no-sync variant, which does not call sas_drain_ha(). */
-void sas_resume_ha_no_sync(struct sas_ha_struct *ha)
-{
-	_sas_resume_ha(ha, false);
-}
-EXPORT_SYMBOL(sas_resume_ha_no_sync);
-
 void sas_suspend_ha(struct sas_ha_struct *ha)
 {
 	int i;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 8a43534eea5cb..367b06fe5fcb8 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -678,7 +678,6 @@ extern int sas_register_ha(struct sas_ha_struct *);
 extern int sas_unregister_ha(struct sas_ha_struct *);
 extern void sas_prep_resume_ha(struct sas_ha_struct *sas_ha);
 extern void sas_resume_ha(struct sas_ha_struct *sas_ha);
-extern void sas_resume_ha_no_sync(struct sas_ha_struct *sas_ha);
 extern void sas_suspend_ha(struct sas_ha_struct *sas_ha);
 
 int sas_set_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates);
-- 
2.53.0



