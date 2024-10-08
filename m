Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E871DF96C;
	Tue,  8 Oct 2024 13:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393874; cv=none; b=Yg8hzQ9Fp/39Uu/Grn4LZZP5mE3uzQwVBDrYoQcb3HEpx6g9Etrfppg7QcSKTEzHw/ZtrWOj3H6Q5nThK/nCf+hf9O/xz5WxhPhNKQ1gKM0D9a/2rETX4Hms++zjKl43aIp3KnDR1rn/tSjYPj1aViXYtLYrSjh9XauDN6CjPRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393874; c=relaxed/simple;
	bh=0Foy6w7OlhKsTSpezmOEhr2xwkrj++HgNnEY7c62LnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwiQ6nXx9PIib3Pq05ZIk+ZB00OrdGvwafaevqFdMjEHtDd00Wr6JY9kaLLF3COrggZesoB1fBGkfgp9Cg/hFUOYST8ecEeX5LBM6vGX9aGGccxIIyh4/hUlkqHExRzrx7UW3N8QGs+LOYMnpJFhEi9gEZ6HoC1U04NImhTrJm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4wOyob2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4wOyob2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B71DC4AF09;
	Tue,  8 Oct 2024 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393874;
	bh=0Foy6w7OlhKsTSpezmOEhr2xwkrj++HgNnEY7c62LnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4wOyob2hQt3ccOsC7FO0GbSP8K3Qh+8bcbyevG50d/8oBGUX0p/9Jv8RvvtJouVN
	 tUpn5j0I6CuxTp3rgY9vYsmcE4IV5r9pNWZDra1fO4IEwE2ECjc8Orkfwrovnrhd2o
	 8wKoLo1R+CZGmZxwqK2Uu99SgczwrHwysJyIHHAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 279/386] media: ov5675: Fix power on/off delay timings
Date: Tue,  8 Oct 2024 14:08:44 +0200
Message-ID: <20241008115640.367342812@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 719ec29fceda2f19c833d2784b1574638320400f upstream.

The ov5675 specification says that the gap between XSHUTDN deassert and the
first I2C transaction should be a minimum of 8192 XVCLK cycles.

Right now we use a usleep_rage() that gives a sleep time of between about
430 and 860 microseconds.

On the Lenovo X13s we have observed that in about 1/20 cases the current
timing is too tight and we start transacting before the ov5675's reset
cycle completes, leading to I2C bus transaction failures.

The reset racing is sometimes triggered at initial chip probe but, more
usually on a subsequent power-off/power-on cycle e.g.

[   71.451662] ov5675 24-0010: failed to write reg 0x0103. error = -5
[   71.451686] ov5675 24-0010: failed to set plls

The current quiescence period we have is too tight. Instead of expressing
the post reset delay in terms of the current XVCLK this patch converts the
power-on and power-off delays to the maximum theoretical delay @ 6 MHz with
an additional buffer.

1.365 milliseconds on the power-on path is 1.5 milliseconds with grace.
85.3 microseconds on the power-off path is 90 microseconds with grace.

Fixes: 49d9ad719e89 ("media: ov5675: add device-tree support and support runtime PM")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Tested-by: Quentin Schulz <quentin.schulz@cherry.de> # RK3399 Puma with
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov5675.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/media/i2c/ov5675.c
+++ b/drivers/media/i2c/ov5675.c
@@ -979,12 +979,10 @@ static int ov5675_set_stream(struct v4l2
 
 static int ov5675_power_off(struct device *dev)
 {
-	/* 512 xvclk cycles after the last SCCB transation or MIPI frame end */
-	u32 delay_us = DIV_ROUND_UP(512, OV5675_XVCLK_19_2 / 1000 / 1000);
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct ov5675 *ov5675 = to_ov5675(sd);
 
-	usleep_range(delay_us, delay_us * 2);
+	usleep_range(90, 100);
 
 	clk_disable_unprepare(ov5675->xvclk);
 	gpiod_set_value_cansleep(ov5675->reset_gpio, 1);
@@ -995,7 +993,6 @@ static int ov5675_power_off(struct devic
 
 static int ov5675_power_on(struct device *dev)
 {
-	u32 delay_us = DIV_ROUND_UP(8192, OV5675_XVCLK_19_2 / 1000 / 1000);
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct ov5675 *ov5675 = to_ov5675(sd);
 	int ret;
@@ -1021,8 +1018,11 @@ static int ov5675_power_on(struct device
 
 	gpiod_set_value_cansleep(ov5675->reset_gpio, 0);
 
-	/* 8192 xvclk cycles prior to the first SCCB transation */
-	usleep_range(delay_us, delay_us * 2);
+	/* Worst case quiesence gap is 1.365 milliseconds @ 6MHz XVCLK
+	 * Add an additional threshold grace period to ensure reset
+	 * completion before initiating our first I2C transaction.
+	 */
+	usleep_range(1500, 1600);
 
 	return 0;
 }


