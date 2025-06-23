Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB02B676;
	Mon, 23 Jun 2025 22:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717021; cv=none; b=h0n3YPVACccSIRPQiYQ4bFExrk6lCmpe1B0CSkhdAXxglEs5uv7PrdsVXY9WfpmKEm8l+HRYgQz8H10eGGV3jm4/NzD6lfBzNI457gakwKw4YdF+OOwcGhaeCn5iQJp9ITn+ECUODSpBMqbtuveaS694bHTeCw6c36ed1albLrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717021; c=relaxed/simple;
	bh=4wALQD21FIa1csLPWZDC54lR8KstQaPxTtQtIJw42Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2/80fYSrvi9wYwFmyFLRVt5rk2pHDswlhlS5+UYAf55KiFkbvHeRk1k8ONBg1DEKkOUanJF9qkojqwRLVpC45CfWkBHJhtssW+2XhWjjwkT4KEC0j26qGPVj2E559W2p2jPQPwWJQ4vvVc7b+di2pzNP41d0Sf6E2RE0Mtk828=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoZkeTvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoZkeTvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DFCC4CEEA;
	Mon, 23 Jun 2025 22:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717021;
	bh=4wALQD21FIa1csLPWZDC54lR8KstQaPxTtQtIJw42Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoZkeTvPjnu1a1d3wSAkyeXDAYGyvaL0lH4rGWiBqc438xKUpBz/GN8foR18Xafe4
	 hdF+n2r7zEmhNIVj4ZsP55+sjpFOPzOsaNDNIKx+jwaBR+r11Te79Fq5H9zD7mJ6Wg
	 vOqJWoygmN9V5ujRwuSY26olFxSi/wfvDBkIkwXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 578/592] gpio: pca953x: fix wrong error probe return value
Date: Mon, 23 Jun 2025 15:08:56 +0200
Message-ID: <20250623130714.184981382@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 0a1db19f66c0960eb00e1f2ccd40708b6747f5b1 ]

The second argument to dev_err_probe() is the error value. Pass the
return value of devm_request_threaded_irq() there instead of the irq
number.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Fixes: c47f7ff0fe61 ("gpio: pca953x: Utilise dev_err_probe() where it makes sense")
Link: https://lore.kernel.org/r/20250616134503.1201138-1-s.hauer@pengutronix.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 13cc120cf11f1..02da81ff1c0f1 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -952,7 +952,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 					IRQF_ONESHOT | IRQF_SHARED, dev_name(dev),
 					chip);
 	if (ret)
-		return dev_err_probe(dev, client->irq, "failed to request irq\n");
+		return dev_err_probe(dev, ret, "failed to request irq\n");
 
 	return 0;
 }
-- 
2.39.5



