Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0622346AFB;
	Fri,  7 Aug 2026 15:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116561; cv=none; b=YN4A8ve+x6clJISsmc2mD2AmoKYIsx+kFegC96h0RYb43E2ztsUGGCrV4tCA1oX263AuxtHF3azUxjYZsXT8igXVAhFD7/THEfaRzbo4hoEOLBIcEzTcFWJFjg9uhz9I79JoxfYZOaHgHSy0oB4TfEroTGRhlnYIvJ+N4VR2O6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116561; c=relaxed/simple;
	bh=nDz/bTpx/+PE+y7OUqDiWZfnqyEvIjMaLpikxf09X/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElkiTTl8cxwQ3Qc2QShbh78dPjJj2O3S5S+hfJeFdJ2ny/g0267HJgV4YfUcXyTMsyCeCVfY9EWxo4/492J7tbqESkr1PV62y4RTO/m4DXFTFH2YnZcOyCU5PaPSuJRCDCYhtMlGBp69V9ZhDfwEYyGTbyjimH7aYHZkQfD5yCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=In2Lrj/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="In2Lrj/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FDF1F000E9;
	Fri,  7 Aug 2026 15:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116559;
	bh=vDJBkzt1Ip/37xdXt1LRLycuVKBmU+Pb3jwXVnB44RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=In2Lrj/ge9njZ3Gt8YOBv9avo2X8/mGEN0iOARXxhBhh3wTG36DGmH4dAgQ71DphD
	 Ub9b2dpLyCfLmibZ3ULjnhgyDxWEUG3ng3L0oTKZEqINl5gN3EtlgDzgjqgpOiN756
	 sbmNMNq+P3+wRwUIsNb38mXVs8WSpYDllnNKYH70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 012/438] dmaengine: idxd: fix double free of wq, engine, and group structs
Date: Fri,  7 Aug 2026 16:33:28 +0200
Message-ID: <20260807143428.272192525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit ec2d428b2e32dd157de8f86a86dd85c5b2c8f45c ]

The release callbacks for wq, engine, and group devices
(idxd_conf_wq_release, idxd_conf_engine_release,
idxd_conf_group_release) each call kfree() on the enclosing struct.
The setup error paths and cleanup functions also call kfree()
explicitly after put_device(), producing a double free whenever
put_device() drops the reference count to zero and fires the release.

In the setup functions, device_initialize() is called before
device_add(), so the reference count is exactly 1 at the error sites.
put_device() unconditionally fires the release, which frees the struct;
the subsequent explicit kfree() then operates on freed memory.

For idxd_setup_wqs(), the wq release callback also owns opcap_bmap
and wqcfg. The error unwind additionally freed those fields explicitly
before calling put_device(), causing further double frees on both.

Remove the redundant explicit kfree() calls from all setup error paths
and cleanup functions for wq, engine, and group structs, delegating
sole ownership of those allocations to the release callbacks.

Fixes: 7c5dd23e57c1 ("dmaengine: idxd: fix wq conf_dev 'struct device' lifetime")
Fixes: 75b911309060 ("dmaengine: idxd: fix engine conf_dev lifetime")
Fixes: defe49f96012 ("dmaengine: idxd: fix group conf_dev lifetime")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260415205452.67155-1-dbgh9129@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index f1cfc7790d950..4b827a3297564 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -159,18 +159,12 @@ static void idxd_cleanup_interrupts(struct idxd_device *idxd)
 
 static void idxd_clean_wqs(struct idxd_device *idxd)
 {
-	struct idxd_wq *wq;
 	struct device *conf_dev;
 	int i;
 
 	for (i = 0; i < idxd->max_wqs; i++) {
-		wq = idxd->wqs[i];
-		if (idxd->hw.wq_cap.op_config)
-			bitmap_free(wq->opcap_bmap);
-		kfree(wq->wqcfg);
-		conf_dev = wq_confdev(wq);
+		conf_dev = wq_confdev(idxd->wqs[i]);
 		put_device(conf_dev);
-		kfree(wq);
 	}
 	bitmap_free(idxd->wq_enable_map);
 	kfree(idxd->wqs);
@@ -212,7 +206,6 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 		rc = dev_set_name(conf_dev, "wq%d.%d", idxd->id, wq->id);
 		if (rc < 0) {
 			put_device(conf_dev);
-			kfree(wq);
 			goto err_unwind;
 		}
 
@@ -227,7 +220,6 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 		wq->wqcfg = kzalloc_node(idxd->wqcfg_size, GFP_KERNEL, dev_to_node(dev));
 		if (!wq->wqcfg) {
 			put_device(conf_dev);
-			kfree(wq);
 			rc = -ENOMEM;
 			goto err_unwind;
 		}
@@ -235,9 +227,7 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 		if (idxd->hw.wq_cap.op_config) {
 			wq->opcap_bmap = bitmap_zalloc(IDXD_MAX_OPCAP_BITS, GFP_KERNEL);
 			if (!wq->opcap_bmap) {
-				kfree(wq->wqcfg);
 				put_device(conf_dev);
-				kfree(wq);
 				rc = -ENOMEM;
 				goto err_unwind;
 			}
@@ -252,13 +242,8 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 
 err_unwind:
 	while (--i >= 0) {
-		wq = idxd->wqs[i];
-		if (idxd->hw.wq_cap.op_config)
-			bitmap_free(wq->opcap_bmap);
-		kfree(wq->wqcfg);
-		conf_dev = wq_confdev(wq);
+		conf_dev = wq_confdev(idxd->wqs[i]);
 		put_device(conf_dev);
-		kfree(wq);
 	}
 	bitmap_free(idxd->wq_enable_map);
 
@@ -270,15 +255,12 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 
 static void idxd_clean_engines(struct idxd_device *idxd)
 {
-	struct idxd_engine *engine;
 	struct device *conf_dev;
 	int i;
 
 	for (i = 0; i < idxd->max_engines; i++) {
-		engine = idxd->engines[i];
-		conf_dev = engine_confdev(engine);
+		conf_dev = engine_confdev(idxd->engines[i]);
 		put_device(conf_dev);
-		kfree(engine);
 	}
 	kfree(idxd->engines);
 }
@@ -313,7 +295,6 @@ static int idxd_setup_engines(struct idxd_device *idxd)
 		rc = dev_set_name(conf_dev, "engine%d.%d", idxd->id, engine->id);
 		if (rc < 0) {
 			put_device(conf_dev);
-			kfree(engine);
 			goto err;
 		}
 
@@ -324,10 +305,8 @@ static int idxd_setup_engines(struct idxd_device *idxd)
 
  err:
 	while (--i >= 0) {
-		engine = idxd->engines[i];
-		conf_dev = engine_confdev(engine);
+		conf_dev = engine_confdev(idxd->engines[i]);
 		put_device(conf_dev);
-		kfree(engine);
 	}
 	kfree(idxd->engines);
 
@@ -336,13 +315,10 @@ static int idxd_setup_engines(struct idxd_device *idxd)
 
 static void idxd_clean_groups(struct idxd_device *idxd)
 {
-	struct idxd_group *group;
 	int i;
 
 	for (i = 0; i < idxd->max_groups; i++) {
-		group = idxd->groups[i];
-		put_device(group_confdev(group));
-		kfree(group);
+		put_device(group_confdev(idxd->groups[i]));
 	}
 	kfree(idxd->groups);
 }
@@ -377,7 +353,6 @@ static int idxd_setup_groups(struct idxd_device *idxd)
 		rc = dev_set_name(conf_dev, "group%d.%d", idxd->id, group->id);
 		if (rc < 0) {
 			put_device(conf_dev);
-			kfree(group);
 			goto err;
 		}
 
@@ -402,7 +377,6 @@ static int idxd_setup_groups(struct idxd_device *idxd)
 	while (--i >= 0) {
 		group = idxd->groups[i];
 		put_device(group_confdev(group));
-		kfree(group);
 	}
 	kfree(idxd->groups);
 
-- 
2.53.0



