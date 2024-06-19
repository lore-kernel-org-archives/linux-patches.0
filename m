Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA09C143C4E;
	Wed, 19 Jun 2024 13:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802479; cv=none; b=hTP4/VWna/KTuUQJY28xdkFK3GAB/NjwLdYeoz3NcujIroc4YUOVmnuFNaOlEDxc4XPj0Y8wCLP01O+ctDD5Xr+hQ+RMQwhrMP/XcanmU4+9rvELjywpQHudNLkuOEoqN51HlYWtlPX5YEp1kbZn709UNZoW7guwejEQKLscpBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802479; c=relaxed/simple;
	bh=XXx0oJcVK3PmEmjj/mG4ft8ZgNB/c4Rsq0EeuX0PZ9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNTfM+ITrI4siTXT0N8E1fpwH/RN/vqOenwdFqBdLxGuLdnrcAkUGtA3M+HqV8Qqgk1RLP6u0bNGpRbf9dGKYR12V9k5DFPIsPelXutRoFqTWGJoUDyCPMOWKFW7v77OHHjC4aVBEujXe2zWzBSk5Gcuq7C5laAQ1pMdRuaRfNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1bzttWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1bzttWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F8AC2BBFC;
	Wed, 19 Jun 2024 13:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802479;
	bh=XXx0oJcVK3PmEmjj/mG4ft8ZgNB/c4Rsq0EeuX0PZ9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1bzttWMEogMrGMx8MMQ64XHOwWlm5Ox4J5srgstZS5RiUz/UZXMTHUFxsbTHOHEO
	 UUu34lLx6LB2HZa1nOea+76Oah7OdLRbE6KmpslqC25HXRY8HhmSi8M2B2OzMexSEn
	 kZg2hrpPDXl3/WviXgo2472fFCZabDiyusFCQS5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 210/267] iio: adc: axi-adc: make sure AXI clock is enabled
Date: Wed, 19 Jun 2024 14:56:01 +0200
Message-ID: <20240619125614.388208842@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Nuno Sa <nuno.sa@analog.com>

commit 80721776c5af6f6dce7d84ba8df063957aa425a2 upstream.

We can only access the IP core registers if the bus clock is enabled. As
such we need to get and enable it and not rely on anyone else to do it.

Note this clock is a very fundamental one that is typically enabled
pretty early during boot. Independently of that, we should really rely on
it to be enabled.

Fixes: ef04070692a2 ("iio: adc: adi-axi-adc: add support for AXI ADC IP core")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240426-ad9467-new-features-v2-4-6361fc3ba1cc@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/adi-axi-adc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -175,6 +175,7 @@ static int adi_axi_adc_probe(struct plat
 	struct adi_axi_adc_state *st;
 	void __iomem *base;
 	unsigned int ver;
+	struct clk *clk;
 	int ret;
 
 	st = devm_kzalloc(&pdev->dev, sizeof(*st), GFP_KERNEL);
@@ -195,6 +196,10 @@ static int adi_axi_adc_probe(struct plat
 	if (!expected_ver)
 		return -ENODEV;
 
+	clk = devm_clk_get_enabled(&pdev->dev, NULL);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
 	/*
 	 * Force disable the core. Up to the frontend to enable us. And we can
 	 * still read/write registers...


