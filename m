Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438E5757EA;
	Sat, 12 Sep 2026 19:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242292; cv=none; b=qwX9zf7xu9fQ7JCXl5bQgTAynJeG8mYpzCV7LNhjiaNsj4hkK9jEL7Bt0Uo0y+7Z4cBpjNRgJlZX3kiVRyypZL7Yl192nsem0CAAhVHqt/2YDtgDt1XUfhBGXzx/rrHCUG4Yl8y4zI6hiUnPjg849Cvb2KknpG1PqJOHKZVb25I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242292; c=relaxed/simple;
	bh=ZqAlv8jQ+pSEw+62CGjgBoHZZbKnl1y4A+ey1on6dek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYRSFxpfnGL7rnG5f0sen2d8ftRiycsJFQHVOxDNeuyB61RwphRhrwXGPH8Pr2u6Sk6eAeJrtCsy1mH/ObVLh+QSL2FAIRYBEL+wxONvJhw9Gyx5DVZ8V5y3/3J4v/A+bqWtvpyzWdz7D42wUTVdMSrkseeC1UIuut+5nw0th7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obIeI3r4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obIeI3r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA341F000FF;
	Sat, 12 Sep 2026 19:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242291;
	bh=dJyBjdOHLnXPnK5osklHS7mHa5FrdLudKOrRZGAF5JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obIeI3r4708B6sww4wmbe9VLAq1FfwosIP+2h1506F76S6ZuMBDczF3K/cB7L6+qb
	 LlauNqTPINF/gULTFJkdXShNTqnpUvOHsqE4NnbstpsyWInRgVkdhanxWkH9sOtVoY
	 enAvyicn7b2HaExhrs0GwoUx5U9M0GND7x0Ai+m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel McCarthy <daniel@dragonzap.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 353/798] pinctrl: bcm2835: Dont remove an unregistered GPIO chip
Date: Sat, 12 Sep 2026 08:59:41 +0200
Message-ID: <20260912065525.253470988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e3f49d0ed0298..fe848decc2a87 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1261,7 +1261,6 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	pc->pctl_desc = *pdata->pctl_desc;
 	pc->pctl_dev = devm_pinctrl_register(dev, &pc->pctl_desc, pc);
 	if (IS_ERR(pc->pctl_dev)) {
-		gpiochip_remove(&pc->gpio_chip);
 		return PTR_ERR(pc->pctl_dev);
 	}
 
-- 
2.53.0



