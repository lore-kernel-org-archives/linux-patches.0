Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ADF1E0480;
	Wed,  6 Nov 2024 12:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897812; cv=none; b=mh6ax7I2ab73eX1hiGsHDOKr+L5MgK3iemY53v4F+bFhA+wd0o6KxrOw+4BY+r6E94TPmjpgvwvJ69gcggj9eOFTar7zERSW2O1IyMvx0TIifC1oT5Ulbn8BEErwWjlN/KG/WpOg6LiEaUiWvcTzvwj2qW1m1LYW20AEDA0EgYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897812; c=relaxed/simple;
	bh=Acr3jF7H4+wF0v6pOLnm4PkiFvjRUih94BHZkU7ADiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dp1iWUdTkFj52W2Eml3h6yp5So7utcoHHq/qQtjHe46mFWwyYSW4PAtM1U3fF3AUJICQXOwhzF8Z0UAU8nK5B87rTZbipGte4G61av2JkM/TiEkJFpEcYKVhO+AHVxYXe8tYUieurE6oVglHsDON8BCe5NiM86JMxMKdzVX3Y6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDF4ZiAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDF4ZiAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEADC4CED3;
	Wed,  6 Nov 2024 12:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897812;
	bh=Acr3jF7H4+wF0v6pOLnm4PkiFvjRUih94BHZkU7ADiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDF4ZiAGVmxxfCxeMPxHS3o28oU2aZxdYb1UgCP1wqFSBMoOfCh7fCk/gIYdrhRWm
	 qM7/upWkIgldJgVeWvUg5JNaXntUGXl6EyiHFvKYwLBa145vXAstkF34VKuIlS1JHD
	 w8hpH1udpaTTfYdRvnz50OZeUi0ROIrT43cOco8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 5.4 027/462] gpio: prevent potential speculation leaks in gpio_device_get_desc()
Date: Wed,  6 Nov 2024 12:58:40 +0100
Message-ID: <20241106120332.187155596@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/nospec.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/device.h>
@@ -147,7 +148,7 @@ struct gpio_desc *gpiochip_get_desc(stru
 	if (hwnum >= gdev->ngpio)
 		return ERR_PTR(-EINVAL);
 
-	return &gdev->descs[hwnum];
+	return &gdev->descs[array_index_nospec(hwnum, gdev->ngpio)];
 }
 
 /**


