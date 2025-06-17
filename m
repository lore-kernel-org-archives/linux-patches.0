Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA2C2DFF1B;
	Tue, 17 Jun 2025 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178370; cv=none; b=utMVrnDgZv2qpd//4v1jpF1/d5XDmkuuMzcwjq720rMaHQjHtcp9FC+6RakAstMzfOsenb6qrImbUW6GxWHtuCnDPMikvobn2Lg81iMDAqZAsWNjcXlEbaUQFGYoxWYVMp8NZ7/omOD8+JhGjzSe9NTmmFxoAva6BqJ4ZR43hy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178370; c=relaxed/simple;
	bh=Qy6jQ1WQbFAXwd70yL/uidD8QO4mZMISFttelxSBPf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XszxGm2bM7nCWvL3mZBsczxce+M4S3RyHUp0Rxkz9ZmKKyGbVHmacnp+eqkDmb2apv2YAjyjsu8SFc9wIvwq1XV7TWqGJJWKl/2/URfCjY57Ct2RYK0aX5uy6vQL6inhUgWFmri0sUFNkwZ2VEppecO/6dFtI+eGVh/QPUQT/+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVoE+mZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVoE+mZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B01C4CEE3;
	Tue, 17 Jun 2025 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178370;
	bh=Qy6jQ1WQbFAXwd70yL/uidD8QO4mZMISFttelxSBPf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVoE+mZomKhBcVRY1M0NZXWE6uiTnXsXlp01o1QSL7fwR7viwFA6hrUoO92reLa3x
	 vaVYagEp9dm8MEZzBIHq3wURXyC0D9upXfRj630D/Lzd4s8TKdYRe2SGUeai42iJTf
	 VNMEI2rJMrSKyR7OU78iW3+ER3eYZuJM9HTAfJpI=
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
Subject: [PATCH 6.15 450/780] remoteproc: k3-dsp: Drop check performed in k3_dsp_rproc_{mbox_callback/kick}
Date: Tue, 17 Jun 2025 17:22:38 +0200
Message-ID: <20250617152509.786737612@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a695890254ff7..35e8c3cc313c3 100644
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



