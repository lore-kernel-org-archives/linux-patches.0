Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666D41EF082;
	Wed, 19 Feb 2025 08:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954852; cv=none; b=rtf7mNuVgSo7P0mOsVAy5SsMcVWYNTJimFvI7cidvBUazQMn6funQRSfHDsd+Cn7eC4Gvk6FAd0KXovt4g+i8kbaimrCxcqR1uvfvRxEz+J2D1VKtn8giJFcoXfmWyvPD1E2Znb2CgYAPltkqxeKZVM/gNLLNFD0i6WGjOEz8aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954852; c=relaxed/simple;
	bh=xd6IHO3bg0WCtHKsKAVssoW6Kz4dQAhJaWK+Y9EYkwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnhgiSnNsq47+YASZ+B6YKLw2I4WyJaEGq+UkvB6tB6qGuUbzstIOnVlu8BJUTSwmHX1HA1TypIy3L3cQDJTVY73GQXn7YwRLNsrpRgBcPBxNygqUQ4jTzcHgD1uuMqu7w7LYlOAS+hN8sr6Hy7DJuQ5dg0TIhCjq12bRQDxEK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JnTiXQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JnTiXQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D835CC4CEE8;
	Wed, 19 Feb 2025 08:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954852;
	bh=xd6IHO3bg0WCtHKsKAVssoW6Kz4dQAhJaWK+Y9EYkwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JnTiXQnpxEjnFmRrp+OcDblY//HoNImqKkn4G9054oiS6PNnnu13jMumjUrtRog2
	 OOs1PRjlYSUHDvmuHJj39oQZfL2bkxVOOwyGTF+smulvAeG5y7IyrB7arCpQE1+n4U
	 Y6kWx66jq4dyjwrWu1rKSUG+hZDPsga2O7bwtl0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/230] gpiolib: Fix crash on error in gpiochip_get_ngpios()
Date: Wed, 19 Feb 2025 09:26:12 +0100
Message-ID: <20250219082603.867907477@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7b4aebeecbbd5b5fe73e35fad3f62ed21aa7ef44 ]

The gpiochip_get_ngpios() uses chip_*() macros to print messages.
However these macros rely on gpiodev to be initialised and set,
which is not the case when called via bgpio_init(). In such a case
the printing messages will crash on NULL pointer dereference.
Replace chip_*() macros by the respective dev_*() ones to avoid
such crash.

Fixes: 55b2395e4e92 ("gpio: mmio: handle "ngpios" properly in bgpio_init()")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250213155646.2882324-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 44372f8647d51..1e8f0bdb6ae3b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -905,13 +905,13 @@ int gpiochip_get_ngpios(struct gpio_chip *gc, struct device *dev)
 	}
 
 	if (gc->ngpio == 0) {
-		chip_err(gc, "tried to insert a GPIO chip with zero lines\n");
+		dev_err(dev, "tried to insert a GPIO chip with zero lines\n");
 		return -EINVAL;
 	}
 
 	if (gc->ngpio > FASTPATH_NGPIO)
-		chip_warn(gc, "line cnt %u is greater than fast path cnt %u\n",
-			gc->ngpio, FASTPATH_NGPIO);
+		dev_warn(dev, "line cnt %u is greater than fast path cnt %u\n",
+			 gc->ngpio, FASTPATH_NGPIO);
 
 	return 0;
 }
-- 
2.39.5



