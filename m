Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7DE31D72E;
	Mon, 27 Oct 2025 19:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593392; cv=none; b=EQhv5ZvgsqcqlMWha97rwbexYCtlHM9TBSTFeymheskhzoxYVmiDGDBH7t4yEwU4uXn7hfhtexUGY7wJagNW2IQE/cyKrPCQP1KvA9GT0DyBYx79kzGad2T3fLFR9RWYtlZ7IyxEZqc0XoczAcXoFuDvyCVupB4JW5IcOnmO1OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593392; c=relaxed/simple;
	bh=fqWM4/7Gy/kFL/sQT4BxVWsyKB9hcrfhgspQRi8D8Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIjrEiUp4Gh0oifJVE/297XsH1aTQaYJQ2wwbfAzRQchldHsw9x5081VLRarcFNkPmvjOPA3iRyMTlGoJTNwgJ6F5UF+TgSNriL7AFuH/8dcOdge6SVJdeTNVc583nnb4PEo+jLiBb3Y45BU67cIoBSVp53pNeU9/T5XBEllYmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXXwWSFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXXwWSFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2B7C4CEF1;
	Mon, 27 Oct 2025 19:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593391;
	bh=fqWM4/7Gy/kFL/sQT4BxVWsyKB9hcrfhgspQRi8D8Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXXwWSFOJgabAjoMG6hUyQZsIyQJmQM7oW2/cbFx0O3jlhudqv/BouIh55P4ANVr3
	 7lVzEe3/HDZTLT7uHqo8lc6k8mV++U2AiY/VD+53WR7X/dKiG6mqgsexN9a1BBraW5
	 Go3JPE+Gfubq637nUhtk5LeXOu7uw6zZwa/PlnyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mattijs Korpershoek <mkorpershoek@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 120/184] spi: cadence-quadspi: Fix pm_runtime unbalance on dma EPROBE_DEFER
Date: Mon, 27 Oct 2025 19:36:42 +0100
Message-ID: <20251027183518.174963575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mattijs Korpershoek <mkorpershoek@kernel.org>

[ Upstream commit 8735696acea24ac1f9d4490992418c71941ca68c ]

In csqspi_probe(), when cqspi_request_mmap_dma() returns -EPROBE_DEFER,
we handle the error by jumping to probe_setup_failed.
In that label, we call pm_runtime_disable(), even if we never called
pm_runtime_enable() before.

Because of this, the driver cannot probe:

[    2.690018] cadence-qspi 47040000.spi: No Rx DMA available
[    2.699735] spi-nor spi0.0: resume failed with -13
[    2.699741] spi-nor: probe of spi0.0 failed with error -13

Only call pm_runtime_disable() if it was enabled by adding a new
label to handle cqspi_request_mmap_dma() failures.

Fixes: b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
Signed-off-by: Mattijs Korpershoek <mkorpershoek@kernel.org>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20251009-cadence-quadspi-fix-pm-runtime-v2-1-8bdfefc43902@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index d1a59120d3845..ce0f605ab688b 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1995,7 +1995,7 @@ static int cqspi_probe(struct platform_device *pdev)
 	if (cqspi->use_direct_mode) {
 		ret = cqspi_request_mmap_dma(cqspi);
 		if (ret == -EPROBE_DEFER)
-			goto probe_setup_failed;
+			goto probe_dma_failed;
 	}
 
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
@@ -2019,9 +2019,10 @@ static int cqspi_probe(struct platform_device *pdev)
 
 	return 0;
 probe_setup_failed:
-	cqspi_controller_enable(cqspi, 0);
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
 		pm_runtime_disable(dev);
+probe_dma_failed:
+	cqspi_controller_enable(cqspi, 0);
 probe_reset_failed:
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);
-- 
2.51.0



