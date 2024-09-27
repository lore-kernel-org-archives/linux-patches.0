Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F82F1802AB;
	Fri, 27 Sep 2024 12:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440422; cv=none; b=It8bkLWkJwHk9tRRlfsGLvgsb/1leAlMiMm1Q4hAgLCVWxozXL2pzRCBjoWwxAk+YuB/C7fhc3eYiY5liKRKO0cbWzBWSdI0nhFtlWvHmJ6DVCXMW1HhmcRgpon92xNqE4ma3rlubvBSnRVJqEt5/BhIfmOkPDjA6uC5mlAt7jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440422; c=relaxed/simple;
	bh=7A6/bew5fxBibs7oda1oAaOcFyq6XfFNk9wNT+qw9Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKnG1ZABw34i1iuGKL3uHkCLqY67nVYXdOMdyhoMe+XuVlmHh9DntnYKkV6FqSI6rlI3z7sI6KyAxKCtqr0sEbfe+0KvlTG8DV2emoqpRc8/cCgE4WFOjbC3CBaUz9iY4s75QIV7elUfCMA3k7qwf+pudUqClypa5+GmctmaoiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHgTKVF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHgTKVF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCC6C4CEC4;
	Fri, 27 Sep 2024 12:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440422;
	bh=7A6/bew5fxBibs7oda1oAaOcFyq6XfFNk9wNT+qw9Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHgTKVF/PC47c0ty8Ya6Q7xOZ1qsGiaXJP5HhTOYZogLPgudN0achl4gWs9Kwk20w
	 WBBe/H6+IzSnZHhn1mh0P1bzJKuVMB+rIsg/uJQIu6EYHbwbmUWeYKk4rzmRltJjSq
	 7AFgCzeJV0p69ECVv1VAgxa6Kh7Kp2T8EI3apaeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 6.1 65/73] gpio: prevent potential speculation leaks in gpio_device_get_desc()
Date: Fri, 27 Sep 2024 14:24:16 +0200
Message-ID: <20240927121722.507885326@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hagar Hemdan <hagarhem@amazon.com>

commit d795848ecce24a75dfd46481aee066ae6fe39775 upstream.

Userspace may trigger a speculative read of an address outside the gpio
descriptor array.
Users can do that by calling gpio_ioctl() with an offset out of range.
Offset is copied from user and then used as an array index to get
the gpio descriptor without sanitization in gpio_device_get_desc().

This change ensures that the offset is sanitized by using
array_index_nospec() to mitigate any possibility of speculative
information leaks.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Link: https://lore.kernel.org/r/20240523085332.1801-1-hagarhem@amazon.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/nospec.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/device.h>
@@ -146,7 +147,7 @@ struct gpio_desc *gpiochip_get_desc(stru
 	if (hwnum >= gdev->ngpio)
 		return ERR_PTR(-EINVAL);
 
-	return &gdev->descs[hwnum];
+	return &gdev->descs[array_index_nospec(hwnum, gdev->ngpio)];
 }
 EXPORT_SYMBOL_GPL(gpiochip_get_desc);
 


