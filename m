Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9484BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEF3C433EF;
	Tue,  7 Mar 2023 18:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213343;
	bh=hSHw0+w3LFQi4ksALU05R/0a2ukRR5E/U/EYVxDLyQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGFhFrWmQRrnm3vvHe/m08K9H/03kNoyl+bSkiljl9oeagzF3CRqhKBATIILYFTLv
	 pUUf2jkL5SkH7DDSNfuRTxP1qyjJtArmeA5hGzLb1eFbKsbG/3q799yhL5YtU9l9ET
	 0EGGQLv6M/uEx/DR2J38usGWntkU5EMXZVIHNLYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 437/885] firmware: stratix10-svc: fix error handle while alloc/add device failed
Date: Tue,  7 Mar 2023 17:56:11 +0100
Message-Id: <20230307170021.399763625@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit d66a4c20ae55ac88136b4a3befd944c093ffa677 ]

If add device "stratix10-rsu" failed in stratix10_svc_drv_probe(),
the 'svc_fifo' and 'genpool' need be freed in the error path.

If allocate or add device "intel-fcs" failed in stratix10_svc_drv_probe(),
the device "stratix10-rsu" need be unregistered in the error path.

Fixes: e6281c26674e ("firmware: stratix10-svc: Add support for FCS")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20221129163602.462369-2-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 1a5640b3ab422..bde1f543f5298 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1202,19 +1202,20 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 	ret = platform_device_add(svc->stratix10_svc_rsu);
 	if (ret) {
 		platform_device_put(svc->stratix10_svc_rsu);
-		return ret;
+		goto err_free_kfifo;
 	}
 
 	svc->intel_svc_fcs = platform_device_alloc(INTEL_FCS, 1);
 	if (!svc->intel_svc_fcs) {
 		dev_err(dev, "failed to allocate %s device\n", INTEL_FCS);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_unregister_dev;
 	}
 
 	ret = platform_device_add(svc->intel_svc_fcs);
 	if (ret) {
 		platform_device_put(svc->intel_svc_fcs);
-		return ret;
+		goto err_unregister_dev;
 	}
 
 	dev_set_drvdata(dev, svc);
@@ -1223,6 +1224,8 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_unregister_dev:
+	platform_device_unregister(svc->stratix10_svc_rsu);
 err_free_kfifo:
 	kfifo_free(&controller->svc_fifo);
 err_destroy_pool:
-- 
2.39.2



