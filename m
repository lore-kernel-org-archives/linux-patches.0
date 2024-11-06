Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177011F669B;
	Wed,  6 Nov 2024 13:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898648; cv=none; b=kZ6SXV1V26lK6of732rYasjiHss/6IWTIUp2Tp3b419b5BqmQK5wJOwcFDl2uV7Lg3XIht/QtdvAO3+hTmxA4SjwEv+UabYMEDbWRpU+dUqYBJCdOzxuBQV+5+GVKmEdhBvG/PEsbQpqdTdIBj45uo3OH2WR+0O6q7/GyM/cT1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898648; c=relaxed/simple;
	bh=KFruHAUdwx61h2t5jShzobR5CJcleCkTc8VeltVXclM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUL1hqTrlmQPvx9AmHhWoWlmOGZnilxo+U5BgtOBpHIqfuuAB2/yWD8DKjBpJNkYv52SYRPFZKhPeQ7CPUzrq56Xat3esCbyhO3c0du3fbbeNRcizOl1xDmIbBo4luPeX2s2sKMP5/t56ZuHB7W8Jkf0BQ233wcR9BiEHAzlSUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIEQbBBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIEQbBBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9068DC4CECD;
	Wed,  6 Nov 2024 13:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898648;
	bh=KFruHAUdwx61h2t5jShzobR5CJcleCkTc8VeltVXclM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIEQbBBLZWJgIvAgAEJ+1hzJC1LUqbSFcIUgg2TzDSBPtczRDzbpmcIAuoFftqPDJ
	 C7EePSsFF0XDF3tVX7OHFgzNwlh8GcquReUjekRXdHrDrw1yR5ulGWO++FMvD+zlDM
	 AygBJqPKNJQKyNe1ymEsEBX1v2YYtzM3LaUsCO84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 273/462] rtc: at91sam9: fix OF node leak in probe() error path
Date: Wed,  6 Nov 2024 13:02:46 +0100
Message-ID: <20241106120338.269993897@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -370,6 +370,7 @@ static int at91_rtc_probe(struct platfor
 		return ret;
 
 	rtc->gpbr = syscon_node_to_regmap(args.np);
+	of_node_put(args.np);
 	rtc->gpbr_offset = args.args[0];
 	if (IS_ERR(rtc->gpbr)) {
 		dev_err(&pdev->dev, "failed to retrieve gpbr regmap, aborting.\n");


