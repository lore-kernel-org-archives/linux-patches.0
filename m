Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AB31BD9D3;
	Tue, 17 Jun 2025 16:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177023; cv=none; b=by5EV/bDQVrxb8TFbnEbeixNg6VDk95ZAKrFuN33oxK0A+Gh8FfM2Y84WBEkT/B243ZG+8+FqbtZIK9X2kMloKXQY33aLb8TOe1cOXX9+7GI1bt6VI/jS4ATleo8+ohQlKuRml6q61+b49rz4eaCjDEL8445KWQ3thFehle3MYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177023; c=relaxed/simple;
	bh=vtOUlwq7z0G6Iog3wXdo/bW33Dx+JLdbO/FbUKbvD4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlPqvB4aQlL/vkWaEt7FFLWcEAGiBUvT7CcHNDKfFICbKhoSe58EetZ05vOC4htgSrb6/D4LQZTgZTYN38jxuhAk3gGn5VR1uBePsg2n8KWWK9+U5AoJ/MBAhTkxJ2AQ/PZqI16FVNVPM+QgzV01dX2sDoytUUoZNwORbuX4NdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4MhVnsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4MhVnsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFD0C4CEE3;
	Tue, 17 Jun 2025 16:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177023;
	bh=vtOUlwq7z0G6Iog3wXdo/bW33Dx+JLdbO/FbUKbvD4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4MhVnsWLwNmvtGKx+KoLgXKppizY2Acq1mEkn/0YeT4djl8fX/hTUtOPGwA650IR
	 BrhKnXUHldFQvC50jlhFJroVM4tL3iud60sU/JrbtlOeeNXgePYo2KeXTxiXwAAbmJ
	 vVBq6PPN2TmvhgMqO9RsGmKA6lwCPNOpDw8qUc4Q=
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
Subject: [PATCH 6.12 289/512] remoteproc: k3-dsp: Drop check performed in k3_dsp_rproc_{mbox_callback/kick}
Date: Tue, 17 Jun 2025 17:24:15 +0200
Message-ID: <20250617152431.316074932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 349d62ab207f55f039c3ddb40b36e95c2f0b3ed0 ]

Commit ea1d6fb5b571 ("remoteproc: k3-dsp: Acquire mailbox handle during
probe routine") introduced a check in the "k3_dsp_rproc_mbox_callback()"
and "k3_dsp_rproc_kick()" callbacks, causing them to exit if the remote
core's state is "RPROC_DETACHED". However, the "__rproc_attach()"
function that is responsible for attaching to a remote core, updates the
state of the remote core to "RPROC_ATTACHED" only after invoking
"rproc_start_subdevices()".

The "rproc_start_subdevices()" function triggers the probe of the Virtio
RPMsg devices associated with the remote core, which require that the
"k3_dsp_rproc_kick()" and "k3_dsp_rproc_mbox_callback()" callbacks are
functional. Hence, drop the check in the callbacks.

Fixes: ea1d6fb5b571 ("remoteproc: k3-dsp: Acquire mailbox handle during probe routine")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Tested-by: Judith Mendez <jm@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20250513054510.3439842-3-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_dsp_remoteproc.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/remoteproc/ti_k3_dsp_remoteproc.c b/drivers/remoteproc/ti_k3_dsp_remoteproc.c
index 8be3f631c1920..2ae0655ddf1d2 100644
--- a/drivers/remoteproc/ti_k3_dsp_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_dsp_remoteproc.c
@@ -115,10 +115,6 @@ static void k3_dsp_rproc_mbox_callback(struct mbox_client *client, void *data)
 	const char *name = kproc->rproc->name;
 	u32 msg = omap_mbox_message(data);
 
-	/* Do not forward messages from a detached core */
-	if (kproc->rproc->state == RPROC_DETACHED)
-		return;
-
 	dev_dbg(dev, "mbox msg: 0x%x\n", msg);
 
 	switch (msg) {
@@ -159,10 +155,6 @@ static void k3_dsp_rproc_kick(struct rproc *rproc, int vqid)
 	mbox_msg_t msg = (mbox_msg_t)vqid;
 	int ret;
 
-	/* Do not forward messages to a detached core */
-	if (kproc->rproc->state == RPROC_DETACHED)
-		return;
-
 	/* send the index of the triggered virtqueue in the mailbox payload */
 	ret = mbox_send_message(kproc->mbox, (void *)msg);
 	if (ret < 0)
-- 
2.39.5



