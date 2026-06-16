Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993173A3E78;
	Tue, 16 Jun 2026 17:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631288; cv=none; b=hxIQZLIsojs6VVjSbFaCwTXtcOuwbeGLYSAMsnVXFJVCFzgL+XIrMCXrW31TCG+GlPyDM7awP0kuGrF9b0tGJOsxO5GBBRY9lMyLxeW7VVBJIFGqspcl/+8Uq75EeD8x8gHvnTOgTn2qKitZr67NCvqhglGuu8iLwEquNGZypiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631288; c=relaxed/simple;
	bh=n8xDyeMvLsjshalzIi/NmeYRH9vw2eJG81dOkaG5tUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvWIPF+j8qv+bp67RKGGJGblybxrcFOzYMZ1DFmI5WVTPmHiMRC7UNAn2RLHm+pQyLFr5opzJ/vfL7TXc2I4y1pX9PY8E3EpwRTs8N5M1wQoL2uT4IJ4hJ8nGqwdEiBOimuw5Nk0WNusdFlwxSazDY1MSd7vOzj12kt15X/rKUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aj3M8bHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aj3M8bHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7CC1F00AC4;
	Tue, 16 Jun 2026 17:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631287;
	bh=uOnipilYfCO6GNsKlG9u+G2q4/2sOl0qkNyno5V6HFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aj3M8bHWxq2Cwt4ZQtXOYNJSgI2eI3WMqWbAnWUfBKtB0odHM1Iii/qggKFEke4EZ
	 NRoHZqvnuILL0aCStOLrlY+ck0TRSjxSZmCebULLAjxdCzsS5UMBpm3K9VFXwd9EUs
	 HT7+x3KCmKkJvqLC3Og80VoZFY/4HQvG8IKj/+38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/522] dmaengine: idxd: Fix not releasing workqueue on .release()
Date: Tue, 16 Jun 2026 20:25:39 +0530
Message-ID: <20260616145135.088308344@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6059ffc08eace1..2880a0b0f5e67e 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -813,7 +813,6 @@ static void idxd_remove(struct pci_dev *pdev)
 	if (device_user_pasid_enabled(idxd))
 		iommu_dev_disable_feature(&pdev->dev, IOMMU_DEV_FEAT_SVA);
 	pci_disable_device(pdev);
-	destroy_workqueue(idxd->wq);
 	perfmon_pmu_remove(idxd);
 	put_device(idxd_confdev(idxd));
 }
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 0689464c4816ab..ea222e1654ab94 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1663,6 +1663,7 @@ static void idxd_conf_device_release(struct device *dev)
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
+	destroy_workqueue(idxd->wq);
 	kfree(idxd->groups);
 	bitmap_free(idxd->wq_enable_map);
 	kfree(idxd->wqs);
-- 
2.53.0



