Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1CB1DE2BD;
	Wed, 19 Feb 2025 08:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954011; cv=none; b=dT+Z2wpAgCQu1CIlhBJ3rd+k0B8zM/1GZCPVFv1Anb8lQOCjt7uZbjwhnrpx4DgHD4TtHGcweyhgzuA/EJLZUoDmAuVYRdQngtQ1pzN7tWwYf4iKlA8PtCm5M8IR0Jt8UCqFSxrb3hSRDfD97pZLtkc00eNyj4lP+hOu/HZmRJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954011; c=relaxed/simple;
	bh=5c8q82tMe6VWBWItV+cstBPeOAccbAhasIbEEDEyY90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHrZiGX8+jEKvziHfjADo0Ke2CKw8Zj8bP7dw/Ho/jBZZTCH22Pb1lQx7maFKWsYzJvSKUo1stRjUDSk6nYD86o+eB7OWn7t8B1KtQJdn15cxXbMGn6bUWuG6wLD29Vq3m6YLN8X/0NklYyuvE17b5kKecvjCsCOwKTp6iqWJuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOtPQtJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOtPQtJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AADAC4CEE6;
	Wed, 19 Feb 2025 08:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954010;
	bh=5c8q82tMe6VWBWItV+cstBPeOAccbAhasIbEEDEyY90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOtPQtJA3vS6S+aO3e87Ckre/F+kFWYGazI+34isjTJYqfUKplPVySHh0S4ASy+pi
	 AQsk3va9iMNq5jdeHyFRC3BqjP2S8sMUJONJLmRiv+RLUMr6jb0uF83gk/vVQJHWTL
	 fQTTHZ5if3SyN3FMfNid+fGGARvXx8JhWOwhQlzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 066/274] gpiolib: Fix crash on error in gpiochip_get_ngpios()
Date: Wed, 19 Feb 2025 09:25:20 +0100
Message-ID: <20250219082612.207760943@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 679ed764cb143..ca2f58a2cd45e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -904,13 +904,13 @@ int gpiochip_get_ngpios(struct gpio_chip *gc, struct device *dev)
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



