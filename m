Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9E8339714;
	Tue, 11 Nov 2025 01:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824991; cv=none; b=htcZOTzr7QqEd3tu/HWKd7lpuFQ22Gli3/44QDMCEwybY1ycG3Rrf02MaaLfdC1v7Pb4+kQmthuSx+zJq4JieDt8i3xNwuRcR7O3pOmQ7OrK1bMEwJU4weyTTtD4h2iFWmsKVJ4WkKPUmsNhIG/sD4UEZl+CtvsU7L5xf8+6Zos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824991; c=relaxed/simple;
	bh=q3tShRDKSVRMPbmje4yrOFmVoakAfQU/1XbbE6A3aSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9zxwYZ5f2yq/7JE9D5a/ZKMIPtI7JRzFjn+Uj5Ob5lq3fecfvx/kt6gxO0tvcak8QwuYCs/j+7SlmdhrwNc4MU8HS7zuh95twCqUXziQ47FNEyZcj+DzGz84x9+Z1NOs4e2hu1GsY3uXkuDksygNkFonhbJxDuoUM+nihDow5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZDCq2Vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZDCq2Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ACCC116D0;
	Tue, 11 Nov 2025 01:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824991;
	bh=q3tShRDKSVRMPbmje4yrOFmVoakAfQU/1XbbE6A3aSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZDCq2VmZZt8HeieVjm1JN3XRilQvde8SwzAgbqy5qVtbF0as2ks1cnfFF8VsifK8
	 OJQEPxvuD0eSfPuNWRI0HJSMEWVzwY01k+w5MqnDAIOiWOI7MIsotyUFGnmf/fW3KV
	 NtsRY/EBtb/NWPJUQPcXEjYCpgz3T6Zz6kspSSzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 611/849] crypto: hisilicon/qm - clear all VF configurations in the hardware
Date: Tue, 11 Nov 2025 09:43:01 +0900
Message-ID: <20251111004551.198220942@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 64b9642fc29a14e1fe67842be9c69c7b90a3bcd6 ]

When disabling SR-IOV, clear the configuration of each VF
in the hardware. Do not exit the configuration clearing process
due to the failure of a single VF. Additionally, Clear the VF
configurations before decrementing the PM counter.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 822202e0f11b6..f9bf102b2b37d 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3646,19 +3646,19 @@ static int qm_vf_q_assign(struct hisi_qm *qm, u32 num_vfs)
 	return 0;
 }
 
-static int qm_clear_vft_config(struct hisi_qm *qm)
+static void qm_clear_vft_config(struct hisi_qm *qm)
 {
-	int ret;
 	u32 i;
 
-	for (i = 1; i <= qm->vfs_num; i++) {
-		ret = hisi_qm_set_vft(qm, i, 0, 0);
-		if (ret)
-			return ret;
-	}
-	qm->vfs_num = 0;
+	/*
+	 * When disabling SR-IOV, clear the configuration of each VF in the hardware
+	 * sequentially. Failure to clear a single VF should not affect the clearing
+	 * operation of other VFs.
+	 */
+	for (i = 1; i <= qm->vfs_num; i++)
+		(void)hisi_qm_set_vft(qm, i, 0, 0);
 
-	return 0;
+	qm->vfs_num = 0;
 }
 
 static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
@@ -3993,13 +3993,13 @@ int hisi_qm_sriov_enable(struct pci_dev *pdev, int max_vfs)
 		goto err_put_sync;
 	}
 
+	qm->vfs_num = num_vfs;
 	ret = pci_enable_sriov(pdev, num_vfs);
 	if (ret) {
 		pci_err(pdev, "Can't enable VF!\n");
 		qm_clear_vft_config(qm);
 		goto err_put_sync;
 	}
-	qm->vfs_num = num_vfs;
 
 	pci_info(pdev, "VF enabled, vfs_num(=%d)!\n", num_vfs);
 
@@ -4034,11 +4034,10 @@ int hisi_qm_sriov_disable(struct pci_dev *pdev, bool is_frozen)
 	}
 
 	pci_disable_sriov(pdev);
-
-	qm->vfs_num = 0;
+	qm_clear_vft_config(qm);
 	qm_pm_put_sync(qm);
 
-	return qm_clear_vft_config(qm);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_sriov_disable);
 
-- 
2.51.0



