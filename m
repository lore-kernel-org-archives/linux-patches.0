Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282A251121F;
	Wed, 30 Sep 2026 16:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784481; cv=none; b=iuYZvJIUtR+xOvy41rY1Ery7w8MhrFBYXAMqo1uxiM42p3RMXbid69hK9Sf7MpvWMN6vScgGN7LuRBGHC4WbS5IfiCQ1qr02TPaEkRwtjynsKygahcMAkGypI2aI3uibyEl+nhlArluK8Pew8cQr/vvdidWsxoeT7EGN0KuFYHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784481; c=relaxed/simple;
	bh=CRMtHlIWh9044ONkGKDEmNvVHrZk4ilLpE/kVe2nJ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlZa5QePzTuxTWD5D4aCIZp/9KIX+qvGe68gvV7YpvvpwCeK3wQr20JXP59DsU2G/beFLMYIPSK3HGFMJdDrYMKRpZ7ZGRTE9f0ZklUm0Wh+I8WrpGOv0iMsgfFv/LfneCnIUsUyHBN4+Nwnil9sPH+eEdYpV+sUeA38YTokg0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gr4D0MXE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gr4D0MXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BA41F000FF;
	Wed, 30 Sep 2026 16:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784470;
	bh=PW5yu55q1aZdtaqC919gXDLtkhiTkQ+RUDv1zB1OnZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gr4D0MXE8dW/j9h9NDsBvy+3cAAed3UwV/vgvsAt5KFOoly7UgWsx5DJmRsjQmwlR
	 DHLV7ILYzww0m86FZsYG17M+bRtafwpnc3vfnXkIYbjvMsnRfH4mXMkpDy6jcnDt57
	 d1LzreXfkWcbawwFmdG5N/Jz/PIUnHXMOZQNG0HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/982] mmc: davinci: fix mmc_add_host order in probe
Date: Wed, 30 Sep 2026 17:14:18 +0200
Message-ID: <20260930152419.438173423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

[ Upstream commit d04e0151d316edbdb4f0397a9b92a1936e4a1421 ]

mmc_add_host() makes the host visible to the MMC core. Register the
interrupt handlers and advertise MMC_CAP_SDIO_IRQ before that, so the
core cannot start using the host before IRQ handling is set up.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/davinci_mmc.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index b744651f3b625..62e75df6b6b00 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1303,14 +1303,10 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 		goto cpu_freq_fail;
 	}
 
-	ret = mmc_add_host(mmc);
-	if (ret < 0)
-		goto mmc_add_host_fail;
-
 	ret = devm_request_irq(&pdev->dev, irq, mmc_davinci_irq, 0,
 			       mmc_hostname(mmc), host);
 	if (ret)
-		goto request_irq_fail;
+		goto mmc_add_host_fail;
 
 	if (host->sdio_irq >= 0) {
 		ret = devm_request_irq(&pdev->dev, host->sdio_irq,
@@ -1320,6 +1316,10 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 			mmc->caps |= MMC_CAP_SDIO_IRQ;
 	}
 
+	ret = mmc_add_host(mmc);
+	if (ret < 0)
+		goto mmc_add_host_fail;
+
 	rename_region(mem, mmc_hostname(mmc));
 
 	dev_info(mmc_dev(host->mmc), "Using %s, %d-bit mode\n",
@@ -1328,8 +1328,6 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 
 	return 0;
 
-request_irq_fail:
-	mmc_remove_host(mmc);
 mmc_add_host_fail:
 	mmc_davinci_cpufreq_deregister(host);
 cpu_freq_fail:
-- 
2.53.0



