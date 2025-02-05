Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1F4FC0B;
	Wed,  5 Feb 2025 13:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763588; cv=none; b=Pf4mooQahnnmpUjmyJBQs6bCbEjIB+HTnLI2GUAqf7ztskfmZ0EikeSwnN35ftOIfpgFSAEdjQ/7kZ6fd2zx0UFGtEh0t+uQTzeCtUGVqMcY9XWP6zxW7n36IVWXE7+qg9EivkBxLKTcaPsDvdieD0z4Nb6cin6AUHOdzNvy6BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763588; c=relaxed/simple;
	bh=JXNVlT4WIJa77fuSOVyd8LG339PkdGyBkch5q1Ap+i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uF4iBFr+mG+1GQYvmO3IOw2Yph4InSuKUthGNPh5M56ZIqTodRZFRK5+3OOod5Y3BSIYeQLq/n4ohcLgHG3RUex0vpbP4F/dMTdcz3ZFiNCzsSQTLdRLZWeSnVngN9VQ66XYBhnLBnsKDRtWSvkSdJcAFchnVAlvibgFqt2Un/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMfyIGSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMfyIGSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0C5C4CEDD;
	Wed,  5 Feb 2025 13:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763588;
	bh=JXNVlT4WIJa77fuSOVyd8LG339PkdGyBkch5q1Ap+i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMfyIGSyza5V99vF0+GvZS8dogKZgrJqpcnZ3SKaWXKSmRkw1kXuJq5m63jHppdli
	 dZ5bAhBI9/tDYZvqyIgG4TyqBLDbZz6vAzU0JCsAqjchUAILhB39m+0Ev67+SbNN7c
	 w9Yr3zzNpzr7ySu+MMXxnpJaYfil1Gy0SXx4/zcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/393] gpio: pca953x: log an error when failing to get the reset GPIO
Date: Wed,  5 Feb 2025 14:40:04 +0100
Message-ID: <20250205134423.545168002@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 7cef813a91c468253c80633891393478b9f2c966 ]

When the dirver fails getting this GPIO, it fails silently. Log an error
message to make debugging a lot easier by just reading dmesg.

Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Fixes: 054ccdef8b28 ("gpio: pca953x: Add optional reset gpio control")
Link: https://lore.kernel.org/r/20241219-pca953x-log-no-reset-gpio-v1-1-9aa7bcc45ead@bootlin.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index cf5d85c6c8925..9c33f9da724cf 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1107,7 +1107,8 @@ static int pca953x_probe(struct i2c_client *client)
 		reset_gpio = devm_gpiod_get_optional(&client->dev, "reset",
 						     GPIOD_OUT_LOW);
 		if (IS_ERR(reset_gpio))
-			return PTR_ERR(reset_gpio);
+			return dev_err_probe(dev, PTR_ERR(reset_gpio),
+					     "Failed to get reset gpio\n");
 	}
 
 	chip->client = client;
-- 
2.39.5



