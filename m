Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EF62F2351;
	Tue, 17 Jun 2025 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175766; cv=none; b=kX4iNxB6GSSC9ugTQ+KaLugNfdLek8Lrfk4g9c/+Lcfs8estp2NDa40raSN2CyZCOzjTMtB7br0Hz776KRd1JXZA2HCA91RKoc9nGdGpnm3EV+bSz4ZsIreVfH5jeeBmOiqB1ibxSeVcUt4a+Bpq94VztVSUKKKU+N6pCXsel3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175766; c=relaxed/simple;
	bh=9On7laok/DrYdpPeBY848MVVuBAT0VOIgmdOBBLIX5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Np8NrlEAZUlsLxjVeYQkNYEJawKrp7pyNIcHCGBuiimmVz0VMsrLlb8JcrqWaoqOpZn9InO5G0/w4a8YxbJq33m+AJAY7n7lOdwLiKXpT6TYCgzEUVuoRDjOgKVPxSLHyra3FT01iNuT9ThyVqQ73yv84tmK0/fkXPtTm5BylaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4OjZBku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4OjZBku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273A2C4CEE3;
	Tue, 17 Jun 2025 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175766;
	bh=9On7laok/DrYdpPeBY848MVVuBAT0VOIgmdOBBLIX5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4OjZBku5Wve0Xpm9kIp86ldrWtuDsrOqPhD+Sr781TN5QZZ4iHcEy1B3qvBxQFct
	 BryA1fEzU3ENBSoNyGuYqzlW1LuIkjBSRxqNkakLI+Pxad9bGHj55OETryjAgK13rB
	 aGKZ6JZFCXcWNtPj5FTwueiA4ooctxRtS/6TnjJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Beleswar Padhi <b-padhi@ti.com>,
	Judith Mendez <jm@ti.com>,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/356] remoteproc: k3-r5: Drop check performed in k3_r5_rproc_{mbox_callback/kick}
Date: Tue, 17 Jun 2025 17:25:26 +0200
Message-ID: <20250617152346.705754447@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 9995dbfc2235efabdb3759606d522e1a7ec3bdcb ]

Commit f3f11cfe8907 ("remoteproc: k3-r5: Acquire mailbox handle during
probe routine") introduced a check in the "k3_r5_rproc_mbox_callback()"
and "k3_r5_rproc_kick()" callbacks, causing them to exit if the remote
core's state is "RPROC_DETACHED". However, the "__rproc_attach()"
function that is responsible for attaching to a remote core, updates
the state of the remote core to "RPROC_ATTACHED" only after invoking
"rproc_start_subdevices()".

The "rproc_start_subdevices()" function triggers the probe of the Virtio
RPMsg devices associated with the remote core, which require that the
"k3_r5_rproc_kick()" and "k3_r5_rproc_mbox_callback()" callbacks are
functional. Hence, drop the check in the callbacks.

Fixes: f3f11cfe8907 ("remoteproc: k3-r5: Acquire mailbox handle during probe routine")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Tested-by: Judith Mendez <jm@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20250513054510.3439842-2-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/remoteproc/ti_k3_r5_remoteproc.c b/drivers/remoteproc/ti_k3_r5_remoteproc.c
index 5491b1b17ca36..37005640c784c 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -194,10 +194,6 @@ static void k3_r5_rproc_mbox_callback(struct mbox_client *client, void *data)
 	const char *name = kproc->rproc->name;
 	u32 msg = omap_mbox_message(data);
 
-	/* Do not forward message from a detached core */
-	if (kproc->rproc->state == RPROC_DETACHED)
-		return;
-
 	dev_dbg(dev, "mbox msg: 0x%x\n", msg);
 
 	switch (msg) {
@@ -233,10 +229,6 @@ static void k3_r5_rproc_kick(struct rproc *rproc, int vqid)
 	mbox_msg_t msg = (mbox_msg_t)vqid;
 	int ret;
 
-	/* Do not forward message to a detached core */
-	if (kproc->rproc->state == RPROC_DETACHED)
-		return;
-
 	/* send the index of the triggered virtqueue in the mailbox payload */
 	ret = mbox_send_message(kproc->mbox, (void *)msg);
 	if (ret < 0)
-- 
2.39.5



