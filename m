Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4914FB9AF;
	Wed, 30 Sep 2026 16:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786646; cv=none; b=F07xk7CMF30Y4UR7U0hjl4EhPuCGPafcqvJ1wxzi8L3gOayNntNrnuDtlilP3xYfnX6TzsMWkJZP51Pe9YesroeH9bRXExRfl8072fGKVGf0tmw0XiX3l2gW1GamORNKH0FVbVcmAPf89WBTw+2gDJYa0NxZ2zBZEoG/b1R4d7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786646; c=relaxed/simple;
	bh=agvdR49b36uUIxl1rvfe3wlXk6Lq+ynXHGUwwP9rCVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvW7E1l072/OqBb1uAb8qsiEbdV1IWV0t1/8YAjpJJfPiTwXU8dzpSWCXMbgkirilefSmnUQ4W0ciCPby/UDpcnq8DI8kJ5ST1ERtTGvAzlihEsXgQE7ATUTrBnf9A2QbohxwG5TsprH47NNpXCPS8qfElxreJiC92vxxRso/Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Px3GnDVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Px3GnDVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0541F000FF;
	Wed, 30 Sep 2026 16:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786645;
	bh=rGbxMcNuETAMCs1efF62PCbIO3jWkyGfdOCwG2xNhrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Px3GnDVAN3JIHGH/msyZw07M9nkEpphnpRW8lSpscqTl4fTch1o/jeHkfSTwrx3fF
	 oKCr2+Y1IioBLDWUQZyhvbqelz2LgjHwnnygSVYGDHTwN22ARwjwVO9ttA5+9mP5s6
	 9YQz7//8NxBwYIJFSv8UO9PoS3MwnZS9KPK+Afdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.1 936/982] gpio: zynq: fix runtime PM leak on request error path
Date: Wed, 30 Sep 2026 17:27:52 +0200
Message-ID: <20260930152436.845966950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


