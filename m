Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6910BBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E320AC433EF;
	Tue,  7 Mar 2023 18:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215481;
	bh=WyC1qIlx4sbfkyTYX64GbyX9+UosiYajlzxK/B4nv3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFIsbLyWyctDTl9h7lorNr69vrub7k+ATl+f3+rAvcBVnJ05ClQcoRRklDrT+ZnQW
	 HT2jNoZmCvps4BZgwcb+5Ggfs/s161e5wml9fNaLb6mxaXbAk+ROkQJTRHKbRwBIGd
	 7+EU5ETiN8peK5xay/FXa6z5DZ5D4lb8SzLZlVh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 276/567] usb: gadget: fusb300_udc: free irq on the error path in fusb300_probe()
Date: Tue,  7 Mar 2023 18:00:12 +0100
Message-Id: <20230307165917.863373209@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit a8d3392e0e5cfeb03f0cea1f2bc3f5f183c1deb4 ]

When request_irq(ires1->start) failed in w5300_hw_probe(), irq
ires->start has not been freed, and on the clean_up3 error path,
we also need to free ires1->start irq, fix it.

In addition, We should add free_irq in fusb300_remove(), and give
the lables a proper name so that they can be understood easily,
so add free_irq in fusb300_remove(), and update clean_up3 to
err_alloc_request.

Fixes: 0fe6f1d1f612 ("usb: udc: add Faraday fusb300 driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221123014121.1989721-1-cuigaosheng1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fusb300_udc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/fusb300_udc.c b/drivers/usb/gadget/udc/fusb300_udc.c
index 9af8b415f303b..5e9e8e56e2d09 100644
--- a/drivers/usb/gadget/udc/fusb300_udc.c
+++ b/drivers/usb/gadget/udc/fusb300_udc.c
@@ -1347,6 +1347,7 @@ static int fusb300_remove(struct platform_device *pdev)
 	usb_del_gadget_udc(&fusb300->gadget);
 	iounmap(fusb300->reg);
 	free_irq(platform_get_irq(pdev, 0), fusb300);
+	free_irq(platform_get_irq(pdev, 1), fusb300);
 
 	fusb300_free_request(&fusb300->ep[0]->ep, fusb300->ep0_req);
 	for (i = 0; i < FUSB300_MAX_NUM_EP; i++)
@@ -1432,7 +1433,7 @@ static int fusb300_probe(struct platform_device *pdev)
 			IRQF_SHARED, udc_name, fusb300);
 	if (ret < 0) {
 		pr_err("request_irq1 error (%d)\n", ret);
-		goto clean_up;
+		goto err_request_irq1;
 	}
 
 	INIT_LIST_HEAD(&fusb300->gadget.ep_list);
@@ -1471,7 +1472,7 @@ static int fusb300_probe(struct platform_device *pdev)
 				GFP_KERNEL);
 	if (fusb300->ep0_req == NULL) {
 		ret = -ENOMEM;
-		goto clean_up3;
+		goto err_alloc_request;
 	}
 
 	init_controller(fusb300);
@@ -1486,7 +1487,10 @@ static int fusb300_probe(struct platform_device *pdev)
 err_add_udc:
 	fusb300_free_request(&fusb300->ep[0]->ep, fusb300->ep0_req);
 
-clean_up3:
+err_alloc_request:
+	free_irq(ires1->start, fusb300);
+
+err_request_irq1:
 	free_irq(ires->start, fusb300);
 
 clean_up:
-- 
2.39.2



