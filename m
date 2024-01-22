Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A275025C;
	Tue, 23 Jan 2024 01:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974730; cv=none; b=rg8WG+6PJq4pYh2cAJl8TynVDiG2Jg4CWP5RTMror9eFTCiQc8VHTWodHg4QKkZ/1UjIZsaRYyVbAgPrVSm5acECYCYNUp9lLaagSu4CH4Y/qZgkVL2wU1LtBY2Dmp3e1uCNH4GJtueX2kc6qk2INhfUH/75rZajrjnwUUP8yfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974730; c=relaxed/simple;
	bh=SM2FJC7LXdgWu7oleTk/yOU8/KGdQz1mczlOKywJoE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cKOtdKAs9EUrnY4ENkEYxjWzvkOMo4xhgk2KA8mcmEAeq/vTReq77gMQjyjrRgsLk7+MuF5HSYRtT65xDQooy6VWAddO0UOmW0De6AwCccAU0nKAcFUcy5zkjPiNUl6dPL0nv1u8Q2OVS99OAiN3jFlatDBhqm1gaVafO5bruPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ChGveJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ChGveJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F417C433C7;
	Tue, 23 Jan 2024 01:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974730;
	bh=SM2FJC7LXdgWu7oleTk/yOU8/KGdQz1mczlOKywJoE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ChGveJDaWe06U21heu73r4WpT/iKd2gnayUJHdiNi42A+AWVFxT47C/ps7CdnJMa
	 GfC8EYg0PtFRusGPn6gVywJ45i5d5UFj7DJDXHXhDiGRFTezjZ9oLFCcFDD6NFVIui
	 sSnXHKTXcgLlmWQdPnRat42fgL0CpeOGTHI8JMbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 5.15 271/374] pwm: jz4740: Dont use dev_err_probe() in .request()
Date: Mon, 22 Jan 2024 15:58:47 -0800
Message-ID: <20240122235754.194481678@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 9320fc509b87b4d795fb37112931e2f4f8b5c55f upstream.

dev_err_probe() is only supposed to be used in probe functions. While it
probably doesn't hurt, both the EPROBE_DEFER handling and calling
device_set_deferred_probe_reason() are conceptually wrong in the request
callback. So replace the call by dev_err() and a separate return
statement.

This effectively reverts commit c0bfe9606e03 ("pwm: jz4740: Simplify
with dev_err_probe()").

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240106141302.1253365-2-u.kleine-koenig@pengutronix.de
Fixes: c0bfe9606e03 ("pwm: jz4740: Simplify with dev_err_probe()")
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-jz4740.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -60,9 +60,10 @@ static int jz4740_pwm_request(struct pwm
 	snprintf(name, sizeof(name), "timer%u", pwm->hwpwm);
 
 	clk = clk_get(chip->dev, name);
-	if (IS_ERR(clk))
-		return dev_err_probe(chip->dev, PTR_ERR(clk),
-				     "Failed to get clock\n");
+	if (IS_ERR(clk)) {
+		dev_err(chip->dev, "error %pe: Failed to get clock\n", clk);
+		return PTR_ERR(clk);
+	}
 
 	err = clk_prepare_enable(clk);
 	if (err < 0) {


