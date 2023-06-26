Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DE1C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334D8C433C9;
	Mon, 26 Jun 2023 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804581;
	bh=WiT9+2OZJ5kjsAA2QOwcaOrvaBBUEypuFc9T2gpN8Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsmExmba+aK5eBfdPxEfkaCG74FPh7uyY2lLJhiwD0AM/4XrbIaqBw1RfZ1ACwAsv
	 zNrviFeDh9kpXDxPiC8SpOvnNgi01g3c0tUN5uG7wK/X3OBfzNYDq9JPgtTtfea3+7
	 1BczQn8zLlwrq9N0PoRdTiQnwr+0al59cjjPjBG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/60] mmc: omap_hsmmc: fix deferred probing
Date: Mon, 26 Jun 2023 20:12:12 +0200
Message-ID: <20230626180740.884649756@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180739.558575012@linuxfoundation.org>
References: <20230626180739.558575012@linuxfoundation.org>
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

[ Upstream commit fb51b74a57859b707c3e8055ed0c25a7ca4f6a29 ]

The driver overrides the error codes returned by platform_get_irq() to
-ENXIO, so if it returns -EPROBE_DEFER, the driver will fail the probe
permanently instead of the deferred probing. Switch to propagating the
error codes upstream.

Fixes: 9ec36cafe43b ("of/irq: do irq resolution in platform_get_irq")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20230617203622.6812-7-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/omap_hsmmc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index ee9edf817a326..aef2253ed5c81 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1843,9 +1843,11 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	irq = platform_get_irq(pdev, 0);
-	if (res == NULL || irq < 0)
+	if (!res)
 		return -ENXIO;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
-- 
2.39.2



