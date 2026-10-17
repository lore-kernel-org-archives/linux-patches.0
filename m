Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4893A0E85;
	Sat, 17 Oct 2026 16:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254913; cv=none; b=tTWbkwWHCHqbfPq4AJMjLgetGdNKoYzIKWbWEtgiccmLC9phlmj3cMrhHv3w9UN/hzQEfhqGimUZdmLQOa/6aBhSRCOUw8kEtqFEqkt0EnlBOubEqy58axUuAt6Kpz4rm9G5NbpY6qVMm5/u2Ibz4VMIJnYekFeazPJiEBNRPVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254913; c=relaxed/simple;
	bh=6Xm6L2E6yhMOaW0MTGJn30N0xOBzaq7X7qmc5OjifQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hqn2IA3xle2s0f1kA4D9jtaomhbOLxVsJFIwhNZeHzE2DnbhurUyuhnYb4rliK7XMTLwv+gk3Vx3QutCTBxFYGtSWXkcv79eddNjy6rAq+t2z6a1A3FVL9jNevSuFQfkhOgsuJYb96hzuUjarzpcRvTayFh2hRb5KoTqh9Ynogw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Es+zGu7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Es+zGu7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6CA1F000C4;
	Sat, 17 Oct 2026 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254912;
	bh=s0t8OWFdydpOjRNIuJKAtxsXUtL4TVfZKOo32W4FrVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Es+zGu7zBhVYm12XWd/f7BJWVB5n00Al0uYldHlCR1MieY03AyW+8yN9/1jnW7LXT
	 DUxlHBSCRFEcwZU5bEBJt+LQzMmHExqLB6kIVAqpwQqvNyCarhj1EoP92wzSWmbsud
	 vuaKoll+RBPoCAWWNw0wYwREU9kmkcDUHG84D3vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Anshumali Gaur <agaur@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 601/869] octeontx2-vf: fix workqueue and netdev race in probe/remove
Date: Sat, 17 Oct 2026 17:57:22 +0200
Message-ID: <20261017160052.453041086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e26c830ae1ffc..37d36cedd157c 100644
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



