Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A631A26A0E5;
	Tue, 25 Mar 2025 12:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906153; cv=none; b=GJlM9O8AepxVtvNKLS9M0pSwzKFhs7XG4TJBKhRZPuRs4pjMOYS/a0VOyb082LtpF1apz1d/iX8IPxCdChwv2x0f6yeJYyC40CjD1mqewwPT5GY7bdgm8DHylhAIYqTu1xW5V0wgmy3zr7VA9ztBAfxEmuDx1+RAIW5SsGTetEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906153; c=relaxed/simple;
	bh=aQf89Phc5HSdsN3nOQKGDAqRGhcX+vms8EK/XwCQSsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVHCBihjsJ0pJNmIkjo1S3It6lPDKsWeobX29jLCL6h0lc/CShINOAFfH1W+3XUg+keqGSPVmcOl1l8YI+R1wQ18ewcyj2ZIT9c2Jp/hVtYA0UszdJ2NdkIHblLay5Y4UJpD1A0tdklH0ylMITR0x/P53cf+PqxiJROcpW3egI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H03ZmbwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H03ZmbwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53817C4CEE4;
	Tue, 25 Mar 2025 12:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906153;
	bh=aQf89Phc5HSdsN3nOQKGDAqRGhcX+vms8EK/XwCQSsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H03ZmbwVNDDm8WU3aCSJfw815BgbIYYRxOVFvBZVHa2w7fyNMaXoh7FXzS8Qgctfb
	 RAz0k41tLppWkoW/Pb/CpfluKrjkS92uwvMXCW9kQ4Yx8yPsXOAaV20QiDjoeqzIN2
	 lp3sFuN6TBL6h+cZkuM81o+cqBQUTzLz4olyZi0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gu Bowen <gubowen5@huawei.com>,
	Aubin Constans <aubin.constans@microchip.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 44/77] mmc: atmel-mci: Add missing clk_disable_unprepare()
Date: Tue, 25 Mar 2025 08:22:39 -0400
Message-ID: <20250325122145.505787388@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gu Bowen <gubowen5@huawei.com>

commit e51a349d2dcf1df8422dabb90b2f691dc7df6f92 upstream.

The error path when atmci_configure_dma() set dma fails in atmci driver
does not correctly disable the clock.
Add the missing clk_disable_unprepare() to the error path for pair with
clk_prepare_enable().

Fixes: 467e081d23e6 ("mmc: atmel-mci: use probe deferring if dma controller is not ready yet")
Signed-off-by: Gu Bowen <gubowen5@huawei.com>
Acked-by: Aubin Constans <aubin.constans@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250225022856.3452240-1-gubowen5@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/atmel-mci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2536,8 +2536,10 @@ static int atmci_probe(struct platform_d
 	/* Get MCI capabilities and set operations according to it */
 	atmci_get_cap(host);
 	ret = atmci_configure_dma(host);
-	if (ret == -EPROBE_DEFER)
+	if (ret == -EPROBE_DEFER) {
+		clk_disable_unprepare(host->mck);
 		goto err_dma_probe_defer;
+	}
 	if (ret == 0) {
 		host->prepare_data = &atmci_prepare_data_dma;
 		host->submit_data = &atmci_submit_data_dma;


