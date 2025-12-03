Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74115398FA5;
	Wed,  3 Dec 2025 16:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781138; cv=none; b=GZLpdtuunil7CNwmAfzEfN2Qphd4Bnpv6yA9Z80PIs2O9APhSqZ0K5lC7AH+H0QcBt2KXK4hH7eR2gm+m3w25xjEufIr+NNZEBCJqxXdurl254QeM9qmV3nwV2sRKG5MeMAi1zthHR5C8wzXJJKulBuskGsqH0JVEWvvKtkaoU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781138; c=relaxed/simple;
	bh=WEUutv3PxOZrXBwqd/zLsHqHUlgJPdJAAH0KSkVWQPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TarxvdDiCaye72eIrdkt18kNL9e10+gfNX054vW/XFKKEJbOOcPleO3Zl/o0y+dePneXPL1CiD4y1C+FLfuJYjSOkTh0Bo4XPf8NdX0d0J7aFYSmUP2WuDg/eK7YXib6KXlJYweLnVRElt23vsWmAc3EFmrGemie1zuQ1+1n4fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaZAVyJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaZAVyJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9F4C4CEF5;
	Wed,  3 Dec 2025 16:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781137;
	bh=WEUutv3PxOZrXBwqd/zLsHqHUlgJPdJAAH0KSkVWQPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaZAVyJkDqdD3AVRWP3i5Gr+7FIYHPxE/F54Izu+/3Wr5xtSqE3vp3AlA1i25Ghw0
	 IZAyuZRNrKhAAJr/vLl0/clWxoXKSD0+zkz+I2gDRYFuUs/Dm5MOHiOpHUsZfXsY6b
	 NE3m9Qprj6L1A5tlMm9uUm9DUBZHHEnVejay202Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ang Tien Sung <tiensung.ang@altera.com>,
	Khairul Anuar Romli <khairul.anuar.romli@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.6 53/93] firmware: stratix10-svc: fix bug in saving controller data
Date: Wed,  3 Dec 2025 16:29:46 +0100
Message-ID: <20251203152338.484005690@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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
@@ -134,6 +134,7 @@ struct stratix10_svc_data {
  * @complete_status: state for completion
  * @svc_fifo_lock: protect access to service message data queue
  * @invoke_fn: function to issue secure monitor call or hypervisor call
+ * @svc: manages the list of client svc drivers
  *
  * This struct is used to create communication channels for service clients, to
  * handle secure monitor or hypervisor call.
@@ -150,6 +151,7 @@ struct stratix10_svc_controller {
 	struct completion complete_status;
 	spinlock_t svc_fifo_lock;
 	svc_invoke_fn *invoke_fn;
+	struct stratix10_svc *svc;
 };
 
 /**
@@ -1209,6 +1211,7 @@ static int stratix10_svc_drv_probe(struc
 		ret = -ENOMEM;
 		goto err_free_kfifo;
 	}
+	controller->svc = svc;
 
 	svc->stratix10_svc_rsu = platform_device_alloc(STRATIX10_RSU, 0);
 	if (!svc->stratix10_svc_rsu) {
@@ -1236,8 +1239,6 @@ static int stratix10_svc_drv_probe(struc
 		goto err_unregister_dev;
 	}
 
-	dev_set_drvdata(dev, svc);
-
 	pr_info("Intel Service Layer Driver Initialized\n");
 
 	return 0;
@@ -1253,8 +1254,8 @@ err_destroy_pool:
 
 static int stratix10_svc_drv_remove(struct platform_device *pdev)
 {
-	struct stratix10_svc *svc = dev_get_drvdata(&pdev->dev);
 	struct stratix10_svc_controller *ctrl = platform_get_drvdata(pdev);
+	struct stratix10_svc *svc = ctrl->svc;
 
 	platform_device_unregister(svc->intel_svc_fcs);
 	platform_device_unregister(svc->stratix10_svc_rsu);


