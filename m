Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B98442B32;
	Mon, 17 Aug 2026 15:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979402; cv=none; b=q4E3FGX6GWA0P8SnFrE6BtVcO1MKSTPwyR7Gs5HjckhdQUwic6C/LC8P9ZJaefwRJq/O7eGUL8LoDaQwHPzDxj0uk1o5HiKPYs1qKuOgVesloQaKfLfZembBXlUDA3NhdR4WdhOVFqCKc9LW2B4H4V1vWBMmW2oqm5xGdXMx2xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979402; c=relaxed/simple;
	bh=EPAOdIqg4q0ieRXYeMMG8kpRkVYEeYwc0sxCLDWATjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUp9QuD6OGeTNMr2guDFtCNZuWBZlbgmTTq9q+GvTBioeTD5Kli8pAyDoFPUlXxXgtbOS5C2O0r8ySSmPlWBUqsRs/kTW81xDFQK9DNfLjFlM2R1VqQQFHvajR2piiFr11n+7YbasMWthAdvguLs4d1E4zUigGjUmF2Oiu6zlFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrc2d8wg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrc2d8wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC09A1F00A3A;
	Mon, 17 Aug 2026 15:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979401;
	bh=cmPIyLJ4PCoJ5zYLsqm1lts6zbK/ZaF7W8cXtp9iOus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xrc2d8wg7wbopN0PzC/ayO8J/CwGzBpkVznsu8OwvuBg7IwZ1SB1M7Mw75YZM4gKD
	 ntGhTmEDn91iv9WBKJDWNwcVMiZf6p6/vRDgETuvYR+4jGXfZc1J+oDeY8TGwXmHsB
	 snOrAWh/2+tVNeuJRBkc/uatHrYKIo/ILvzPT5A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 213/609] media: vidtv: fix reference leak on failed device registration
Date: Mon, 17 Aug 2026 15:28:29 +0200
Message-ID: <20260817132551.217679263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 9aa21e1549db8882ff77b691e7714153df21dff0 upstream.

When platform_device_register() fails in vidtv_bridge_init(), the
embedded struct device in vidtv_bridge_dev has already been initialized
by device_initialize(), but the failure path returns the error without
dropping the device reference for the current platform device:

  vidtv_bridge_init()
    -> platform_device_register(&vidtv_bridge_dev)
       -> device_initialize(&vidtv_bridge_dev.dev)
       -> setup_pdev_dma_masks(&vidtv_bridge_dev)
       -> platform_device_add(&vidtv_bridge_dev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: f90cf6079bf67 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vidtv/vidtv_bridge.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -596,8 +596,10 @@ static int __init vidtv_bridge_init(void
 	int ret;
 
 	ret = platform_device_register(&vidtv_bridge_dev);
-	if (ret)
+	if (ret) {
+		platform_device_put(&vidtv_bridge_dev);
 		return ret;
+	}
 
 	ret = platform_driver_register(&vidtv_bridge_driver);
 	if (ret)


