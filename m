Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C604C4F58;
	Wed, 30 Sep 2026 15:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783901; cv=none; b=DNwfzns6Jeu+f+bMnvuxRXmYBQPultsi1SWDG18sCFYM4YNFgdVNjGOsjfy+x7FrLQMCWs3Rz+6DOzZMCRO4A8s83o4tR0RrE+YrDw3zZlYiXYYXQbdE4yKgn1U+v4Uy6iQpr7TkvvN/4B3bd/HabYQYxaaxg+XGah/3hpCBvb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783901; c=relaxed/simple;
	bh=fSccKVqzINHYZN9bu7wpAYsEBPfQO1DERvgNgLjH93A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thPJUngxBkU4+jbBs4IZWUGCU6n3xvF+TixlahKRWRo1EsfTua7AZGjA5fWUWov2VVu+DWWNeQo88bAA/sUUE28iEzf38bD/VAxYsAvu0WnRAx4k2txnX/1lE0WpiZ/RM7rWk1k/lGisKPYWswwX3RyVKauxgkSYxGcZvwHPbW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQhG881k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQhG881k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E4C1F00898;
	Wed, 30 Sep 2026 15:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783895;
	bh=KtfS/Ck3p9h/G1Hh97UECjIAutOUYX3FY0hBgU8IpcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQhG881ksV33CA+891OiqsvAhpyrCfmxlLpqYTn/V5NuLwjYf358bZAWUyvM38Irb
	 Ndc5Wzfg2HkjcdEyz5HYfR7bOxr6Fi7rkFhNkmx3FnGXECO674Cdtdm4ZJX2h7ZbUZ
	 fSAqdWYD99S+PrYo8jqm4qRGSVHdUQcb+MJJGJ5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.10 561/595] gpio: zynq: fix runtime PM leak on request error path
Date: Wed, 30 Sep 2026 17:27:34 +0200
Message-ID: <20260930152359.788084601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -793,15 +793,7 @@ static int __maybe_unused zynq_gpio_runt
 
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


