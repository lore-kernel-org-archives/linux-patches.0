Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E0D25522E;
	Tue, 25 Mar 2025 12:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905995; cv=none; b=cr5bXFKWEvJPbjWYtp4eHeR6b0B6F3sTmVU61kn98IYml7uqKS+URSxmsdooow+hdFoImlXOSArVxZhp8xCO5GaU74+YpxlpUKo0GwTmjVytRPnzMW+7wfJq6DhQqFDPM5KkWvbeh8+vC4JSBm9PWo7YrGXQJ6hMkN5niMmePo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905995; c=relaxed/simple;
	bh=ae7qyvO39Bo1EsWu9VvuJBTrQTfxxU0ggITXaMdgh8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srh+Sm6tIWdK8e3OFyR+viZJSU+rZ4shKtoXdwbTlGwNFlxKtpwkpWyXaykuN2CZLLEO1V9BndecncNAdEzXZazBdy2We10yWsHQFt5DrP81zBbsDtLAP7pbz2gkzZKb9axM4lzQ5CEKNgWrucKTxJ2NT//odZGPeiNtPsr2iYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ER8r+q/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ER8r+q/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2C2C4CEE4;
	Tue, 25 Mar 2025 12:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905995;
	bh=ae7qyvO39Bo1EsWu9VvuJBTrQTfxxU0ggITXaMdgh8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ER8r+q/PZ+j93JSN58pJ+smiJuup3cnGaLNQGhGphdeYmYfh4F54i1ulbryDRmgsd
	 P7UuYtkIulem3pyQNsRI2HMwOLBuGW7FsMMX/FUKRd8bhcuzi/CK/Tu+/gUgd+asbw
	 Ah4f47Uvq28639jBw7nIrRCxWCB3jRym7zbkZp+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gu Bowen <gubowen5@huawei.com>,
	Aubin Constans <aubin.constans@microchip.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.13 077/119] mmc: atmel-mci: Add missing clk_disable_unprepare()
Date: Tue, 25 Mar 2025 08:22:15 -0400
Message-ID: <20250325122151.025372191@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2499,8 +2499,10 @@ static int atmci_probe(struct platform_d
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


