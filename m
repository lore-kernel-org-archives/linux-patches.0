Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B18529CEB;
	Tue,  8 Oct 2024 13:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394106; cv=none; b=i68vY9H2g69UaxXlxmlTkatM1UC41h5DcTL3NMmDBFCN+ZtyHqGKdsz1a0s5uHxFcpGXDG7jpdfxg5t8yx9MI9C1gtAREUOPBelgl7oja/NRVXTg/CdxT36++Mz5GHEAiDHYvkejgPMES/+K4Ifz/BH9IgsE5qgLM6DH95tw7cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394106; c=relaxed/simple;
	bh=Sy63Ad0DzbjK9drcGBrrlPi5bp+s6vKd8lR7E7XdDys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5Jrl4PuHsrR+PlYd6/HSebNuk5PhKDASL4dPiRhifbrJtfG6XCq4RFv3EuKDFWf7zIxDJ/f0/SCNgmWv9N9GJFo/6cfTn+97eVn9N0jCnAGaDSr1boCa1R/3Iokay+PtN0UzqwoJywyif9mfJzggMyksCGOGLnwKumFGGjDq20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWFGDCK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWFGDCK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0916C4CEC7;
	Tue,  8 Oct 2024 13:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394106;
	bh=Sy63Ad0DzbjK9drcGBrrlPi5bp+s6vKd8lR7E7XdDys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWFGDCK8tu2GxCbg0bv5u/SWhhW/H7Hqos6r61hFMNeJoUPj+oU/XaD64uh2oq+27
	 UFETlVQX5Te0EnMqYsIqvTFJzR9wUqSAi+udrxkqKYrACtzsEo2SC4dxMU+s6Hh5GM
	 j2CH0fPQV3L6qRXeV6aFj3IvCZj+GgvzShGbyJzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 349/386] remoteproc: k3-r5: Acquire mailbox handle during probe routine
Date: Tue,  8 Oct 2024 14:09:54 +0200
Message-ID: <20241008115643.116250101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Beleswar Padhi <b-padhi@ti.com>

[ Upstream commit f3f11cfe890733373ddbb1ce8991ccd4ee5e79e1 ]

Acquire the mailbox handle during device probe and do not release handle
in stop/detach routine or error paths. This removes the redundant
requests for mbox handle later during rproc start/attach. This also
allows to defer remoteproc driver's probe if mailbox is not probed yet.

Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Link: https://lore.kernel.org/r/20240808074127.2688131-3-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 8fa052c29e50 ("remoteproc: k3-r5: Delay notification of wakeup event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c | 78 +++++++++---------------
 1 file changed, 30 insertions(+), 48 deletions(-)

diff --git a/drivers/remoteproc/ti_k3_r5_remoteproc.c b/drivers/remoteproc/ti_k3_r5_remoteproc.c
index 7c48f41808fa3..15fc663389096 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -194,6 +194,10 @@ static void k3_r5_rproc_mbox_callback(struct mbox_client *client, void *data)
 	const char *name = kproc->rproc->name;
 	u32 msg = omap_mbox_message(data);
 
+	/* Do not forward message from a detached core */
+	if (kproc->rproc->state == RPROC_DETACHED)
+		return;
+
 	dev_dbg(dev, "mbox msg: 0x%x\n", msg);
 
 	switch (msg) {
@@ -229,6 +233,10 @@ static void k3_r5_rproc_kick(struct rproc *rproc, int vqid)
 	mbox_msg_t msg = (mbox_msg_t)vqid;
 	int ret;
 
+	/* Do not forward message to a detached core */
+	if (kproc->rproc->state == RPROC_DETACHED)
+		return;
+
 	/* send the index of the triggered virtqueue in the mailbox payload */
 	ret = mbox_send_message(kproc->mbox, (void *)msg);
 	if (ret < 0)
@@ -399,12 +407,9 @@ static int k3_r5_rproc_request_mbox(struct rproc *rproc)
 	client->knows_txdone = false;
 
 	kproc->mbox = mbox_request_channel(client, 0);
-	if (IS_ERR(kproc->mbox)) {
-		ret = -EBUSY;
-		dev_err(dev, "mbox_request_channel failed: %ld\n",
-			PTR_ERR(kproc->mbox));
-		return ret;
-	}
+	if (IS_ERR(kproc->mbox))
+		return dev_err_probe(dev, PTR_ERR(kproc->mbox),
+				     "mbox_request_channel failed\n");
 
 	/*
 	 * Ping the remote processor, this is only for sanity-sake for now;
@@ -552,10 +557,6 @@ static int k3_r5_rproc_start(struct rproc *rproc)
 	u32 boot_addr;
 	int ret;
 
-	ret = k3_r5_rproc_request_mbox(rproc);
-	if (ret)
-		return ret;
-
 	boot_addr = rproc->bootaddr;
 	/* TODO: add boot_addr sanity checking */
 	dev_dbg(dev, "booting R5F core using boot addr = 0x%x\n", boot_addr);
@@ -564,7 +565,7 @@ static int k3_r5_rproc_start(struct rproc *rproc)
 	core = kproc->core;
 	ret = ti_sci_proc_set_config(core->tsp, boot_addr, 0, 0);
 	if (ret)
-		goto put_mbox;
+		return ret;
 
 	/* unhalt/run all applicable cores */
 	if (cluster->mode == CLUSTER_MODE_LOCKSTEP) {
@@ -580,13 +581,12 @@ static int k3_r5_rproc_start(struct rproc *rproc)
 		if (core != core0 && core0->rproc->state == RPROC_OFFLINE) {
 			dev_err(dev, "%s: can not start core 1 before core 0\n",
 				__func__);
-			ret = -EPERM;
-			goto put_mbox;
+			return -EPERM;
 		}
 
 		ret = k3_r5_core_run(core);
 		if (ret)
-			goto put_mbox;
+			return ret;
 	}
 
 	return 0;
@@ -596,8 +596,6 @@ static int k3_r5_rproc_start(struct rproc *rproc)
 		if (k3_r5_core_halt(core))
 			dev_warn(core->dev, "core halt back failed\n");
 	}
-put_mbox:
-	mbox_free_channel(kproc->mbox);
 	return ret;
 }
 
@@ -658,8 +656,6 @@ static int k3_r5_rproc_stop(struct rproc *rproc)
 			goto out;
 	}
 
-	mbox_free_channel(kproc->mbox);
-
 	return 0;
 
 unroll_core_halt:
@@ -674,42 +670,22 @@ static int k3_r5_rproc_stop(struct rproc *rproc)
 /*
  * Attach to a running R5F remote processor (IPC-only mode)
  *
- * The R5F attach callback only needs to request the mailbox, the remote
- * processor is already booted, so there is no need to issue any TI-SCI
- * commands to boot the R5F cores in IPC-only mode. This callback is invoked
- * only in IPC-only mode.
+ * The R5F attach callback is a NOP. The remote processor is already booted, and
+ * all required resources have been acquired during probe routine, so there is
+ * no need to issue any TI-SCI commands to boot the R5F cores in IPC-only mode.
+ * This callback is invoked only in IPC-only mode and exists because
+ * rproc_validate() checks for its existence.
  */
-static int k3_r5_rproc_attach(struct rproc *rproc)
-{
-	struct k3_r5_rproc *kproc = rproc->priv;
-	struct device *dev = kproc->dev;
-	int ret;
-
-	ret = k3_r5_rproc_request_mbox(rproc);
-	if (ret)
-		return ret;
-
-	dev_info(dev, "R5F core initialized in IPC-only mode\n");
-	return 0;
-}
+static int k3_r5_rproc_attach(struct rproc *rproc) { return 0; }
 
 /*
  * Detach from a running R5F remote processor (IPC-only mode)
  *
- * The R5F detach callback performs the opposite operation to attach callback
- * and only needs to release the mailbox, the R5F cores are not stopped and
- * will be left in booted state in IPC-only mode. This callback is invoked
- * only in IPC-only mode.
+ * The R5F detach callback is a NOP. The R5F cores are not stopped and will be
+ * left in booted state in IPC-only mode. This callback is invoked only in
+ * IPC-only mode and exists for sanity sake.
  */
-static int k3_r5_rproc_detach(struct rproc *rproc)
-{
-	struct k3_r5_rproc *kproc = rproc->priv;
-	struct device *dev = kproc->dev;
-
-	mbox_free_channel(kproc->mbox);
-	dev_info(dev, "R5F core deinitialized in IPC-only mode\n");
-	return 0;
-}
+static int k3_r5_rproc_detach(struct rproc *rproc) { return 0; }
 
 /*
  * This function implements the .get_loaded_rsc_table() callback and is used
@@ -1277,6 +1253,10 @@ static int k3_r5_cluster_rproc_init(struct platform_device *pdev)
 		kproc->rproc = rproc;
 		core->rproc = rproc;
 
+		ret = k3_r5_rproc_request_mbox(rproc);
+		if (ret)
+			return ret;
+
 		ret = k3_r5_rproc_configure_mode(kproc);
 		if (ret < 0)
 			goto err_config;
@@ -1395,6 +1375,8 @@ static void k3_r5_cluster_rproc_exit(void *data)
 			}
 		}
 
+		mbox_free_channel(kproc->mbox);
+
 		rproc_del(rproc);
 
 		k3_r5_reserved_mem_exit(kproc);
-- 
2.43.0



