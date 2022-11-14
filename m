Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604C04C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0052C433D6;
	Mon, 14 Nov 2022 12:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430515;
	bh=So4KTSjvUEcYg2qnLK1G4EkNRdS8THM5K746TjcZe/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNaco7GI62+q21TKfWHcmiQqisHibr1A2YaMynV8MeoA6rhvRAE2niy4IPxEpmFSK
	 3Ls5UNTTC6rKx+K8Scym3TJ3rJLWtu1K6mW1ymKKOEj2eQZ0fVRx2DYqDJcy2A31JV
	 G0vgIEtb1prv70CqtFqz4CxjTP3Hmz1vmFbWM2MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/131] dmaengine: ti: k3-udma-glue: fix memory leak when register device fail
Date: Mon, 14 Nov 2022 13:45:19 +0100
Message-Id: <20221114124450.850239307@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ac2b9f34f02052709aea7b34bb2a165e1853eb41 ]

If device_register() fails, it should call put_device() to give
up reference, the name allocated in dev_set_name() can be freed
in callback function kobject_cleanup().

Fixes: 5b65781d06ea ("dmaengine: ti: k3-udma-glue: Add support for K3 PKTDMA")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20221020062827.2914148-1-yangyingliang@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma-glue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ti/k3-udma-glue.c b/drivers/dma/ti/k3-udma-glue.c
index 4fdd9f06b723..4f1aeb81e9c7 100644
--- a/drivers/dma/ti/k3-udma-glue.c
+++ b/drivers/dma/ti/k3-udma-glue.c
@@ -299,6 +299,7 @@ struct k3_udma_glue_tx_channel *k3_udma_glue_request_tx_chn(struct device *dev,
 	ret = device_register(&tx_chn->common.chan_dev);
 	if (ret) {
 		dev_err(dev, "Channel Device registration failed %d\n", ret);
+		put_device(&tx_chn->common.chan_dev);
 		tx_chn->common.chan_dev.parent = NULL;
 		goto err;
 	}
@@ -917,6 +918,7 @@ k3_udma_glue_request_rx_chn_priv(struct device *dev, const char *name,
 	ret = device_register(&rx_chn->common.chan_dev);
 	if (ret) {
 		dev_err(dev, "Channel Device registration failed %d\n", ret);
+		put_device(&rx_chn->common.chan_dev);
 		rx_chn->common.chan_dev.parent = NULL;
 		goto err;
 	}
@@ -1048,6 +1050,7 @@ k3_udma_glue_request_remote_rx_chn(struct device *dev, const char *name,
 	ret = device_register(&rx_chn->common.chan_dev);
 	if (ret) {
 		dev_err(dev, "Channel Device registration failed %d\n", ret);
+		put_device(&rx_chn->common.chan_dev);
 		rx_chn->common.chan_dev.parent = NULL;
 		goto err;
 	}
-- 
2.35.1



