Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FE1745D6;
	Tue, 23 Jan 2024 02:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975449; cv=none; b=Vy3vqTBHTlk+CFOCX2HhBSdvt1jUxmzmv5pX8GiAeNdzO3xB0CmFy5dbNLDeGhvtaTHn525XTBAIgdmHzk0YztM3iEFTqqvVRiAagpCfWW0smJv0znkGHPY28mXE8yk2bCGoN+ICpuwNvRA2b7y1ZB8qqrUCDs5G9IRtxHGe6CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975449; c=relaxed/simple;
	bh=2/gvAl3UEdzOPzk4WWVliygXXOZiW19hFI08S2xRjTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EmdDubRUL0QtMVrkB0nlbPSqkvYjEUgaeHYHqVdkAIcbuEFHuCVdYlmWplWhwM3+Cr+421+QQVPMSULOXld50v9zqrGcWU9oY3ZtmIeDYvAju2RTDSB9sQA7FgJttND+kX7IycTuvFGRUjVobPOj8qiTNeEtlP5/XLZjPk50rgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ld2lySJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ld2lySJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2595CC433F1;
	Tue, 23 Jan 2024 02:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975449;
	bh=2/gvAl3UEdzOPzk4WWVliygXXOZiW19hFI08S2xRjTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ld2lySJ0qx/pzIPMGvLPQXhJ9oY4nv10KPWSLPmfAc9n/NTtH6Cfb1oG1a21wBiml
	 5n3mnCLoJXdbkNXMWHD7dPrXcPO6OPeV6Ek6Xm92cVmbPHQrwE/VIQ2JHqnmQJL5+9
	 01efVcpbPAWKfalHme6+fv4UUdCN6zLt8vbq/5jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 6.6 405/583] pwm: jz4740: Dont use dev_err_probe() in .request()
Date: Mon, 22 Jan 2024 15:57:36 -0800
Message-ID: <20240122235824.373882644@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


