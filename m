Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAE813A25F;
	Tue,  9 Jul 2024 11:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524225; cv=none; b=qs4rzy/dNp7GSJXhAA2e5juAIajF5GrjnECGfBNEhR7OmzPh4ynCa1HkbtMwD2UG5nEH5kBNxq5RqEImwXvUeWbH1WDuNIHaOnuacViBLyVnZ3QkhgMN+4M6MTJobIjcOY4JMiADvcc5pGxLc1Dmnj+FqsKEhLX8hJWe4ra7YgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524225; c=relaxed/simple;
	bh=e1B/bZxmn45IfRzYmvUGn4tIdbUgQy4711g9WJ1B81k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZFUaowSb8ZddUD5/BHzaWtZ6YBWcJ25o76M9zUn39tyWZBC3FuA3T7lQU6Olxr0Una3pv2Pq3mEIaOdM/7zB0khQ/BWxN3cqhwzBYGuVClwAI9CKYi1b13QBHhyZAGcN24OSz+e232DlsolF/X80Lv9hj4r8YjsY/R/xgyYpERg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEgY8zyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEgY8zyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201ABC3277B;
	Tue,  9 Jul 2024 11:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524225;
	bh=e1B/bZxmn45IfRzYmvUGn4tIdbUgQy4711g9WJ1B81k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEgY8zyBNan1x0MggrltmWlW72BcOfObMQsT7tNRQBW2qn1GWHP1tvzjijpMO15TV
	 XSZZ0ge/ytO6KPH9H9TGZfkMAFQOGFL4b7E+qhzDx79HG9EnbhqIwt36H1S8xLrlkl
	 8k/liQg90sm8BS372TXJo3qNAGRYMlc4gURvwa8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Mentovai <mark@mentovai.com>,
	Shiji Yang <yangshiji66@outlook.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?L=C3=B3r=C3=A1nd=20Horv=C3=A1th?= <lorand.horvath82@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 113/197] gpio: mmio: do not calculate bgpio_bits via "ngpios"
Date: Tue,  9 Jul 2024 13:09:27 +0200
Message-ID: <20240709110713.328292228@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit f07798d7bb9c46d17d80103fb772fd2c75d47919 ]

bgpio_bits must be aligned with the data bus width. For example, on a
32 bit big endian system and we only have 16 GPIOs. If we only assume
bgpio_bits=16 we can never control the GPIO because the base address
is the lowest address.

low address                          high address
-------------------------------------------------
|   byte3   |   byte2   |   byte1   |   byte0   |
-------------------------------------------------
|    NaN    |    NaN    |  gpio8-15 |  gpio0-7  |
-------------------------------------------------

Fixes: 55b2395e4e92 ("gpio: mmio: handle "ngpios" properly in bgpio_init()")
Fixes: https://github.com/openwrt/openwrt/issues/15739
Reported-by: Mark Mentovai <mark@mentovai.com>
Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Suggested-By: Mark Mentovai <mark@mentovai.com>
Reviewed-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Lóránd Horváth <lorand.horvath82@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/TYCP286MB089577B47D70F0AB25ABA6F5BCD52@TYCP286MB0895.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mmio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpio/gpio-mmio.c b/drivers/gpio/gpio-mmio.c
index 71e1af7c21847..d89e78f0ead31 100644
--- a/drivers/gpio/gpio-mmio.c
+++ b/drivers/gpio/gpio-mmio.c
@@ -619,8 +619,6 @@ int bgpio_init(struct gpio_chip *gc, struct device *dev,
 	ret = gpiochip_get_ngpios(gc, dev);
 	if (ret)
 		gc->ngpio = gc->bgpio_bits;
-	else
-		gc->bgpio_bits = roundup_pow_of_two(round_up(gc->ngpio, 8));
 
 	ret = bgpio_setup_io(gc, dat, set, clr, flags);
 	if (ret)
-- 
2.43.0



