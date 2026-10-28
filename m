Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211391;
	b=s1EhYOZkAbA3kQvq+ysdyH4rIOKG5or2yu0zwK+23puHiz3SLfQMS4LJHQti9cNMfWQm
	 4FIn/HK0YhAafeOAsdiGLKMuafr0n7C2cW5FyCSCPzrsqSzlG4jqaNK40NJSeKPiW3yRt
	 A+VGRP1UDbpWFBsNO6ld/6DL3bw0vVtClSZ+4kAb0GMYUXz8qQrw+sJ7tMoelKYDqeqrs
	 GsRd3Hv3Rb2HKefYFHdKOXW8ZA7eA4r4dU63H3L8ISnr4CejZDcJd8oHXrCUzG/wSiGSz
	 PgC/wxqDQPshJTQqwmqPDUQFMHgOc07QNH8Ig0h2Vf8L3af4EdUkVfF+uLtd7G3Qf2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iPJFOeH78+WbgGULD2lKEUtWdoPgs8/mVO83+JwA3sA=;
	b=X/CRnDIxlEBvbCRF5gdBaIh+GOq/E1i9wRwcrnue2jO2oF8+z4cs4rMcFnH1gng0Klw0
	 K+6d2sfk10n/MZrAOlAyIJD2llTUVt8Iy4DujFqiVzy/sr4Hl1jgbDOiaJqaIhkGfOurE
	 4fI3lkX5wPc0dBXffuLBHhDBa7wDoCJqnjpsmvDyqaDPfIBTElwzhmm6NLkdv9t7YZudl
	 5tEVQYTWdeq3oamaVqpkvSPxt0NuV4hffiNgSxhkgH6+wZ+lpwLGhmQCw3xrHkopKcIe3
	 cIMVWvdsG/6uRYTn937PZeYMFRMIVjXVSuyBDgY8kGTMqXe6omucC0trCRoYrON90jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t7umOvwZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6DE606A325;
	Wed, 28 Oct 2026 18:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t7umOvwZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0795C1F01825;
	Wed, 28 Oct 2026 18:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211390;
	bh=iPJFOeH78+WbgGULD2lKEUtWdoPgs8/mVO83+JwA3sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7umOvwZ7WkIfXHoUMo+AWDyTtgEGVGzkqp9SP+Cr6QeYj3LgQQK53OYOKCGpiJye
	 fD7H3Tf/3wx4DnCRyRgsoYF+k1MZtbrQbxcIwYAoHgUEjcZVo2UmaaqLVGSPGnJI/M
	 S/NBIlrGM/3RxJrXL8oMwMFz6dzv9jvFgos9Sabw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.15 359/571] gpio: xilinx: fix runtime PM leak on request error path
Date: Wed, 28 Oct 2026 17:58:26 +0100
Message-ID: <20261028170016.533473377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -291,14 +291,7 @@ static void xgpio_save_regs(struct xgpio
 
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


