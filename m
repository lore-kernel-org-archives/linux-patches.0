Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3818F1D4141;
	Tue,  8 Oct 2024 12:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390834; cv=none; b=SlhJKrqsWJgsnfF199yJxPWSQIGubgeB2480QbW9Wyt0cF0ku2P8EXfnFY3JQocyIJbh/L19eC6ybI81z8yORr1QEgmI2uMMX6gBaju63SN4P3jzJP2VOrVtsQDFkOZXwxkeaZ3FLi90AAC1orgQ3pPJYLmRuM7jL0p3GaacRnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390834; c=relaxed/simple;
	bh=E9EARz8SzA+k4cIhPiZApRVt5kdqp5yD8jNP+fRddFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZs0+8wC7GRZWspvbjZmGRNbzihtwAb3xGQXTIpNJf4WTNeHE8AIYFb5F7GkIKFNzPeyl5mcKGIs9RTVRVPXSA+PFg0rfyO2+xnqTX7zrKaQ/zqnGENeM+wjSKBb1PUx9+2U/9zF+DV1BoCpWaD/3SLbW/Q1n8KRyos3X+baWx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+OD2fLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+OD2fLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7971C4CEC7;
	Tue,  8 Oct 2024 12:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390834;
	bh=E9EARz8SzA+k4cIhPiZApRVt5kdqp5yD8jNP+fRddFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+OD2fLCtOyYpp4KfQEc77Qf3d9QZA3zB/z8UNj3AsRUjUkoGimXHiObLqgIMNceH
	 fo9Ioei9xCDGmCZMxfYwq4vaF13CaymJSosMb9lsdXW1nCcy7Z8kkgqkTntIFkzdBr
	 EqPa9Izt4O4OSUoxzP4byDCMqD4jiSFATHpHpI/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.10 408/482] rtc: at91sam9: fix OF node leak in probe() error path
Date: Tue,  8 Oct 2024 14:07:51 +0200
Message-ID: <20241008115704.465340202@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 73580e2ee6adfb40276bd420da3bb1abae204e10 upstream.

Driver is leaking an OF node reference obtained from
of_parse_phandle_with_fixed_args().

Fixes: 43e112bb3dea ("rtc: at91sam9: make use of syscon/regmap to access GPBR registers")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240825183103.102904-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-at91sam9.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -368,6 +368,7 @@ static int at91_rtc_probe(struct platfor
 		return ret;
 
 	rtc->gpbr = syscon_node_to_regmap(args.np);
+	of_node_put(args.np);
 	rtc->gpbr_offset = args.args[0];
 	if (IS_ERR(rtc->gpbr)) {
 		dev_err(&pdev->dev, "failed to retrieve gpbr regmap, aborting.\n");


