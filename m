Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BD846C4B9;
	Tue, 21 Jul 2026 16:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649717; cv=none; b=ON4EL+4bHTzXCJ6zWyIj9Gsv7vJIpMB6SK59mr9rh89ZJ6dhxn4ATc/AvFbYsVhskwwedmjJnNDxTzNYr7nqeoJWtmoZ3/UsQcs71bKGfIYTuw/+q/UzUSnv898VwHOEzLhiGOQi5e45nQq3zdcD7ZhOWKOhcLy74Gigm5KEZJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649717; c=relaxed/simple;
	bh=aXUzyoFeH2gr8NHbE0kycalszapdk2+K+3VFckNaNvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjUIK/lseXF3tesSDPWaZy3z9C6ted4Kz8W2OoB3nDyTGkIoMfoLGrKjRotos3v+3QZm/JliEpDcEbGYeSojEQWZ7NOh70Kr6LosEF0paRP20GG6oKNhNoQrg/LDj5TyOw6K5W6gu85OTAFycTkMsyO3266qFMxNCkfnNTlMDoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKQfnkT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKQfnkT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778E41F00A3A;
	Tue, 21 Jul 2026 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649716;
	bh=avOEIrJt7BeQsX2b+EqUBoM9HGWgnG3bGeDepyqkMaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKQfnkT449pwT//EHjSHwyD/1BSkFS82TzMKjPBv9EFoyh3RRYDzr2EOcugTAjXKh
	 IMgXBWgb6c0E5+XOFNLf+ndFgC/71MKDuEQUryjD15E/0UMeajzp9a6QhjHyszmJa6
	 kFekqSz+m4qteuTCjUgdbokV9EEnehADfSrghfo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0644/2077] hwmon: (gpd-fan): Initialize EC before registering hwmon device
Date: Tue, 21 Jul 2026 17:05:17 +0200
Message-ID: <20260721152607.996456048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit a8a444917fe5d30a9787f41cc179f55fc5f559d3 ]

Move the gpd_init_ec() call to before devm_hwmon_device_register_with_info
in the probe function. With the previous ordering the hwmon device was
registered and exposed to userspace before the EC initialization
completes, creating a window where sysfs reads could return invalid values.

Some buggy firmware won't initialize EC properly on boot. Before its
initialization, reading RPM will always return 0, and writing PWM will have
no effect. So move gpd_init_ec to before hwmon device register.

Fixes: 0ab88e239439 ("hwmon: add GPD devices sensor driver")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/4be3734b135c8013157979ab5e80c7ee51243ddd.1781055639.git.xiaopei01@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 1fb4397509bd ("hwmon: (gpd-fan): fix race condition between device removal and sysfs access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpd-fan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hwmon/gpd-fan.c b/drivers/hwmon/gpd-fan.c
index 7284babd4f5c96..745b3fb9e3a49d 100644
--- a/drivers/hwmon/gpd-fan.c
+++ b/drivers/hwmon/gpd-fan.c
@@ -643,6 +643,7 @@ static int gpd_fan_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, data);
 
+	gpd_init_ec(data);
 	hwdev = devm_hwmon_device_register_with_info(dev,
 						     DRIVER_NAME,
 						     data,
@@ -651,9 +652,6 @@ static int gpd_fan_probe(struct platform_device *pdev)
 	if (IS_ERR(hwdev))
 		return dev_err_probe(dev, PTR_ERR(hwdev),
 				     "Failed to register hwmon device\n");
-
-	gpd_init_ec(data);
-
 	return 0;
 }
 
-- 
2.53.0



