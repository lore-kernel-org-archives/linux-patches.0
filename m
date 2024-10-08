Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D171D0BAA;
	Tue,  8 Oct 2024 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390570; cv=none; b=tzZ3CMfCHlMbEIWRVBwO25pQM7iFk9BL09wki4RmikyTow+6BtCn5AHGG3i4FJTj3tUDHuzodME0OP6wzG8AAWumlG/4En7rf76uOyUL0nJ7U7FBGbRWME2EqymaDA4Ilc1rqhu3lJYWFHAu0evr4uTjoMHKjvdTI77ql3WQdY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390570; c=relaxed/simple;
	bh=VwR5v8WrpYWqjWPXwzGg517Rw28jI9wAHFpq1vcsXW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ItpY4HUcQdWuUNb7yREhVB1rQnNr7ZJtvYD0K/WcXmfP8A+9b+tjKYjMOW0RdW7EwflzKVMHzgPdNqoW1sQ+qJtbnYVAXFmDm62je/Tf4E+hypiscwWYqeY8IgyqQRlDsBgyKF7ReQst1tN/Q/9M6I6NkakxHdFM2xpBy8SXbp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S17srnYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S17srnYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC554C4CEC7;
	Tue,  8 Oct 2024 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390570;
	bh=VwR5v8WrpYWqjWPXwzGg517Rw28jI9wAHFpq1vcsXW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S17srnYXLZ+npZaGcufbFvtweuRuAkwyOVyWLpkb5QmtalSgiLO+Gp5oCXyrfTWf2
	 gufeeEpjaAMZI0afNaU4grDunpva+vttczTjgKsFp11bvCnLG3YzwBRJ3FDMfyQH/e
	 jVyYR4PtBst47zyR59C3XDQC4q6yU2+PHFLKDbEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	=?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 295/482] media: i2c: ar0521: Use cansleep version of gpiod_set_value()
Date: Tue,  8 Oct 2024 14:05:58 +0200
Message-ID: <20241008115659.890780348@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


