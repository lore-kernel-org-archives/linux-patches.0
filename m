Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC394FD265;
	Thu, 17 Sep 2026 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667722; cv=none; b=sp57vt9ZLnhsUds+8Kw0ykCn5ve3ZKDDSfcgYRyywOSpH5En9qBysxMaLxUiqOhBJl/0aZ03vSDmc2f/mo24kC7XTGILwJEO1q01V15pKbj+Ulhb0vERuQ/GoIFpJeMAuV2RCtnDcTSWRj5V5CFWpmJ1gNvAHL2gvYGtCkdKOx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667722; c=relaxed/simple;
	bh=ogbn59V8FUQvPiQSxrAUi+Gv1q3fMGCw/rdgAheEeFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpXC4K5AfcfUH+5ziuf26JunB04VPhgDEE9t/w5B+Pl57TSxbvIJ5tVYISGnZe9bYvJ7Vj1vkmAuW69lirBsZbnzRbjf9JQQlhklUXfmWK/fwGyY1ZUek1ZfZk4388+Fw0R8nUs6dGy9oNB48tF0K+cYDNpDNt/EBpcGi4afSqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrXqnCkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrXqnCkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7371F000FF;
	Thu, 17 Sep 2026 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667721;
	bh=lNTJsRiSap2bTIeiKC4az53PfabvNnFLip8D1bmSzUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrXqnCkMRdr5QuPUF39+J9E7zfjUTwiu5sGmSFRE03l3APeGI9nrZSdCZOjE0cWT/
	 iZZY7MPvVBTfFc/vTn4e9SPervlsYrwUUuOja5S2B8fO+Am6q/RYL/pX/k5WjXXhm5
	 VeeFnQk49qDyxi7cw6TQUix4RdWXDWZ0YWVWk6ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0187/1102] mmc: davinci: fix mmc_add_host order in probe
Date: Thu, 17 Sep 2026 16:02:10 +0100
Message-ID: <20260917151544.258722711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 48f85c0aca207..8adee047aa666 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1298,14 +1298,10 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
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
@@ -1315,6 +1311,10 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 			mmc->caps |= MMC_CAP_SDIO_IRQ;
 	}
 
+	ret = mmc_add_host(mmc);
+	if (ret < 0)
+		goto mmc_add_host_fail;
+
 	rename_region(mem, mmc_hostname(mmc));
 
 	if (mmc->caps & MMC_CAP_8_BIT_DATA)
@@ -1328,8 +1328,6 @@ static int davinci_mmcsd_probe(struct platform_device *pdev)
 
 	return 0;
 
-request_irq_fail:
-	mmc_remove_host(mmc);
 mmc_add_host_fail:
 	mmc_davinci_cpufreq_deregister(host);
 cpu_freq_fail:
-- 
2.53.0



