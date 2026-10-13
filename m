Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFA04F3937;
	Tue, 13 Oct 2026 12:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895602; cv=none; b=otHb9mWRZwaex8Gda3nu3M2LcwAQG8gqCDfAWSS5pOZgff5NW9hLw7JPHi8tYyrHK2Qsc/ZXZoiKJa4gXvM3OtuptQIGLrDyAqSIPupDou3Wzbjiid0Fx5E/czj3XdzL+qu02lDHyFX88tqCR8HUTuBeIB+taovjtclfWqvpT8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895602; c=relaxed/simple;
	bh=ae+IkQSAWAYQXtIJY+1FS85gQQvKtF6WM3AfG3BCdlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0/kjRNL80SrYiMGxH/lqc2Ve7peq+xJsana9GzmnniVwK9PJwurlKS+wnWju/xJ2bmJZU3j1s6RQVONT0W7htMINq3vxeGUZ13OU/abM0oWrVKyaTNRw6zLLJMScnzAdkYDHANcQsU6K3BZkRqLYMVRTNWZkK+fYGDCAggFjoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbuDHaXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbuDHaXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7412A1F00893;
	Tue, 13 Oct 2026 12:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895600;
	bh=VQkLH9+jMPO+n65cQBciP4AdCkd7Y81RPvo7wljXGe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zbuDHaXPS/dCPdKHBLjW6VscdccVx+8DdXUxf5plBalwj0tFEKMvvAPsfpgKwY01C
	 cpzJ+fcL/a3RGX2pv7zA92i3ekiqOb3wORc48WNDk38kss7NSO8EWbxzrVAjWvdlN8
	 9Lp/Qjeki2Eh9x2A0mCh3VHMSTn+P7N8Su55GP5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/497] iio: adc: aspeed: Simplify with dev_err_probe
Date: Tue, 13 Oct 2026 13:38:17 +0200
Message-ID: <20261013112915.736700483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8ab29948214a5..1cf9df6a14a54 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -536,11 +536,10 @@ static int aspeed_adc_probe(struct platform_device *pdev)
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



