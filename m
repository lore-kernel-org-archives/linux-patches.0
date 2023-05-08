Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADB2168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE18C433D2;
	Mon,  8 May 2023 11:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544965;
	bh=vUx02TOStQc4xnXRJqoMKJTGwsr1mViVOJ9jgvvmFyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJcHZENgBTsqjnPpXKCbWSiAZC5/+VER+enhuiVtzL0abgk2d6V16POrBskpkQK+j
	 2He4E+bxG60eOimWRbakpaqNF13Pby52gfiPRrKren+Mae14fDpjBOr086HauwWuzh
	 +K+2EP+lkCPFGvQbuhnjhWBN14DN4rEMegmx6JAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dhruva Gole <d-gole@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 550/694] spi: cadence-quadspi: use macro DEFINE_SIMPLE_DEV_PM_OPS
Date: Mon,  8 May 2023 11:46:25 +0200
Message-Id: <20230508094452.409260163@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dhruva Gole <d-gole@ti.com>

[ Upstream commit be3206e8906e7a93df673ab2e96d69304a008edc ]

Using this macro makes the code more readable.
It also inits the members of dev_pm_ops in the following manner
without us explicitly needing to:

.suspend = cqspi_suspend, \
.resume = cqspi_resume, \
.freeze = cqspi_suspend, \
.thaw = cqspi_resume, \
.poweroff = cqspi_suspend, \
.restore = cqspi_resume

Also get rid of conditional compilation based on CONFIG_PM_SLEEP because
it introduces build issues with certain configs when CQSPI_DEV_PM_OPS is
just NULL.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304191900.2fARFQW9-lkp@intel.com/
Fixes: 140623410536 ("mtd: spi-nor: Add driver for Cadence Quad SPI Flash Controller")
Signed-off-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20230420054257.925092-1-d-gole@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1802,7 +1802,6 @@ static int cqspi_remove(struct platform_
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int cqspi_suspend(struct device *dev)
 {
 	struct cqspi_st *cqspi = dev_get_drvdata(dev);
@@ -1832,15 +1831,7 @@ static int cqspi_resume(struct device *d
 	return spi_master_resume(master);
 }
 
-static const struct dev_pm_ops cqspi__dev_pm_ops = {
-	.suspend = cqspi_suspend,
-	.resume = cqspi_resume,
-};
-
-#define CQSPI_DEV_PM_OPS	(&cqspi__dev_pm_ops)
-#else
-#define CQSPI_DEV_PM_OPS	NULL
-#endif
+static DEFINE_SIMPLE_DEV_PM_OPS(cqspi_dev_pm_ops, cqspi_suspend, cqspi_resume);
 
 static const struct cqspi_driver_platdata cdns_qspi = {
 	.quirks = CQSPI_DISABLE_DAC_MODE,
@@ -1907,7 +1898,7 @@ static struct platform_driver cqspi_plat
 	.remove = cqspi_remove,
 	.driver = {
 		.name = CQSPI_NAME,
-		.pm = CQSPI_DEV_PM_OPS,
+		.pm = &cqspi_dev_pm_ops,
 		.of_match_table = cqspi_dt_ids,
 	},
 };


