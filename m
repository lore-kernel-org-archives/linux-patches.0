Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B2A313E00;
	Wed,  3 Dec 2025 15:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776771; cv=none; b=CqGSZvHSgBjWnFptcb0URqSIcEyJixyuCk3PbYI9Lohc+NGdSWUmaiM+7b3s7cpXW0DX7UMkJaJQixa0IiYwjHLnnLSEO5iTHu+3orO9gSMrAkpr4e69QNCN5wSgHyjKyPc3Jh7vsXflquyLlqN66uOSA381KkYDNXuVKpSBnPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776771; c=relaxed/simple;
	bh=KakpE9ql+E08l1BOhbRQZrp2qjsr04ga2hDCTH55b1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlMB90WEimsuvZmrrLKWsW18T0Fz3q06xxeu2DxlOEzmVCPrjiGPDYcKnQ7DOjB2G6XGBwoW+CxLZRvPw1/gL3mpW9VAh5FxXNiK9KFT2+nQdP3TIFAA8rKutRtxoHO/2DTvJwSU28z4IquGdi8rnIYBM9FhXdEDYl4SpPtOIXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaTmayi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaTmayi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96791C4CEF5;
	Wed,  3 Dec 2025 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776771;
	bh=KakpE9ql+E08l1BOhbRQZrp2qjsr04ga2hDCTH55b1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaTmayi++XuvzSDZMDBJcdjxtRk+z017qwfrbToEZaVQZTcQyQzha4Uuix1tns+E0
	 bWMRJAm7/7FBoZo5HMJrFZQSUywDyCM/MfogjxkxIDqP2hxUPKygl6BykdZSCONvhW
	 xga+9PihY665jR80UFcmCUTm9oL8opB8WWTmqzsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ang Tien Sung <tiensung.ang@altera.com>,
	Khairul Anuar Romli <khairul.anuar.romli@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.10 275/300] firmware: stratix10-svc: fix bug in saving controller data
Date: Wed,  3 Dec 2025 16:27:59 +0100
Message-ID: <20251203152410.817393010@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khairul Anuar Romli <khairul.anuar.romli@altera.com>

commit d0fcf70c680e4d1669fcb3a8632f41400b9a73c2 upstream.

Fix the incorrect usage of platform_set_drvdata and dev_set_drvdata. They
both are of the same data and overrides each other. This resulted in the
rmmod of the svc driver to fail and throw a kernel panic for kthread_stop
and fifo free.

Fixes: b5dc75c915cd ("firmware: stratix10-svc: extend svc to support new RSU features")
Cc: stable@vger.kernel.org # 6.6+
Signed-off-by: Ang Tien Sung <tiensung.ang@altera.com>
Signed-off-by: Khairul Anuar Romli <khairul.anuar.romli@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -127,6 +127,7 @@ struct stratix10_svc_data {
  * @complete_status: state for completion
  * @svc_fifo_lock: protect access to service message data queue
  * @invoke_fn: function to issue secure monitor call or hypervisor call
+ * @svc: manages the list of client svc drivers
  *
  * This struct is used to create communication channels for service clients, to
  * handle secure monitor or hypervisor call.
@@ -143,6 +144,7 @@ struct stratix10_svc_controller {
 	struct completion complete_status;
 	spinlock_t svc_fifo_lock;
 	svc_invoke_fn *invoke_fn;
+	struct stratix10_svc *svc;
 };
 
 /**
@@ -1038,6 +1040,7 @@ static int stratix10_svc_drv_probe(struc
 		ret = -ENOMEM;
 		goto err_free_kfifo;
 	}
+	controller->svc = svc;
 
 	svc->stratix10_svc_rsu = platform_device_alloc(STRATIX10_RSU, 0);
 	if (!svc->stratix10_svc_rsu) {
@@ -1050,8 +1053,6 @@ static int stratix10_svc_drv_probe(struc
 	if (ret)
 		goto err_put_device;
 
-	dev_set_drvdata(dev, svc);
-
 	pr_info("Intel Service Layer Driver Initialized\n");
 
 	return 0;
@@ -1065,8 +1066,8 @@ err_free_kfifo:
 
 static int stratix10_svc_drv_remove(struct platform_device *pdev)
 {
-	struct stratix10_svc *svc = dev_get_drvdata(&pdev->dev);
 	struct stratix10_svc_controller *ctrl = platform_get_drvdata(pdev);
+	struct stratix10_svc *svc = ctrl->svc;
 
 	platform_device_unregister(svc->stratix10_svc_rsu);
 


