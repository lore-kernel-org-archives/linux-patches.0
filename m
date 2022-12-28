Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F461875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3463AC433D2;
	Wed, 28 Dec 2022 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243040;
	bh=2PV6rZ6kwN1VEo166SUCdr4uGIWFt0H3y7Ea7llfnzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPAabiLsjr7MJM2x3uzrGiA45UHHZgUx9wbefrbE4TMCYOeluaC9vn05NxXtFug7C
	 A16kt37Z4E64cAbeamlfQ3apS2eEAdEPp1clwNeXreoVqg1iir23zw/lckPlXfILWC
	 d0V9BpV27FV1MzlGKEn5Di6Kw/Ld3W0OkM7EVzf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 674/731] crypto: hisilicon/hpre - fix resource leak in remove process
Date: Wed, 28 Dec 2022 15:43:01 +0100
Message-Id: <20221228144316.016377145@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhiqi Song <songzhiqi1@huawei.com>

[ Upstream commit 45e6319bd5f2154d8b8c9f1eaa4ac030ba0d330c ]

In hpre_remove(), when the disable operation of qm sriov failed,
the following logic should continue to be executed to release the
remaining resources that have been allocated, instead of returning
directly, otherwise there will be resource leakage.

Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 65a641396c07..edc61e4105f3 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1143,18 +1143,12 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 static void hpre_remove(struct pci_dev *pdev)
 {
 	struct hisi_qm *qm = pci_get_drvdata(pdev);
-	int ret;
 
 	hisi_qm_pm_uninit(qm);
 	hisi_qm_wait_task_finish(qm, &hpre_devices);
 	hisi_qm_alg_unregister(qm, &hpre_devices);
-	if (qm->fun_type == QM_HW_PF && qm->vfs_num) {
-		ret = hisi_qm_sriov_disable(pdev, true);
-		if (ret) {
-			pci_err(pdev, "Disable SRIOV fail!\n");
-			return;
-		}
-	}
+	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
+		hisi_qm_sriov_disable(pdev, true);
 
 	hpre_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
-- 
2.35.1



