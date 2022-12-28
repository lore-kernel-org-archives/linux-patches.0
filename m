Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F7F1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C692C433D2;
	Wed, 28 Dec 2022 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243506;
	bh=9SoGPepvjppRXXngI9GOkeLImGE7v0zYpMEXdu2jfxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuNpgsyWHGbmrlV+FJJ1PvM5d14dspG0jIMzDlbPpMxRmrDWABJCxQXzszTdPf0C9
	 q7QeBtcQvXIR4rUV/QMUz5uBEVfsSKGR+yOx1zTC/rOT/EgImrka3Rf3cKTlD9qHia
	 6llSpwwte4CMAzPscoXSl8I6r6SRKuNI7lTaFCao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0500/1146] mmc: rtsx_usb_sdmmc: fix return value check of mmc_add_host()
Date: Wed, 28 Dec 2022 15:33:59 +0100
Message-Id: <20221228144343.759645314@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit fc38a5a10e9e5a75eb9189854abeb8405b214cc9 ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and calling mmc_free_host() in the
error path, besides, led_classdev_unregister() and pm_runtime_disable() also
need be called.

Fixes: c7f6558d84af ("mmc: Add realtek USB sdmmc host driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-7-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_usb_sdmmc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 5798aee06653..2c650cd58693 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1329,6 +1329,7 @@ static int rtsx_usb_sdmmc_drv_probe(struct platform_device *pdev)
 #ifdef RTSX_USB_USE_LEDS_CLASS
 	int err;
 #endif
+	int ret;
 
 	ucr = usb_get_intfdata(to_usb_interface(pdev->dev.parent));
 	if (!ucr)
@@ -1365,7 +1366,15 @@ static int rtsx_usb_sdmmc_drv_probe(struct platform_device *pdev)
 	INIT_WORK(&host->led_work, rtsx_usb_update_led);
 
 #endif
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+#ifdef RTSX_USB_USE_LEDS_CLASS
+		led_classdev_unregister(&host->led);
+#endif
+		mmc_free_host(mmc);
+		pm_runtime_disable(&pdev->dev);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.35.1



