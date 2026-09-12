Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E8F37E5D1;
	Sat, 12 Sep 2026 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222462; cv=none; b=j+gzM8fuNKaFvxNC4Lz4SOEBXgwx7bMHdnAqGL+AtoqryysTQ5En8/WbTVOz0xx7ijMM5TY743m7jeVEY0sHNmOevL2i9AWKptlFs+YuMmJCOlQbU+ahIw8KS02sM+jyXIWwOhOkex0QG+Vtx6D2pexfw0Bsy6U6wQe9UyvsN4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222462; c=relaxed/simple;
	bh=gRH1l8McLKNg2rC9jNtMOph7/TXJ36bvI5SOzQ3jDVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHe9xF2FHu5rlY8DFdnx/vmnLm5JB60Bmydhdez4LKCQI9It0MaE5yjMvmrHZOEgSu7NN+yfG2ZGHB1H9O1ph2HmEPsJS41O0En0holLKEpauIuujz7bpYiNIa60t6+c/2vugfBP3xxtnAkiQ8h7NI3mMfB8LVYeejr00Ovg0WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elOKe/xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elOKe/xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BAF1F000FF;
	Sat, 12 Sep 2026 14:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222461;
	bh=saaJGsLk5R+//ZQvbuyo/LV3YpgYO257TfOH1OOmDWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elOKe/xuX7rO+s9HCeUMVUp7FCPmWoatR9Z3y9OSJO+RuPqmDLczLhrSTfLbuPf4A
	 +Itos+nryCsRu8D3rogwMHeyWEL/lq0RWQ9rMfKJeX30bij8bjnz303epZIsDlU3/n
	 crphYfsiXEXdNWKZYUDoVlrfi4/yv6IldqYu+09s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel McCarthy <daniel@dragonzap.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0592/1424] pinctrl: bcm2835: Dont remove an unregistered GPIO chip
Date: Sat, 12 Sep 2026 08:50:24 +0200
Message-ID: <20260912065620.549774599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 1489191a213fe..8f3470d576e43 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1280,7 +1280,6 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	pc->pctl_desc = *pdata->pctl_desc;
 	pc->pctl_dev = devm_pinctrl_register(dev, &pc->pctl_desc, pc);
 	if (IS_ERR(pc->pctl_dev)) {
-		gpiochip_remove(&pc->gpio_chip);
 		return PTR_ERR(pc->pctl_dev);
 	}
 
-- 
2.53.0



