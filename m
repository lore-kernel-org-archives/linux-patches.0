Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBC85012A9;
	Tue, 13 Oct 2026 12:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892938; cv=none; b=KGRKbB83Tn+DEjj2bJ66L9HwuDWsNhsImMWHjuUSqmjo2aKwqv7MMnJfRTr0jNS282haLDROOzDWDXOw7PFZTW1zgBq3kbnFSD6OnFpC0TkHxQ6HM1V85Vzm10W2SPrIrhyE3zi0lC8relMhk9rWHcCc/QAmb3ce/wUT4Khhi9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892938; c=relaxed/simple;
	bh=K/qgeUYu2+stxC1+EXHZeglOr/iA7B9B+qkUGYR+0l4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOanxlXRuomyFIEzwAHIXhfXkpJXa2qpQBfFYly+rd1uahhwhPtmMYo/aamkMcO9p73X4NHRyCLVcuq+9dvomUj5ZdgI0pLLzN+uP0B40jG0O3C/e6KrDf9DT89QTCzWm5GZBnfHdahQVAhxZQCfJy1pd+kbbv01SkKbHWgGPkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/5q3hdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/5q3hdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672921F000FF;
	Tue, 13 Oct 2026 12:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892937;
	bh=aeVeAvgPMv0fHrbPcWqgiHzYO6gUV1Cyzcc8SCeSTTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/5q3hdhQP5T8e4OakyfueD3mdBYrSz069yS88K87IBnFHxFBBHVBQNlhz/R4SAtZ
	 yWr0Gv/qlImEH4aO2gyxOdcsZKdePU0ZWSbpZzwIKYUSBh140sPQyILg9X16d+Odr+
	 1mTYogp7HHG5nDwe0bEsg+XHnWO/7YzeIAOUdBpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 056/621] gpio: xilinx: fix runtime PM leak on request error path
Date: Tue, 13 Oct 2026 13:30:51 +0200
Message-ID: <20261013112922.193268575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

commit ff82fc3a4a1d417dee1229681cc5285986edb1fa upstream.

pm_runtime_get_sync() leaves the usage counter incremented even when it
fails, and xgpio_request() returns the error without dropping it.

gpiolib does not call ->free() when ->request() fails, so xgpio_free(),
which holds the only matching pm_runtime_put(), never runs. The reference
is leaked and the controller can no longer runtime-suspend, so its clock
stays enabled.

Switch to pm_runtime_resume_and_get(), which only increments the usage
counter on success.

Fixes: 26b04774621e ("gpio: gpio-xilinx: Add support for suspend and resume")
Cc: stable@vger.kernel.org
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260923113905.1409290-1-khurana.ridham222@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-xilinx.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -271,14 +271,7 @@ static void xgpio_save_regs(struct xgpio
 
 static int xgpio_request(struct gpio_chip *chip, unsigned int offset)
 {
-	int ret;
-
-	ret = pm_runtime_get_sync(chip->parent);
-	/*
-	 * If the device is already active pm_runtime_get() will return 1 on
-	 * success, but gpio_request still needs to return 0.
-	 */
-	return ret < 0 ? ret : 0;
+	return pm_runtime_resume_and_get(chip->parent);
 }
 
 static void xgpio_free(struct gpio_chip *chip, unsigned int offset)


