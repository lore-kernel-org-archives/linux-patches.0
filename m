Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165E5D520
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDAAC433C8;
	Mon, 26 Jun 2023 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803212;
	bh=M0x5sOh7BFzkJ3oKdGCF5EZ+JMkIwFsKRXGsKDzS1N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWOE6lw3WQ0dRyCBS88RL8/xbhtsO9KI4NW5Y1ER2NaVBwqG1weAdFFKDy7krLOJJ
	 4YN1Lq/eINor4z2U47jEsY9nTnDbhRRv+q5rLiTwD8y9yWI+cEoDIi6cdaUcFIRXPf
	 MEIRLK0fIwKd+7a0kZGa+qK5Pj8/4/dlBB4psXMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/26] mmc: usdhi60rol0: fix deferred probing
Date: Mon, 26 Jun 2023 20:11:14 +0200
Message-ID: <20230626180734.148870571@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180733.699092073@linuxfoundation.org>
References: <20230626180733.699092073@linuxfoundation.org>
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

[ Upstream commit 413db499730248431c1005b392e8ed82c4fa19bf ]

The driver overrides the error codes returned by platform_get_irq_byname()
to -ENODEV, so if it returns -EPROBE_DEFER, the driver will fail the probe
permanently instead of the deferred probing.  Switch to propagating error
codes upstream.

Fixes: 9ec36cafe43b ("of/irq: do irq resolution in platform_get_irq")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20230617203622.6812-13-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/usdhi6rol0.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
index d27ee9eb2eacf..27459eab0ed09 100644
--- a/drivers/mmc/host/usdhi6rol0.c
+++ b/drivers/mmc/host/usdhi6rol0.c
@@ -1749,8 +1749,10 @@ static int usdhi6_probe(struct platform_device *pdev)
 	irq_cd = platform_get_irq_byname(pdev, "card detect");
 	irq_sd = platform_get_irq_byname(pdev, "data");
 	irq_sdio = platform_get_irq_byname(pdev, "SDIO");
-	if (irq_sd < 0 || irq_sdio < 0)
-		return -ENODEV;
+	if (irq_sd < 0)
+		return irq_sd;
+	if (irq_sdio < 0)
+		return irq_sdio;
 
 	mmc = mmc_alloc_host(sizeof(struct usdhi6_host), dev);
 	if (!mmc)
-- 
2.39.2



