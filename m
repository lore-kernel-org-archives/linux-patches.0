Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384EE3B19BA;
	Sat, 17 Oct 2026 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257077; cv=none; b=PD702gJwtiM1Hs0sVL1ceDdNYT+ukQU4V55r6/elBqvVbL49GDxzAyes6jvN0ZQdICYZdDMxp6qA59VOVWoodoFyMGI6PN3hIeNjYvrk/xhpf8LfOntnNyrA8lNTkEOwIDOggGvdN/hO/A7xTeKggwUY+k6SiF7vGGZkB9Y8RaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257077; c=relaxed/simple;
	bh=33Z5ZeiJFD3vDQJHoncJsq7gQxltu/uouM0PbOZPQ5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEgmEEteGALecYYJTToBdR5o9K509YbLNuTuZ64dOxs+IZVRqUD4DNf/El3skqJl7JbclKTbolT3FZEwlXprr+O/P28YHSl90Lj8T0+cGD8BBW7h1pnC92sBaSWKh8Lm4YC5As5pJO2bVvzPP7NCOUqPFDbo6VgU5PHNphAbGYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5U2/101; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5U2/101"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875EC1F000C4;
	Sat, 17 Oct 2026 17:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257076;
	bh=UeYJnt9bk/xioESc4TPCOWboqgNeI0UVUJOImdNlWJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5U2/101H4WUSd6Smc6EYnvY8rEymwyic0ZIZQ9nMYp+h2hHVYwiG00DkGRuhWAeJ
	 5bCYa9aFe/mUzYEfMlR4g9BsuHKzDiI0k9Ye9yaT/lY9mTPuw+rM9tVBYoTdCXeTQO
	 aI+f+kY7B8dqxEIwR7/ZbdCZi6NvStXWJSKZt2O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0445/1674] iio: adc: aspeed: Simplify with dev_err_probe
Date: Sat, 17 Oct 2026 17:45:17 +0200
Message-ID: <20261017160442.544828420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit dcc3ac29f46fff6775c0a945afc68fd9dece6d34 ]

Use dev_err_probe() to make error code handling simpler and handle
deferred probe nicely (avoid spamming logs).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 95e4eb426b4b ("iio: adc: aspeed: propagate reset deassert errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/aspeed_adc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index 998e8bcc06e1d..e6a9d8d77af53 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -549,11 +549,10 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 		return PTR_ERR(data->clk_scaler);
 
 	data->rst = devm_reset_control_get_shared(&pdev->dev, NULL);
-	if (IS_ERR(data->rst)) {
-		dev_err(&pdev->dev,
-			"invalid or missing reset controller device tree entry");
-		return PTR_ERR(data->rst);
-	}
+	if (IS_ERR(data->rst))
+		return dev_err_probe(&pdev->dev, PTR_ERR(data->rst),
+				     "invalid or missing reset controller device tree entry");
+
 	reset_control_deassert(data->rst);
 
 	ret = devm_add_action_or_reset(data->dev, aspeed_adc_reset_assert,
-- 
2.53.0



