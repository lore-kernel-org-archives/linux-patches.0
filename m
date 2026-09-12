Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1750C38B15B;
	Sat, 12 Sep 2026 19:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242477; cv=none; b=tG1WBeu6lArVnxQJN8L/1Q5M2vITbWAvnpb6YbSN0Ayu+lAxINwq46teBr1PpDPFU1S0P9+xnEhPLbKONqs2KUhlT1TnU3F1ganGcPp5rGGmw8BAv/aqVeOxetADf2ku9xzr097BuLSdiimHtiiD9AZaYqdXRDlnR4jdIB9Neak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242477; c=relaxed/simple;
	bh=s0KbhFBsgXEfNTpFayelGi+GU6PZYrM1VshJt+jjInU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZJm2dqyUiWTvrm0XIEbZsgR8BXLAWiLLUqBHC8Z2yDarm55uGIZB+b0tP/ffNEMqRTn6JfETD4VcNAZp+W+AuCtJ11OH7QTyF1U9R19RAX7P4rtL2ydtlIArhWofmOeeQ/c+nzk+ZGMHiIhyEj4WzhtoKEqlA8kusceR7nsrKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ0sUUwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ0sUUwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692721F000FF;
	Sat, 12 Sep 2026 19:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242476;
	bh=OrkA9eBqjaUWS/a681fR/nK6ser23HAVqxBfJF7pC9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZ0sUUwTqjFi1MnLNSf3hi4h2GinGRtqEfc8shLITygF4d0cJJ4V2GVer/pHzNq2v
	 swKd2mh9VGX6JRiCrtY0HgKup79JZwmvQJ8j4UD7OJvRfuz1dP3brXdUWZUqBfY7/j
	 cFmlikkhnt/sO182htMm9+lvILgpONuYWVm78xeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/798] driver core: platform: Emit a warning if a remove callback returned non-zero
Date: Sat, 12 Sep 2026 09:00:44 +0200
Message-ID: <20260912065526.686342466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <uwe@kleine-koenig.org>

[ Upstream commit e5e1c209788138f33ca6558bf9f572f6904f486d ]

The driver core ignores the return value of a bus' remove callback. However
a driver returning an error code is a hint that there is a problem,
probably a driver author who expects that returning e.g. -EBUSY has any
effect.

The right thing to do would be to make struct platform_driver::remove()
return void. With the immense number of platform drivers this is however a
big quest and I hope to prevent at least a few new drivers that return an
error code here.

Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
Link: https://lore.kernel.org/r/20210207211537.19992-1-uwe@kleine-koenig.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 589b9e6f96be ("usb: renesas_usbhs: Fix power-off ordering on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 90166535a5c05..d0b15cbab0ff0 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1305,13 +1305,16 @@ static int platform_remove(struct device *_dev)
 {
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
 	struct platform_device *dev = to_platform_device(_dev);
-	int ret = 0;
 
-	if (drv->remove)
-		ret = drv->remove(dev);
+	if (drv->remove) {
+		int ret = drv->remove(dev);
+
+		if (ret)
+			dev_warn(_dev, "remove callback returned a non-zero value. This will be ignored.\n");
+	}
 	dev_pm_domain_detach(_dev, true);
 
-	return ret;
+	return 0;
 }
 
 static void platform_shutdown(struct device *_dev)
-- 
2.53.0



