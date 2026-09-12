Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1226447886E;
	Sat, 12 Sep 2026 11:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212273; cv=none; b=f4ti1V3u5A8ihQQq2VUYKG91DAcXdFC1Wop0RVHkqBtBkGyv/g/XtzjxWa/c58wysb6QLhQTwLJJEVUdviWrbl7HdU0rUE2DFhl00N1sftV8TyK2CKOXB1SYoYhbvluJDub2tzifQuAPNHoAub2z7Nu1QPTvIMyNjRF8tZPSVpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212273; c=relaxed/simple;
	bh=X1V54JBNQyWe3H4D37zzBe6/7O71AQkWIzMp+w37JHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvoWCFbgCJ5HFpwVQdTtqhu++f2K/TMgtRsk2LVZIaNTUmnGsrWXoX+GSSeQGWrdzy+Up+Fgge/fgvEeD1adjKQ3EafODF7E0qQE6iHeedp0FA7gOf/5CXA8oULQCGVuhrDLUMdHhtpxNDU461oKAA1BuTM20OOxDNFeEaim8GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5I0V+dU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5I0V+dU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E3B1F000FF;
	Sat, 12 Sep 2026 11:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212268;
	bh=WmV66Xs0Bbo76BGs3Ugcqcw3IgIMH5yyVk200P8yLoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5I0V+dU2QDwM2YZbdtbBYAnPlZM3vYM9aypAMCLHjDQdBFaPJMw3hZEGldIPmypv
	 tT+hP7s7YYjV+xQfH0WTIzUnAiiAEP0M0y2oW6R6nf8zfDHnJ2oaOzzENiSqgzwnKJ
	 gCBJtp6kziQCjQTFe0mPFFqd5lN7bLc9axcuOpbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Anshumali Gaur <agaur@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1402/1518] octeontx2-vf: fix workqueue and netdev race in probe/remove
Date: Sat, 12 Sep 2026 08:59:31 +0200
Message-ID: <20260912065655.261540554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshumali Gaur <agaur@marvell.com>

[ Upstream commit 3ba97ff4f873481d370bee7f7dfb87f8296af9be ]

Initialize the VF workqueue before register_netdev() so ndo_set_rx_mode
does not queue work on a NULL workqueue. Unregister the netdev before
destroying the workqueue, and add proper probe error cleanup.

Fixes: cbc100aa2205 ("octeontx2-nicvf: add ndo_set_rx_mode support for multicast & promisc")
Signed-off-by: Nitin Shetty J <nshettyj@marvell.com>
Signed-off-by: Anshumali Gaur <agaur@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260820083634.1641740-1-nshettyj@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 5534c2c8db0fb..67f01bb6073b1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -736,16 +736,16 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_ptp_destroy;
 
+	err = otx2_vf_wq_init(vf);
+	if (err)
+		goto err_ipsec_clean;
+
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_ipsec_clean;
+		goto err_wq_destroy;
 	}
 
-	err = otx2_vf_wq_init(vf);
-	if (err)
-		goto err_unreg_netdev;
-
 	otx2vf_set_ethtool_ops(netdev);
 
 	err = otx2vf_mcam_flow_init(vf);
@@ -788,6 +788,10 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	otx2_shutdown_tc(vf);
 err_unreg_netdev:
 	unregister_netdev(netdev);
+err_wq_destroy:
+	cancel_work_sync(&vf->reset_task);
+	cancel_work_sync(&vf->rx_mode_work);
+	destroy_workqueue(vf->otx2_wq);
 err_ipsec_clean:
 	cn10k_ipsec_clean(vf);
 err_ptp_destroy:
@@ -835,11 +839,13 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	}
 #endif
 
-	cancel_work_sync(&vf->reset_task);
 	otx2_unregister_dl(vf);
 	unregister_netdev(netdev);
-	if (vf->otx2_wq)
+	if (vf->otx2_wq) {
+		cancel_work_sync(&vf->reset_task);
+		cancel_work_sync(&vf->rx_mode_work);
 		destroy_workqueue(vf->otx2_wq);
+	}
 	cn10k_ipsec_clean(vf);
 	otx2_ptp_destroy(vf);
 	otx2_mcam_flow_del(vf);
-- 
2.53.0



