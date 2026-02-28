Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB41E32AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301259; cv=none; b=oOpyL4okjIFwde9wjcUqrIF4D76vDXOeGtJjo8LD2BmshUQM/9HFR1BYjt2kZEnbGxoiA1Mm4tBKU3VOYypdrtVaG7DXhAch3/wpS3+Zaeh+/w0ukKhSKY7wCHToInxfc0+C9rRzMCMozJS4ecOIPBPNuUcelXO8+zvf5GnBuMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301259; c=relaxed/simple;
	bh=vAbDcYMI6KGTRUOWcArUtIL8IPB9URLkH4nK8C5U7Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0VDmEmUCCaO/LNS1vnQkdy1Oa+kmj1RSda8V0MlMCzzrGxHPf73mxkW3dCx9VkkUtUgxC8Aq1eYD3UDT+U8KsWg68XVmd8m6XFe3kIigqX9MF+BHNCTCL5HqAOuzPTSMI29t+Xotve8iHQkqR2Gslo6ACXKuEdidB9t90B93yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFPKPk5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFPKPk5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F063EC19423;
	Sat, 28 Feb 2026 17:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301259;
	bh=vAbDcYMI6KGTRUOWcArUtIL8IPB9URLkH4nK8C5U7Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFPKPk5EEY7grPAFiK73V36gNK3zFGWnGAX4oyJq/6D49OXfExR7dr89rvs8wBcZq
	 0No8QNqmLxO1/8c109MI1f5imGCOZr0/izO632WYizs1uU9Ttl6VdVGPdAuFPXl6Mi
	 0hJeRNwKubEqMMxgWNmbbXiy6td923DMCDFNQNdnNPGLT9g858bSdOnhH78g8+Thll
	 aIQHLCt56+hqXOZuJ7YnTxcC6qcQEL1NkZ8qK8iuFOrfSeEqmdBZ/guIz+/isCVobn
	 TyukIMdRPrhydFx4pYV1gzcFAlxQdSIR4mUDQRowdZKp6gyEXcoF3OJuxjCLqsLovy
	 vXdAOzuCWoaYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 443/752] net: mana: Fix double destroy_workqueue on service rescan PCI path
Date: Sat, 28 Feb 2026 12:42:34 -0500
Message-ID: <20260228174750.1542406-443-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit f975a0955276579e2176a134366ed586071c7c6a ]

While testing corner cases in the driver, a use-after-free crash
was found on the service rescan PCI path.

When mana_serv_reset() calls mana_gd_suspend(), mana_gd_cleanup()
destroys gc->service_wq. If the subsequent mana_gd_resume() fails
with -ETIMEDOUT or -EPROTO, the code falls through to
mana_serv_rescan() which triggers pci_stop_and_remove_bus_device().
This invokes the PCI .remove callback (mana_gd_remove), which calls
mana_gd_cleanup() a second time, attempting to destroy the already-
freed workqueue. Fix this by NULL-checking gc->service_wq in
mana_gd_cleanup() and setting it to NULL after destruction.

Call stack of issue for reference:
[Sat Feb 21 18:53:48 2026] Call Trace:
[Sat Feb 21 18:53:48 2026]  <TASK>
[Sat Feb 21 18:53:48 2026]  mana_gd_cleanup+0x33/0x70 [mana]
[Sat Feb 21 18:53:48 2026]  mana_gd_remove+0x3a/0xc0 [mana]
[Sat Feb 21 18:53:48 2026]  pci_device_remove+0x41/0xb0
[Sat Feb 21 18:53:48 2026]  device_remove+0x46/0x70
[Sat Feb 21 18:53:48 2026]  device_release_driver_internal+0x1e3/0x250
[Sat Feb 21 18:53:48 2026]  device_release_driver+0x12/0x20
[Sat Feb 21 18:53:48 2026]  pci_stop_bus_device+0x6a/0x90
[Sat Feb 21 18:53:48 2026]  pci_stop_and_remove_bus_device+0x13/0x30
[Sat Feb 21 18:53:48 2026]  mana_do_service+0x180/0x290 [mana]
[Sat Feb 21 18:53:48 2026]  mana_serv_func+0x24/0x50 [mana]
[Sat Feb 21 18:53:48 2026]  process_one_work+0x190/0x3d0
[Sat Feb 21 18:53:48 2026]  worker_thread+0x16e/0x2e0
[Sat Feb 21 18:53:48 2026]  kthread+0xf7/0x130
[Sat Feb 21 18:53:48 2026]  ? __pfx_worker_thread+0x10/0x10
[Sat Feb 21 18:53:48 2026]  ? __pfx_kthread+0x10/0x10
[Sat Feb 21 18:53:48 2026]  ret_from_fork+0x269/0x350
[Sat Feb 21 18:53:48 2026]  ? __pfx_kthread+0x10/0x10
[Sat Feb 21 18:53:48 2026]  ret_from_fork_asm+0x1a/0x30
[Sat Feb 21 18:53:48 2026]  </TASK>

Fixes: 505cc26bcae0 ("net: mana: Add support for auxiliary device servicing events")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/aZ2bzL64NagfyHpg@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 5 ++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c   | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 43f034e180c41..e22a98a9c9856 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1866,7 +1866,10 @@ static void mana_gd_cleanup(struct pci_dev *pdev)
 
 	mana_gd_remove_irqs(pdev);
 
-	destroy_workqueue(gc->service_wq);
+	if (gc->service_wq) {
+		destroy_workqueue(gc->service_wq);
+		gc->service_wq = NULL;
+	}
 	dev_dbg(&pdev->dev, "mana gdma cleanup successful\n");
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 0142fd98392c2..5712ec4f644a4 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3580,7 +3580,9 @@ void mana_rdma_remove(struct gdma_dev *gd)
 	}
 
 	WRITE_ONCE(gd->rdma_teardown, true);
-	flush_workqueue(gc->service_wq);
+
+	if (gc->service_wq)
+		flush_workqueue(gc->service_wq);
 
 	if (gd->adev)
 		remove_adev(gd);
-- 
2.51.0

