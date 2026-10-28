Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215795;
	b=o40q67JMdTZZDnV4vOhXtS8mHp1R0x/5pz75it07mI/RZTtdzBrFg/QFb1hocgORbDGR
	 3ckXs7kLiAwJE3k9raggr/VzGUYdCv1OsbWhcqh5iPU4wQXWhlIz8WqOchVzcYMtkrx9h
	 W/IqC8CCn/+98GZbM4kvdCigubCqs8kdtEBIapF6QAbAZDjjRIaMQHxtlGc6LK0oEh1Zk
	 5wkwpuKqdSMgrvqmnrEWuScEh5d2pF28tzYR88eJwMAAKSPf4merG4ao7NV+87BFqvgua
	 Yc0GReVPtr6XgR9cYFFJ9vBS/z1cSAfb6FnBRosT6JQx1XBJgA+pFnPC7YdWxsvHqYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FVcAPNE5Da5m9wZ6AzxCGhpYanAR6ux81LLPAWjpa54=;
	b=z/vNHsiSh5cbYGq48sg37nLPmrTnsotQpvbUq5JvaUesS5EbdoDUr4iotcR7yUk/rs90
	 oA3j8G5k/kj6edOtF6RoIhHDyXrIPh5nKvx/BLgsQ1W/B1F5dsCc3IZt8WMJY/ZQl09dv
	 HuDWK2q9LvnboYQRV+igc9kY6GHuJfq8Wh28fknmIzyM9QU1kyyB46GwaZot2kxUrz810
	 CH1UgFu7LwwQPMSrIVxpWLHTH8dU9xDSGjk4dUsEmBQde2a97Zp+FESVPi3kSit41ybw/
	 mASYWSN0vUd62XFR4OO5zcB/qlf5J4uNds/kbSUt9KAFNOyBnlLy2Fzaw3YuTrjcjBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViFmIjDS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F21606A31A;
	Wed, 28 Oct 2026 19:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViFmIjDS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7A31F01825;
	Wed, 28 Oct 2026 19:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215794;
	bh=FVcAPNE5Da5m9wZ6AzxCGhpYanAR6ux81LLPAWjpa54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViFmIjDSBMMShgieECwgTfsqaOA2MlnCuibtQkVvdQfHjWf/pi0bxiqd9PXbJ8Vi5
	 ZYtO7/28wtWjeHcGy+UWeC+GaX9vvDpHsYiTuFQFrRnmVuIG1G+ErOOdXC7SV3uswB
	 n7APTbFInUx4zbEBvSKbVpZfUqd3bsGAFVSOqCU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1336/1887] dmaengine: idxd: fix double free of wq, engine, and group structs
Date: Wed, 28 Oct 2026 17:57:12 +0100
Message-ID: <20261028170529.837975667@linuxfoundation.org>
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
index 2880a0b0f5e67..b0f32a7982827 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -143,18 +143,12 @@ static void idxd_cleanup_interrupts(struct idxd_device *idxd)
 
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
@@ -196,7 +190,6 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 		rc = dev_set_name(conf_dev, "wq%d.%d", idxd->id, wq->id);
 		if (rc < 0) {
 			put_device(conf_dev);
-			kfree(wq);
 			goto err_unwind;
 		}
 
@@ -210,7 +203,6 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 		wq->wqcfg = kzalloc_node(idxd->wqcfg_size, GFP_KERNEL, dev_to_node(dev));
 		if (!wq->wqcfg) {
 			put_device(conf_dev);
-			kfree(wq);
 			rc = -ENOMEM;
 			goto err_unwind;
 		}
@@ -218,9 +210,7 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 		if (idxd->hw.wq_cap.op_config) {
 			wq->opcap_bmap = bitmap_zalloc(IDXD_MAX_OPCAP_BITS, GFP_KERNEL);
 			if (!wq->opcap_bmap) {
-				kfree(wq->wqcfg);
 				put_device(conf_dev);
-				kfree(wq);
 				rc = -ENOMEM;
 				goto err_unwind;
 			}
@@ -235,13 +225,8 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 
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
 
@@ -253,15 +238,12 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 
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
@@ -296,7 +278,6 @@ static int idxd_setup_engines(struct idxd_device *idxd)
 		rc = dev_set_name(conf_dev, "engine%d.%d", idxd->id, engine->id);
 		if (rc < 0) {
 			put_device(conf_dev);
-			kfree(engine);
 			goto err;
 		}
 
@@ -307,10 +288,8 @@ static int idxd_setup_engines(struct idxd_device *idxd)
 
  err:
 	while (--i >= 0) {
-		engine = idxd->engines[i];
-		conf_dev = engine_confdev(engine);
+		conf_dev = engine_confdev(idxd->engines[i]);
 		put_device(conf_dev);
-		kfree(engine);
 	}
 	kfree(idxd->engines);
 
@@ -319,13 +298,10 @@ static int idxd_setup_engines(struct idxd_device *idxd)
 
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
@@ -360,7 +336,6 @@ static int idxd_setup_groups(struct idxd_device *idxd)
 		rc = dev_set_name(conf_dev, "group%d.%d", idxd->id, group->id);
 		if (rc < 0) {
 			put_device(conf_dev);
-			kfree(group);
 			goto err;
 		}
 
@@ -380,7 +355,6 @@ static int idxd_setup_groups(struct idxd_device *idxd)
 	while (--i >= 0) {
 		group = idxd->groups[i];
 		put_device(group_confdev(group));
-		kfree(group);
 	}
 	kfree(idxd->groups);
 
-- 
2.53.0



