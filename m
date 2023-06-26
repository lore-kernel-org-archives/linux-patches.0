Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDE414AA1
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEB3C433C0;
	Mon, 26 Jun 2023 18:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804280;
	bh=tM7oAIEgPSuEPRNMy6w1X1/iyMvCI0tIqKmxuDizM9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOq9EaV+eaBDFwfdh7MXp8kOS5+QL8T4c0a3y7+7KmXEwUWMNFi5QAYr/kcUAEeZb
	 SMEwPt5BFiuKHL65dbGOgYFKsQJw/XWtlcPJ7r0Vh6cN1pcpA49nKa447xYe7Ih/Ce
	 F2/4dhKsD6BnnBnoUhvbIP5Wp4gEwNe12BNENEMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/170] mmc: sdhci-acpi: fix deferred probing
Date: Mon, 26 Jun 2023 20:11:11 +0200
Message-ID: <20230626180805.125933265@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
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
index 4cca4c90769bc..b917060a258a4 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -829,7 +829,7 @@ static int sdhci_acpi_probe(struct platform_device *pdev)
 	host->ops	= &sdhci_acpi_ops_dflt;
 	host->irq	= platform_get_irq(pdev, 0);
 	if (host->irq < 0) {
-		err = -EINVAL;
+		err = host->irq;
 		goto err_free;
 	}
 
-- 
2.39.2



