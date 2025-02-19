Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1206A1A841F;
	Wed, 19 Feb 2025 08:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955496; cv=none; b=j5igT/CgQ6BtfACqcBE+nLQZjCDmMFQ/ST1QnZ46TiqP1QbX/6MlVYGxoI1uplVeSSa2aYa1azqgKzZeBx5M+E/ijrkD+45b4/ShugYj4R3Z4i4tV3Z1BbhnbYd3ImEEfAyeG52CcYU+selOzLaGydTW786hJeQs9yRXnZIcfu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955496; c=relaxed/simple;
	bh=taGogW7ytytSalD2KhCeFv+qz0emWKBXaB+ux3+xR9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEfumJ44A490yP1uSHCf1KjWumXR2yC5tKg9fuFzF01qcNzu7ScdmikamvRJuVwdnZb2EqX/MlAV5tuDMJkkasXwIZWI4UDrSmgsmTqqVTIgKcof1stT4vsih6NHgr1rL7HdG3twdKR3Z2co04bmTg/2xmRyENv7qcqprTVcmho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtHjQSe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtHjQSe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C4DC4CED1;
	Wed, 19 Feb 2025 08:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955495;
	bh=taGogW7ytytSalD2KhCeFv+qz0emWKBXaB+ux3+xR9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtHjQSe38bOggnuEXlMaphvMg5/NHdYY4E77JEuNrACi+XeWtfo959Gmtzm3OK2wQ
	 g1oX9CTSGqQyw2Kdlsrnpm/8+A7puiCxJUeYhCghnP6yCPm/k9EPP8cEzlcqBKGYno
	 f7rtcnoyC5qihXCI8BqtL/gm9CsGkyrLD6ZrINt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/152] gpiolib: Fix crash on error in gpiochip_get_ngpios()
Date: Wed, 19 Feb 2025 09:27:17 +0100
Message-ID: <20250219082550.991613284@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5c0016c77d2ab..efb592b6f6aa7 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -723,13 +723,13 @@ int gpiochip_get_ngpios(struct gpio_chip *gc, struct device *dev)
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



