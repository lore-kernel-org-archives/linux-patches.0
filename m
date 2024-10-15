Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D761EF081;
	Tue, 15 Oct 2024 11:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992433; cv=none; b=BQlrRL/SL9/09PVcJKC/jSGbW+yht5aFsPR73yMChAcvyO+6ihTxso/zhfkCaNwI/AoUA+PdkxJXSGi7/9Jy8ubuGXleczvYYFMyd4/lhEqJXkYiDtcwEDynFtXkXWhjzBMVC2kpmWlKh7CAcigvE2Om7X6oTXlluJlAGYrZna4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992433; c=relaxed/simple;
	bh=4Lo4TzSTCA9IX7Blj/jYoRlxgYDwkU82GN7DEJM9cDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTMpDGx7rXn1nLzNk2C+8/mXzToQqsbXOgkpX8BWMyctATRLT641Rjz0UsYMn/JTy6qeUlciBFWMmxPLfzDZbzU/JQSuxHVxIlx9Iifn3HYFheo8HTGrWX/r4pvOfoGxMZJd3XdRFFYKOoB4HgVRMDLGAnZrL1nJX/HbPeAETy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmrC2Ocr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmrC2Ocr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D845C4CEC6;
	Tue, 15 Oct 2024 11:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992433;
	bh=4Lo4TzSTCA9IX7Blj/jYoRlxgYDwkU82GN7DEJM9cDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmrC2OcrB27pWU7ymBsHmk++g+U8anYvSmlhznk2fdTaMx+qdD4e87424AEW9WgwR
	 ozWmNPKH5EGfFMvlaE38MubEPAbf6fJE/bge6phLzTK5I7+xDF24U65cDZfnqUA5qJ
	 4Kxt1G6vivdueKvMf8rOWT2mTDWpu+h+eNQSvKz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hagar Hemdan <hagarhem@amazon.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 5.15 084/691] gpio: prevent potential speculation leaks in gpio_device_get_desc()
Date: Tue, 15 Oct 2024 13:20:32 +0200
Message-ID: <20241015112443.694082534@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


