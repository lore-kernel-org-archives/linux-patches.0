Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1311E133E;
	Wed,  6 Nov 2024 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898302; cv=none; b=RvdYq13WKfcPY0dRcKntk/LMoKRfKMqu3HRWduL1Kfw837KCZOeTinCKs+t5wEYhX7dTHKnxQBrgyFLjJoT5ibTgt+qKRb+FFfu/8llbF5KM/dYD0X4elRvc4WNrhPF+SXn1lEdyzcNeApvsaZIcOiyRyKtjPWnSXFewPD/4E0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898302; c=relaxed/simple;
	bh=kDVpU0JCus3rHpzOUHj9asKlOCf1ww0QivXw33W9C4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlg2h40NpCdmc21LcZqHKwQmWS6KpRWffF2Fp2TwAjhj5cmwTM0nUVNZByfxrOQg3qkvn17+V9x1TnPWl35iQr/XzhO8pSZUjPGhBcQLF1iMidedHaRwM8RlN1yIjaaUPkIvb1dMS/GKSX3dBxsolr2VWBMXAb0G115LaqCebJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzz9hSTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzz9hSTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41016C4CECD;
	Wed,  6 Nov 2024 13:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898301;
	bh=kDVpU0JCus3rHpzOUHj9asKlOCf1ww0QivXw33W9C4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzz9hSTp3UwX8xbWC9F3DGgZQnw48HYYcZ9UuryAJgS47x41ObtxdV4xKAwHakSWp
	 C6rUXg8ceZYV66ljpNKSyoPAWAQl0lZ6DqumN6qujATjc0ccPuG6S0K7oLFkMi7CXd
	 qzkE+bEyIroE4DPzM4WrJdaHEna09/6/+LNRvhDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Guoqing Jiang <guoqing.jiang@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 155/462] hwrng: mtk - Use devm_pm_runtime_enable
Date: Wed,  6 Nov 2024 13:00:48 +0100
Message-ID: <20241106120335.345380910@linuxfoundation.org>
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

From: Guoqing Jiang <guoqing.jiang@canonical.com>

commit 78cb66caa6ab5385ac2090f1aae5f3c19e08f522 upstream.

Replace pm_runtime_enable with the devres-enabled version which
can trigger pm_runtime_disable.

Otherwise, the below appears during reload driver.

mtk_rng 1020f000.rng: Unbalanced pm_runtime_enable!

Fixes: 81d2b34508c6 ("hwrng: mtk - add runtime PM support")
Cc: <stable@vger.kernel.org>
Suggested-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/mtk-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -149,7 +149,7 @@ static int mtk_rng_probe(struct platform
 	dev_set_drvdata(&pdev->dev, priv);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
+	devm_pm_runtime_enable(&pdev->dev);
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 


