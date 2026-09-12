Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD9A343893;
	Sat, 12 Sep 2026 12:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215445; cv=none; b=uVT52Pbjc3YU3ZKK2dkEs/smnsE5e0LMKDMkS+/aT03jqm75O4qHT//WINJFVLS/y0R1sonnE/uU6Z4H6CfumhV4CCGMLpXx/WhM+qr9M3YQPksB6pj6NgwGertt+b9sjEPFfhzMIJb7ZiPgfNqaHM4qvjmE6rVYM/hlnwgeFqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215445; c=relaxed/simple;
	bh=OQ/y287d+VwDaeoIUQZoql93ZODxz933PEI2btLHNQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHw2XKSoCUIqjaA9vu8fma4adLu26dzWmcFF8Eq3oBCVBzSTBIWXA+dIqN0xR9PJReoGZCcAmsKl2oBDxT0pFaO8oeO7/mHahT5NeQwqEaHLe5JcLIyAleOFc3VR7nOJGL/DGlin61Cli4mGCvgEOKnhDm/KUJnDZMoHYxoAgqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnPpuPao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnPpuPao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A821F000FF;
	Sat, 12 Sep 2026 12:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215443;
	bh=q+mPnqi5f8DAASfEDN20hFOhIo7DeQqB/xLnRbknC5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnPpuPao4Dh4b/MVDmdqpl0c2ztYFCRrFq/u9VwfQGFez/FD/QF73KpXsk91epboQ
	 YKlMGCo3cfdi8smJr5cCm+aQaQzUOWHB0fqpgmAZZpm3tdeIyZ9C7fn8EyCu3RAG3G
	 GVZeP5HRHB2vvM178YyC5HZfl6BzEpLmP1N+V3MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0533/1376] firmware: arm_scmi: Publish channel state before callbacks
Date: Sat, 12 Sep 2026 08:49:19 +0200
Message-ID: <20260912065619.420863887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 0314900dcdde044af0208fed212035dbfaa55843 ]

Transport setup can enable callbacks before the setup routine returns.
mailbox_chan_setup() registers the mailbox client with
mbox_request_channel(), and the mailbox controller startup path can enable
interrupt delivery before SCMI mailbox channel state has been published.
Similarly, smc_chan_setup() requests the optional A2P completion IRQ before
the SMC transport has made its cinfo pointer visible.

If a pending or spurious callback fires in those windows, the transport RX
callback can dereference a NULL transport cinfo pointer. Publishing only
the transport-private pointer is not sufficient either: an early callback
can enter the SCMI core before scmi_chan_setup() has assigned
cinfo->handle.
The core derives scmi_info from cinfo->handle in the RX path, so a NULL
handle can still fault even when the transport-private cinfo is valid.

Assign cinfo->handle before invoking the transport setup callback. Publish
the mailbox and SMC transport-private channel state before requesting the
mailbox channels or IRQ, and clear the early-published pointers again on
setup failure. Also unwind mailbox setup devres resources on failure so an
optional RX setup error that is ignored by the core does not leave stale
transport state behind.

Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-1-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c             |  2 +-
 drivers/firmware/arm_scmi/transports/mailbox.c | 18 +++++++++++++-----
 drivers/firmware/arm_scmi/transports/smc.c     | 15 +++++++++------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 79866f3b6b3e7..1901cc1ec8dd0 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2657,6 +2657,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 
 	cinfo->id = prot_id;
 	cinfo->dev = &tdev->dev;
+	cinfo->handle = &info->handle;
 	ret = info->desc->ops->chan_setup(cinfo, info->dev, tx);
 	if (ret) {
 		of_node_put(of_node);
@@ -2689,7 +2690,6 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 		return ret;
 	}
 
-	cinfo->handle = &info->handle;
 	return 0;
 }
 
diff --git a/drivers/firmware/arm_scmi/transports/mailbox.c b/drivers/firmware/arm_scmi/transports/mailbox.c
index e3d5f75609905..f4847569b42c8 100644
--- a/drivers/firmware/arm_scmi/transports/mailbox.c
+++ b/drivers/firmware/arm_scmi/transports/mailbox.c
@@ -208,13 +208,18 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 	cl->tx_block = false;
 	cl->knows_txdone = tx;
 
+	cinfo->transport_info = smbox;
+	smbox->cinfo = cinfo;
+	mutex_init(&smbox->chan_lock);
+
 	smbox->chan = mbox_request_channel(cl, tx ? 0 : p2a_chan);
 	if (IS_ERR(smbox->chan)) {
 		ret = PTR_ERR(smbox->chan);
+		smbox->chan = NULL;
 		if (ret != -EPROBE_DEFER)
 			dev_err(cdev,
 				"failed to request SCMI %s mailbox\n", desc);
-		return ret;
+		goto err_clear_cinfo;
 	}
 
 	/* Additional unidirectional channel for TX if needed */
@@ -238,11 +243,14 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 		}
 	}
 
-	cinfo->transport_info = smbox;
-	smbox->cinfo = cinfo;
-	mutex_init(&smbox->chan_lock);
-
 	return 0;
+
+err_clear_cinfo:
+	cinfo->transport_info = NULL;
+	smbox->cinfo = NULL;
+	devm_iounmap(dev, smbox->shmem);
+	devm_kfree(dev, smbox);
+	return ret;
 }
 
 static int mailbox_chan_free(int id, void *p, void *data)
diff --git a/drivers/firmware/arm_scmi/transports/smc.c b/drivers/firmware/arm_scmi/transports/smc.c
index f8dd108777f9b..2a35434a2b7f5 100644
--- a/drivers/firmware/arm_scmi/transports/smc.c
+++ b/drivers/firmware/arm_scmi/transports/smc.c
@@ -169,6 +169,13 @@ static int smc_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 		scmi_info->param_page = SHMEM_PAGE(res.start);
 		scmi_info->param_offset = SHMEM_OFFSET(res.start);
 	}
+
+	scmi_info->func_id = func_id;
+	scmi_info->cap_id = cap_id;
+	scmi_info->cinfo = cinfo;
+	smc_channel_lock_init(scmi_info);
+	cinfo->transport_info = scmi_info;
+
 	/*
 	 * If there is an interrupt named "a2p", then the service and
 	 * completion of a message is signaled by an interrupt rather than by
@@ -180,18 +187,14 @@ static int smc_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 				  IRQF_NO_SUSPEND, dev_name(dev), scmi_info);
 		if (ret) {
 			dev_err(dev, "failed to setup SCMI smc irq\n");
+			cinfo->transport_info = NULL;
+			scmi_info->cinfo = NULL;
 			return ret;
 		}
 	} else {
 		cinfo->no_completion_irq = true;
 	}
 
-	scmi_info->func_id = func_id;
-	scmi_info->cap_id = cap_id;
-	scmi_info->cinfo = cinfo;
-	smc_channel_lock_init(scmi_info);
-	cinfo->transport_info = scmi_info;
-
 	return 0;
 }
 
-- 
2.53.0



