Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF691DED7B;
	Tue,  8 Oct 2024 12:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392222; cv=none; b=qbn0XvHv14Hf6zPT4CqrE8ggozk9nOTEvyR+fiH6rFy0Py7t8RBG521K0JrdM7WteV4DinvxRDBwlb/nZQCOZrdnpLdH5qzgGEt4YdwxH6ZZOGALR/K7zgk3CfT9eTNUyGh2b6tVHpf/+y9v5a2GxIPSqyLdOYhVV/jWVIr1Bh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392222; c=relaxed/simple;
	bh=ew5fcnLKqxEdlr5G0XEznH1OcorBWPyIBrwMsjv/x1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qLW8z7xVonXtT3X6hP4bSfDdoxY6pAZ492HlLvIEpopAAIK4+ldv/9CeGgHrS6MHFvaMqv+KoxEr09TFNXaKuxKNIYthVxM9ShUbFE9qsZ2wboPw+elx/bGoa0pb75Jc5xwdcUOMZPpuVmfo5cPgsxPK9yY+9u1ry/qrwSWJxQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6Rh/o4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6Rh/o4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D60C4CECC;
	Tue,  8 Oct 2024 12:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392221;
	bh=ew5fcnLKqxEdlr5G0XEznH1OcorBWPyIBrwMsjv/x1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6Rh/o4/P3ki9m6ScngqhoOliAlWXWFdthJqorc0DB1Wb+HZsg3jVf5Twu1sOCxe5
	 ME/1m6SlefQ7ECZ5J20Wj6CBdtbcLddjT31TRBc2oh0yWd8DYpmKlYgx/tfm0upxcR
	 E+KsoVsS0anOpIg6377z8KaDfRi1PWCDQSc2Yx0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	=?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.11 352/558] media: i2c: ar0521: Use cansleep version of gpiod_set_value()
Date: Tue,  8 Oct 2024 14:06:22 +0200
Message-ID: <20241008115716.151684153@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <eagle.alexander923@gmail.com>

commit bee1aed819a8cda47927436685d216906ed17f62 upstream.

If we use GPIO reset from I2C port expander, we must use *_cansleep()
variant of GPIO functions.
This was not done in ar0521_power_on()/ar0521_power_off() functions.
Let's fix that.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 11 at drivers/gpio/gpiolib.c:3496 gpiod_set_value+0x74/0x7c
Modules linked in:
CPU: 0 PID: 11 Comm: kworker/u16:0 Not tainted 6.10.0 #53
Hardware name: Diasom DS-RK3568-SOM-EVB (DT)
Workqueue: events_unbound deferred_probe_work_func
pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : gpiod_set_value+0x74/0x7c
lr : ar0521_power_on+0xcc/0x290
sp : ffffff8001d7ab70
x29: ffffff8001d7ab70 x28: ffffff80027dcc90 x27: ffffff8003c82000
x26: ffffff8003ca9250 x25: ffffffc080a39c60 x24: ffffff8003ca9088
x23: ffffff8002402720 x22: ffffff8003ca9080 x21: ffffff8003ca9088
x20: 0000000000000000 x19: ffffff8001eb2a00 x18: ffffff80efeeac80
x17: 756d2d6332692f30 x16: 0000000000000000 x15: 0000000000000000
x14: ffffff8001d91d40 x13: 0000000000000016 x12: ffffffc080e98930
x11: ffffff8001eb2880 x10: 0000000000000890 x9 : ffffff8001d7a9f0
x8 : ffffff8001d92570 x7 : ffffff80efeeac80 x6 : 000000003fc6e780
x5 : ffffff8001d91c80 x4 : 0000000000000002 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000001
Call trace:
 gpiod_set_value+0x74/0x7c
 ar0521_power_on+0xcc/0x290
...

Signed-off-by: Alexander Shiyan <eagle.alexander923@gmail.com>
Fixes: 852b50aeed15 ("media: On Semi AR0521 sensor driver")
Cc: stable@vger.kernel.org
Acked-by: Krzysztof Hałasa <khalasa@piap.pl>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ar0521.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ar0521.c
+++ b/drivers/media/i2c/ar0521.c
@@ -844,7 +844,8 @@ static int ar0521_power_off(struct devic
 	clk_disable_unprepare(sensor->extclk);
 
 	if (sensor->reset_gpio)
-		gpiod_set_value(sensor->reset_gpio, 1); /* assert RESET signal */
+		/* assert RESET signal */
+		gpiod_set_value_cansleep(sensor->reset_gpio, 1);
 
 	for (i = ARRAY_SIZE(ar0521_supply_names) - 1; i >= 0; i--) {
 		if (sensor->supplies[i])
@@ -878,7 +879,7 @@ static int ar0521_power_on(struct device
 
 	if (sensor->reset_gpio)
 		/* deassert RESET signal */
-		gpiod_set_value(sensor->reset_gpio, 0);
+		gpiod_set_value_cansleep(sensor->reset_gpio, 0);
 	usleep_range(4500, 5000); /* min 45000 clocks */
 
 	for (cnt = 0; cnt < ARRAY_SIZE(initial_regs); cnt++) {


