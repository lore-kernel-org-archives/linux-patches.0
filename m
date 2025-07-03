Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67126126BFF;
	Thu,  3 Jul 2025 14:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554566; cv=none; b=hGtD0ViSghDOpXMfs4GBjpkg/mEl+jkY5TKOKRbidJIJ0wp4qi2SpiERXEtoV+IBdo8UH2pTt6rl/Qs/o39qJxbM6UbtemHLlW4R2krDGT7mre3WVv6ydZUjayOsz79AIeep+97+AE3dEiVYDTaRbWzTabuVfjuWDH3ik611D34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554566; c=relaxed/simple;
	bh=fY+CzWWxHvhG6wIW3ZxetTAyXWvEKBnMEwP2nL641E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ll+Cvpywvo4/XEQmYp0+6AYE7NNp3yfjgLZ+pTB9+RMIxOjwkoHtOqgXBd9CidQANpq23hamzs052gBqiKmS+qy00b2sKu8KX93G9i6b+ZNfYd1FpahZeJH/odDmGfl3gKKoDq1oDVc0dvNKMxgGXz4lIPBfxMSXmayCtzMV6tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fk1C0fKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fk1C0fKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16D4C4CEE3;
	Thu,  3 Jul 2025 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554566;
	bh=fY+CzWWxHvhG6wIW3ZxetTAyXWvEKBnMEwP2nL641E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fk1C0fKvtRaUt/wmfGg0oLpzU7Ij96KGnu3ACF2RRHxNo+G9kcXWZibSO2+jWVc6t
	 Yn927HZWfe0xXBNeGFzSpKPV+00CWxjAsIBFX3W9+Rl+jF30u6ApMjBFK1w+PifWg4
	 VjdeBEpzEfVIqW8clvd7QfciY1yAwscaefU+4I/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 010/263] mfd: max77705: Fix wakeup source leaks on device unbind
Date: Thu,  3 Jul 2025 16:38:50 +0200
Message-ID: <20250703144004.705857581@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit a59a56cc4fb1f7d101f7ce1f5396ceaa2e304b71 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406-mfd-device-wakekup-leak-v1-5-318e14bdba0a@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/max77705.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77705.c b/drivers/mfd/max77705.c
index 60c457c21d952..6b263bacb8c28 100644
--- a/drivers/mfd/max77705.c
+++ b/drivers/mfd/max77705.c
@@ -131,7 +131,9 @@ static int max77705_i2c_probe(struct i2c_client *i2c)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to register child devices\n");
 
-	device_init_wakeup(dev, true);
+	ret = devm_device_init_wakeup(dev);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to init wakeup\n");
 
 	return 0;
 }
-- 
2.39.5



