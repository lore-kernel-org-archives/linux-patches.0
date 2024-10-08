Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38181DE4CD;
	Tue,  8 Oct 2024 13:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392746; cv=none; b=Extam6fBxdtg4qQ7GGVaFlZPOCUR8b+wIkCy8XuIIGRMNL0t5oO7wD3uJSeH+84uTwXwLw1YEAeUILqZwLzgvREDwm9Nb8om6Hpz0steWkN1yez8NXvQNO0QlH8FDkixZxlE8EaNFoKZlDYJ1NCtSCchWDV3gIs14bAR+3xbwq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392746; c=relaxed/simple;
	bh=ZWgyS9HVX4I8XwE/Z7LTC5dTNEFG2Ia6r4p/AiQbFXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DydOiMH/qlGSPOvUInZw7kNClXAf+OYg7jTp3QMgHo1NcAdJu+d2smYqRRhS4FT/NY+pS5ghNTnWHSj/Bvhdh1ZFjXgSKX4h/sNA1Z19swiPtb1V37pdumTLClW6HvW6ZE/rLOTWGYFn7Z3PDQxvcVQNpbobO66ZCb411VQpspA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arxjsw1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arxjsw1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6588AC4CEC7;
	Tue,  8 Oct 2024 13:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392745;
	bh=ZWgyS9HVX4I8XwE/Z7LTC5dTNEFG2Ia6r4p/AiQbFXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arxjsw1JO+5MpZdwiyHNDFBJFtM001AmZJalcBifu+Tg7nOJAN+MNiHw7JAaNX4CD
	 FYGXYvMElmNtKdn3B5xSRT9V5LlaaOywj1Fmjo7hn0Pt8nZnuI20JSQJRUmiTi5XSy
	 3B2BM7Nv+d2Kj8jAprElkekLmDX1rpmrHHonH5Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.11 479/558] rtc: at91sam9: fix OF node leak in probe() error path
Date: Tue,  8 Oct 2024 14:08:29 +0200
Message-ID: <20241008115721.087802019@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


