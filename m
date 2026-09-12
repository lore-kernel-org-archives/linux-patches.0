Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DA53B6BE5;
	Sat, 12 Sep 2026 20:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243552; cv=none; b=dc6ENtVCfwddre8QchuaeCSJ8eZrTiJA8cjhWOarAg+TTsoFIOCUVHTzZ/A0jjZTr17I5i66muZMjfSH4fy6cEg5bQ3oX+kVbxGiGwPgQBFUGGOoNyZYCEh8L0cHm6FSFtK3kgdFpb+q9MxDlPVsz0NESzHqh1k0hwozlZpLLIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243552; c=relaxed/simple;
	bh=jvceBHqqyvhaZ7Ll1vAe89O581OSTLTOaOOtYb/9VqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ajXr7sczpRNGysspgmYvZz+4GfosZLIOWHGjilcEx1v/mjDHT5pIgXrrVrIZTOhbgaDZKctVpkVeSAtC2jGr9a7TFb4B+IkZECW+dkq5ksuncT+mJB9lfjpDU4An7RSwH/LqgQcRoQsS/5OAHVw2iXSf3nXITet+ejc+whxrrEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZoPYYM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZoPYYM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD241F00898;
	Sat, 12 Sep 2026 20:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243549;
	bh=T8IpnWt9N0Tj3vLyAkDxz1oEsIhE1PBjg4uhVl+li5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZoPYYM2PWaLayCGKzO8Qagu36PgqsBFYmcori7HF07mPQlrlOMPw9a/NEzdn5Pdj
	 MKNTuELB8YmiBTTLUJHJNez8LtV6zgw4/PQDDZGIK2v4pC+OqLh80RDSC5+QY3Awvu
	 7YEFzMHlJOtYPSjdVJ/CpydxDe5mY3yu0uhKlgh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.10 787/798] driver core: platform: dont oops in platform_shutdown() on unbound devices
Date: Sat, 12 Sep 2026 09:06:55 +0200
Message-ID: <20260912065535.102209704@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 46e85af0cc53f35584e00bb5db7db6893d0e16e5 upstream.

On shutdown the driver core calls the bus' shutdown callback also for
unbound devices. A driver's shutdown callback however is only called for
devices bound to this driver. Commit 9c30921fe799 ("driver core:
platform: use bus_type functions") changed the platform bus from driver
callbacks to bus callbacks, so the shutdown function must be prepared to
be called without a driver. Add the corresponding check in the shutdown
function.

Fixes: 9c30921fe799 ("driver core: platform: use bus_type functions")
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20201212235533.247537-1-dmitry.baryshkov@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/platform.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1321,9 +1321,13 @@ static int platform_remove(struct device
 
 static void platform_shutdown(struct device *_dev)
 {
-	struct platform_driver *drv = to_platform_driver(_dev->driver);
 	struct platform_device *dev = to_platform_device(_dev);
+	struct platform_driver *drv;
 
+	if (!_dev->driver)
+		return;
+
+	drv = to_platform_driver(_dev->driver);
 	if (drv->shutdown)
 		drv->shutdown(dev);
 }


