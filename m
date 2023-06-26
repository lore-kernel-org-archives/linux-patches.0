Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B679134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAA2C433C8;
	Mon, 26 Jun 2023 18:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803595;
	bh=PkmAwMMpaQ2Z0zOxhGAcWgpqvFpbZEtlmac6vlhcASA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqOv3LrGhhO3NuJ/ioFpn1unCxQ4sXdcPur5JIDKSabS1rU7DxFHfe15tBodedYJW
	 R3VfxWwZ9g2UNQ9P3svyfH3FDKQ+kB2y8DhN22ODljfTz7/BzvyLw/J5v+HtlXRZaG
	 QDgbZCwxsbA4Dx3ERo7NQ/+bELnIhccgIKt77jHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 114/199] mmc: mtk-sd: fix deferred probing
Date: Mon, 26 Jun 2023 20:10:20 +0200
Message-ID: <20230626180810.649598537@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 0c4dc0f054891a2cbde0426b0c0fdf232d89f47f ]

The driver overrides the error codes returned by platform_get_irq() to
-EINVAL, so if it returns -EPROBE_DEFER, the driver will fail the probe
permanently instead of the deferred probing. Switch to propagating the
error codes upstream.

Fixes: 208489032bdd ("mmc: mediatek: Add Mediatek MMC driver")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20230617203622.6812-4-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index edade0e54a0c2..9785ec91654f7 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2680,7 +2680,7 @@ static int msdc_drv_probe(struct platform_device *pdev)
 
 	host->irq = platform_get_irq(pdev, 0);
 	if (host->irq < 0) {
-		ret = -EINVAL;
+		ret = host->irq;
 		goto host_free;
 	}
 
-- 
2.39.2



