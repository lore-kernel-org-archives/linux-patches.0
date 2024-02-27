Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8E313AA2F;
	Tue, 27 Feb 2024 13:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041666; cv=none; b=RK+B6jHo2dbsnXGFrRoRRrtWPOji5/aTtaumI0il42uH3STpg21zXb+EelO1lmbC/R80lSI6mx4SeSH3AXbR4bhhN6+k0/+JBlFEXsGAnV93W10s3RqGCp2NP4kG84m8QR80Fd/VcHWIdNQ4elYcLg6LpKd+bNkNpfG7nXtul1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041666; c=relaxed/simple;
	bh=p/aCfYLb+hAJ3ndx1gFNY3P8c0nul8jLaskZ+/3Op+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A94aT2lmcptM79N/jR9q+kOCTT2Zma0Ezbwio4PXvnC5hXo3oa0dEW5tqGuVonNkoK9Wa7qBbkQzkd4Mpyvhlhpzc5u9lZhrKKgit1qh4vejgO1vOOifc27caaHZfpJZnkeF14B3PzEhz5I/qZWvJ8cnTaF1KmgAAJxWXaGkgTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6fDhOPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6fDhOPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AD7C433C7;
	Tue, 27 Feb 2024 13:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041665;
	bh=p/aCfYLb+hAJ3ndx1gFNY3P8c0nul8jLaskZ+/3Op+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6fDhOPHVJ10C06sos5oYtvBegR1gz0ORLaUKk57cuT11fTVJIc1e0Le5ArJyXsRe
	 i4HqSnWYWGIWcGhheJLYC5YI6UqsPx8KFvgiFzdWdmPIs9JHlRrAB/O42JtwxzgLR7
	 5apllbl4KyW+M+SvQJc/78Zc9WxymsMQ4WiZvS/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/299] spi: cs42l43: Handle error from devm_pm_runtime_enable
Date: Tue, 27 Feb 2024 14:22:19 +0100
Message-ID: <20240227131626.732903169@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit f9f4b0c6425eb9ffd9bf62b8b8143e786b6ba695 ]

As it devm_pm_runtime_enable can fail due to memory allocations, it is
best to handle the error.

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://msgid.link/r/20240124174101.2270249-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cs42l43.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cs42l43.c b/drivers/spi/spi-cs42l43.c
index d239fc5a49ccc..c1556b6529092 100644
--- a/drivers/spi/spi-cs42l43.c
+++ b/drivers/spi/spi-cs42l43.c
@@ -244,7 +244,10 @@ static int cs42l43_spi_probe(struct platform_device *pdev)
 	priv->ctlr->use_gpio_descriptors = true;
 	priv->ctlr->auto_runtime_pm = true;
 
-	devm_pm_runtime_enable(priv->dev);
+	ret = devm_pm_runtime_enable(priv->dev);
+	if (ret)
+		return ret;
+
 	pm_runtime_idle(priv->dev);
 
 	regmap_write(priv->regmap, CS42L43_TRAN_CONFIG6, CS42L43_FIFO_SIZE - 1);
-- 
2.43.0



