Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672BD6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0248C433EF;
	Mon, 16 Jan 2023 17:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888909;
	bh=mczP5xVA44gzLO413m99bRw7SDCNuGWx3BLwy44Ekhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WY89Dvc9tWxVbZZURU1GPUPkZohRY71RapeHmcyYcduJ4Ox6N/5+8DiX17iinp1LW
	 E+5L5HcQI2XVpJhSUYorxMxFg9vwRMVGIv0P16OwSGVgyRJi9drTXrWsEcT+NOrHQI
	 FwZuuWYtnZXK251PHepFGq2XvCdJ4aZvL4YZ6PxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 186/338] HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()
Date: Mon, 16 Jan 2023 16:50:59 +0100
Message-Id: <20230116154829.040842178@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

[ Upstream commit f5181c35ed7ba0ceb6e42872aad1334d994b0175 ]

In error label 'out1' path in ssi_probe(), the pm_runtime_enable()
has not been called yet, so pm_runtime_disable() is not needed.

Fixes: b209e047bc74 ("HSI: Introduce OMAP SSI driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 6e9d88d9d471..281fb9b1f219 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -572,9 +572,9 @@ static int ssi_probe(struct platform_device *pd)
 	device_for_each_child(&pd->dev, NULL, ssi_remove_ports);
 out2:
 	ssi_remove_controller(ssi);
+	pm_runtime_disable(&pd->dev);
 out1:
 	platform_set_drvdata(pd, NULL);
-	pm_runtime_disable(&pd->dev);
 
 	return err;
 }
-- 
2.35.1



