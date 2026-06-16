Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8F82F12AE;
	Tue, 16 Jun 2026 18:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633111; cv=none; b=LZbEogORJ4hu2JjpswcuKSBUBgGaBLCqatgGngWOpt1NswHPLZe5zOnv6eHPsBbGKsnPeLpZKvGtzGsKbbDmu5qs3npNC5OnQoQjQ59jlsT5NXC+diliCAf4QRXjzs9XgKzNPe37QhRNNPf4C+0R5X+I5DhIJ25p2Zxaer8XLA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633111; c=relaxed/simple;
	bh=hifhXj/Xhu5ZwYS7HCtMRx0PpCIlHpVQN4wwey/sB20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAyEmdNjN36j/3podQZcmFhjaA6fWvOHoa7mebX/T1Revfi8oHE/o0T+OTe09HKvl+PZ2owQj0d98oikQs8VV8JDwLkp72ykVe4HUQGLuXE+SfpramonySo7BuRYOhQsFT6Uek5FY/YgjulHWUWElWaaQOn3qUvaSJOgBYysez4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XG/QrsdI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XG/QrsdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6221F000E9;
	Tue, 16 Jun 2026 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633110;
	bh=t1vk2XuJy6m5Uxd2HPCqQAcqLLZr/z+vKcKyhjxh34g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XG/QrsdIRjKowoJ85QQ0G+0PwgGITxnt7hvsDEbsD4tnhxRwjepdeOL2rKC3OqlMI
	 TspzlKKN+lO0l1naW6JuVGTDubJwDW/jk0rDdeQ4lit78c+sPloywH/BUnkX/+phC+
	 QJe/yS8wMCteTxBcCmvswggTPwTCnjsmomaTx5sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/411] dmaengine: idxd: Fix not releasing workqueue on .release()
Date: Tue, 16 Jun 2026 20:24:04 +0530
Message-ID: <20260616145100.702231067@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 3d33de353b1ff9023d5ec73b9becf80ea87af695 ]

The workqueue associated with an DSA/IAA device is not released when
the object is freed.

Fixes: 47c16ac27d4c ("dmaengine: idxd: fix idxd conf_dev 'struct device' lifetime")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-7-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ Remove destroy_workqueue(idxd->wq) from the function idxd_remove() to
avoid the workqueue is released twice. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c  | 1 -
 drivers/dma/idxd/sysfs.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index f2d27c6ec1ce88..698387103da738 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -829,7 +829,6 @@ static void idxd_remove(struct pci_dev *pdev)
 	pci_iounmap(pdev, idxd->reg_base);
 	iommu_dev_disable_feature(&pdev->dev, IOMMU_DEV_FEAT_SVA);
 	pci_disable_device(pdev);
-	destroy_workqueue(idxd->wq);
 	perfmon_pmu_remove(idxd);
 	put_device(idxd_confdev(idxd));
 }
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 489a9d8850764b..ee208dfdd0cb51 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1271,6 +1271,7 @@ static void idxd_conf_device_release(struct device *dev)
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
+	destroy_workqueue(idxd->wq);
 	kfree(idxd->groups);
 	kfree(idxd->wqs);
 	kfree(idxd->engines);
-- 
2.53.0



