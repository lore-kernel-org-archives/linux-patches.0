Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4EC242D6A;
	Tue, 29 Apr 2025 17:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947874; cv=none; b=c9oZy1nA1x2kEuLJYODPiWzLCJii4M6I/jXdx4NjUSl/5m3FK0j+NGHawecQIFWuLYs3ey7qcUQWxwq44ov8OikIovoAxoSWMNyTyOBD0vDGL4lMVQzPrFlC3A2zayH1/DVgfo/wof1rISr92nE1LssPGuFlzdw6PshDkR4JqlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947874; c=relaxed/simple;
	bh=frB5SD1M2N4lkJx3tzPojavEHt5f8eCj5HNQRHmgOqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2zPuCR0Mtc3Ih23wdzNUFjHSAAq9FPZrz9zXiYlhKRRJXK89ylQJZMe70b/V2FEutK1MDuhJW4j7uSAJFoVzRT/u+q7oPHV4MtqEroeGh0khQIJSovC7TYjuWy8l+5HtZpdRlEF66mrTjq30RDqQVY3AjO1m29dp22jbcC3FHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4mCoHyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4mCoHyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB0EC4CEE3;
	Tue, 29 Apr 2025 17:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947873;
	bh=frB5SD1M2N4lkJx3tzPojavEHt5f8eCj5HNQRHmgOqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4mCoHyKTrs7VKibapB1fD7xb9upuimaYxekhhCPcMo3LP74l4ZJmsCylogT8dTv+
	 kLJRj8cnkWSKZO+xrLt6fijfwZorzkX4ljbRHka4zN1TxI538Rv5n1HAUncRjVyZjq
	 Z0NPrqRbdi/iC8T8kSY8cIHdCO70nAp5DVnzJgp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Xu Yilun <yilun.xu@intel.com>,
	Mahesh Rao <mahesh.rao@intel.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.12 129/280] firmware: stratix10-svc: Add of_platform_default_populate()
Date: Tue, 29 Apr 2025 18:41:10 +0200
Message-ID: <20250429161120.405123951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Mahesh Rao <mahesh.rao@intel.com>

commit 4d239f447f96bd2cb646f89431e9db186c1ccfd4 upstream.

Add of_platform_default_populate() to stratix10-svc
driver as the firmware/svc node was moved out of soc.
This fixes the failed probing of child drivers of
svc node.

Cc: stable@vger.kernel.org
Fixes: 23c3ebed382a ("arm64: dts: socfpga: agilex: move firmware out of soc node")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Mahesh Rao <mahesh.rao@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20250326115446.36123-1-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1227,22 +1227,28 @@ static int stratix10_svc_drv_probe(struc
 	if (!svc->intel_svc_fcs) {
 		dev_err(dev, "failed to allocate %s device\n", INTEL_FCS);
 		ret = -ENOMEM;
-		goto err_unregister_dev;
+		goto err_unregister_rsu_dev;
 	}
 
 	ret = platform_device_add(svc->intel_svc_fcs);
 	if (ret) {
 		platform_device_put(svc->intel_svc_fcs);
-		goto err_unregister_dev;
+		goto err_unregister_rsu_dev;
 	}
 
+	ret = of_platform_default_populate(dev_of_node(dev), NULL, dev);
+	if (ret)
+		goto err_unregister_fcs_dev;
+
 	dev_set_drvdata(dev, svc);
 
 	pr_info("Intel Service Layer Driver Initialized\n");
 
 	return 0;
 
-err_unregister_dev:
+err_unregister_fcs_dev:
+	platform_device_unregister(svc->intel_svc_fcs);
+err_unregister_rsu_dev:
 	platform_device_unregister(svc->stratix10_svc_rsu);
 err_free_kfifo:
 	kfifo_free(&controller->svc_fifo);
@@ -1256,6 +1262,8 @@ static void stratix10_svc_drv_remove(str
 	struct stratix10_svc *svc = dev_get_drvdata(&pdev->dev);
 	struct stratix10_svc_controller *ctrl = platform_get_drvdata(pdev);
 
+	of_platform_depopulate(ctrl->dev);
+
 	platform_device_unregister(svc->intel_svc_fcs);
 	platform_device_unregister(svc->stratix10_svc_rsu);
 


