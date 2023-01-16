Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFE146B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABDCC433F0;
	Mon, 16 Jan 2023 16:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885821;
	bh=1ZQ6+/fuRCxh9DqWHM9P3dLdWAyJxLUDJHaysaLu7W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCgfyXhPhg4rmgUQ9ncRfbJ9wXR5XTZdcBH3bENAx533Gs+pb+vNPB6VrT/q4Icob
	 a7tl8+ip8e+udbu4//ozcVcCjMuBT9402xmOFiWiLiKU1c8kUBX+4juEpjq0lBQNLh
	 jpqwFhlBa2YmFu70rRnWC4vApcvZfxh/4st+0Ah8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/658] mmc: omap_hsmmc: fix return value check of mmc_add_host()
Date: Mon, 16 Jan 2023 16:44:45 +0100
Message-Id: <20230116154918.445987939@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit a525cad241c339ca00bf7ebf03c5180f2a9b767c ]

mmc_add_host() may return error, if we ignore its return value,
it will lead two issues:
1. The memory that allocated in mmc_alloc_host() is leaked.
2. In the remove() path, mmc_remove_host() will be called to
   delete device, but it's not added yet, it will lead a kernel
   crash because of null-ptr-deref in device_del().

Fix this by checking the return value and goto error path wihch
will call mmc_free_host().

Fixes: a45c6cb81647 ("[ARM] 5369/1: omap mmc: Add new omap hsmmc controller for 2430 and 34xx, v3")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221108121316.340354-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/omap_hsmmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index d0df054b0b47..ee9edf817a32 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1998,7 +1998,9 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	if (!ret)
 		mmc->caps |= MMC_CAP_SDIO_IRQ;
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto err_irq;
 
 	if (mmc_pdata(host)->name != NULL) {
 		ret = device_create_file(&mmc->class_dev, &dev_attr_slot_name);
-- 
2.35.1



