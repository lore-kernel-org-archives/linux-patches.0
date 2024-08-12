Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D67183CA6;
	Mon, 12 Aug 2024 16:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479920; cv=none; b=g6X3YboBNPT9gyPFLRc60qKUMFbJxnGQDUw4phPICfG6jeUiOUqPeFzpj6IPCDz4HVQ4cNF8gEVV1YCfAyqd022aPQ+Qvdki00T/lAKHpmYO/v+TkreK4lT4oQs9zWzwOcb93cUb6WwbTlUtIvxDOcdiadYnx35/zdKjUPsaGbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479920; c=relaxed/simple;
	bh=dyRCGq7bJ795U+9VywL7/3YTkbbRD4Gmh1rG8ZfUYtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KknBo1Gl9jZjZgCzharH82xMS7kyLwtzXtbzgoNo7pCmF0OXStw4sBAJDYdHGvq5w4hQn5ZvIBQCynEMGKkfVlRgvGbkNi384UcfNIznaEssfVB1FqHuELy8oNzUglBUiTnC62lvlBkC2RjKtBebu7DzJnVbwwHx3t9mIFJN1b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrLei9Bh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrLei9Bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F76C32782;
	Mon, 12 Aug 2024 16:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479920;
	bh=dyRCGq7bJ795U+9VywL7/3YTkbbRD4Gmh1rG8ZfUYtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrLei9BhpO6duVckv5/O2O35RD8EpM7egeP89rzBKoVM6qHpWl4sfaScNU3/gHZe9
	 Ngt8RddYxMpX1oL/Io3wwL3JH7EGUl4iwE9uD6CTXz8BVfxl+3C3nPWScxSU1jHn6K
	 OEno5XI5u/JfS7vqGqiokbaMN+xdqklnbJG5WM1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 041/263] gpio: prevent potential speculation leaks in gpio_device_get_desc()
Date: Mon, 12 Aug 2024 18:00:42 +0200
Message-ID: <20240812160148.117238169@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hagar Hemdan <hagarhem@amazon.com>

[ Upstream commit d795848ecce24a75dfd46481aee066ae6fe39775 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index fa62367ee9290..1a9aadd4c803c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -17,6 +17,7 @@
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/module.h>
+#include <linux/nospec.h>
 #include <linux/of.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/seq_file.h>
@@ -198,7 +199,7 @@ gpio_device_get_desc(struct gpio_device *gdev, unsigned int hwnum)
 	if (hwnum >= gdev->ngpio)
 		return ERR_PTR(-EINVAL);
 
-	return &gdev->descs[hwnum];
+	return &gdev->descs[array_index_nospec(hwnum, gdev->ngpio)];
 }
 EXPORT_SYMBOL_GPL(gpio_device_get_desc);
 
-- 
2.43.0



