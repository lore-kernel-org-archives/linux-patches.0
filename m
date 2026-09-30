Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BB04DDB2B;
	Wed, 30 Sep 2026 18:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793371; cv=none; b=Vpvwf5PL5Ftyf+ZY9RGT4ZJT7ofCr/AVX2xwDtw52CwFj9KtKe2NvArz4+bt4ZEEKK1eA6N/Y+9O54y5GSI30Bg6HtL9xxqw6Bz9J5GiYQOmCC9wC2gKuIvFV8bt4qQ0PG0PaIyp2ooAXonB4tCBxOBOM1MK8bvBK7Bh5MKibF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793371; c=relaxed/simple;
	bh=68/hh5EPu9MMarNMnx10woYU3PyFbjQP4M6bCt3aMhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkkUpj48Jgn08MxWwqTIji4uyg3DeU4YcmOdV2W2kH2lFlHx8xiC56YQRhg1V1F1tgiJ8VmRyt2H3Y7ICnd+Kv6Lwe491FpdJd2lb8P+ldYaDdtD5+PJ0ByVXKhqxYh5JW2OXTkPd2iccg0wGC1D1BwSjLjPcEQdwsfB+kVdQJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/i4aHS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/i4aHS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B6D1F000FF;
	Wed, 30 Sep 2026 18:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793370;
	bh=x/kugozp9ZDhsKLsxeW/GwMfQR/JTOPjgNDDyMMJ6us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/i4aHS1tmBoprSQEmSlxWHGh9yBKgOZxfvbjv299ysYIduq17jbkCmrp0CuFpj2f
	 MVhYGWmKDddRouMvJS/4NcN6PIv4nkGVLdKz6rkJ1aH3MDGelt5MKNkoKHjDWUhsFH
	 df46dq2ek1Sn8fRTQoDU+Wk9KpeKj8C0StT7Jzd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 232/395] gpio: zynq: fix runtime PM leak on request error path
Date: Wed, 30 Sep 2026 17:28:14 +0200
Message-ID: <20260930152345.695468257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Ridham Khurana <khurana.ridham222@gmail.com>

commit e9438ab5328a177c9c0e5df87eb92a7162841e98 upstream.

pm_runtime_get_sync() leaves the usage counter incremented even when it
fails, and zynq_gpio_request() returns the error without dropping it.

gpiolib does not call ->free() when ->request() fails, so zynq_gpio_free(),
which holds the only matching pm_runtime_put(), never runs. The reference
is leaked and the controller can no longer runtime-suspend, so its clock
stays enabled.

Switch to pm_runtime_resume_and_get(), which only increments the usage
counter on success.

Fixes: 3242ba117e9b ("gpio: Add driver for Zynq GPIO controller")
Cc: stable@vger.kernel.org
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260922092102.1053513-1-khurana.ridham222@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-zynq.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -797,15 +797,7 @@ static int __maybe_unused zynq_gpio_runt
 
 static int zynq_gpio_request(struct gpio_chip *chip, unsigned int offset)
 {
-	int ret;
-
-	ret = pm_runtime_get_sync(chip->parent);
-
-	/*
-	 * If the device is already active pm_runtime_get() will return 1 on
-	 * success, but gpio_request still needs to return 0.
-	 */
-	return ret < 0 ? ret : 0;
+	return pm_runtime_resume_and_get(chip->parent);
 }
 
 static void zynq_gpio_free(struct gpio_chip *chip, unsigned int offset)


