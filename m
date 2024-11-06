Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDBA1DF24A;
	Wed,  6 Nov 2024 12:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894863; cv=none; b=K1hMHK0gpURF2m7q6u33zR8cR1aKbQNWL24cF6OtmZcr+7fwW7TJM/oGhYIIFWLKYtw6F1YpbLx6hUQj0209p0Lt3i4ipV4PAC0IBC1YjxCVjHxTp2qgaGytDEA/8x93kp1iZwp4o7JClgFXbP9NBz4+gIK1FScXARzC8/pclM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894863; c=relaxed/simple;
	bh=LwboW90aKy9PgooDhS/BCHWORXxgzKXz4ailNfmeoBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWpKwnvd6gXJPmsbxQX12626pA9r7cnqfw/JEXpW7itosNkxyEeq0i1FYyEmNPrKnT7gIyYMhqTYyhON6zkPBlYSrrfTyA7xGp6BpZkFp71IQPNLl+dsLsYG3UvphiHvBwH31/FTU4VJNyVny9AE3p6HLd4u59FBMieQUe8XAb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVS3MWbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVS3MWbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19045C4CECD;
	Wed,  6 Nov 2024 12:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894863;
	bh=LwboW90aKy9PgooDhS/BCHWORXxgzKXz4ailNfmeoBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVS3MWbVXiSoE+oZ4B6Y4pwy6qYJweXp+X+GYxxyIH5v/dBIf+4yZ+pOEfRDwSa0u
	 Ng9uTmcjjvn6SDzs6aWJLsWA0MdopJHZOH0gEL+S63OszGK8SousB5vgpfE+x42iD6
	 MNjEsoao4HeVTyKk/Koekyohy/gaahYG+YLFBVWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 4.19 026/350] gpio: prevent potential speculation leaks in gpio_device_get_desc()
Date: Wed,  6 Nov 2024 12:59:14 +0100
Message-ID: <20241106120321.523895514@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3,6 +3,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/nospec.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/device.h>
@@ -144,7 +145,7 @@ struct gpio_desc *gpiochip_get_desc(stru
 	if (hwnum >= gdev->ngpio)
 		return ERR_PTR(-EINVAL);
 
-	return &gdev->descs[hwnum];
+	return &gdev->descs[array_index_nospec(hwnum, gdev->ngpio)];
 }
 
 /**


