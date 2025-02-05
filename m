Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913A21519A4;
	Wed,  5 Feb 2025 14:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765076; cv=none; b=fjwZUrYcjIOFXtzy/BBmZRUniB+53vtVs07p01EoOyuTGlTLOXWHV3DTzIqAPIMz5u14Mq/dKN0OonQ1UlIXFjGXMKbIOaSwzBgGvIlG/UI1DGy1kNysdG1hiF3Q+qSAlV03FiKIhPXKIKDYEgf5hhGzh7ZcJUk4bW1F1Hf9CEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765076; c=relaxed/simple;
	bh=wggHTt6fZKORWkIVCgz9ffADtky0kNcL6L5BuCk3hK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLS3MaKqpSIo1SEXfD2SM/UbZ3z8GUu7cX1GykOcj4YPbPXrRpdfLJns4sCWA37jHqEiFbohVBzF4ci3XUq6/BGBHbhE+vnUKPdwSeTJzj7bxTXmARqtgt3M8yM5a72iiDNBP+bhmlGOug8lIZ29gWd7vM2f9+xh57pYXHeOQes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPRnVLQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPRnVLQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F47C4CED1;
	Wed,  5 Feb 2025 14:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765076;
	bh=wggHTt6fZKORWkIVCgz9ffADtky0kNcL6L5BuCk3hK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPRnVLQW+YM9HfZ9OVEZ3Id/y+At2qICPLwfIWUwMOIfeIZLTe54ulHxooUH+aY9n
	 3mU88luAhhaXt6IRoX+LGnJG/Vqji1D9wy7IYulVGSZBV5l3b8Jxrc4q5OSeqU82ss
	 YB5BigeUGOdLBuUVSaDucoluBCDkIxsRVNDxcQYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 126/623] gpio: pca953x: log an error when failing to get the reset GPIO
Date: Wed,  5 Feb 2025 14:37:48 +0100
Message-ID: <20250205134501.046774132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 272febc3230e9..be4c9981ebc40 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1088,7 +1088,8 @@ static int pca953x_probe(struct i2c_client *client)
 		 */
 		reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
 		if (IS_ERR(reset_gpio))
-			return PTR_ERR(reset_gpio);
+			return dev_err_probe(dev, PTR_ERR(reset_gpio),
+					     "Failed to get reset gpio\n");
 	}
 
 	chip->client = client;
-- 
2.39.5



