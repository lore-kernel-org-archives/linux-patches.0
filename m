Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23BE1DED58;
	Wed,  6 Nov 2024 12:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895454; cv=none; b=rE6dCHnZZ6jvktwzUZLrOFFP291i7CHFrcARe169vkhKPjku+2RXdX3DPfyklmYzesE1IykWYdjIzgG/nKrP+HbRlR83dxXF/ngjLIYc3D+klRrSA2X4njmycvp3gHPhbfA/O2ptBWWkyhwlzFvkWlbgB2h/9sAMEfeL/OsLQSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895454; c=relaxed/simple;
	bh=gXxxpkYm18NJ1xC4sFbtKdcE08DOPPlGuLvY7Ib0MMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRDL8FaMfY6g5AsYGWOZkQDQcU/iJvz7vTAIkfOhVhRKorPfgTihq7kdjgt9RzmWf3Qbc0rwd+gaMkeNLLQrlARQt5jPkdZCgQiCzev76yUjKgl/jwOj9UuZk9+yvJPuvKdBeT8riUWQjrM/Z7xdfIFyHq8phw3EbQc4Y0UaJts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiXK0jrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiXK0jrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D8BC4CECD;
	Wed,  6 Nov 2024 12:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895453;
	bh=gXxxpkYm18NJ1xC4sFbtKdcE08DOPPlGuLvY7Ib0MMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiXK0jrsLFkJB5o7PjJ9a+PHYWzYDk9JiTxWsT7M5Y/1ZNqK2QPofLL5vuK+qa6Gs
	 CSXTpzDfvgjbkGx8/gnmS2bhjjHrKrJLJRkPsigKKM7O5sOsVzLUZ5p5EPuX+Av12e
	 N6Id+3HIr63WgebPy9/b/E5pD9fMbdJU64i2QAyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 224/350] rtc: at91sam9: fix OF node leak in probe() error path
Date: Wed,  6 Nov 2024 13:02:32 +0100
Message-ID: <20241106120326.529063849@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 73580e2ee6adfb40276bd420da3bb1abae204e10 ]

Driver is leaking an OF node reference obtained from
of_parse_phandle_with_fixed_args().

Fixes: 43e112bb3dea ("rtc: at91sam9: make use of syscon/regmap to access GPBR registers")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240825183103.102904-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-at91sam9.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 1c8bdf77f6edd..4672dde68c782 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -391,6 +391,7 @@ static int at91_rtc_probe(struct platform_device *pdev)
 		return ret;
 
 	rtc->gpbr = syscon_node_to_regmap(args.np);
+	of_node_put(args.np);
 	rtc->gpbr_offset = args.args[0];
 	if (IS_ERR(rtc->gpbr)) {
 		dev_err(&pdev->dev, "failed to retrieve gpbr regmap, aborting.\n");
-- 
2.43.0



