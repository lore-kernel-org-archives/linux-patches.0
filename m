Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1154D310785;
	Wed,  3 Dec 2025 15:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777553; cv=none; b=V44KkkmdfYGOsORcKv/dXeP67TZbmXydeJ8cNz71HYpj3uL+hAYlNgxgCfEpi4dkRDc+37acovaWAjZ0i1S21oiRv7gqulZ0yReDxUhhvKrx+blOoP66FoveIcj4iWDYsD8yQ8Y8c5Jg38MMEVgQoM1jlI7krHUx7EJNqEzoPAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777553; c=relaxed/simple;
	bh=W7iDy2jpLz5JPZcT64aWy/YzGyFaXbJEEYVBHU2iEB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGG8UefbAV8w8Rqrz4PwFhiEhohhtUn3EiagZhhPSJkWSpe6lmoCDxeDXCnVGEuA6RLLlTaOvzTDC2fmyS2QcQSOXH6gj35IrYdxPwqiKOcbp3XFHoMg02qJhgdqaimLVoMDRwJCzuCUju636HrjLCnSx8l5ei8P+VQhJgV1rjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGvQF3A0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGvQF3A0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242A5C4CEF5;
	Wed,  3 Dec 2025 15:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777552;
	bh=W7iDy2jpLz5JPZcT64aWy/YzGyFaXbJEEYVBHU2iEB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGvQF3A09NzJ/9H+WvZMsmLs8mnpfdHKpoQEcKST+Zln8T+5ZlJiQ4tYtCpqWe+q9
	 O37BQU920KjyxYTRsr6LCytEyV7r4f07iSZhFLsiDP2NbPEYvedCJJUt89JklO8Iec
	 Lp1HCvDVKkEhPd8tv6AFjuXFE6MGOUGtAo6rNXw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/392] nvme-fc: use lock accessing port_state and rport state
Date: Wed,  3 Dec 2025 16:23:45 +0100
Message-ID: <20251203152416.865750465@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/nvme/host/fc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index ebe8c2f147a33..8a9cb7709b32d 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3039,11 +3039,17 @@ nvme_fc_create_association(struct nvme_fc_ctrl *ctrl)
 
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



