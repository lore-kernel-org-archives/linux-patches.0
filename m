Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013772FFF94;
	Tue, 11 Nov 2025 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824786; cv=none; b=E9ghK7TgtzpJPpKTAGwNEu64bTchiQ3aqAxSp4OI+wVzlQJWdB3uB7Qc7iPRiAREXGmFwUwYgjlTENPFYwAbSGGhIxHUmCB9Mw4pd7RlSfc5kdgmAglMyoI/4mUL22ykFGsRmR5+NlV7GXdKCPPmYwwmpmYENWbPDG4oW6PivxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824786; c=relaxed/simple;
	bh=S6LQh/wrTloX8Ocn9O7Muv/6NAX+GoP/CBT9MyNWEmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulEKSaBIY3WS5PTGIIWZxGrxceAOPLk42rVvTGwWcsWghXL4SiykkuHGCnM3JZS/wsk/l5rl4CkgpBdmhR8V6OR0HN8U7Tml7DU6vFzSM35ZYFgzjzQJJTsV6lkKE3XLMmisjE+SlUhAzLhoQ+SqTRLn2uUJRRPCJa7O77+he5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qr6qeEN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr6qeEN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91539C113D0;
	Tue, 11 Nov 2025 01:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824785;
	bh=S6LQh/wrTloX8Ocn9O7Muv/6NAX+GoP/CBT9MyNWEmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qr6qeEN7PYPT05uHHgqrPxuD/JKkvpkvGr9EZWfNDKi+sUlXapYOr4cjbCPwV9zVu
	 NBPzoavRWcuE55oQhOaf/BHKJRP16fX9tm5jRvaXkRY4YyS3elI5s2L+KDeHzRGxi0
	 yysGFHIxxPKGLiV2R1yqGvTK7OeSzdTTx8wdkN5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 517/565] gpio: swnode: dont use the swnodes name as the key for GPIO lookup
Date: Tue, 11 Nov 2025 09:46:13 +0900
Message-ID: <20251111004538.590656595@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit e5d527be7e6984882306b49c067f1fec18920735 ]

Looking up a GPIO controller by label that is the name of the software
node is wonky at best - the GPIO controller driver is free to set
a different label than the name of its firmware node. We're already being
passed a firmware node handle attached to the GPIO device to
swnode_get_gpio_device() so use it instead for a more precise lookup.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: e7f9ff5dc90c ("gpiolib: add support for software nodes")
Link: https://lore.kernel.org/r/20251103-reset-gpios-swnodes-v4-4-6461800b6775@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-swnode.c b/drivers/gpio/gpiolib-swnode.c
index 51d2475c05c57..bb652921585ea 100644
--- a/drivers/gpio/gpiolib-swnode.c
+++ b/drivers/gpio/gpiolib-swnode.c
@@ -41,7 +41,7 @@ static struct gpio_device *swnode_get_gpio_device(struct fwnode_handle *fwnode)
 	    !strcmp(gdev_node->name, GPIOLIB_SWNODE_UNDEFINED_NAME))
 		return ERR_PTR(-ENOENT);
 
-	gdev = gpio_device_find_by_label(gdev_node->name);
+	gdev = gpio_device_find_by_fwnode(fwnode);
 	return gdev ?: ERR_PTR(-EPROBE_DEFER);
 }
 
-- 
2.51.0



