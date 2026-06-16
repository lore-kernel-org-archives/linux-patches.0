Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E8447CC62;
	Tue, 16 Jun 2026 17:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632334; cv=none; b=oiVyD9nBxOa6xurbXvjKrR+pRFWT27F7ZaWtJoYPLIyK0ItQaYqe9cQsGVRBYQso/YeuCi+y+0Uu6MfHUlbSnRiKqP4mHn9qg95hh6KSqLeZ2H6EHDcn6YIKzVw8uRPSuEZUBAX/5yLxwDuf3/wCzT7/jh1L1sD+Cr4u1U05ghg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632334; c=relaxed/simple;
	bh=TjqBi/FVuXZYVuRVsbANvzVco/ItADRajDTyhiTjlq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJPDlF+9Pko5WVjWsynb+7o6osliB5eREPBFb5f4KcCyyB5hv2kXtYoMUcggdl3m+5IHUJxzSJxKhXYS70sa6MMP3aY9LvfuzutOTvzA8UrLM5HSfYH6Q6YCufes0RRfGkleP15XzDMOI0gerqjaeuYrmXmXQbo7ToBdYRNIw+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAoNfwZr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAoNfwZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4771F000E9;
	Tue, 16 Jun 2026 17:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632330;
	bh=yRkBdjCzQd8Juf3V4+jJgIcU8g9kj4rI+y2yND6zjQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAoNfwZruLKxpp9PsBHfp7ManwiDtD5uqCd6FGN6KqfvYFTXop4CHdp24As3kVvHf
	 N57UIsrgWELaISYg9MV24eBzVMlur/y4euI8P+C48OOJk31FfUnUiP4M7eDI8HlkxB
	 lGNntbAT3BhlD7A26+jHk+mYbJ6oRWHhWpMAUIYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruan Jinjie <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 390/522] spi: spi-zynq: Do not check for 0 return after calling platform_get_irq()
Date: Tue, 16 Jun 2026 20:28:57 +0530
Message-ID: <20260616145144.046740979@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruan Jinjie <ruanjinjie@huawei.com>

[ Upstream commit 3182d49aad5f1cd8acdcf7de0c5b651772edd32e ]

It is not possible for platform_get_irq() to return 0. Use the
return value from platform_get_irq().

Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20230802094357.981100-1-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c9c012706c9f ("spi: zynq-qspi: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynq-qspi.c    |    4 ++--
 drivers/spi/spi-zynqmp-gqspi.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -688,8 +688,8 @@ static int zynq_qspi_probe(struct platfo
 	}
 
 	xqspi->irq = platform_get_irq(pdev, 0);
-	if (xqspi->irq <= 0) {
-		ret = -ENXIO;
+	if (xqspi->irq < 0) {
+		ret = xqspi->irq;
 		goto clk_dis_all;
 	}
 	ret = devm_request_irq(&pdev->dev, xqspi->irq, zynq_qspi_irq,
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1164,8 +1164,8 @@ static int zynqmp_qspi_probe(struct plat
 	zynqmp_qspi_init_hw(xqspi);
 
 	xqspi->irq = platform_get_irq(pdev, 0);
-	if (xqspi->irq <= 0) {
-		ret = -ENXIO;
+	if (xqspi->irq < 0) {
+		ret = xqspi->irq;
 		goto clk_dis_all;
 	}
 	ret = devm_request_irq(&pdev->dev, xqspi->irq, zynqmp_qspi_irq,


