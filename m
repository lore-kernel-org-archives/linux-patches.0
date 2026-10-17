Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAE4382F2F;
	Sat, 17 Oct 2026 17:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259922; cv=none; b=kJEja4IaqMV0YdP1WOGl1RKvXc3Uu4Y9yUHuq/oy6zaGIHmKzrY41sKhmHZt55E0PkOkVCZPWYx6I+Xo5wFBa39w7bNnoBI8vCgg1sXsqXZvqP90c0nRToBWa6Y5ILwXaNaUfB1gQpO+ioasdKM4XT0+cf+aMSoxBLF8QHP8CwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259922; c=relaxed/simple;
	bh=7O+Bt34BuAebvxCu/337DDXedbCTPzOeX4zt7v6A00A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPDlDupEcpuI4MPyfa8U1L4x0eecICl9IHSTZDZmD82MeAmx2GBPhe+4PffJHVdutcLOEOMnqtkjGAArk8nzzZDPGWbypWDwo/hdc+hvGt2mE1gfjU1ZcSEMFu3QQvcR9DJWdlEDtXETdDMx8wfyrqC3Bnxh5tCjbQECB4q2i60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qj+Zm+VZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qj+Zm+VZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5498C1F000C4;
	Sat, 17 Oct 2026 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259920;
	bh=FsFdYCxCJTSZG4PAS2sP63iSpFgIMD5/JgpgMtyfpnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qj+Zm+VZnmxpbLGQLTOMH1YN08mlG9Qyae+U19E5ZZZmCs7IuistkWtVm0h3BWm1w
	 DR+OFSQZaV5vOYFxVDAVTgGZY87JpnFBpk7nsScaRiTHVIQcHL4OEU/Y2i72T6Ipv1
	 Lu06BuKuxBNtRqPmDcMkzgjG8VFcGuW98kqg8ANU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Anshumali Gaur <agaur@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1375/1674] octeontx2-vf: fix workqueue and netdev race in probe/remove
Date: Sat, 17 Oct 2026 18:00:47 +0200
Message-ID: <20261017160506.457348118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index d93b4109a144f..3fe0b30d39b74 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -685,16 +685,16 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		snprintf(netdev->name, sizeof(netdev->name), "lbk%d", n);
 	}
 
+	err = otx2_wq_init(vf);
+	if (err)
+		goto err_ptp_destroy;
+
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_ptp_destroy;
+		goto err_wq_destroy;
 	}
 
-	err = otx2_wq_init(vf);
-	if (err)
-		goto err_unreg_netdev;
-
 	otx2vf_set_ethtool_ops(netdev);
 
 	err = otx2vf_mcam_flow_init(vf);
@@ -722,6 +722,10 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	otx2_shutdown_tc(vf);
 err_unreg_netdev:
 	unregister_netdev(netdev);
+err_wq_destroy:
+	cancel_work_sync(&vf->reset_task);
+	cancel_work_sync(&vf->rx_mode_work);
+	destroy_workqueue(vf->otx2_wq);
 err_ptp_destroy:
 	otx2_ptp_destroy(vf);
 err_detach_rsrc:
@@ -769,11 +773,13 @@ static void otx2vf_remove(struct pci_dev *pdev)
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
 	otx2_ptp_destroy(vf);
 	otx2_mcam_flow_del(vf);
 	otx2_shutdown_tc(vf);
-- 
2.53.0



