Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0343437C118;
	Sat, 12 Sep 2026 09:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205329; cv=none; b=izYYRWgu3TyAp0Y6KCzVw5qy2AoMtC3YZFWe2djr+uKEJBk9+/rZ5v2jxGjN8kLhUvG4obh2wK1Elukd8WPk9k6cg8/HIoD04kirTHcJ8hUeuSjgd6yNhO47euMnPtX0hTKdK70wVIEmEEMkdbkTqBUbYd5SqXzGFwT0gjD5qYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205329; c=relaxed/simple;
	bh=STqhw+SjoB01DsPdJw18igK/VMUN0QzfiRoFovlENic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jesLWJdx6pBjE13rlakfzg78LMZZ6rsFF/ZDUPWWgPv26l6AkZtvRBvQA0QW3YkyMzgXkACeIbPwOT0+HJr8RktgoZiKsOcJFnDZFLBUNvMsI1TvdFJ6QV+1a74Uj9VnMmiKfYjjzCklmHaduYavuKyi5IuUiaC4KNsyzQuLVVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjLD4Xsb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjLD4Xsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98761F000FF;
	Sat, 12 Sep 2026 09:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205327;
	bh=q+HHeKWauL3rCVxy4Eqqf1KZ8Htm+36sWpiigU0Tl0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjLD4XsbvST4kZzyN9LIOb8PIda9JdBv5KgFEAZ0L0HlEZBqH5SsPOvWIdf0tbc1Z
	 htQ3fwmJ1ntHOdR8jwd9fO+5McShDKvMUbdIvl/q41A5Sl8KkhPidPVrfp03JKEiNJ
	 o4kFlwddfFbC3RFJY+jfbRsLZfvVrvrUxoQtcKLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anoop Vijay <anoop.c.vijay@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1796/1815] drm/xe/sysctrl: Read mailbox phase bit from hardware
Date: Sat, 12 Sep 2026 08:59:06 +0200
Message-ID: <20260912065731.198317114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anoop Vijay <anoop.c.vijay@intel.com>

[ Upstream commit a62212b35a214c2ff3bd1c785a440d7ad8205ec9 ]

The mailbox PHASE bit in SYSCTRL_MB_CTRL is toggled per-message and
was tracked in software as sc->phase_bit, reset to 0 on error paths.
If the cached value ever drifts from what the hardware last saw, all
following messages carry the wrong phase and get silently misread by
firmware.

Drop the cache and read PHASE directly from SYSCTRL_MB_CTRL before
each frame instead, removing xe_sysctrl_mailbox_init() and its call
sites along with it.

Fixes: 1f95f618182b ("drm/xe/xe_sysctrl: Add System Controller mailbox communication support")
Signed-off-by: Anoop Vijay <anoop.c.vijay@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20260825172827.3801591-2-anoop.c.vijay@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 04984fcdbf6876c940c01026a7404c1e9cc91ba7)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_sysctrl.c         |  7 +------
 drivers/gpu/drm/xe/xe_sysctrl_mailbox.c | 22 ++++------------------
 drivers/gpu/drm/xe/xe_sysctrl_mailbox.h |  1 -
 drivers/gpu/drm/xe/xe_sysctrl_types.h   |  3 ---
 4 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_sysctrl.c b/drivers/gpu/drm/xe/xe_sysctrl.c
index 1db20be8158b5..62ccc9be71b45 100644
--- a/drivers/gpu/drm/xe/xe_sysctrl.c
+++ b/drivers/gpu/drm/xe/xe_sysctrl.c
@@ -85,7 +85,6 @@ int xe_sysctrl_init(struct xe_device *xe)
 		return ret;
 
 	xe->soc_remapper.set_sysctrl_region(xe, SYSCTRL_MAILBOX_INDEX);
-	xe_sysctrl_mailbox_init(sc);
 	INIT_WORK(&sc->work, xe_sysctrl_work);
 
 	return devm_add_action_or_reset(xe->drm.dev, sysctrl_fini, xe);
@@ -114,12 +113,10 @@ void xe_sysctrl_irq_handler(struct xe_device *xe, u32 master_ctl)
  * @xe: xe device instance
  *
  * Invoked during system resume (S3/S4 to S0) and runtime resume from D3cold.
- * Restores SoC remapper configuration and reinitializes mailbox interface.
+ * Restores SoC remapper configuration.
  */
 void xe_sysctrl_pm_resume(struct xe_device *xe)
 {
-	struct xe_sysctrl *sc = &xe->sc;
-
 	if (!xe->info.has_soc_remapper_sysctrl)
 		return;
 
@@ -127,6 +124,4 @@ void xe_sysctrl_pm_resume(struct xe_device *xe)
 		return;
 
 	xe->soc_remapper.set_sysctrl_region(xe, SYSCTRL_MAILBOX_INDEX);
-
-	xe_sysctrl_mailbox_init(sc);
 }
diff --git a/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c b/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c
index e13eebaac1d00..72baf1aa4b3ad 100644
--- a/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c
+++ b/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c
@@ -145,6 +145,7 @@ static int sysctrl_send_frames(struct xe_sysctrl *sc,
 	struct xe_device *xe = sc_to_xe(sc);
 	u32 ctrl_reg, total_frames, frame;
 	size_t bytes_sent, frame_size;
+	bool phase;
 
 	total_frames = DIV_ROUND_UP(cmd_size, XE_SYSCTRL_MB_FRAME_SIZE);
 
@@ -153,7 +154,8 @@ static int sysctrl_send_frames(struct xe_sysctrl *sc,
 		return -EBUSY;
 	}
 
-	sc->phase_bit ^= 1;
+	ctrl_reg = xe_mmio_read32(sc->mmio, SYSCTRL_MB_CTRL);
+	phase = !(ctrl_reg & SYSCTRL_FRAME_PHASE);
 	bytes_sent = 0;
 
 	for (frame = 0; frame < total_frames; frame++) {
@@ -161,7 +163,6 @@ static int sysctrl_send_frames(struct xe_sysctrl *sc,
 
 		if (sysctrl_write_frame(sc, mbox_cmd + bytes_sent, frame_size)) {
 			xe_err(xe, "sysctrl: Failed to write frame %u\n", frame);
-			sc->phase_bit = 0;
 			return -EIO;
 		}
 
@@ -169,13 +170,12 @@ static int sysctrl_send_frames(struct xe_sysctrl *sc,
 			   REG_FIELD_PREP(SYSCTRL_FRAME_CURRENT_MASK, frame) |
 			   REG_FIELD_PREP(SYSCTRL_FRAME_TOTAL_MASK, total_frames - 1) |
 			   SYSCTRL_MB_CTRL_CMD |
-			   (sc->phase_bit ? SYSCTRL_FRAME_PHASE : 0);
+			   (phase ? SYSCTRL_FRAME_PHASE : 0);
 
 		xe_mmio_write32(sc->mmio, SYSCTRL_MB_CTRL, ctrl_reg);
 
 		if (!sysctrl_wait_bit_clear(sc, SYSCTRL_MB_CTRL_RUN_BUSY, timeout_ms)) {
 			xe_err(xe, "sysctrl: Frame %u acknowledgment timeout\n", frame);
-			sc->phase_bit = 0;
 			return -ETIMEDOUT;
 		}
 
@@ -321,20 +321,6 @@ void xe_sysctrl_create_command(struct xe_sysctrl_mailbox_command *command, u8 gr
 	command->data_out_len = response_len;
 }
 
-/**
- * xe_sysctrl_mailbox_init - Initialize System Controller mailbox interface
- * @sc: System controller structure
- *
- * Initialize system controller mailbox interface for communication.
- */
-void xe_sysctrl_mailbox_init(struct xe_sysctrl *sc)
-{
-	u32 ctrl_reg;
-
-	ctrl_reg = xe_mmio_read32(sc->mmio, SYSCTRL_MB_CTRL);
-	sc->phase_bit = (ctrl_reg & SYSCTRL_FRAME_PHASE) ? 1 : 0;
-}
-
 /**
  * xe_sysctrl_send_command() - Send mailbox command to System Controller
  * @sc: System Controller instance
diff --git a/drivers/gpu/drm/xe/xe_sysctrl_mailbox.h b/drivers/gpu/drm/xe/xe_sysctrl_mailbox.h
index fb434cc165b2a..f0d5e3d7f5e31 100644
--- a/drivers/gpu/drm/xe/xe_sysctrl_mailbox.h
+++ b/drivers/gpu/drm/xe/xe_sysctrl_mailbox.h
@@ -26,7 +26,6 @@ struct xe_sysctrl_mailbox_command;
 void xe_sysctrl_create_command(struct xe_sysctrl_mailbox_command *command, u8 group_id, u8 cmd_id,
 			       void *request, size_t request_len, void *response,
 			       size_t response_len);
-void xe_sysctrl_mailbox_init(struct xe_sysctrl *sc);
 int xe_sysctrl_send_command(struct xe_sysctrl *sc,
 			    struct xe_sysctrl_mailbox_command *cmd,
 			    size_t *rdata_len);
diff --git a/drivers/gpu/drm/xe/xe_sysctrl_types.h b/drivers/gpu/drm/xe/xe_sysctrl_types.h
index 66ba24f43017d..98c2f473f7c6a 100644
--- a/drivers/gpu/drm/xe/xe_sysctrl_types.h
+++ b/drivers/gpu/drm/xe/xe_sysctrl_types.h
@@ -26,9 +26,6 @@ struct xe_sysctrl {
 	/** @cmd_lock: Mutex protecting mailbox command operations */
 	struct mutex cmd_lock;
 
-	/** @phase_bit: Message boundary phase toggle bit (0 or 1) */
-	bool phase_bit;
-
 	/** @work: Pending events worker */
 	struct work_struct work;
 
-- 
2.53.0



