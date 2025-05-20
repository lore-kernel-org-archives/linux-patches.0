Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22497246771;
	Tue, 20 May 2025 14:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749902; cv=none; b=rwnsQje3GXotgH8Y4K9nnb5Hxe1wgFQbjx1Z5ezwGS/cGSW/QMu9ww24BdwGHMhThOfdlbRNe5nhve6x1ZILCRKzSOu1DUee8xln1gUEfsWbb3gMqOQRuxN8W2mfQG8o+jlGGoNYkr7c5yIR2i8IJ+sUmAaViXK0S0EQrmEbi2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749902; c=relaxed/simple;
	bh=cmevxjNyEexfrbsT2khgS08C1blkhP+ZHYe9kEOuP+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L11HRPM4I4O3il0YjSy12di+Vbx/de6JPsfImDaaNs/ZozZHL3WkbIxO9EaRwWUSl0zcH3AazkQVFBiypT3xX76UaJlFxYw3USF4icVQyL3B8h9fEcsC6jKWhE2PCv2+OVr+H8izlOjLq6uwvufWrmqysBd7Sk6A6pbGS92+FYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/Rwo48z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/Rwo48z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5892C4CEEB;
	Tue, 20 May 2025 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749902;
	bh=cmevxjNyEexfrbsT2khgS08C1blkhP+ZHYe9kEOuP+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/Rwo48zm/9h7PQ0qwH58w8ZFYP80e/28EitHBtCDlFEMmcumsaXAUhtQ16xNesIO
	 WdHde09gBmO4xtI02EvD4DRLbaZMhBivQxPDP18Lkd9ELa0Z8IYeddAHdJoO/bjRcU
	 gP3FaeM8hY+DfDr8wLl/Pks6BD5FHbw+11L42fjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenghua Yu <fenghuay@nvidia.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 097/117] dmaengine: idxd: Add missing cleanup for early error out in idxd_setup_internals
Date: Tue, 20 May 2025 15:51:02 +0200
Message-ID: <20250520125807.840867231@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 61259fb96e023f7299c442c48b13e72c441fc0f2 upstream.

The idxd_setup_internals() is missing some cleanup when things fail in
the middle.

Add the appropriate cleanup routines:

- cleanup groups
- cleanup enginces
- cleanup wqs

to make sure it exits gracefully.

Fixes: defe49f96012 ("dmaengine: idxd: fix group conf_dev lifetime")
Cc: stable@vger.kernel.org
Suggested-by: Fenghua Yu <fenghuay@nvidia.com>
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250404120217.48772-5-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |   58 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 7 deletions(-)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -145,6 +145,25 @@ static void idxd_cleanup_interrupts(stru
 	pci_free_irq_vectors(pdev);
 }
 
+static void idxd_clean_wqs(struct idxd_device *idxd)
+{
+	struct idxd_wq *wq;
+	struct device *conf_dev;
+	int i;
+
+	for (i = 0; i < idxd->max_wqs; i++) {
+		wq = idxd->wqs[i];
+		if (idxd->hw.wq_cap.op_config)
+			bitmap_free(wq->opcap_bmap);
+		kfree(wq->wqcfg);
+		conf_dev = wq_confdev(wq);
+		put_device(conf_dev);
+		kfree(wq);
+	}
+	bitmap_free(idxd->wq_enable_map);
+	kfree(idxd->wqs);
+}
+
 static int idxd_setup_wqs(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
@@ -235,6 +254,21 @@ err_bitmap:
 	return rc;
 }
 
+static void idxd_clean_engines(struct idxd_device *idxd)
+{
+	struct idxd_engine *engine;
+	struct device *conf_dev;
+	int i;
+
+	for (i = 0; i < idxd->max_engines; i++) {
+		engine = idxd->engines[i];
+		conf_dev = engine_confdev(engine);
+		put_device(conf_dev);
+		kfree(engine);
+	}
+	kfree(idxd->engines);
+}
+
 static int idxd_setup_engines(struct idxd_device *idxd)
 {
 	struct idxd_engine *engine;
@@ -286,6 +320,19 @@ static int idxd_setup_engines(struct idx
 	return rc;
 }
 
+static void idxd_clean_groups(struct idxd_device *idxd)
+{
+	struct idxd_group *group;
+	int i;
+
+	for (i = 0; i < idxd->max_groups; i++) {
+		group = idxd->groups[i];
+		put_device(group_confdev(group));
+		kfree(group);
+	}
+	kfree(idxd->groups);
+}
+
 static int idxd_setup_groups(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
@@ -400,7 +447,7 @@ static int idxd_init_evl(struct idxd_dev
 static int idxd_setup_internals(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
-	int rc, i;
+	int rc;
 
 	init_waitqueue_head(&idxd->cmd_waitq);
 
@@ -431,14 +478,11 @@ static int idxd_setup_internals(struct i
  err_evl:
 	destroy_workqueue(idxd->wq);
  err_wkq_create:
-	for (i = 0; i < idxd->max_groups; i++)
-		put_device(group_confdev(idxd->groups[i]));
+	idxd_clean_groups(idxd);
  err_group:
-	for (i = 0; i < idxd->max_engines; i++)
-		put_device(engine_confdev(idxd->engines[i]));
+	idxd_clean_engines(idxd);
  err_engine:
-	for (i = 0; i < idxd->max_wqs; i++)
-		put_device(wq_confdev(idxd->wqs[i]));
+	idxd_clean_wqs(idxd);
  err_wqs:
 	return rc;
 }


