Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FBD15CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEBFC433D6;
	Tue,  8 Nov 2022 13:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915556;
	bh=uRFhGg7Ypg5wGlVbkwJUQlCJaH1yK/i5jBX9JTsvRlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgjnL1PGyMCT7augW351Jd4iWFHLVBP07vwEhw3pL2P5EJXO6q6qnVOV3P4idJK5U
	 GMEuXWju55PIwhsrae+EMvfGuvpIc9M61WtwHh/sMR5fmPOXxfs1CmSwULYlm5ZO6o
	 ONPTVihgYh1ciA2AsXJ/5bs3P2zYCGjtjqJEUjPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wengjianfeng <wengjianfeng@yulong.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/118] NFC: nxp-nci: remove unnecessary labels
Date: Tue,  8 Nov 2022 14:38:22 +0100
Message-Id: <20221108133341.716314975@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: wengjianfeng <wengjianfeng@yulong.com>

[ Upstream commit 96a19319921ceb4b2f4c49d1b9bf9de1161e30ca ]

Simplify the code by removing unnecessary labels and returning directly.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7bf1ed6aff0f ("nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nxp-nci/core.c | 39 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index a0ce95a287c5..2b0c7232e91f 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -70,21 +70,16 @@ static int nxp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	struct nxp_nci_info *info = nci_get_drvdata(ndev);
 	int r;
 
-	if (!info->phy_ops->write) {
-		r = -ENOTSUPP;
-		goto send_exit;
-	}
+	if (!info->phy_ops->write)
+		return -EOPNOTSUPP;
 
-	if (info->mode != NXP_NCI_MODE_NCI) {
-		r = -EINVAL;
-		goto send_exit;
-	}
+	if (info->mode != NXP_NCI_MODE_NCI)
+		return -EINVAL;
 
 	r = info->phy_ops->write(info->phy_id, skb);
 	if (r < 0)
 		kfree_skb(skb);
 
-send_exit:
 	return r;
 }
 
@@ -104,10 +99,8 @@ int nxp_nci_probe(void *phy_id, struct device *pdev,
 	int r;
 
 	info = devm_kzalloc(pdev, sizeof(struct nxp_nci_info), GFP_KERNEL);
-	if (!info) {
-		r = -ENOMEM;
-		goto probe_exit;
-	}
+	if (!info)
+		return -ENOMEM;
 
 	info->phy_id = phy_id;
 	info->pdev = pdev;
@@ -120,31 +113,25 @@ int nxp_nci_probe(void *phy_id, struct device *pdev,
 	if (info->phy_ops->set_mode) {
 		r = info->phy_ops->set_mode(info->phy_id, NXP_NCI_MODE_COLD);
 		if (r < 0)
-			goto probe_exit;
+			return r;
 	}
 
 	info->mode = NXP_NCI_MODE_COLD;
 
 	info->ndev = nci_allocate_device(&nxp_nci_ops, NXP_NCI_NFC_PROTOCOLS,
 					 NXP_NCI_HDR_LEN, 0);
-	if (!info->ndev) {
-		r = -ENOMEM;
-		goto probe_exit;
-	}
+	if (!info->ndev)
+		return -ENOMEM;
 
 	nci_set_parent_dev(info->ndev, pdev);
 	nci_set_drvdata(info->ndev, info);
 	r = nci_register_device(info->ndev);
-	if (r < 0)
-		goto probe_exit_free_nci;
+	if (r < 0) {
+		nci_free_device(info->ndev);
+		return r;
+	}
 
 	*ndev = info->ndev;
-
-	goto probe_exit;
-
-probe_exit_free_nci:
-	nci_free_device(info->ndev);
-probe_exit:
 	return r;
 }
 EXPORT_SYMBOL(nxp_nci_probe);
-- 
2.35.1



