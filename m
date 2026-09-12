Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959B93A7580;
	Sat, 12 Sep 2026 18:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238191; cv=none; b=Gr9fpyu5NcXcepTV5btaYhG6IFFHLdMpUQn+6HilJY0q5aVKmN5ItTpTLdRu0LOS13af7DcnlTrTxe3W2LWAickvCZWAjFrvy7BM/GyM7f/kSDvalWFXR+u4KQ2591KbJJCmh1jeKJYM1/E/Vmga3IpTsH+eNPr31ZyI7nf1KlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238191; c=relaxed/simple;
	bh=7ratOOf45u0a2kHtJjzwKMLMucgZqIszZMUfI1pm/fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPvg6HBW/pfWmqofjLpZo1jGnPoHtXc5M15l5EtvZnQh7kRSaFqPnFI98InDQp4rVzJRBZiNBKdfy0Xtk3xDSnUgZr9YHKve/0xNBLdxhImWBkOd+fNZKMG2vhGN284Dccn/A6ApA9Ie1j0cbHi+NPfN7FVvDudF5MNtG0EPOvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2tYvGLa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2tYvGLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3C91F000FF;
	Sat, 12 Sep 2026 18:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238188;
	bh=v+Wz8SifXBlt8LrrVDlXyVR4ubvG2gYGUlkHfBgsfRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2tYvGLanKG8Y7/Sx0QiPEwpWph5P+3VKGY5kKqzeBKJhmv3RNz4/tKqRHZJ2T5Lq
	 leHbaHCmMvosvT1xiVoyLKv8TY9C7aWs/gvU1dFm8z4YrQ8jxsXjisza4WkzTGCMvg
	 ZsQ2ZlCggJOz6GpOzZ10vbOjufH4Ous//NvZJ9W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel McCarthy <daniel@dragonzap.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 412/935] pinctrl: bcm2835: Dont remove an unregistered GPIO chip
Date: Sat, 12 Sep 2026 08:57:22 +0200
Message-ID: <20260912065536.272572436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel McCarthy <daniel@dragonzap.com>

[ Upstream commit 32711f77db0641e57fd96fdc013bf1286b9f2514 ]

If the devm_pinctrl_register() function fails,
bcm2835_pinctrl_probe() calls gpiochip_remove()
before gpiochip_add_data() has registered the GPIO chip.

This means that upon failure the gpio_chip.gpiodev
 is NULL resulting in a null pointer dereference
inside the gpiochip_remove() function.

Remove the unnecessary function call to gpiochip_remove().
No GPIO cleanup is required because the GPIO chip
has not yet been registered. Without this change there
is potential for a kernel panic upon registration failure

Fixes: 266423e60ea1 ("pinctrl: bcm2835: Change init order for gpio hogs")
Signed-off-by: Daniel McCarthy <daniel@dragonzap.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 55371769d54f0..3a2d9f64ed41e 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1260,7 +1260,6 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	pc->pctl_desc = *pdata->pctl_desc;
 	pc->pctl_dev = devm_pinctrl_register(dev, &pc->pctl_desc, pc);
 	if (IS_ERR(pc->pctl_dev)) {
-		gpiochip_remove(&pc->gpio_chip);
 		return PTR_ERR(pc->pctl_dev);
 	}
 
-- 
2.53.0



