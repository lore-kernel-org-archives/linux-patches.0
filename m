Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C418A2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF18C433EF;
	Tue, 18 Apr 2023 12:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821899;
	bh=S8EdIpybQ3dbjkW3l22hV52frnPpXw+QCFHLqqD7EJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w85uqpt3STWA/soaTs4pFV95YoE1Wb/1VSzOkNhOTRhApaSQzaKJU6+kQ7WYTIYvB
	 8BOmzEh8c/mGB2VJsmXIDiOfccoLuPKTmHQPmOAZOquyDYEaYEEIwts+35ddI67dlI
	 lbNZ9kOZ/tl2JFki8hBg9dNjeuuWy5qdGHjrEGaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Jing <jingfelix@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/134] hwmon: (xgene) Fix ioremap and memremap leak
Date: Tue, 18 Apr 2023 14:22:20 +0200
Message-Id: <20230418120316.037513996@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tianyi Jing <jingfelix@hust.edu.cn>

[ Upstream commit 813cc94c7847ae4a17e9f744fb4dbdf7df6bd732 ]

Smatch reports:

drivers/hwmon/xgene-hwmon.c:757 xgene_hwmon_probe() warn:
'ctx->pcc_comm_addr' from ioremap() not released on line: 757.

This is because in drivers/hwmon/xgene-hwmon.c:701 xgene_hwmon_probe(),
ioremap and memremap is not released, which may cause a leak.

To fix this, ioremap and memremap is modified to devm_ioremap and
devm_memremap.

Signed-off-by: Tianyi Jing <jingfelix@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230318143851.2191625-1-jingfelix@hust.edu.cn
[groeck: Fixed formatting and subject]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/xgene-hwmon.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index d1abea49f01be..78d9f52e2a719 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -698,14 +698,14 @@ static int xgene_hwmon_probe(struct platform_device *pdev)
 		ctx->comm_base_addr = pcc_chan->shmem_base_addr;
 		if (ctx->comm_base_addr) {
 			if (version == XGENE_HWMON_V2)
-				ctx->pcc_comm_addr = (void __force *)ioremap(
-							ctx->comm_base_addr,
-							pcc_chan->shmem_size);
+				ctx->pcc_comm_addr = (void __force *)devm_ioremap(&pdev->dev,
+								  ctx->comm_base_addr,
+								  pcc_chan->shmem_size);
 			else
-				ctx->pcc_comm_addr = memremap(
-							ctx->comm_base_addr,
-							pcc_chan->shmem_size,
-							MEMREMAP_WB);
+				ctx->pcc_comm_addr = devm_memremap(&pdev->dev,
+								   ctx->comm_base_addr,
+								   pcc_chan->shmem_size,
+								   MEMREMAP_WB);
 		} else {
 			dev_err(&pdev->dev, "Failed to get PCC comm region\n");
 			rc = -ENODEV;
-- 
2.39.2



