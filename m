Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832F1348C4A;
	Tue, 21 Jul 2026 20:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664254; cv=none; b=HicG+hEoqcptBysKR/LtUG2nKiFNhi/kESyCI16QUQx5t2Tg81HxxV1GQ+iy5AzdNHq+Z49gLseGePvWwnseKJKqU1HYx3ChyUXEzEN/VbfrAh82fr1eCH9MXvVKXl+XydpBpA9D5f30vo9dGZ5Celbr82XlGKBdAvgzdpmp9Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664254; c=relaxed/simple;
	bh=F85yRmB/a8nIQsKJbYDymSpY3gnKxd/3WHhr67tSN+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAH/FMn0DujQPzwmjS4wctnD48Thy1rxtnOaLsQ8Dks1t+chEWqJuNswQAZOa6LQo78hu7ZMsBK7LWE9h5qoQ4KCOZS9UkS/YIl4xh+uMKTku5S/b7XgyzEoLtFWPrH05Ye5HO5hg6MeDoY5Q4HiVGWnclbefgE6SeU3sxwKC9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7I+4Q0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7I+4Q0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E869F1F000E9;
	Tue, 21 Jul 2026 20:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664252;
	bh=SHPUW5W+dPLmINFo4arrG9Ugn0KtuSkJZ7QyVZRn+ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7I+4Q0P5SOemAFeKdeu9dvmi2hkWw7aEQkDnKOlK/0G+JAg1vweMD3QrjhYjUX9k
	 OyfepKX1YFPFsLng8FmebSKgw/2Dbgw7gXmBxY/6nE8AlILabfT37AUzo94rrwxJrZ
	 TU+rZBI+wL9m1Q6Z7CrCHLmkOdgCDPzC3Ycb8rKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 1130/1276] mmc: sdhci-of-dwcmshc: check bus clock enable result in the probe() method
Date: Tue, 21 Jul 2026 17:26:13 +0200
Message-ID: <20260721152511.281002015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -1464,13 +1464,16 @@ static int dwcmshc_probe(struct platform
 			goto free_pltfm;
 
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
 
@@ -1484,7 +1487,7 @@ static int dwcmshc_probe(struct platform
 	if (pltfm_data->init) {
 		err = pltfm_data->init(&pdev->dev, host, priv);
 		if (err)
-			goto err_clk;
+			goto err_bus_clk;
 	}
 
 #ifdef CONFIG_ACPI
@@ -1530,9 +1533,10 @@ err_setup_host:
 err_rpm:
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
+err_bus_clk:
+	clk_disable_unprepare(priv->bus_clk);
 err_clk:
 	clk_disable_unprepare(pltfm_host->clk);
-	clk_disable_unprepare(priv->bus_clk);
 	clk_bulk_disable_unprepare(priv->num_other_clks, priv->other_clks);
 free_pltfm:
 	sdhci_pltfm_free(pdev);


