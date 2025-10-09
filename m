Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80E1221544;
	Thu,  9 Oct 2025 16:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025664; cv=none; b=lKehDGJHFIWy4Gwafcb7AnpCFKIHJpimHeI0vg4eXXpEE+Q7PA0NxQhLK5IQDFkm0Mh8yiWr03AyVqeRD7vc9IADS5tv5+Fnb0f6wHgkyOoSvuLyfKtmX6M7oPQtidW9kxYH3x0s9icvT7qmxJwHNVwZxk8iCYPdfB5C2wa9rW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025664; c=relaxed/simple;
	bh=s6E6DxFLAxma+oKOTr17ggDa1wGixk9Y8lcLACFjhbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JhEMX0DheWYCYEZrg9CDAxNTDSCkBmGo7IxRggcMO1pNISADKaRoCtapfdu3RZyt6JxIuTg0jtwgVz84QvqyzA6+rLK5IIsSFTgm1yOoiamFWkbFfi4c/s+sdOfoiwZ82gSFWqsnegufZEiHNeMOvoDuLrO0iKKx8Sonxp/9xzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnQk+lyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnQk+lyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89612C4CEF8;
	Thu,  9 Oct 2025 16:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025663;
	bh=s6E6DxFLAxma+oKOTr17ggDa1wGixk9Y8lcLACFjhbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnQk+lyF/WkFD1aNjqEXCJu5LBMZjSjZFO8pR8o0mSyk7O6IA2TQEuZW5krykSzdK
	 UuvUcu4f0rWwiTeJKODWJGGpExP6MoBH7Zy7UILHgc5tGgO9r5VzQYUyXXlJH1CfZC
	 zdfUZ+29Po8pILzPmrRTbYW1Bxy16WaOm+Ix2UBWceIRvu5MlfrCVd2bG64ANGOfUB
	 ZKdXd5zTgbbvbmjvYm8bX5iSJEq4Z0e+nHyOTUif/q1mtmbUPgIKNoCjK4sfyvIAZO
	 +D4tiDY+bTIHc67u+QkkxZ6tj6RhY+P5uDD+jIZGFwJXUpDfMPt33TiFHmhHfC11sc
	 d3eCv2OIGlQqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Wagner <wagi@kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	justin.tee@broadcom.com,
	nareshgottumukkala83@gmail.com,
	paul.ely@broadcom.com,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.10] nvme-fc: use lock accessing port_state and rport state
Date: Thu,  9 Oct 2025 11:56:07 -0400
Message-ID: <20251009155752.773732-101-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 891cdbb162ccdb079cd5228ae43bdeebce8597ad ]

nvme_fc_unregister_remote removes the remote port on a lport object at
any point in time when there is no active association. This races with
with the reconnect logic, because nvme_fc_create_association is not
taking a lock to check the port_state and atomically increase the
active count on the rport.

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/all/u4ttvhnn7lark5w3sgrbuy2rxupcvosp4qmvj46nwzgeo5ausc@uyrkdls2muwx
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- Adds the missing synchronization in `nvme_fc_create_association()` so
  we hold `rport->lock` while checking `remoteport.port_state` and
  bumping `act_ctrl_cnt` via `nvme_fc_ctlr_active_on_rport()`
  (`drivers/nvme/host/fc.c:3034-3044`). That makes the state check and
  reference grab atomic with respect to other rport users.
- Without this lock, `nvme_fc_unregister_remoteport()` can flip the same
  `remoteport.port_state` and tear down the rport under lock
  (`drivers/nvme/host/fc.c:813-839`) while a reconnect path is still
  between the state check and the `act_ctrl_cnt` increment
  (`drivers/nvme/host/fc.c:2987-2999`). This window lets the reconnect
  code touch freed memory or miss the counter bump, causing crashes or
  failed reconnections—the bug reported on the mailing list.
- The fix is tightly scoped to this race, no API or behavioral changes
  elsewhere, and it follows existing locking rules for the rport. The
  affected logic is unchanged across supported stable branches, so the
  patch applies cleanly and removes a long-standing use-after-free
  hazard.

 drivers/nvme/host/fc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 3e12d4683ac72..03987f497a5b5 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3032,11 +3032,17 @@ nvme_fc_create_association(struct nvme_fc_ctrl *ctrl)
 
 	++ctrl->ctrl.nr_reconnects;
 
-	if (ctrl->rport->remoteport.port_state != FC_OBJSTATE_ONLINE)
+	spin_lock_irqsave(&ctrl->rport->lock, flags);
+	if (ctrl->rport->remoteport.port_state != FC_OBJSTATE_ONLINE) {
+		spin_unlock_irqrestore(&ctrl->rport->lock, flags);
 		return -ENODEV;
+	}
 
-	if (nvme_fc_ctlr_active_on_rport(ctrl))
+	if (nvme_fc_ctlr_active_on_rport(ctrl)) {
+		spin_unlock_irqrestore(&ctrl->rport->lock, flags);
 		return -ENOTUNIQ;
+	}
+	spin_unlock_irqrestore(&ctrl->rport->lock, flags);
 
 	dev_info(ctrl->ctrl.device,
 		"NVME-FC{%d}: create association : host wwpn 0x%016llx "
-- 
2.51.0

