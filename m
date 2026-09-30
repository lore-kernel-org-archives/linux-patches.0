Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C3151B196;
	Wed, 30 Sep 2026 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792685; cv=none; b=t+XbshvzrdEolRJJjDdyulYwjXSESGPbJbcmqphizTEC2wXrEtHpTLDD3WAWuFgJxRUOh8W1lvuVrjDNXCE4M1jNRTG7s/MpYSFHZ4poZU/2DOdtINyUqQ940Ef61JKumKUsW3BLLbiJHFSgvNEny+hPDqLzm3PutzGq7PzfAHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792685; c=relaxed/simple;
	bh=Sin/bEF/pjH41odPr/wgDLoujeE9elZzT4HTyJDlUX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbPPjoSXiwv04N2wqfcB+S2Ij3e1GlTtGW5YUSFv+CP3yXeMnc4i2DAs+iXFvo6wzx78+h/Ugv+4wUW/jagAwPQm6d+QF/DyiOCL7Sz6AxIivWwv86vOJu7Wqj7XjYYTVGltRxInuZbL9iz35XBcacsE4aUbNFWvsxZcAjWqE/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2V6WmX7h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2V6WmX7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26701F000FF;
	Wed, 30 Sep 2026 18:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792684;
	bh=4q8MY8vhbUnyCICzMXQ2IDMaeoLJuv98RqPKMTIA0Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2V6WmX7hnoXiPvyAaKEkyoHWe1SgmYzdwyFpkxT4733fDz6f4KkTjXoI8lq9ffPoX
	 an1I3tbdsaJjYAA+QmZA7EYQQctmucX01uMT6kKECyy1otEWbd4pfr6XeJCRyB9EwT
	 pNHd3Qm76bOQgku/SGfE08LxtL49S92uJs+3EmMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.15 705/752] gpio: zynq: fix runtime PM leak on request error path
Date: Wed, 30 Sep 2026 17:29:35 +0200
Message-ID: <20260930152413.487899189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -789,15 +789,7 @@ static int __maybe_unused zynq_gpio_runt
 
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


