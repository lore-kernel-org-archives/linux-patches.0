Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE4733AD88;
	Sat, 12 Sep 2026 09:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205029; cv=none; b=ZgQgkXnl69XT72AYCIuQwM+jxeeEHplpL8g+LKREwVEvM7s7dqhMe2Ti2+eYQRAYGJn14ZPpTjDqsUq8v47otNK8rSR+eLho+8Z9N2rShwSP0TqHm90kTY/JQIKmwH0zHAcvlOVKQygoiAKCorv42wiNxp99CLWCHKKdlpwc4tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205029; c=relaxed/simple;
	bh=Tu0oTTp3q8seQiN7XZdpV1zK1b/SCe3Cs7bRif2cKg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFqMJQ8XBSP915dWz6U5xInZgGKIwTrpPBRrH6dNE29LEyvTwddCb7hRkDDxvdRsSVUdATZIejCS40m8U4Ks0G3MPcpqL8Bkea7fJKahjOOONW5KbuaYgRJilURQYa4uaYns6zx7UY97VGn4C5iGhD8pCsP3pDv9COUKJfq0Dfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnWBaD4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnWBaD4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33781F000FF;
	Sat, 12 Sep 2026 09:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205028;
	bh=AE6Jf0rcdVCNORYcnav7YtPfPvVyr4DdDycK0xzi01U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnWBaD4XT7NB3UN3+P2WDquvNJ9qs3xKiG6jqeLCesOzNWX/Q35zrLJ2423axFgcm
	 bj0iu9ckT7NY9Z5mJlFcJgIuyv5xsYFizvpD49KxPpXSPLFHFB8F9Jgy2ZeF1qRJLC
	 mJtiAwgfaHuirs87ysbUIPX0ntbiyoo7QZZMrIcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Anshumali Gaur <agaur@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1732/1815] octeontx2-vf: fix workqueue and netdev race in probe/remove
Date: Sat, 12 Sep 2026 08:58:02 +0200
Message-ID: <20260912065729.637491765@linuxfoundation.org>
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
index b022f52c68450..fcdf891f90b58 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -737,16 +737,16 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -789,6 +789,10 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -836,11 +840,13 @@ static void otx2vf_remove(struct pci_dev *pdev)
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



