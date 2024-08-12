Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB561862B9;
	Mon, 12 Aug 2024 16:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479237; cv=none; b=J3WmLKwLRFNxLZLbVZKuL5HJMRrNFduJAsE0sj0R85Wm3PS531jkKFDEvSQ1CD1h6qTupWUtUDeyPwPb7Q//ZfANX6eMjQJ2DS1nj5HT1gclLIL1phVnRCxGu4NORovXI+md+uSTG7F9s9RawJC2dbsRfbuxdguNPrrKoXRJquY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479237; c=relaxed/simple;
	bh=BQtdDMPUb5eAD74pntuFlLk8A15OyyRk5xqP91DE1dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsCPYuNhI3997MYPfA6fG4OqgWkTFM7NttmDYkssj4cwfbJI9apewZF50V79mBLK8pRHnx8ZuZC52YvpS9yEmMd4kHSpyLXxAbebUfP/T/zYHCTR5ihF2rfsmo8UfpqNM59V9KXLW6MU6lG1IM20klmP9MF0+PFQjSCIg8sR89g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPpKRHI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPpKRHI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41442C32782;
	Mon, 12 Aug 2024 16:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479237;
	bh=BQtdDMPUb5eAD74pntuFlLk8A15OyyRk5xqP91DE1dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPpKRHI/ACHUPXEqofZVgqIDnx5JZZleEnawYwyWQCkJC6ZaA9Ys32JvGdUY1iXvM
	 dd7/F9bG0PVcM5hZE1kTMvOwOOMu7StoenKY0DRxWa8y3cD4gUYCglXhez7glJ3/zr
	 GMZgXKinAcqteY30Dj6sRRvM9TXKM9qQx4t2GcFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/189] gpio: prevent potential speculation leaks in gpio_device_get_desc()
Date: Mon, 12 Aug 2024 18:01:20 +0200
Message-ID: <20240812160133.075904228@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c512ed3fa6d9..5c0016c77d2ab 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/nospec.h>
 #include <linux/of.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/seq_file.h>
@@ -164,7 +165,7 @@ struct gpio_desc *gpiochip_get_desc(struct gpio_chip *gc,
 	if (hwnum >= gdev->ngpio)
 		return ERR_PTR(-EINVAL);
 
-	return &gdev->descs[hwnum];
+	return &gdev->descs[array_index_nospec(hwnum, gdev->ngpio)];
 }
 EXPORT_SYMBOL_GPL(gpiochip_get_desc);
 
-- 
2.43.0



