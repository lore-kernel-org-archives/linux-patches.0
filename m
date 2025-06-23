Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E92224BBE4;
	Mon, 23 Jun 2025 13:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684507; cv=none; b=YmAvGNy6HFS7qr7Y4k7txcAOI2qj8HozDc3gEU/ZkZSBItoEVGdoY9Kf3SzOox+FbjhGyrl+swpQX6Q+ljiJ9TDaEHEeCaplvucK+lCkam5L76P5jJAvllQLYN5YvlqwLf0bisS6iaK5wZmKMzwENJ5aD0+2qjRjQnPNkf9XV1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684507; c=relaxed/simple;
	bh=p5WWBJfpduQ5Ns9tyXId9mVWsUktYKyOjhaDAweuMhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebSuLsMk59CjRsl8fta8nBCyQsTQVQVO4cG5EBy4nAKuPKo/1Lpt3K5A7zhgLkUgHPJJ4QLrNZ4wkYHuD7ztnxIhjfj7BD+SOxvhT8c94DtMkMPiETaSEZLyist4DOKuEJ8xMIA4mSG9FQqT7uEwJfeevd5OJOIueBzb6CFzm8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yowfHEp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yowfHEp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04C3C4CEEA;
	Mon, 23 Jun 2025 13:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684507;
	bh=p5WWBJfpduQ5Ns9tyXId9mVWsUktYKyOjhaDAweuMhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yowfHEp/FP+lDw8cVswSyBidycXrpLdifd8ymmh55et7FCcTfpB2Ch5nl057xCv0H
	 DNmhjEp1chjmp9+pM86fh3lLppJhEUrq91M6Pw9/cSUNohn5cSLlmw918fhTPMgJLe
	 5vPl6eWfwq9Xjh3XC2wUtq2qb+E1NnAX15Qpbgew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.15 095/592] ASoC: codecs: wcd9375: Fix double free of regulator supplies
Date: Mon, 23 Jun 2025 15:00:53 +0200
Message-ID: <20250623130702.537993331@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 63fe298652d4eda07d738bfcbbc59d1343a675ef upstream.

Driver gets regulator supplies in probe path with
devm_regulator_bulk_get(), so should not call regulator_bulk_free() in
error and remove paths to avoid double free.

Fixes: 216d04139a6d ("ASoC: codecs: wcd937x: Remove separate handling for vdd-buck supply")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250526-b4-b4-asoc-wcd9395-vdd-px-fixes-v1-3-0b8a2993b7d3@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd937x.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -2945,10 +2945,8 @@ static int wcd937x_probe(struct platform
 		return dev_err_probe(dev, ret, "Failed to get supplies\n");
 
 	ret = regulator_bulk_enable(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
-	if (ret) {
-		regulator_bulk_free(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
+	if (ret)
 		return dev_err_probe(dev, ret, "Failed to enable supplies\n");
-	}
 
 	wcd937x_dt_parse_micbias_info(dev, wcd937x);
 
@@ -2984,7 +2982,6 @@ static int wcd937x_probe(struct platform
 
 err_disable_regulators:
 	regulator_bulk_disable(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
-	regulator_bulk_free(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
 
 	return ret;
 }
@@ -3001,7 +2998,6 @@ static void wcd937x_remove(struct platfo
 	pm_runtime_dont_use_autosuspend(dev);
 
 	regulator_bulk_disable(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
-	regulator_bulk_free(WCD937X_MAX_BULK_SUPPLY, wcd937x->supplies);
 }
 
 #if defined(CONFIG_OF)


