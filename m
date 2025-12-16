Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C5A3590DD;
	Tue, 16 Dec 2025 12:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886647; cv=none; b=ByIHp4SbSSyeoIKVOaOTtVPlll5xPkGmdTgMDgDe1J7eJp4stPwRDgEaDzmjDMhlFy8j/c/Tvpf9LYBAMhRmv4dZTmjiR3e7LUp6i6RlGL8eSp7aEYyfvmMM0tqj9ILeqXkU7arYpw1a+8m0xgHaXwL1VTbvxez/pG+9iyfbC0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886647; c=relaxed/simple;
	bh=JO7zsLOhxUikjp4pyfvdEXbZPiUq8qlithjXrYipqVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIgLyIV6l87yAYJNFnjRAXJU0sOI0rqrfKms9ReljPbt+nCj43DWit9nZ4AdMYYfHT/gniCeHEczp/izfXIHavVWC+kjxl2ky8eW1xViX41jxqxZTOIp4M7YHyVYM6jzMnekg7xqaJ7jlUjQha84cietXJJj9J47IWBgMIEgLyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dx1K+b++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dx1K+b++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41751C16AAE;
	Tue, 16 Dec 2025 12:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886646;
	bh=JO7zsLOhxUikjp4pyfvdEXbZPiUq8qlithjXrYipqVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dx1K+b++nrz1kBKMhWMgCauDI8hZMzJGUIoKfNTbqKfs7esxSN2T64GOQbj2Q4Tmc
	 FPyAgDbJWzy7ryT93GgAClTKeezLpQ34eBeqOMXKiZdxvGsIcCzRsJfZnCI8yjDKk7
	 2xHg1mtLpz4pIpPTfdWzR+0BK3HwApQBD10xX/js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <diederik@cknow-tech.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 465/507] regulator: fixed: Rely on the core freeing the enable GPIO
Date: Tue, 16 Dec 2025 12:15:06 +0100
Message-ID: <20251216111402.292250232@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 79a45ddcdbba330f5139c7c7ff7042d69cf147b2 ]

In order to simplify ownership rules for enable GPIOs supplied by drivers
regulator_register() always takes ownership of them, even if it ends up
failing for some other reason. We therefore should not free the GPIO if
registration fails but just let the core worry about things.

Fixes: 636f4618b1cd (regulator: fixed: fix GPIO descriptor leak on register failure)
Reported-by: Diederik de Haas <diederik@cknow-tech.com>
Closes: https://lore.kernel.org/r/DEPEYUF5BRGY.UKFBWRRE8HNP@cknow-tech.com
Tested-by: Diederik de Haas <diederik@cknow-tech.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20251204-regulator-fixed-fix-gpiod-leak-v1-1-48efea5b82c2@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index a2d16e9abfb58..254c0a8a45559 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -330,13 +330,10 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 
 	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
 					       &cfg);
-	if (IS_ERR(drvdata->dev)) {
-		ret = dev_err_probe(&pdev->dev, PTR_ERR(drvdata->dev),
-				    "Failed to register regulator: %ld\n",
-				    PTR_ERR(drvdata->dev));
-		gpiod_put(cfg.ena_gpiod);
-		return ret;
-	}
+	if (IS_ERR(drvdata->dev))
+		return dev_err_probe(&pdev->dev, PTR_ERR(drvdata->dev),
+				     "Failed to register regulator: %ld\n",
+				     PTR_ERR(drvdata->dev));
 
 	platform_set_drvdata(pdev, drvdata);
 
-- 
2.51.0



