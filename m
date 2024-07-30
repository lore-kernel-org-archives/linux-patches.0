Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABE01A6192;
	Tue, 30 Jul 2024 16:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357203; cv=none; b=bGqRHuYvjfLmYlBVixV27NuCjv30JFCf8JKohvGEsR9hsWoLbdn7+FtzZh/xdSDP5PUdGMdbiSdcVpck6PTk55bd8BRH/101GhE96vQfqNrprR6chJoD/JL+DEPnemAM24Xg3oFbLGB1D2UCMCzelSNEPl/BAeRu8PmwC4vUXQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357203; c=relaxed/simple;
	bh=cuta3MJXN1rjRClJwf7qpa4JwnPF0gSwZ/pumn6UOTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oz6IHIGT0x99Of73ZTi6wh6eghNvY5vvUJTyhCT3kDDTiJp5kAFXrx4SrLk28VwsBoLbFnr7QsBAUpXLTqxF8+s6A/l47SgsSzoLkgHxQu2sfcn0KgCwDc3tqo2IInfZEYb4C+TF7K/Luuz0hEFitD1CO3Onl1cMc3/hx62cq7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeRNVdzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeRNVdzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BA2C4AF0C;
	Tue, 30 Jul 2024 16:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357203;
	bh=cuta3MJXN1rjRClJwf7qpa4JwnPF0gSwZ/pumn6UOTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeRNVdzUhO0CqnNDDm+4F992cNlbR1V9pDUSjJRUHUPJ6z0lJof+LLX3ER6VjxMjo
	 PC94OA0zQumdWSOEttnyMlsbt1A7o+Au67A3uZ/Y7fCp9CNT1cpkiSRkoTJ8yv45HC
	 Mj4IKbc21rDAume6qBAPHjtzc9hhHLI5x0QuCpiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Herv=C3=A9=20Codina?= <herve.codina@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/568] Revert "leds: led-core: Fix refcount leak in of_led_get()"
Date: Tue, 30 Jul 2024 17:45:36 +0200
Message-ID: <20240730151648.833433690@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 940b27161afc6ec53fc66245a4fb3518394cdc92 ]

This reverts commit da1afe8e6099980fe1e2fd7436dca284af9d3f29.

Commit 699a8c7c4bd3 ("leds: Add of_led_get() and led_put()"), introduced in
5.5, added of_led_get() and led_put() but missed a put_device() in
led_put(), thus creating a leak in case the consumer device is removed.

Arguably device removal was not very popular, so this went apparently
unnoticed until 2022. In January 2023 two different patches got merged to
fix the same bug:

 - commit da1afe8e6099 ("leds: led-core: Fix refcount leak in of_led_get()")
 - commit 445110941eb9 ("leds: led-class: Add missing put_device() to led_put()")

They fix the bug in two different ways, which creates no patch conflicts,
and both were merged in v6.2. The result is that now there is one more
put_device() than get_device()s, instead of one less.

Arguably device removal is not very popular yet, so this apparently hasn't
been noticed as well up to now. But it blew up here while I'm working with
device tree overlay insertion and removal. The symptom is an apparently
unrelated list of oopses on device removal, with reasons:

  kernfs: can not remove 'uevent', no directory
  kernfs: can not remove 'brightness', no directory
  kernfs: can not remove 'max_brightness', no directory
  ...

Here sysfs fails removing attribute files, which is because the device name
changed and so the sysfs path. This is because the device name string got
corrupted, which is because it got freed too early and its memory reused.

Different symptoms could appear in different use cases.

Fix by removing one of the two fixes.

The choice was to remove commit da1afe8e6099 because:

 * it is calling put_device() inside of_led_get() just after getting the
   device, thus it is basically not refcounting the LED device at all
   during its entire lifetime
 * it does not add a corresponding put_device() in led_get(), so it fixes
   only the OF case

The other fix (445110941eb9) is adding the put_device() in led_put() so it
covers the entire lifetime, and it works even in the non-DT case.

Fixes: da1afe8e6099 ("leds: led-core: Fix refcount leak in of_led_get()")
Co-developed-by: Hervé Codina <herve.codina@bootlin.com>
Signed-off-by: Hervé Codina <herve.codina@bootlin.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/r/20240625-led-class-device-leak-v2-1-75fdccf47421@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index ba1be15cfd8ea..c66d1bead0a4a 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -258,7 +258,6 @@ struct led_classdev *of_led_get(struct device_node *np, int index)
 
 	led_dev = class_find_device_by_of_node(&leds_class, led_node);
 	of_node_put(led_node);
-	put_device(led_dev);
 
 	return led_module_get(led_dev);
 }
-- 
2.43.0



