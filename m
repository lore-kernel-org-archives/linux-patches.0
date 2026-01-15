Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C393D331E;
	Thu, 15 Jan 2026 17:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499943; cv=none; b=QBewSGaWd0guHyOPyJBuUZ6306eOkpkhwto7yUpCWAdsV2ACJGK0sBglZZkNv4Bz44erGwQtyrEItqd0gB+o9JBTIRxulG7Fqisl4zbjjTvhMzzQVNNNQYK20EE/RG/B4r/yBig4REtoONZo/c+pFWsFCLLGy2Wo0NYMSQlbRIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499943; c=relaxed/simple;
	bh=82UouV3pQktZ+gf6P5HtYzCyNAOzYFDu87YwX+qdkEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RdCQydrrRhP5OrWR9GATH+obzasHvdIpH/yHH/vSJIlJLmhe6wp0MaiVXDnhrLmSDu2uXiBR7TBeeE4u4i+Id6elbzastcbiZRJ8v4ru/wve743PMN27nJIhbBYpy5snB2kqS+nayvQB1KHvx4G06tUGIRN2rdVVJ2xJNqR7U0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aV171TU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aV171TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66328C116D0;
	Thu, 15 Jan 2026 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499943;
	bh=82UouV3pQktZ+gf6P5HtYzCyNAOzYFDu87YwX+qdkEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aV171TUKMi2TP4phJtapp/qu0UH112G0P+T5SczguBUsHBP4A+RFdzX66/KK2Is2
	 0ijP//KceTP5rHjPIHMfN6iWPrmcCZ6kvwqha5Sh3DE15tPP3l1/Z5qWUCxRy6AKBG
	 /oZ+CKAu4LeuUA3+TfOP1xtWmOetnul8neFhz6Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Pavel Machek <pavel@ucw.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 403/451] leds: lp50xx: Remove duplicated error reporting in .remove()
Date: Thu, 15 Jan 2026 17:50:04 +0100
Message-ID: <20260115164245.517898048@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 73bce575ed90c752eaa4b2b9a70860481d58d240 ]

Returning an error value from an i2c remove callback results in an error
message being emitted by the i2c core, but otherwise it doesn't make a
difference. The device goes away anyhow and the devm cleanups are
called.

As stk3310_set_state() already emits an error message on failure and the
additional error message by the i2c core doesn't add any useful
information, don't pass the error value up the stack. Instead continue
to clean up and return 0.

This patch is a preparation for making i2c remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Stable-dep-of: 434959618c47 ("leds: leds-lp50xx: Enable chip before any communication")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp50xx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -582,10 +582,8 @@ static int lp50xx_remove(struct i2c_clie
 	int ret;
 
 	ret = lp50xx_enable_disable(led, 0);
-	if (ret) {
+	if (ret)
 		dev_err(led->dev, "Failed to disable chip\n");
-		return ret;
-	}
 
 	if (led->regulator) {
 		ret = regulator_disable(led->regulator);


