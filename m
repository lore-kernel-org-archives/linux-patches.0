Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA3A3D75AA;
	Fri,  9 Oct 2026 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557220; cv=none; b=Pnz6Tnx5BGvq/7xaktzEis4YjQE3hGiWD3V81OZdg3twJYA3WdrrnybkJ7f18WDklCY6Ql52FtLfkdcWLRIOiApvlkKGJn2w1utQzXLkjs/r7b/L6TdI8Qw81EHMtIfbbDb5m/feSU2sIGTYGpgoXjBEn20c8j9TRRKMAstTvG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557220; c=relaxed/simple;
	bh=b4z1Xc/EXBNvNLKzo2OTYT9ibNvDrgZ1jV1kqyWQYyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbjaNKZpSrpWSukGK4Hl7wcY/YrM0WBhqMEGHUoxiTkl8kHDwiLB7jbOlEKe4x0IEWMx4lTJb9Guo8ziY/KvL5tWk45J+bsZ6MIU1fI9UtiYQJbTHM1JRvS9machNmH1bL1tuNS4/fDGY3l5w5lFD8y/VKyLev7tqr92e+GbYgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZHlDxot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZHlDxot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7402A1F000FF;
	Fri,  9 Oct 2026 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557218;
	bh=qLKOeogoXZq3CkTp9nKdRBGvVQcxluj1Ps3dVECB7xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZHlDxotGfi865ox29k3RUETdyptdl0yKjFHZ7sUP7Z7xt6bQyn1iZF+0jesJJIyA
	 agrakrvdjGY7/vbk3KqFYevC33kGT0PrdvhyhPJqIoDJp+lmladcJ71G9+6PEGBkOP
	 SvT21Cam9ozQuT1IkhKOrKwJ0jqOevuC9EkSxUqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 366/403] iio: adc: aspeed: Simplify with dev_err_probe
Date: Fri,  9 Oct 2026 16:12:07 +0200
Message-ID: <20261009141000.853667570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit dcc3ac29f46fff6775c0a945afc68fd9dece6d34 ]

Use dev_err_probe() to make error code handling simpler and handle
deferred probe nicely (avoid spamming logs).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 95e4eb426b4b ("iio: adc: aspeed: propagate reset deassert errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/aspeed_adc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -536,11 +536,10 @@ static int aspeed_adc_probe(struct platf
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


