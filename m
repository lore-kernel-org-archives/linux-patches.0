Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC302E285C;
	Wed, 30 Sep 2026 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794247; cv=none; b=tPYFmnkSAJdn3jtwzTBbb9BiVX02XQRms2m2A1Pthkmx1ABNSPhlWhvZ6w306rLg8RZLgoDH7QdKMBDU8AgTr2cjM6aG73/et6RbCn+B4fgXL7h2Nj5LUeTlqsMxmUA3kFUD/BpGZJRom9hdW9zHe9cPfPQIk65CF9I40SPGMOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794247; c=relaxed/simple;
	bh=ynMe9fqC+kZ9rWhrt6d+22aXKyxEjGnzEsgnWhH5dsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8uzE5eSEeSw3IeIDNHmdFRxC+nTncBdWlBAkXR+tlhkEoUKxZKGQeJAEZZb28yb/D/22UUqlyh789qJsg24Zar3aYlCyZM69v3gvbvAayMYSx2s5TJluyKKKlL8I1NvnJ98oMyHNSVsK/NIMtIKab/fyKSU2FncTrNQ8ZoVJP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyT8bAxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyT8bAxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67FF1F000FF;
	Wed, 30 Sep 2026 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794245;
	bh=12CJy016QmfkZ74vwzMPK36Fqzn/qAQW3HC9ON2tFFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyT8bAxwBbwE10I6QxxRIwDu5KDhHqtT+1yBVxoXwE87fehDFzNXAWjADOu6pcNcy
	 XgYJ4cVok72r/EAmZzud/y78yUVuWghJVw7AHvs4fv6f5hkQl+pmQ3CjlpHi1yR7Ik
	 4d81/vqhry4WW8Lm0X1PsMn5bmLjkGeWwSfwBcpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0141/1193] mmc: davinci: fix mmc_add_host order in probe
Date: Wed, 30 Sep 2026 17:13:45 +0200
Message-ID: <20260930152437.341213430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f0b4c904ad6c1..1751c69e4bf4c 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1302,14 +1302,10 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
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
@@ -1319,6 +1315,10 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 			mmc->caps |= MMC_CAP_SDIO_IRQ;
 	}
 
+	ret = mmc_add_host(mmc);
+	if (ret < 0)
+		goto mmc_add_host_fail;
+
 	rename_region(mem, mmc_hostname(mmc));
 
 	dev_info(mmc_dev(host->mmc), "Using %s, %d-bit mode\n",
@@ -1327,8 +1327,6 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 
 	return 0;
 
-request_irq_fail:
-	mmc_remove_host(mmc);
 mmc_add_host_fail:
 	mmc_davinci_cpufreq_deregister(host);
 cpu_freq_fail:
-- 
2.53.0



