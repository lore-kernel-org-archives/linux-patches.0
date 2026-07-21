Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16B947127A;
	Tue, 21 Jul 2026 18:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659403; cv=none; b=ZIAAN2nmqdSlI5uyGWtUbwECfh4Q88CzGzyG3jFeknlRwhi0klMfsJ91sJk4AYrrV8hXIonzS2UTkYcGYWb0ZAbS15CXvcahLpdSk/Ais5JCqlDUIa2xosLZ/gAW5PxRJXJMljr1I4suq2Rq55ElHHeQAa73Tp/WQfsCp36Ryxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659403; c=relaxed/simple;
	bh=j5kiJ8hqUa2bRTJm7iMdFahLLobENnfd9C+V8vbGEBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpTodMuqSm7X5GZwnxcNdSEMzbryT2ok5/L732Zbd4vRmV5eNJVr4ZV2CuhOoPPVVgjJD/1WgIjHl4VEweJnmG/LVXMQq4b6TrluFANu0ycLVyRNdk0wgrQoO6gyXL1FOmcvyZUGk7AkG/1l7ipAwjL3LHUMDi7VL4r52CkUVCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxTgQQNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxTgQQNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC411F00A3A;
	Tue, 21 Jul 2026 18:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659401;
	bh=+WhfI0S+s7X9LNkHoa4T+4NzEtEO+VwHJpZDKLWDbiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxTgQQNCzrDvIpgD1yplPCIqbGi0BEtB6IVz6D6unI53rzq0tyU65jzQkuA1hWYrU
	 3HWQss8yTtq5qLXuhaEXH/SaDm4WZB5XP6TPVpWo1LyyI8BYEJOWu0lTXdIK6L9yP4
	 AwQJscgHQIryhTXxcOU1QknbT0XBOQIrDamKwmEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 1507/1611] mmc: sdhci-of-dwcmshc: check bus clock enable result in the probe() method
Date: Tue, 21 Jul 2026 17:27:03 +0200
Message-ID: <20260721152549.337351758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@auroraos.dev>

commit 521f39ca93cc43ce1b3eae8d44201f8f55dd9151 upstream.

In the driver's probe() method, clk_disable_unprepare() for the bus clock
is called on the error path even if the prior clk_prepare_enable() call has
failed (and the same thing happens in the remove() method as well) -- that
would cause the prepare/enable counter imbalance.  Also, the same problem
can happen in the driver's suspend() method; note that the resume() method
does check the clk_prepare_enable()'s result -- let's be consistent and do
that in probe() method as well.  BTW, I don't know for sure what does the
bus clock control -- if it affects the register accesses, the driver will
likely cause (e.g. on ARM) a kernel oops if it fails to prepare/enable the
bus clock in the probe() method...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: e438cf49b305 ("mmc: sdhci-of-dwcmshc: add SDHCI OF Synopsys DWC MSHC driver")
Fixes: bccce2ec7790 ("mmc: sdhci-of-dwcmshc: add suspend/resume support")
Signed-off-by: Sergey Shtylyov <s.shtylyov@auroraos.dev>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -1421,13 +1421,16 @@ static int dwcmshc_probe(struct platform
 			return err;
 
 		priv->bus_clk = devm_clk_get(dev, "bus");
-		if (!IS_ERR(priv->bus_clk))
-			clk_prepare_enable(priv->bus_clk);
+		if (!IS_ERR(priv->bus_clk)) {
+			err = clk_prepare_enable(priv->bus_clk);
+			if (err)
+				goto err_clk;
+		}
 	}
 
 	err = mmc_of_parse(host->mmc);
 	if (err)
-		goto err_clk;
+		goto err_bus_clk;
 
 	sdhci_get_of_property(pdev);
 
@@ -1441,7 +1444,7 @@ static int dwcmshc_probe(struct platform
 	if (pltfm_data->init) {
 		err = pltfm_data->init(&pdev->dev, host, priv);
 		if (err)
-			goto err_clk;
+			goto err_bus_clk;
 	}
 
 #ifdef CONFIG_ACPI
@@ -1487,9 +1490,10 @@ err_setup_host:
 err_rpm:
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
+err_bus_clk:
+	clk_disable_unprepare(priv->bus_clk);
 err_clk:
 	clk_disable_unprepare(pltfm_host->clk);
-	clk_disable_unprepare(priv->bus_clk);
 	clk_bulk_disable_unprepare(priv->num_other_clks, priv->other_clks);
 	return err;
 }


