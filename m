Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9438847AF61;
	Sat, 12 Sep 2026 12:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214534; cv=none; b=o0dVJmC9VjMx7JxB1Yer/dutwG8o1kuUbYZ0xSN/WSiiw9dHgQENoDVD/8GUN69YYPkXnJNoggKEbFSHp7jMXJc+yqVvD7UxbiuPN5goOZ77ZZhsLcJf8Vqd0yDQXHoj4cU68yaCXJqMqgS2lbr4ZoEPPorfFBuxp84cJVBclfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214534; c=relaxed/simple;
	bh=hvZC9vvQ4tDfq/Qt9jTr1Wd/AGZYDXyVbjynd1SVC80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq35LIXUbb6hnVnaB6HtM/AQbIBaEzFvaAI0IqJ7Dl2yWeTft8gOKtFoP2r9hhYdF02nkqSEdxBq5UoFoyHGwRfnDT1T4VpjpSwKAXCz1aT6Q6C9n2+Dp0PddH4UsEP4fRWFWGsznSP+iV7i5+ZYjmkDqpjS4k9M8Z1VIG8D010=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJICiMT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJICiMT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69C81F000FF;
	Sat, 12 Sep 2026 12:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214529;
	bh=Hbq3rcY68C04s9W0Y+dJHY5Qut6JsBCN0tkF9VCKaco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJICiMT4Kn1nYS+XUB3nJmMc2DTmWfDi8R34zxKvkaHnAqJyPy91V9hFDXzZrZKfl
	 0o5gX2Xz7wOW2FoAkGNY92cUNJFORlDxXR9OuDZiFY3q6jy21F/zdS+sRUf1ix/nsq
	 OsFjiqa+WV2aM0QdHdh/vNjT7y0+w7nc+5ZDzL2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel McCarthy <daniel@dragonzap.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0346/1376] pinctrl: bcm2835: Dont remove an unregistered GPIO chip
Date: Sat, 12 Sep 2026 08:46:12 +0200
Message-ID: <20260912065615.263461087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index cc1fe0555e196..5e31a5704fcc9 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1348,7 +1348,6 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	pc->pctl_desc = *pdata->pctl_desc;
 	pc->pctl_dev = devm_pinctrl_register(dev, &pc->pctl_desc, pc);
 	if (IS_ERR(pc->pctl_dev)) {
-		gpiochip_remove(&pc->gpio_chip);
 		return PTR_ERR(pc->pctl_dev);
 	}
 
-- 
2.53.0



