Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B640F22332E;
	Wed,  4 Feb 2026 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219020; cv=none; b=fYCnddZkMxDKCeQ5P7JbzWyuCTGfsJEUFurzBfMQas1//wXqp5/jldflUmRQab3I4/D90+EFs8nyVIy/gUzluIfH9AyY2Rnif31cGmRBS8E/+Pqt8W43oik1VsIV7QkaF2OpzKoSaPB71iSLzPJyUu4THxXH36/9rPG/LHGfS/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219020; c=relaxed/simple;
	bh=ov2x2BH/FnRnPHf3hprwiZxvYJVlsGyRWHoehAEqtMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNFZ5x4oJ2Lu3udwN//IfPJUOkz834N6cPANIAu++rMmX60Vmb9npUjQsdmq6d7r8R/rG+/9Ngfp5TiDnr8VeAkaD3JbOTMTfXM8N/9MvjAncZVeMLI3xsqida5E6zqklMmx0bY5yvrCQUWDqd/3JNKSd4uwIrl+hbaN9VUiQhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTzo/1QR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTzo/1QR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26793C4CEF7;
	Wed,  4 Feb 2026 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219020;
	bh=ov2x2BH/FnRnPHf3hprwiZxvYJVlsGyRWHoehAEqtMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTzo/1QRCCRZ9KsvOxT8VvD4yfbOfx5a7gmMVJ2TA6NYfW5h3GjajiH+2FZDRtlVt
	 mFhdnxTiBJS2tqJuRPdReYZCcG+dfx1c6gT67uGV8Qb0o9tcWaZWN0UnavA8HNUDuZ
	 H/uChWgYDrQ/UOcQzbO3krwRGiqiY/SS2a61aGys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Huang <nekowong743@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/122] gpio: virtuser: fix UAF in configfs release path
Date: Wed,  4 Feb 2026 15:40:25 +0100
Message-ID: <20260204143853.408755861@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuhao Huang <nekowong743@gmail.com>

[ Upstream commit 53ad4a948a4586359b841d607c08fb16c5503230 ]

The gpio-virtuser configfs release path uses guard(mutex) to protect
the device structure. However, the device is freed before the guard
cleanup runs, causing mutex_unlock() to operate on freed memory.

Specifically, gpio_virtuser_device_config_group_release() destroys
the mutex and frees the device while still inside the guard(mutex)
scope. When the function returns, the guard cleanup invokes
mutex_unlock(&dev->lock), resulting in a slab use-after-free.

Limit the mutex lifetime by using a scoped_guard() only around the
activation check, so that the lock is released before mutex_destroy()
and kfree() are called.

Fixes: 91581c4b3f29 ("gpio: virtuser: new virtual testing driver for the GPIO API")
Signed-off-by: Yuhao Huang <nekowong743@gmail.com>
Link: https://lore.kernel.org/r/20260126040348.11167-1-yuhaohuang@YuhaodeMacBook-Pro.local
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-virtuser.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-virtuser.c b/drivers/gpio/gpio-virtuser.c
index a10eab7d2617e..252fec5ea3835 100644
--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -1684,10 +1684,10 @@ static void gpio_virtuser_device_config_group_release(struct config_item *item)
 {
 	struct gpio_virtuser_device *dev = to_gpio_virtuser_device(item);
 
-	guard(mutex)(&dev->lock);
-
-	if (gpio_virtuser_device_is_live(dev))
-		gpio_virtuser_device_deactivate(dev);
+	scoped_guard(mutex, &dev->lock) {
+		if (gpio_virtuser_device_is_live(dev))
+			gpio_virtuser_device_deactivate(dev);
+	}
 
 	mutex_destroy(&dev->lock);
 	ida_free(&gpio_virtuser_ida, dev->id);
-- 
2.51.0



