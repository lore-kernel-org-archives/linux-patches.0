Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D34107AC
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DD5C433C8;
	Mon, 26 Jun 2023 18:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804823;
	bh=z9+qRHCdUaEne/xir7twrimg06NudfRiP0riJtn9RAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVfOJiNcev8JFZnJW9ka+C+2XQlwmFpBQYNXN8iodn3EehIjN9CxwJBlbfmoeAEq8
	 Ds7mNW/lf+ml6njZUtyuhhjSu4YFdjWMf7yqKYLKr+pN+Ew5K+aWg+cxiCzYT3lpf2
	 kEpADUlM/ZmZZLUiZd1V8BU6XsV0NULpuzwo6ebU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 54/96] mmc: sdhci-acpi: fix deferred probing
Date: Mon, 26 Jun 2023 20:12:09 +0200
Message-ID: <20230626180749.205805667@linuxfoundation.org>
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

[ Upstream commit b465dea5e1540c7d7b5211adaf94926980d3014b ]

The driver overrides the error codes returned by platform_get_irq() to
-EINVAL, so if it returns -EPROBE_DEFER, the driver will fail the probe
permanently instead of the deferred probing. Switch to propagating the
error codes upstream.

Fixes: 1b7ba57ecc86 ("mmc: sdhci-acpi: Handle return value of platform_get_irq")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20230617203622.6812-9-s.shtylyov@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index 8fe65f172a611..f4e15eef70454 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -910,7 +910,7 @@ static int sdhci_acpi_probe(struct platform_device *pdev)
 	host->ops	= &sdhci_acpi_ops_dflt;
 	host->irq	= platform_get_irq(pdev, 0);
 	if (host->irq < 0) {
-		err = -EINVAL;
+		err = host->irq;
 		goto err_free;
 	}
 
-- 
2.39.2



