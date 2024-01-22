Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4838657B3;
	Tue, 23 Jan 2024 01:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971776; cv=none; b=AEYDB6ikB8BpGLLTSMEJUTCA1V4LmwfRt9T3VkduSK+aCYw0N/9MtHmJgEdmsfDqy6P0P65utYFoacibcmsg0hFbx5pXKd440EJL5qf5FgaAU1w7Fv2Ct26IA5A41JdZPkC9AzEbnmeF6uK0VU2G7sh5vjOK2HbpZKoztWw+9sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971776; c=relaxed/simple;
	bh=6Ml6X4iqHkOLfjC0Ed0zbsFyvvAPcnNqRyJo8VC/DHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mR/16jJR9glr3vM5Pwrm6NwlqxnQyqwjOisAwd8yeMP0A1ze3TdnWhiGreR0UWNhMolBxUDrQsSBujsI30nYJZcs6DJskReZQynb7qaE9Nyzx05l9E4Pjg1Wng3u6AeyVjh04xEczmsr+AMwsaEEfmoYGQWehs5u2ysZwidvJiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhvHC16E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhvHC16E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F47C433C7;
	Tue, 23 Jan 2024 01:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971775;
	bh=6Ml6X4iqHkOLfjC0Ed0zbsFyvvAPcnNqRyJo8VC/DHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhvHC16EK28xLmDgirKAIpUBcSxMEw5NTmsIsi8fjqZHlFnVFkwg2J8hYxHncegOZ
	 fuvmgj+tDbYiLdbljRaA80UT5En/Z0qfHBINc8Doho/3tpf9wa8+M9wSnfOErAnf3B
	 pseTO+021IndcprXeWYlkQxNV2cJuFjxfKYw5Xkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 5.10 223/286] pwm: jz4740: Dont use dev_err_probe() in .request()
Date: Mon, 22 Jan 2024 15:58:49 -0800
Message-ID: <20240122235740.668517204@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


