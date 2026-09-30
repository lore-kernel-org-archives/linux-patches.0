Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B724251DDF3;
	Wed, 30 Sep 2026 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790842; cv=none; b=arzJWRl3vD0Vz2ZQj0jIldBj5PrdJbUccRPN8LXHJ/UM13RGnrJ0QQxOZhnNPHqeGcWKZEXVz9WKRrODu/bbA+5ksDBiOeXQIewrPVIpOg7vkDNVMoBa3A7uqnA41QRRJ9UukrvTXkO1brsusHusBKY9aPdrDSelUQHV5BM12S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790842; c=relaxed/simple;
	bh=xWOpM+yEzQuXnaWRUoEivT5i8EjpQ9h7jFdubqFvU5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHItznGSbKHPt2YwvJwc4XsH4hpov4LWtFu1CztCM3Xy3rtXkLuPGaQ5VaVJVdf5iVH5YvpKQdzspJQSFEdiSJFF31+fM0lcICrPZKHbHcG07SzPQSBfRYaUUFfeOgw/X0qOatLC8TyAvnCuOkfjjF9yLTqanQT+KokpwMEvwvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ky2mI5JW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ky2mI5JW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D971C1F000FF;
	Wed, 30 Sep 2026 17:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790841;
	bh=Wq5/E8EN6zlKEoi1ASOIQ6N7175gkWbqzEDOT0ELdN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ky2mI5JWY7LbZxNSgm8ZceN2Z/i3T6sp20TZAS8bQs681iVjoPLZWmI59XIBKkuQ5
	 pvS+ka3NWe7jZTNQ7CzY74KcGYAR6+LmVVGH+4ONPSB1r2bvOrwjacI4/LKCbO06H+
	 LKeK6MmyPDVF4w3EhpeXP9P4D8PqrYYR3fF2fwB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/752] mmc: davinci: fix mmc_add_host order in probe
Date: Wed, 30 Sep 2026 17:19:24 +0200
Message-ID: <20260930152400.202125899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 845604a96bc93..0f72c153e611a 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1305,14 +1305,10 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
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
@@ -1322,6 +1318,10 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 			mmc->caps |= MMC_CAP_SDIO_IRQ;
 	}
 
+	ret = mmc_add_host(mmc);
+	if (ret < 0)
+		goto mmc_add_host_fail;
+
 	rename_region(mem, mmc_hostname(mmc));
 
 	dev_info(mmc_dev(host->mmc), "Using %s, %d-bit mode\n",
@@ -1330,8 +1330,6 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 
 	return 0;
 
-request_irq_fail:
-	mmc_remove_host(mmc);
 mmc_add_host_fail:
 	mmc_davinci_cpufreq_deregister(host);
 cpu_freq_fail:
-- 
2.53.0



