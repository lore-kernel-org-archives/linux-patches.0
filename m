Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528EA3C0630;
	Sat, 17 Oct 2026 17:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258452; cv=none; b=DnYHHcSmp0ILxqc1jybY1k4XpiDkwjhSaghXGgRWd6AyFZgDwXvTmVUebaAODrqOGUZK1EzgXRIZuVwe+RZwVHkz+X7oM0+cVdba68wquIwvwWYK5CwfHJs+okpvSB8k9Yh3dEokTLi/K5vXlM9mPNE1HJ5Fwlpyy6Qrjk2tXwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258452; c=relaxed/simple;
	bh=h2IxH1R41cfkgzGlWmmCcXPNWqFYMQ+B8UmBiF+xa60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsx8H2mi8PcaDRhojNJRKzGBXHJlbVuoQZYax/atebPcWua8U+BwtCUqyxSkTiNz8bu/NxayMR4oZp++Ra8myTVzVydQQefCeUfMp3E+kBsFKkNiiNsqR+ezXDx+per9n9+GDSeuHPk3f32fin8sox5WovqnN7jE2e4w/mNr0xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5MQbkRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5MQbkRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DB41F000C4;
	Sat, 17 Oct 2026 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258451;
	bh=aipCorFDIPMUTLrJIMsVpPwSh7F6Sc6A6h0wjyUxNOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5MQbkRUD/gqG+J+8WGAj8mUWRCFUztyP48blAR/MLTQ2ozUH100OkwyXNddCV1aa
	 CwGdw60nGxsMemfK7jLVETijxNwOe1ct41wKOBap2ksBFMQ1fNsN6UYapGskNBRah8
	 F+cqTbKAHUro/f56kCT0wq9HW0HkOvjrxS2Od2TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Chris Lew <quic_clew@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>
Subject: [PATCH 6.6 0849/1674] net: qrtr: Drop the MHI auto_queue feature for IPCR DL channels
Date: Sat, 17 Oct 2026 17:52:01 +0200
Message-ID: <20261017160452.917508007@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 51731792a25cb312ca94cdccfa139eb46de1b2ef ]

MHI stack offers the 'auto_queue' feature, which allows the MHI stack to
auto queue the buffers for the RX path (DL channel). Though this feature
simplifies the client driver design, it introduces race between the client
drivers and the MHI stack. For instance, with auto_queue, the 'dl_callback'
for the DL channel may get called before the client driver is fully probed.
This means, by the time the dl_callback gets called, the client driver's
structures might not be initialized, leading to NULL ptr dereference.

Currently, the drivers have to workaround this issue by initializing the
internal structures before calling mhi_prepare_for_transfer_autoqueue().
But even so, there is a chance that the client driver's internal code path
may call the MHI queue APIs before mhi_prepare_for_transfer_autoqueue() is
called, leading to similar NULL ptr dereference. This issue has been
reported on the Qcom X1E80100 CRD machines affecting boot.

So to properly fix all these races, drop the MHI 'auto_queue' feature
altogether and let the client driver (QRTR) manage the RX buffers manually.
In the QRTR driver, queue the RX buffers based on the ring length during
probe and recycle the buffers in 'dl_callback' once they are consumed. This
also warrants removing the setting of 'auto_queue' flag from controller
drivers.

Currently, this 'auto_queue' feature is only enabled for IPCR DL channel.
So only the QRTR client driver requires the modification.

Fixes: 227fee5fc99e ("bus: mhi: core: Add an API for auto queueing buffers for DL channel")
Fixes: 68a838b84eff ("net: qrtr: start MHI channel after endpoit creation")
Reported-by: Johan Hovold <johan@kernel.org>
Closes: https://lore.kernel.org/linux-arm-msm/ZyTtVdkCCES0lkl4@hovoldconsulting.com
Suggested-by: Chris Lew <quic_clew@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Acked-by: Jeff Johnson <jjohnson@kernel.org> # drivers/net/wireless/ath/...
Acked-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251218-qrtr-fix-v2-1-c7499bfcfbe0@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/mhi_controller.c   | 22 ----------
 drivers/bus/mhi/host/pci_generic.c    | 20 +--------
 drivers/net/wireless/ath/ath11k/mhi.c |  4 --
 drivers/net/wireless/ath/ath12k/mhi.c |  4 --
 net/qrtr/mhi.c                        | 61 +++++++++++++++++++++++----
 5 files changed, 55 insertions(+), 56 deletions(-)

diff --git a/drivers/accel/qaic/mhi_controller.c b/drivers/accel/qaic/mhi_controller.c
index 1405623b03e4e..39012b95a9304 100644
--- a/drivers/accel/qaic/mhi_controller.c
+++ b/drivers/accel/qaic/mhi_controller.c
@@ -34,7 +34,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -50,7 +49,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -66,7 +64,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -82,7 +79,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -98,7 +94,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -114,7 +109,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -130,7 +124,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -146,7 +139,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -162,7 +154,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -178,7 +169,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -194,7 +184,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -210,7 +199,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -226,7 +214,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -242,7 +229,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -258,7 +244,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -274,7 +259,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -290,7 +274,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -306,7 +289,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -322,7 +304,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -338,7 +319,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -354,7 +334,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 	{
@@ -370,7 +349,6 @@ static struct mhi_channel_config aic100_channels[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 		.wake_capable = false,
 	},
 };
diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 6121ca8465411..11377ae6a7bab 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -80,22 +80,6 @@ struct mhi_pci_dev_info {
 		.doorbell_mode_switch = false,		\
 	}
 
-#define MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(ch_num, ch_name, el_count, ev_ring) \
-	{						\
-		.num = ch_num,				\
-		.name = ch_name,			\
-		.num_elements = el_count,		\
-		.event_ring = ev_ring,			\
-		.dir = DMA_FROM_DEVICE,			\
-		.ee_mask = BIT(MHI_EE_AMSS),		\
-		.pollcfg = 0,				\
-		.doorbell = MHI_DB_BRST_DISABLE,	\
-		.lpm_notify = false,			\
-		.offload_channel = false,		\
-		.doorbell_mode_switch = false,		\
-		.auto_queue = true,			\
-	}
-
 #define MHI_EVENT_CONFIG_CTRL(ev_ring, el_count) \
 	{					\
 		.num_elements = el_count,	\
@@ -247,7 +231,7 @@ static const struct mhi_channel_config modem_qcom_v1_mhi_channels[] = {
 	MHI_CHANNEL_CONFIG_UL(14, "QMI", 4, 0),
 	MHI_CHANNEL_CONFIG_DL(15, "QMI", 4, 0),
 	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 8, 0),
-	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 8, 0),
+	MHI_CHANNEL_CONFIG_DL(21, "IPCR", 8, 0),
 	MHI_CHANNEL_CONFIG_UL_FP(34, "FIREHOSE", 32, 0),
 	MHI_CHANNEL_CONFIG_DL_FP(35, "FIREHOSE", 32, 0),
 	MHI_CHANNEL_CONFIG_UL(46, "IP_SW0", 64, 2),
@@ -507,7 +491,7 @@ static const struct mhi_channel_config mhi_telit_fn980_hw_v1_channels[] = {
 	MHI_CHANNEL_CONFIG_UL(14, "QMI", 32, 0),
 	MHI_CHANNEL_CONFIG_DL(15, "QMI", 32, 0),
 	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 16, 0),
-	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 16, 0),
+	MHI_CHANNEL_CONFIG_DL(21, "IPCR", 16, 0),
 	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 1),
 	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0", 128, 2),
 };
diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index d3a4b561832c5..17a4e283eb65b 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -61,7 +61,6 @@ static struct mhi_channel_config ath11k_mhi_channels_qca6390[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 	},
 	{
 		.num = 21,
@@ -75,7 +74,6 @@ static struct mhi_channel_config ath11k_mhi_channels_qca6390[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = true,
 	},
 };
 
@@ -154,7 +152,6 @@ static struct mhi_channel_config ath11k_mhi_channels_qcn9074[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 	},
 	{
 		.num = 21,
@@ -168,7 +165,6 @@ static struct mhi_channel_config ath11k_mhi_channels_qcn9074[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath12k/mhi.c b/drivers/net/wireless/ath/ath12k/mhi.c
index 380328fa2822e..5020ae43de34a 100644
--- a/drivers/net/wireless/ath/ath12k/mhi.c
+++ b/drivers/net/wireless/ath/ath12k/mhi.c
@@ -55,7 +55,6 @@ static const struct mhi_channel_config ath12k_mhi_channels_qcn9274[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 	},
 	{
 		.num = 21,
@@ -69,7 +68,6 @@ static const struct mhi_channel_config ath12k_mhi_channels_qcn9274[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = true,
 	},
 };
 
@@ -148,7 +146,6 @@ static const struct mhi_channel_config ath12k_mhi_channels_wcn7850[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 	},
 	{
 		.num = 21,
@@ -162,7 +159,6 @@ static const struct mhi_channel_config ath12k_mhi_channels_wcn7850[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = true,
 	},
 };
 
diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 9ced13c0627a7..aa9cd496b549f 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -24,13 +24,25 @@ static void qcom_mhi_qrtr_dl_callback(struct mhi_device *mhi_dev,
 	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
 	int rc;
 
-	if (!qdev || mhi_res->transaction_status)
+	if (!qdev || (mhi_res->transaction_status && mhi_res->transaction_status != -ENOTCONN))
 		return;
 
+	/* Channel got reset. So just free the buffer */
+	if (mhi_res->transaction_status == -ENOTCONN) {
+		devm_kfree(&mhi_dev->dev, mhi_res->buf_addr);
+		return;
+	}
+
 	rc = qrtr_endpoint_post(&qdev->ep, mhi_res->buf_addr,
 				mhi_res->bytes_xferd);
 	if (rc == -EINVAL)
 		dev_err(qdev->dev, "invalid ipcrouter packet\n");
+
+	/* Done with the buffer, now recycle it for future use */
+	rc = mhi_queue_buf(mhi_dev, DMA_FROM_DEVICE, mhi_res->buf_addr,
+			   mhi_dev->mhi_cntrl->buffer_len, MHI_EOT);
+	if (rc)
+		dev_err(&mhi_dev->dev, "Failed to recycle the buffer: %d\n", rc);
 }
 
 /* From QRTR to MHI */
@@ -72,6 +84,29 @@ static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 	return rc;
 }
 
+static int qcom_mhi_qrtr_queue_dl_buffers(struct mhi_device *mhi_dev)
+{
+	u32 free_desc;
+	void *buf;
+	int ret;
+
+	free_desc = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
+	while (free_desc--) {
+		buf = devm_kmalloc(&mhi_dev->dev, mhi_dev->mhi_cntrl->buffer_len, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		ret = mhi_queue_buf(mhi_dev, DMA_FROM_DEVICE, buf, mhi_dev->mhi_cntrl->buffer_len,
+				    MHI_EOT);
+		if (ret) {
+			dev_err(&mhi_dev->dev, "Failed to queue buffer: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 			       const struct mhi_device_id *id)
 {
@@ -87,20 +122,30 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	qdev->ep.xmit = qcom_mhi_qrtr_send;
 
 	dev_set_drvdata(&mhi_dev->dev, qdev);
-	rc = qrtr_endpoint_register(&qdev->ep, QRTR_EP_NID_AUTO);
-	if (rc)
-		return rc;
 
 	/* start channels */
-	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
-	if (rc) {
-		qrtr_endpoint_unregister(&qdev->ep);
+	rc = mhi_prepare_for_transfer(mhi_dev);
+	if (rc)
 		return rc;
-	}
+
+	rc = qrtr_endpoint_register(&qdev->ep, QRTR_EP_NID_AUTO);
+	if (rc)
+		goto err_unprepare;
+
+	rc = qcom_mhi_qrtr_queue_dl_buffers(mhi_dev);
+	if (rc)
+		goto err_unregister;
 
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
 	return 0;
+
+err_unregister:
+	qrtr_endpoint_unregister(&qdev->ep);
+err_unprepare:
+	mhi_unprepare_from_transfer(mhi_dev);
+
+	return rc;
 }
 
 static void qcom_mhi_qrtr_remove(struct mhi_device *mhi_dev)
-- 
2.53.0



