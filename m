Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FC413AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C29FC433C8;
	Mon, 26 Jun 2023 18:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803634;
	bh=8rtgpqyGTpDXC8Q8jyIJhPtG8+v+3BaIWxRHGhthRHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LC89NUvcsKOsIsIVYtNP/zV1aGPi0/4s0shQqsMCuHl5+SdEmX7rjR9L6QI6kJhJW
	 f5g5DNqYqyLTVRlgQI8pXpuWwKAwxlhK82MHcMUS4F9QoaO+JoZlzewB/PRsoM0lK2
	 FNhwKySf1XAO9RI4QcRXvehcZJ8eLcwHGtZjiXqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 120/199] mmc: sh_mmcif: fix deferred probing
Date: Mon, 26 Jun 2023 20:10:26 +0200
Message-ID: <20230626180810.908202446@linuxfoundation.org>
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

[ Upstream commit 5b067d7f855c61df7f8e2e8ccbcee133c282415e ]

The driver overrides the error codes returned by platform_get_irq() to
-ENXIO, so if it returns -EPROBE_DEFER, the driver will fail the probe
permanently instead of the deferred probing. Switch to propagating the
error codes upstream.

Fixes: 9ec36cafe43b ("of/irq: do irq resolution in platform_get_irq")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20230617203622.6812-11-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sh_mmcif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index 0fd4c9d644dd5..5cf53348372a4 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1400,7 +1400,7 @@ static int sh_mmcif_probe(struct platform_device *pdev)
 	irq[0] = platform_get_irq(pdev, 0);
 	irq[1] = platform_get_irq_optional(pdev, 1);
 	if (irq[0] < 0)
-		return -ENXIO;
+		return irq[0];
 
 	reg = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(reg))
-- 
2.39.2



