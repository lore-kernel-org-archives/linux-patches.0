Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E2115E5BB;
	Sat, 17 Oct 2026 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258203; cv=none; b=EUYkVhGG/x6n43lHa+0+JXM2usGFGb8n4f7xsvN2qLMZAji9rbYEIrcezLTwzCHuAqkN1OHgN2jmR4uZEh28cleS+SdxCmSqcUp9N9Ri6TPtjXTICN82IrR7dt331BNJ3K2plnNNVJOUdD7yUqq860bXEW4lfZufJXVvowRIsTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258203; c=relaxed/simple;
	bh=zVavgVjNzZbF4Zwn5TnmKHagYbokX20S8wdcQVIU+DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUztBh/N5u2veQMZE7rRdxqcIpRnVQwSrjz9UGD1t6hzBLyJD09OmKhZrgDGNHwW2OMKQBR6PfGMGs6PDQaWgGTwEFA3No4vfHLbI99on9tmT2/u3RiU6ghCEQjPbeXreFdeqLEG6XtJwg3lGfvv8wRR8pjaUTNQkUL625VCKjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTYrGIBO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTYrGIBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786331F000C4;
	Sat, 17 Oct 2026 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258202;
	bh=684/fsruA/x0JLxWTnxHOfuB5g9AmmfiwWM3oLhBmcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTYrGIBOU6kH3SIDd+DuLPx3mhZIMWyaiqiHqjBy8xVrNr2OIOI4pnxX87W8U2UQ1
	 ibM3vJYUrirYFNrnoHe5DJHiuGrQPqlxLu24pO+OtTnTlpTv+cKDHZ7EzIiuxGoR+5
	 U+Bnvx+2pFLPPJ+3xCacsv5c8PwaFHT7DXnkpGkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Levinsky <ben.levinsky@amd.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0807/1674] mailbox: zynqmp: Move buffered IPI setup to of_match selected routine
Date: Sat, 17 Oct 2026 17:51:19 +0200
Message-ID: <20261017160451.829959087@linuxfoundation.org>
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

From: Ben Levinsky <ben.levinsky@amd.com>

[ Upstream commit 41bcf30100c521c73f0fcf05c3dc31967e6408be ]

Move routine that initializes the mailboxes for send and receive to
a function pointer that is set based on compatible string.

Signed-off-by: Ben Levinsky <ben.levinsky@amd.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: 0aead8197fc1 ("mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 122 +++++++++++++++++++--------
 1 file changed, 87 insertions(+), 35 deletions(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 6a523759efa8b..b3428c714e2f6 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -72,6 +72,10 @@ struct zynqmp_ipi_mchan {
 	unsigned int chan_type;
 };
 
+struct zynqmp_ipi_mbox;
+
+typedef int (*setup_ipi_fn)(struct zynqmp_ipi_mbox *ipi_mbox, struct device_node *node);
+
 /**
  * struct zynqmp_ipi_mbox - Description of a ZynqMP IPI mailbox
  *                          platform data.
@@ -81,6 +85,7 @@ struct zynqmp_ipi_mchan {
  * @remote_id:            remote IPI agent ID
  * @mbox:                 mailbox Controller
  * @mchans:               array for channels, tx channel and rx channel.
+ * @setup_ipi_fn:         Function Pointer to set up IPI Channels
  */
 struct zynqmp_ipi_mbox {
 	struct zynqmp_ipi_pdata *pdata;
@@ -88,6 +93,7 @@ struct zynqmp_ipi_mbox {
 	u32 remote_id;
 	struct mbox_controller mbox;
 	struct zynqmp_ipi_mchan mchans[2];
+	setup_ipi_fn setup_ipi_fn;
 };
 
 /**
@@ -464,12 +470,9 @@ static void zynqmp_ipi_mbox_dev_release(struct device *dev)
 static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 				 struct device_node *node)
 {
-	struct zynqmp_ipi_mchan *mchan;
 	struct mbox_chan *chans;
 	struct mbox_controller *mbox;
-	struct resource res;
 	struct device *dev, *mdev;
-	const char *name;
 	int ret;
 
 	dev = ipi_mbox->pdata->dev;
@@ -489,6 +492,73 @@ static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 	}
 	mdev = &ipi_mbox->dev;
 
+	/* Get the IPI remote agent ID */
+	ret = of_property_read_u32(node, "xlnx,ipi-id", &ipi_mbox->remote_id);
+	if (ret < 0) {
+		dev_err(dev, "No IPI remote ID is specified.\n");
+		return ret;
+	}
+
+	ret = ipi_mbox->setup_ipi_fn(ipi_mbox, node);
+	if (ret) {
+		dev_err(dev, "Failed to set up IPI Buffers.\n");
+		return ret;
+	}
+
+	mbox = &ipi_mbox->mbox;
+	mbox->dev = mdev;
+	mbox->ops = &zynqmp_ipi_chan_ops;
+	mbox->num_chans = 2;
+	mbox->txdone_irq = false;
+	mbox->txdone_poll = true;
+	mbox->txpoll_period = 5;
+	mbox->of_xlate = zynqmp_ipi_of_xlate;
+	chans = devm_kzalloc(mdev, 2 * sizeof(*chans), GFP_KERNEL);
+	if (!chans)
+		return -ENOMEM;
+	mbox->chans = chans;
+	chans[IPI_MB_CHNL_TX].con_priv = &ipi_mbox->mchans[IPI_MB_CHNL_TX];
+	chans[IPI_MB_CHNL_RX].con_priv = &ipi_mbox->mchans[IPI_MB_CHNL_RX];
+	ipi_mbox->mchans[IPI_MB_CHNL_TX].chan_type = IPI_MB_CHNL_TX;
+	ipi_mbox->mchans[IPI_MB_CHNL_RX].chan_type = IPI_MB_CHNL_RX;
+	ret = devm_mbox_controller_register(mdev, mbox);
+	if (ret)
+		dev_err(mdev,
+			"Failed to register mbox_controller(%d)\n", ret);
+	else
+		dev_info(mdev,
+			 "Registered ZynqMP IPI mbox with TX/RX channels.\n");
+	return ret;
+}
+
+/**
+ * zynqmp_ipi_setup - set up IPI Buffers for classic flow
+ *
+ * @ipi_mbox: pointer to IPI mailbox private data structure
+ * @node: IPI mailbox device node
+ *
+ * This will be used to set up IPI Buffers for ZynqMP SOC if user
+ * wishes to use classic driver usage model on new SOC's with only
+ * buffered IPIs.
+ *
+ * Note that bufferless IPIs and mixed usage of buffered and bufferless
+ * IPIs are not supported with this flow.
+ *
+ * This will be invoked with compatible string "xlnx,zynqmp-ipi-mailbox".
+ *
+ * Return: 0 for success, negative value for failure
+ */
+static int zynqmp_ipi_setup(struct zynqmp_ipi_mbox *ipi_mbox,
+			    struct device_node *node)
+{
+	struct zynqmp_ipi_mchan *mchan;
+	struct device *mdev;
+	struct resource res;
+	const char *name;
+	int ret;
+
+	mdev = &ipi_mbox->dev;
+
 	mchan = &ipi_mbox->mchans[IPI_MB_CHNL_TX];
 	name = "local_request_region";
 	ret = zynqmp_ipi_mbox_get_buf_res(node, name, &res);
@@ -563,37 +633,7 @@ static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 	if (!mchan->rx_buf)
 		return -ENOMEM;
 
-	/* Get the IPI remote agent ID */
-	ret = of_property_read_u32(node, "xlnx,ipi-id", &ipi_mbox->remote_id);
-	if (ret < 0) {
-		dev_err(dev, "No IPI remote ID is specified.\n");
-		return ret;
-	}
-
-	mbox = &ipi_mbox->mbox;
-	mbox->dev = mdev;
-	mbox->ops = &zynqmp_ipi_chan_ops;
-	mbox->num_chans = 2;
-	mbox->txdone_irq = false;
-	mbox->txdone_poll = true;
-	mbox->txpoll_period = 5;
-	mbox->of_xlate = zynqmp_ipi_of_xlate;
-	chans = devm_kzalloc(mdev, 2 * sizeof(*chans), GFP_KERNEL);
-	if (!chans)
-		return -ENOMEM;
-	mbox->chans = chans;
-	chans[IPI_MB_CHNL_TX].con_priv = &ipi_mbox->mchans[IPI_MB_CHNL_TX];
-	chans[IPI_MB_CHNL_RX].con_priv = &ipi_mbox->mchans[IPI_MB_CHNL_RX];
-	ipi_mbox->mchans[IPI_MB_CHNL_TX].chan_type = IPI_MB_CHNL_TX;
-	ipi_mbox->mchans[IPI_MB_CHNL_RX].chan_type = IPI_MB_CHNL_RX;
-	ret = devm_mbox_controller_register(mdev, mbox);
-	if (ret)
-		dev_err(mdev,
-			"Failed to register mbox_controller(%d)\n", ret);
-	else
-		dev_info(mdev,
-			 "Registered ZynqMP IPI mbox with TX/RX channels.\n");
-	return ret;
+	return 0;
 }
 
 /**
@@ -621,6 +661,7 @@ static int zynqmp_ipi_probe(struct platform_device *pdev)
 	struct zynqmp_ipi_pdata *pdata;
 	struct zynqmp_ipi_mbox *mbox;
 	int num_mboxes, ret = -EINVAL;
+	setup_ipi_fn ipi_fn;
 
 	num_mboxes = of_get_available_child_count(np);
 	if (num_mboxes == 0) {
@@ -641,9 +682,18 @@ static int zynqmp_ipi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ipi_fn = (setup_ipi_fn)device_get_match_data(&pdev->dev);
+	if (!ipi_fn) {
+		dev_err(dev,
+			"Mbox Compatible String is missing IPI Setup fn.\n");
+		return -ENODEV;
+	}
+
 	pdata->num_mboxes = num_mboxes;
 
 	mbox = pdata->ipi_mboxes;
+	mbox->setup_ipi_fn = ipi_fn;
+
 	for_each_available_child_of_node(np, nc) {
 		mbox->pdata = pdata;
 		ret = zynqmp_ipi_mbox_probe(mbox, nc);
@@ -689,7 +739,9 @@ static int zynqmp_ipi_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id zynqmp_ipi_of_match[] = {
-	{ .compatible = "xlnx,zynqmp-ipi-mailbox" },
+	{ .compatible = "xlnx,zynqmp-ipi-mailbox",
+	  .data = &zynqmp_ipi_setup,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, zynqmp_ipi_of_match);
-- 
2.53.0



