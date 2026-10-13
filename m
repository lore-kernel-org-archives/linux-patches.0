Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860944F4021;
	Tue, 13 Oct 2026 12:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895760; cv=none; b=DqMcAdEpNPAcoAYU6w4UqFHFSCbiiT5ayP743YCeEE9HxKcjWfePDBEcejKtJTz2SO44W/sq119/QKX2EmKuikb/gsJy36fHLZ+PR2RXnHf7yqdT/Lsyqm5d9B8d3U3M9CL0tAhef+Zi7lGpvPOe55bwIcuV5ayGgc2hq3n8QEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895760; c=relaxed/simple;
	bh=YwJi9tZ3T8dqyyehbjYvI5D0R9wZoNESatz4FI14lw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fm3O0+MToQfUCC16alVoGP1jv8Cg1o//k59n3rS4qPde2LUGnF8GAM1UsJGhCIST6AXhF7aVLmOtiGajEkUSKxanuhV85RpULFd4BGMT9S+qcVG3vE1BibPLbgdBWLWCQ5vhkmt7uQGRl+ytZNGrihyIWtO0vSSa+jfpx68e5Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dri9SZHg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dri9SZHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF19A1F0089F;
	Tue, 13 Oct 2026 12:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895758;
	bh=+HSDpBbRh397i+/xLpslxHsBIoB11L4RSqV2TG5FGPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dri9SZHgav+TtXAnLoLgGs0yRmAAiUeyRKNx14G3iDMBnp6xQOxjafRK5hAk64rbT
	 wqUQJ5xc+zB8l0Vcx9zuqsTnrgjWLU357Hzi0e8FE6n3TbBQ9HxYCyUkVYEN4PHePR
	 vwUUsByyeVPxldacai3YW6rnYmnXgWz19yLatjMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 384/497] gpio: xilinx: fix runtime PM leak on request error path
Date: Tue, 13 Oct 2026 13:39:11 +0200
Message-ID: <20261013112917.009268088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -292,14 +292,7 @@ static void xgpio_save_regs(struct xgpio
 
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


