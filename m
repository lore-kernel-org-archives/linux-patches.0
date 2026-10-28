Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216311;
	b=ABvEV3P8uGzGMfJEDEy1+epTt4FerrO7/n1AYR5fE2E3f1x3heR5AQKuozW3pT2ksue7
	 F/GxTKwwA9x4i0258VMqm/TZ0GtT0JkCm/OHFugPQ2BNEpznmcsc25ELcPiW8Tr13RxIC
	 1t8UovE7idOPqHLuqGle2HD5iX9jIMlIdmMjcmNRy2ZPJXtmse0QFysQL9MIqFSI/BQTi
	 xWnUQN0PNw2Aln6FlBUNMBho7vpqx90vzCXYxYByrjxezNMiOG/VE/NasrX+jvWZnanDB
	 5iwM1DfPVj+jon0U1D5RfGEZsk0BPpqPggnv6sODoFviVEEeBD8+3HK7WhL0FWXqW+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XjW8FKfMlUzNEAIjpHppw5CmPQjX3+dLzgX0ifbcnAw=;
	b=ZZkhUmoVEQW/2TAoG1cB9neatLMjkbZvuZg/XHjVsGWrsoNFNyujzAg1vl+WESfLpwIO
	 CdHMXLlsFC4axj1+EycG47YZQQKzsO1a+yr2pxMAOsbnTiOa8sMpweUNuk67rl2WwhtJG
	 4qxM0fJr4Ahsa2YzuP7lwE08EiBgwu6KDJEFwfQMYfOYBf0nYtpgnoIkV8DCO3O2wLhvZ
	 lraMbQN5BeVow+3EOS2csF5mlK+kR8bRe9qrOFRKhJ+CsoinbuSM4M2upW84u+susmXBY
	 /ZHiZoYG+bgaciEzj1LC0tWBFNufGZPxjvRVMbyJ3DJVJwuJlbDz1FYhiOLpwpOHgtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2n3MZcc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0652E606A31E;
	Wed, 28 Oct 2026 19:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2n3MZcc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4094A1F01825;
	Wed, 28 Oct 2026 19:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216310;
	bh=XjW8FKfMlUzNEAIjpHppw5CmPQjX3+dLzgX0ifbcnAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2n3MZccHBTE09IoTX/xbBQlEz2mYxH/p+MQt9rmSMCR1LJ7+yB+H+8UPknWPh+oF
	 tKKDrmFH9ppUdpCt3lHROWWIsgGinN49dzPe15UfjEFQ1N6QOcjWX5eTfyAXCeSnBx
	 jNM7+p4mPmNk+9PnRQ7OdLeA1DT+oqJP8Eq0LVP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Anshumali Gaur <agaur@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1515/1887] octeontx2-vf: fix workqueue and netdev race in probe/remove
Date: Wed, 28 Oct 2026 18:00:11 +0100
Message-ID: <20261028170533.938973049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index af5d69e6d267a..f1ae4bb15b8cf 100644
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



