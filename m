Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3321DF258;
	Wed, 19 Mar 2025 14:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395275; cv=none; b=SuP1VP4M7Ro1PemlgocU9rW89CwnLbBYM781MO9NZSl/Ls+LUlynBuUC2K4GTKslgrZEmYhPzGZOx0H+Q2UHeKILT6JJl/GGycBeiARQpdhDya/H5gqI6r/Tig+Tt/lM/dvP209DkiYuZ6I/cRRTJVRC5H/+QghOcU878xTDr5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395275; c=relaxed/simple;
	bh=SsNYxks2G78ASyvxMqYGgebGi7+nJ/+5DLhU5Tl+6T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8icxsJw9UUWFY23DVzJFPurT/R9683177gO2Gk0yAM22k0hHBMDTfZh0x4EpKFKkPWu/oNgTm4NaJlWz7mMgXKKnDHS8/T79hfP+IgxllGaM/ah7Cdnkn+WFAoFALUcEMeis/E+kngvj0qU0xmf6YiTouKPPjwrBJ7sIiywNe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEV+7z2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEV+7z2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D4BC4CEE4;
	Wed, 19 Mar 2025 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395275;
	bh=SsNYxks2G78ASyvxMqYGgebGi7+nJ/+5DLhU5Tl+6T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEV+7z2bf/6fDEaEwX8FEet2cf+9+jJTw9LTCwD28xR0Z/GzqDJAY3tE/w7DhPaYa
	 HNtWUCbnD5PZs4B8vmPATa9i36wJh+NqYponIDpHwVQvFK9qDltG738Pvx4QetgE+e
	 bbVr+CP+J2ijK1nARmXW1iMZuF7zhFv1phIw0w0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 160/166] nvme-fc: rely on state transitions to handle connectivity loss
Date: Wed, 19 Mar 2025 07:32:11 -0700
Message-ID: <20250319143024.362244691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniel Wagner <wagi@kernel.org>

commit f13409bb3f9140dad7256febcb478f0c9600312c upstream.

It's not possible to call nvme_state_ctrl_state with holding a spin
lock, because nvme_state_ctrl_state calls cancel_delayed_work_sync
when fastfail is enabled.

Instead syncing the ASSOC_FLAG and state transitions using a lock, it's
possible to only rely on the state machine transitions. That means
nvme_fc_ctrl_connectivity_loss should unconditionally call
nvme_reset_ctrl which avoids the read race on the ctrl state variable.
Actually, it's not necessary to test in which state the ctrl is, the
reset work will only scheduled when the state machine is in LIVE state.

In nvme_fc_create_association, the LIVE state can only be entered if it
was previously CONNECTING. If this is not possible then the reset
handler got triggered. Thus just error out here.

Fixes: ee59e3820ca9 ("nvme-fc: do not ignore connectivity loss during connecting")
Closes: https://lore.kernel.org/all/denqwui6sl5erqmz2gvrwueyxakl5txzbbiu3fgebryzrfxunm@iwxuthct377m/
Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c |   67 ++++---------------------------------------------
 1 file changed, 6 insertions(+), 61 deletions(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -782,61 +782,12 @@ restart:
 static void
 nvme_fc_ctrl_connectivity_loss(struct nvme_fc_ctrl *ctrl)
 {
-	enum nvme_ctrl_state state;
-	unsigned long flags;
-
 	dev_info(ctrl->ctrl.device,
 		"NVME-FC{%d}: controller connectivity lost. Awaiting "
 		"Reconnect", ctrl->cnum);
 
-	spin_lock_irqsave(&ctrl->lock, flags);
 	set_bit(ASSOC_FAILED, &ctrl->flags);
-	state = nvme_ctrl_state(&ctrl->ctrl);
-	spin_unlock_irqrestore(&ctrl->lock, flags);
-
-	switch (state) {
-	case NVME_CTRL_NEW:
-	case NVME_CTRL_LIVE:
-		/*
-		 * Schedule a controller reset. The reset will terminate the
-		 * association and schedule the reconnect timer.  Reconnects
-		 * will be attempted until either the ctlr_loss_tmo
-		 * (max_retries * connect_delay) expires or the remoteport's
-		 * dev_loss_tmo expires.
-		 */
-		if (nvme_reset_ctrl(&ctrl->ctrl)) {
-			dev_warn(ctrl->ctrl.device,
-				"NVME-FC{%d}: Couldn't schedule reset.\n",
-				ctrl->cnum);
-			nvme_delete_ctrl(&ctrl->ctrl);
-		}
-		break;
-
-	case NVME_CTRL_CONNECTING:
-		/*
-		 * The association has already been terminated and the
-		 * controller is attempting reconnects.  No need to do anything
-		 * futher.  Reconnects will be attempted until either the
-		 * ctlr_loss_tmo (max_retries * connect_delay) expires or the
-		 * remoteport's dev_loss_tmo expires.
-		 */
-		break;
-
-	case NVME_CTRL_RESETTING:
-		/*
-		 * Controller is already in the process of terminating the
-		 * association.  No need to do anything further. The reconnect
-		 * step will kick in naturally after the association is
-		 * terminated.
-		 */
-		break;
-
-	case NVME_CTRL_DELETING:
-	case NVME_CTRL_DELETING_NOIO:
-	default:
-		/* no action to take - let it delete */
-		break;
-	}
+	nvme_reset_ctrl(&ctrl->ctrl);
 }
 
 /**
@@ -3070,7 +3021,6 @@ nvme_fc_create_association(struct nvme_f
 	struct nvmefc_ls_rcv_op *disls = NULL;
 	unsigned long flags;
 	int ret;
-	bool changed;
 
 	++ctrl->ctrl.nr_reconnects;
 
@@ -3175,23 +3125,18 @@ nvme_fc_create_association(struct nvme_f
 		else
 			ret = nvme_fc_recreate_io_queues(ctrl);
 	}
+	if (!ret && test_bit(ASSOC_FAILED, &ctrl->flags))
+		ret = -EIO;
 	if (ret)
 		goto out_term_aen_ops;
 
-	spin_lock_irqsave(&ctrl->lock, flags);
-	if (!test_bit(ASSOC_FAILED, &ctrl->flags))
-		changed = nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_LIVE);
-	else
+	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_LIVE)) {
 		ret = -EIO;
-	spin_unlock_irqrestore(&ctrl->lock, flags);
-
-	if (ret)
 		goto out_term_aen_ops;
+	}
 
 	ctrl->ctrl.nr_reconnects = 0;
-
-	if (changed)
-		nvme_start_ctrl(&ctrl->ctrl);
+	nvme_start_ctrl(&ctrl->ctrl);
 
 	return 0;	/* Success */
 


