Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A144218C332;
	Wed, 30 Sep 2026 16:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787554; cv=none; b=SORw4OLF0QSYyzSfJkj7f7gmYL+XGGgujJlBe9Dp+2dUhPAo6nDvBh7FAQMiSyE/hy+gDvaLKdKQRC82qMxbpjxoSgPRoi0tFfDOvUbdnF5TLbRUp1WeCSWgDEHE748PuCgtkm+TYL1TcHKc2TSJubOcrX+VOy0oQFeGwTPU2pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787554; c=relaxed/simple;
	bh=VH8Y1EW/lVV4MYJYRG+W5SXYmiX8zJclNgWFXqsOvvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYTEDan/xqMJTxp0iAZ8aTipz/lYjpq/9jPQw+CWuBZu2XDJipSMoUXiTJYo+J0UH1fJac/5BEf8IqTwIRfgTqFHjRMZY661Iq5tGMdi5JQJYc3T5VdE2Lr1GQE8wplcUNzOrqPV6tZIMQnLZlaWlCpyp5btcT/vle7S0RaHbQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iERbi+N9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iERbi+N9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEE71F000FF;
	Wed, 30 Sep 2026 16:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787553;
	bh=QYoAiLHaOXs4N4wH/bDPQKXwM/8hpx1Vxzr1xa4ZvN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iERbi+N9f7vEPcemGWnXiWEfS3LClMfhk+XbpAXrotGT2dHRCkKFqBHPyZmUURjV1
	 RpB/4OzkOzun0gt4HMfoBwgq1oT5A7M4L4FOr3EyhzFluKU5/nIooD78RnYwsJEFnk
	 iZGaXTylSHFd83DELqUcVbsxaN6g6TdW2hOUeDrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 271/457] gpio: zynq: fix runtime PM leak on request error path
Date: Wed, 30 Sep 2026 17:26:16 +0200
Message-ID: <20260930152351.889781973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -798,15 +798,7 @@ static int zynq_gpio_runtime_resume(stru
 
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


