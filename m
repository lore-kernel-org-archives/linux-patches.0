Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CF6280335;
	Thu, 27 Nov 2025 14:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254983; cv=none; b=jO2f2X3lkR0dHYg5PR0EUjbD+WVzYrS9oI2ZV/37KMj8HdIkVqffeSgtkb5mpeR39dnz16NfBPVlj9Tuf8UQntsVC089fs6QKet1r+MKPbE4KlebC71LTEam3dWCl8IiTalfRzlaxyDP1MZCN3zxdEEZM+DWMMeG0+ecKZ/mhPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254983; c=relaxed/simple;
	bh=HlMx9IIW+SKZUL+FQgQ8A4+GNCqcAMvYk37PaD1lkxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YY5U2x2BChnmcuLzTigk2o8pc4IdFpFymsKJe3FBZcpvyCkItXqc2dqfwgHifAiD8aTWJNnnqJ//SDEUMsLf4Y4L+0WBoEnSiO4rVj7Zplo7vPytrYmFmkXvgvNwHWTzyWgsCJYQFoCQg231aBHNguNE5gyrmYsSuKq7YXgesZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EoutQlFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EoutQlFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1671C4CEF8;
	Thu, 27 Nov 2025 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254983;
	bh=HlMx9IIW+SKZUL+FQgQ8A4+GNCqcAMvYk37PaD1lkxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoutQlFC2TxQHuU+2Se+hVHny5nIPzZZ/IHVQr0EuoClW1+syQDKll3htAfARVSx3
	 Rh0RiX28bFN59REJpOmQPJ2Efre7Z32vnhfZRuab/A+4SdE+zz6vxUKs/DyoEa4lM4
	 IJtrCjhsuRYZpGRKy3d82aqaanPrB8s0mCOx0nr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 52/86] pinctrl: s32cc: initialize gpio_pin_config::list after kmalloc()
Date: Thu, 27 Nov 2025 15:46:08 +0100
Message-ID: <20251127144029.731269447@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

From: Jared Kangas <jkangas@redhat.com>

[ Upstream commit 6010d4d8b55b5d3ae1efb5502c54312e15c14f21 ]

s32_pmx_gpio_request_enable() does not initialize the newly-allocated
gpio_pin_config::list before adding it to s32_pinctrl::gpio_configs.
This could result in a linked list corruption.

Initialize the new list_head with INIT_LIST_HEAD() to fix this.

Fixes: fd84aaa8173d ("pinctrl: add NXP S32 SoC family support")
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nxp/pinctrl-s32cc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/nxp/pinctrl-s32cc.c b/drivers/pinctrl/nxp/pinctrl-s32cc.c
index 9e97968e25fcd..9c435e44abb4f 100644
--- a/drivers/pinctrl/nxp/pinctrl-s32cc.c
+++ b/drivers/pinctrl/nxp/pinctrl-s32cc.c
@@ -392,6 +392,7 @@ static int s32_pmx_gpio_request_enable(struct pinctrl_dev *pctldev,
 
 	gpio_pin->pin_id = offset;
 	gpio_pin->config = config;
+	INIT_LIST_HEAD(&gpio_pin->list);
 
 	spin_lock_irqsave(&ipctl->gpio_configs_lock, flags);
 	list_add(&gpio_pin->list, &ipctl->gpio_configs);
-- 
2.51.0



