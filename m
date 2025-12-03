Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5373F313546;
	Wed,  3 Dec 2025 16:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780469; cv=none; b=gVTjN5IiVaTJc3ynV6p9bCvO0a0Q1mpNuCO364XJiv8eBQvwBSQHO0tDKg2196VD0y2cH6kHUO6i1MSHqAp5SVZ7W0Bzt2G2uGwXXwMk5qjQzbijr1k24QwOLbCddu6F8KcwfxNgXNY4MuMIMw13hZ6jeQHcPDg6t+kI+dcVloM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780469; c=relaxed/simple;
	bh=qSmbpj04eBVGCKu56ibAquSUSYN6TTQrETnphBqTRn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghnQeB+X2lXyCgYxKNnox9aGD28wF68Nu+chY2ClTLkSKC7xlnkIyibckdNBMBZUl3MCriUzvtlBpYgCGNAD5NMvKMhbv6XeJ+hR9rGC27nw7YPCbQqBFtKN6X4FRPvFRHDbzCne0zvR1sQ+hzvUU39sASxmjcaJy80NHAz1bxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGNWieuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGNWieuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA80C4CEF5;
	Wed,  3 Dec 2025 16:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780469;
	bh=qSmbpj04eBVGCKu56ibAquSUSYN6TTQrETnphBqTRn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGNWieuTP6xEzzfpRYNV9uxzttbZzw5/o6CVrn72BUCbUf+0OeZyr8yP6Kra0mH6M
	 PVr3UbybZzWayJLhKLm61vtP4SgKuDwOg3QE8OOPPLUbTTCgdz2SmVKCpp/g0x8Dut
	 eZCUy6rMxRgsqUJQHVanJTPU58SVOgtU3c1bP02M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ang Tien Sung <tiensung.ang@altera.com>,
	Khairul Anuar Romli <khairul.anuar.romli@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.1 533/568] firmware: stratix10-svc: fix bug in saving controller data
Date: Wed,  3 Dec 2025 16:28:55 +0100
Message-ID: <20251203152500.234821207@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,6 +133,7 @@ struct stratix10_svc_data {
  * @complete_status: state for completion
  * @svc_fifo_lock: protect access to service message data queue
  * @invoke_fn: function to issue secure monitor call or hypervisor call
+ * @svc: manages the list of client svc drivers
  *
  * This struct is used to create communication channels for service clients, to
  * handle secure monitor or hypervisor call.
@@ -149,6 +150,7 @@ struct stratix10_svc_controller {
 	struct completion complete_status;
 	spinlock_t svc_fifo_lock;
 	svc_invoke_fn *invoke_fn;
+	struct stratix10_svc *svc;
 };
 
 /**
@@ -1191,6 +1193,7 @@ static int stratix10_svc_drv_probe(struc
 		ret = -ENOMEM;
 		goto err_free_kfifo;
 	}
+	controller->svc = svc;
 
 	svc->stratix10_svc_rsu = platform_device_alloc(STRATIX10_RSU, 0);
 	if (!svc->stratix10_svc_rsu) {
@@ -1218,8 +1221,6 @@ static int stratix10_svc_drv_probe(struc
 		goto err_unregister_dev;
 	}
 
-	dev_set_drvdata(dev, svc);
-
 	pr_info("Intel Service Layer Driver Initialized\n");
 
 	return 0;
@@ -1235,8 +1236,8 @@ err_destroy_pool:
 
 static int stratix10_svc_drv_remove(struct platform_device *pdev)
 {
-	struct stratix10_svc *svc = dev_get_drvdata(&pdev->dev);
 	struct stratix10_svc_controller *ctrl = platform_get_drvdata(pdev);
+	struct stratix10_svc *svc = ctrl->svc;
 
 	platform_device_unregister(svc->intel_svc_fcs);
 	platform_device_unregister(svc->stratix10_svc_rsu);


