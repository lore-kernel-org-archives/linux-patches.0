Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E991DDCE;
	Tue, 16 Jul 2024 16:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146063; cv=none; b=uAheVRhWDvEhSi7/CpnQ9pTBohnbtn3R2iHHf3QoEWkgpyZGKGo/s/u5NKDdoqkBo+2DdSTbWSa4jU9Pl1Fwro+BuqrJhUPHcuHywUo3/EM+I+rd0zGzUzq69yLHGsHijaWczYRhFCvYn99pIlz2N0bODVxrtAwCPyWOjhbErd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146063; c=relaxed/simple;
	bh=mS0cFjTjiL+VTLkyJlHOPGt2jp3i25uxrBRQQpnVWsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw87BIcgJTkRixKbmhlLc+uLBoP7T1bvyNl0my1lUqk/BiCdTzjOt/0MYui9iwMkUneW6VXUIa884j9+vNGVbMknpRDdLSfcJANqC3+Ps78U+jcXeabw8Nnv4ZnJ0zXd9oN6xkzL3m1TqIgfBThiYctPDtmZvz+Xp1dgaS9VFzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caZvITrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caZvITrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5518DC116B1;
	Tue, 16 Jul 2024 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146063;
	bh=mS0cFjTjiL+VTLkyJlHOPGt2jp3i25uxrBRQQpnVWsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caZvITrwwWfO54qoMwzR6XmRiBEMPKv/mywrpF6qVGXsHjiH7/b+ainB7xqTOdUri
	 QCt+yryAAZSuu9XweTcmWpEAx57cP3UxO8KLUvGNAXaUCTKSqxs3c5Ob2BFmHW3X73
	 WB6CpcyUdXfLjGIgMP41nvjUkICN/LcXQlLOmbog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/144] gpiolib: of: add polarity quirk for TSC2005
Date: Tue, 16 Jul 2024 17:31:54 +0200
Message-ID: <20240716152754.277916668@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit f8d76c2c313c56d5cb894a243dff4550f048278d ]

DTS for Nokia N900 incorrectly specifies "active high" polarity for
the reset line, while the chip documentation actually specifies it as
"active low".  In the past the driver fudged gpiod API and inverted
the logic internally, but it was changed in d0d89493bff8.

Fixes: d0d89493bff8 ("Input: tsc2004/5 - switch to using generic device properties")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/ZoWXwYtwgJIxi-hD@google.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 7a77d9cd9c774..608526ce7bab0 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -173,6 +173,14 @@ static void of_gpio_try_fixup_polarity(const struct device_node *np,
 		 */
 		{ "himax,hx8357",	"gpios-reset",	false },
 		{ "himax,hx8369",	"gpios-reset",	false },
+#endif
+#if IS_ENABLED(CONFIG_TOUCHSCREEN_TSC2005)
+		/*
+		 * DTS for Nokia N900 incorrectly specified "active high"
+		 * polarity for the reset line, while the chip actually
+		 * treats it as "active low".
+		 */
+		{ "ti,tsc2005",		"reset-gpios",	false },
 #endif
 	};
 	unsigned int i;
-- 
2.43.0



