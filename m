Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF454F402A;
	Tue, 13 Oct 2026 11:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892085; cv=none; b=VKP+2Y534Lv/wQa37dFw9yghO66wly5E9CXcscVqWIQ654TLZOy+l1IelWqYdZ1vvgtcDzkTu04HXUPV61n8eyXO5t0/yA7fSf9zzlsnvpAE9u2Mn8XHULnddCSBQEVEft49/bnqCzXoiSpw6jfCrOE8AJlmWZ6AnfK+R+RiIiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892085; c=relaxed/simple;
	bh=hmktN1px2Qi9tOSlcLSlHk1GXFwXIjbRr6LyNdcxs3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jb35qJMvWXHZhqTUbkiQcPcrFXq03B1yf/XLfvzXV6ylb5rplBUAN9Ipxrc07N+fdrsUyuh0+20GR9qYKWpwWCQ/4IESM649OphFk0FzHeMZrTOEtItm4o/ZouQ4ObH8sGSJANJlWDApjciMFLaXjh7Rd53jQ75M0HZvvRyY2lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNYbKfWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNYbKfWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F37D1F000FF;
	Tue, 13 Oct 2026 11:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892084;
	bh=gly5hSckAkLbL5Mf6VyAIdRQqGjJoiSulYTrE1X60bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uNYbKfWydU2wNvBDDFxdL3pAqxI2Lwx8Me2Dl+dDDEiM1gcSRSi9V5PryCPc/eMVL
	 MSccvfphFAJYjEmlEVTUQIToCAaLKTg7AU7uzjZl4/pzywhtn/FUKud1eHxhaleZMv
	 yQLO0l6PrNENvhkdl5lTMUGFZLr8/IpSo/M08V2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 055/281] gpio: xilinx: fix runtime PM leak on request error path
Date: Tue, 13 Oct 2026 13:36:11 +0200
Message-ID: <20261013112856.386811653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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


