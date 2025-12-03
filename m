Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EE335BDB4;
	Wed,  3 Dec 2025 16:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778955; cv=none; b=nVNf+u1jQAslJls3m2urfZg/Ba7zB9Zqm5EwXjVLapkGPfFNymhj/ZrICF7cGwFTdW+hg0h9uoirdCr0fF13F2/da9yIV/CN5+gUv3rlZe2uhogIneYFwF8RUccJO1EsrZmjXkDD62V2/2yWgEkAgrCg+VzLJrvqhENlth2a754=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778955; c=relaxed/simple;
	bh=2xJS/Ap1eVFFBH0fCr6Ot4CJJ1so6UyTdlg8D5V2zSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9f78fw7GgldwqlT7E3i9epAkzWUzInKHedQQhv3O3lL9YBEyV454Ln4A67bnr79TcaS/rysNfY0hFMjPxHVYBLxV16ZDtjYIk8ZWTE37lm9EqASYxsLl8NCe05apRL1O0FG6g8bhZxic4EMoBlUs0T+1SsnDowtJnZBmm4Gzh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFKM/DyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFKM/DyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AC1C4CEF5;
	Wed,  3 Dec 2025 16:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778955;
	bh=2xJS/Ap1eVFFBH0fCr6Ot4CJJ1so6UyTdlg8D5V2zSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFKM/DyM7kZI6cAxMBQhQA1iLQFYAfrOidCpIAQzWa5dExl13NimPUI6xfBOzlQgf
	 V/5rQiv7ly6lvXDBl0xdEQB7CydrQrjRQdHT900ifioZTbrFCQy216OWbfpsvaIXLM
	 HgJOpVTHlrpa127hst7i3SrD2Ged/mmCVIuXyr6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/568] nvme-fc: use lock accessing port_state and rport state
Date: Wed,  3 Dec 2025 16:21:54 +0100
Message-ID: <20251203152444.838857744@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2b0f15de77111..786715e9eeb93 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3048,11 +3048,17 @@ nvme_fc_create_association(struct nvme_fc_ctrl *ctrl)
 
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



