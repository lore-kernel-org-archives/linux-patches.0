Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C171798C;
	Mon, 14 Oct 2024 15:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919471; cv=none; b=JFnK8A0KNXto+q/tMIuHWBIEdVcNYa9gYmFQis+7CPBTsQG5AZmq7hyyQ7f6TGpYKfw+AOqrGhQdbhFnA6F9jTc9VaUa4ZT4VybBqOIo81mz20zkAQDfEWBIGVitGfAsOXD6yQrSh+R1tAX0e28LEayJU05l/tPcLBkKLLDKpm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919471; c=relaxed/simple;
	bh=LKay1aRuaE/u5eF/ZqkLguD3fSpLdtPkXCwgVGG99z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTSKE4QO552JIdlxJxkaJTGQSwMKTuNNHBdWxLmQT46EyBUW+bsJA+pyYPKqRWdW+/m/783dw1ujQbdRAp55wrZoflpmRAIOv12flMUwld/I/P5yAmIy7Aj7X2vEwAnH8N530GsXp9E9ck3kzpijfmWDckCEBhHm8fiY8/VEygA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaMO0mH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaMO0mH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F777C4CECF;
	Mon, 14 Oct 2024 15:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919471;
	bh=LKay1aRuaE/u5eF/ZqkLguD3fSpLdtPkXCwgVGG99z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaMO0mH2gm10wUWUztwx5MtQEG3gsTLEGM+0qP6ybJX1hh3olkTQu+swZDawunanR
	 MJDEFMB/NlWZesP+E+9qcVZIdMHeY1W0Jk2SsX0gRHGqHEtb5XM+qqqlL/qX9a1/ks
	 4vrSx5rSkns0OFbgwjiBdbbRq/roNXP8GL52CHiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 598/798] rtc: at91sam9: fix OF node leak in probe() error path
Date: Mon, 14 Oct 2024 16:19:12 +0200
Message-ID: <20241014141241.497482215@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


