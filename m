Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C2C2D73A6;
	Sat, 17 Oct 2026 17:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257015; cv=none; b=ma9LEYL6hYcuPPRUjcL8b4uYf6roQnAK5CxSM5ow3oricwZoIAgxqUxgIiPN6CnPOsgo4e171i8jlTETbNBo6UsbCpmDB+IDGs+GXP7MerJsiKPiJF30ay8HnXT3AZseRkXj+CR4cegHwK1UMGynHMBKD3eqb6AGbPLpNd/aApA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257015; c=relaxed/simple;
	bh=fprMQBlarh57qg0iUsDnyovOjztcTNrrccwqJYToMA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnVnTe02Dgq8h/XVxbepNu+hxGyKLTrdit2v8Zolq9MHbUV2Y4Ni+qpm0ed3Kxnh3+x6jMbSWZHYDKHb2C+VGanTC8oWtqrlaOzJjbvangIKCe5Nb/d6qvVBfW7+wMx8KYHEQYryb4Lx/yRAqXuAjGcoTXmgr7Ba3i1G/FhurzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6ZJF4ap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6ZJF4ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1FC1F000C4;
	Sat, 17 Oct 2026 17:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257013;
	bh=hmAum2xXGJyyAbH1OM9x795d2tdZtyAn1uZCcCGoqT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6ZJF4apzRFlZqNbTmNNBqvzjm6/jPkSlhfkSXsWjwRDMhB+OgwZPV5Gke082YtAl
	 779BzFEZoSe/qcx/wSsum/GT7NcXXyXKoB/5o9GRd+ASuWyXD5oN+8rnMTYf0VJTaJ
	 sL3wKQTgFulDuM3GhkT4g2HzTxVZImVKTV0/J1P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0423/1674] firmware: arm_scmi: Publish channel state before callbacks
Date: Sat, 17 Oct 2026 17:44:55 +0200
Message-ID: <20261017160441.987065397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ Backport to 6.6.y: use the pre-transport-split file layout, omit newer
  SMC fields absent from this tree, and publish/clear the older mailbox
  and SMC channel state around callback registration. ]

Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-1-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c  |  2 +-
 drivers/firmware/arm_scmi/mailbox.c | 18 +++++++++++++-----
 drivers/firmware/arm_scmi/smc.c     | 13 ++++++++-----
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index d253e9d41d848..f99cfc49dfcdb 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2449,6 +2449,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 
 	cinfo->id = prot_id;
 	cinfo->dev = &tdev->dev;
+	cinfo->handle = &info->handle;
 	ret = info->desc->ops->chan_setup(cinfo, info->dev, tx);
 	if (ret) {
 		of_node_put(of_node);
@@ -2482,7 +2483,6 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 		return ret;
 	}
 
-	cinfo->handle = &info->handle;
 	return 0;
 }
 
diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index f1d5e3fba35e0..80b67f46a4d12 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -211,13 +211,18 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
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
@@ -231,11 +236,14 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
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
diff --git a/drivers/firmware/arm_scmi/smc.c b/drivers/firmware/arm_scmi/smc.c
index 771797b6e2680..fada68b8e15f1 100644
--- a/drivers/firmware/arm_scmi/smc.c
+++ b/drivers/firmware/arm_scmi/smc.c
@@ -166,6 +166,12 @@ static int smc_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 		scmi_info->param_page = SHMEM_PAGE(res.start);
 		scmi_info->param_offset = SHMEM_OFFSET(res.start);
 	}
+
+	scmi_info->func_id = func_id;
+	scmi_info->cinfo = cinfo;
+	smc_channel_lock_init(scmi_info);
+	cinfo->transport_info = scmi_info;
+
 	/*
 	 * If there is an interrupt named "a2p", then the service and
 	 * completion of a message is signaled by an interrupt rather than by
@@ -177,17 +183,14 @@ static int smc_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
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
-	scmi_info->cinfo = cinfo;
-	smc_channel_lock_init(scmi_info);
-	cinfo->transport_info = scmi_info;
-
 	return 0;
 }
 
-- 
2.53.0



