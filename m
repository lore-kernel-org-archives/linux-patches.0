Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0064611CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70557C433C0;
	Mon, 26 Jun 2023 18:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804811;
	bh=oWln9belhgx/LvrKwxE+bs+QSjk7FRGBKTwAnqyyOuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZLrMKREHAbmaqvnQfi6jVSyAvT98wP7vy2HlUQsLha1p8Vccw7uaVo7sbFjNwnWM
	 YDNbesbiXV4crduDtlUJ0DcTlh4zmMwCQZY9xyGXjZ/v8BelcZ1KzZLii+3o3r4P5V
	 D1dphJ+hw+uKVFKQlLZb/lxOUHoMSNJtMYJTW7d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/96] mmc: mvsdio: fix deferred probing
Date: Mon, 26 Jun 2023 20:12:05 +0200
Message-ID: <20230626180749.046754183@linuxfoundation.org>
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

[ Upstream commit 8d84064da0d4672e74f984e8710f27881137472c ]

The driver overrides the error codes returned by platform_get_irq() to
-ENXIO, so if it returns -EPROBE_DEFER, the driver will fail the probe
permanently instead of the deferred probing. Switch to propagating the
error codes upstream.

Fixes: 9ec36cafe43b ("of/irq: do irq resolution in platform_get_irq")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20230617203622.6812-5-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mvsdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 629efbe639c4f..b4f6a0a2fcb51 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -704,7 +704,7 @@ static int mvsd_probe(struct platform_device *pdev)
 	}
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return -ENXIO;
+		return irq;
 
 	mmc = mmc_alloc_host(sizeof(struct mvsd_host), &pdev->dev);
 	if (!mmc) {
-- 
2.39.2



