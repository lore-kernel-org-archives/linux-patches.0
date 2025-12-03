Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F64A305978;
	Wed,  3 Dec 2025 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776012; cv=none; b=c7r8S/f0n8DX1Wd1NbVbwSDDH7uwOvazvo5I74d+FOVEtdJQ4o6Ju+z10Go76SlVY/v85tdn5U6+YJQq8yAB5nGsRfYtuOUScdBrAB/W+neZyYzFIFp4JgKQhmIWmi8spixKnQaBPDrgR38/SqpTYcJHZQidZz9uAiN4FYuIBxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776012; c=relaxed/simple;
	bh=DY2G6KiFaAqJ9EVwiUEjQRdDf55yN5SDRu8M0gxmNfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpxmtC8H/mvutsYl6T2gEWLFbenlwGOWYvEZGp9vI/qkbclx4WCliXCsL6GkrtCY4OVaiUTsO68Lww49WPKWE7Fv5XH38H19MibemaWR2pJfplvkvhjZy66UYS04sgUjQVFnK+AbtKsdkHSXzslxkeLg9F+/liYoaUscE4kWwBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvKuTDvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvKuTDvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F542C4CEF5;
	Wed,  3 Dec 2025 15:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776012;
	bh=DY2G6KiFaAqJ9EVwiUEjQRdDf55yN5SDRu8M0gxmNfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvKuTDvhxFCTn1TzG+1awNUd25eAgQq0nChVCM3A6KCC7DJWHhYr6VXB2EecZ/9S5
	 SdJ4bmpMoXLUmjQLmtZTYI4axy5q9r9ZsQZLCnqbb9ZHNpRa4ow9yW3CPFjYrcHi0V
	 De+pID+lnHsgtS9ABPBCZM/iZxSpKBkGC9au0MNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/300] nvme-fc: use lock accessing port_state and rport state
Date: Wed,  3 Dec 2025 16:24:18 +0100
Message-ID: <20251203152402.623630753@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f49e98c2e31db..635ec11c9a6fc 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3042,11 +3042,17 @@ nvme_fc_create_association(struct nvme_fc_ctrl *ctrl)
 
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



