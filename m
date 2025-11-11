Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED441C28E;
	Tue, 11 Nov 2025 01:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822836; cv=none; b=DXCcJIhIucsZhk/CIxLlqbAFFq246W+eI4X1JvaC+X95U0UCFwUq+W1mCCRHoZEm+BU01UdYnyiSwuywRTrjRLA4ozZTtAKBhmpjjtogi18XafsNOgUxbTBhk50OM/1HsRc2gQ/sn+EKxqghnHGul4pG+kF/PcG7LAT5NN8ySJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822836; c=relaxed/simple;
	bh=eipsNmruqghPAOchKHb0g6+nFB3jbttWtUMHguqcWCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGA/wCxaiaGOIW4NwTDXFojKIfbSTG2W8NKWdZS+K2xVcjx2uurTkjd6rNiyYcS8OUceU9fZ9EvDca2uGsgCZuvguFfkz18XcVhi0YAbbqvf0csdWOftLc0LujnrwKvpRyC7aPUutDskkYmJBhsCRukKdWnXVWLmF0fzRF5eY9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXF2oGaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXF2oGaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144EEC19425;
	Tue, 11 Nov 2025 01:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822836;
	bh=eipsNmruqghPAOchKHb0g6+nFB3jbttWtUMHguqcWCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXF2oGaC3FHD3Eln9Chsf++VZzr/U7Qku0XTuZhcZGFXByM0kth+J9KZW8no8TJvf
	 XcbKqDxgn96fXMrneZTX00Rj16SM0yKkIaJavSa0xEh6DfMcEsnsswAYapHIkyBGo7
	 OaCGFzRCFxPHUQl44kEHGrzUhXVYMaiof2H1H52o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 180/849] nvme-fc: use lock accessing port_state and rport state
Date: Tue, 11 Nov 2025 09:35:50 +0900
Message-ID: <20251111004540.783972647@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



