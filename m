Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35A811CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71637C433C8;
	Mon, 26 Jun 2023 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804814;
	bh=t9lwuGze6JNckhRCy3LNXD501Avmp2yFb0WQTv4whIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UU3+c42C8vfABZYHPWYfiWNPnfibl5IL6VmoVmSV5PGI7zMXwPM1bmCWSLpuH8jCh
	 9nGJnAXcdUV7dR8uspW53XT4G7peyXAHrxz+iFjfP59ZfaPxod5YoOKQeqVWHwmMud
	 gcsa3ZuoaQ0IAyPg4IpfuTqzFQKFC3xqQnEgrcbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/96] mmc: omap: fix deferred probing
Date: Mon, 26 Jun 2023 20:12:06 +0200
Message-ID: <20230626180749.089029828@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
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

[ Upstream commit aedf4ba1ad00aaa94c1b66c73ecaae95e2564b95 ]

The driver overrides the error codes returned by platform_get_irq() to
-ENXIO, so if it returns -EPROBE_DEFER, the driver will fail the probe
permanently instead of the deferred probing. Switch to propagating the
error codes upstream.

Fixes: 9ec36cafe43b ("of/irq: do irq resolution in platform_get_irq")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20230617203622.6812-6-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 5e5af34090f1b..ecf2a68d0e846 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1343,7 +1343,7 @@ static int mmc_omap_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return -ENXIO;
+		return irq;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	host->virt_base = devm_ioremap_resource(&pdev->dev, res);
-- 
2.39.2



