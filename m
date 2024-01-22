Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D825FF12;
	Tue, 23 Jan 2024 00:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969782; cv=none; b=KFcd1Rd2NOn2x+VVsArK4Wy1H06fz4EXzALgXhMEH1aOygzFVLqNSKhUyL2R8s7zsi4NXI3tDaolkIdXgjh9mxeJG6KoOAbekB2NMgrwaksfuTohrLYWDYNVUFZa1oto4QLFWKBSaXcv9RuEDgd3vvGf3w/F3F1g7f4fMvrjgS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969782; c=relaxed/simple;
	bh=k2e18aVFUmi+wyB5JaKx29VpxczWzy1MO4JKJErp8I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZnjnADEVgn/MI5fxWbe8XjSxJNmrR4WNYCELRLHhxymyOVGptpVDuyWxfIP1MMDY6KlSjCj6L6CfiIdiwGf/rYCjZec0r3u9IoApN06FQoksavIuVzNIVQ1Sf71VnFJnqwxrW2vUNNOhxvR80izDdI1VENkQuOPCJT4M6myGBSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAEk1Sva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAEk1Sva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53F4C433C7;
	Tue, 23 Jan 2024 00:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969782;
	bh=k2e18aVFUmi+wyB5JaKx29VpxczWzy1MO4JKJErp8I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAEk1SvaxcrKtbn0UxsLsp/I1ljeTSdVlWECXqv1hmLarI8w/pDx707U8ELGzk9p7
	 mcs+Gvcrc3rW/Gaz+/5OcHroGJHYAwbAAG9t8dKoqoOhzST6YS0qSRDtGTZRdsr5yK
	 rAowa+a5GhbBfeRYsp1gk0oYEXCUkU8kS0IZ/Gn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 6.7 445/641] pwm: jz4740: Dont use dev_err_probe() in .request()
Date: Mon, 22 Jan 2024 15:55:49 -0800
Message-ID: <20240122235831.948366986@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -61,9 +61,10 @@ static int jz4740_pwm_request(struct pwm
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


