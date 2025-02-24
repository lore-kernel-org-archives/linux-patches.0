Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92F9282F0;
	Mon, 24 Feb 2025 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409209; cv=none; b=sKDYVlmCJm8ho4YCdSFjWcO8qsALoMWu9uHZUQH6+4/FWoo57kv7PLkF5RFYaeE0sInPei9u1P3HN/G2Q7I03MNz4QPDxAAj20Dnly23hog9x5HEx/hdyatgk54VGBfyYadLD9pTEyM2sbi38jokPGpA/nPMxP4yBPJMynVA7U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409209; c=relaxed/simple;
	bh=0hrYQq/1NYOjsFTHc14qV7K1SQtvcMywQnnYeVPb+gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ic53BdK3WgJoJEuS2OFnWiWcAqvYsvSfOHCmpasrJ4nHNBdwtmaMVKWKfe+ysChSo5eRQIod1H3J8mtJ8aC9QcGAkFIpeCK2pogDn6jgY44hP073XCRH8pV78TU9QJGXfqenMV410+DzOAxHLl0esUzqU656M68tyOFNu6HaDc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QM4BirN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QM4BirN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7A2C4CEE6;
	Mon, 24 Feb 2025 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409208;
	bh=0hrYQq/1NYOjsFTHc14qV7K1SQtvcMywQnnYeVPb+gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QM4BirN158Aw8vjjnGUezoS1wOiXxmCpyH0BQw6vgmsG86howUac3EYRI9Dmq2Prh
	 +0J6eQNhhAbhLWfbhoLkKKuPvuPg5eavIdX0ocXrL7jKClgugXkyrqq6Dbg0e1yRrn
	 CgXEf3iF4S4uMTrtPLiZKhy8ttGRDQ/hV8Kn74is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.13 097/138] gpiolib: check the return value of gpio_chip::get_direction()
Date: Mon, 24 Feb 2025 15:35:27 +0100
Message-ID: <20250224142608.291477818@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 9d846b1aebbe488f245f1aa463802ff9c34cc078 upstream.

As per the API contract - gpio_chip::get_direction() may fail and return
a negative error number. However, we treat it as if it always returned 0
or 1. Check the return value of the callback and propagate the error
number up the stack.

Cc: stable@vger.kernel.org
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250210-gpio-sanitize-retvals-v1-1-12ea88506cb2@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |   44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1057,8 +1057,11 @@ int gpiochip_add_data_with_key(struct gp
 		desc->gdev = gdev;
 
 		if (gc->get_direction && gpiochip_line_is_valid(gc, desc_index)) {
-			assign_bit(FLAG_IS_OUT,
-				   &desc->flags, !gc->get_direction(gc, desc_index));
+			ret = gc->get_direction(gc, desc_index);
+			if (ret < 0)
+				goto err_cleanup_desc_srcu;
+
+			assign_bit(FLAG_IS_OUT, &desc->flags, !ret);
 		} else {
 			assign_bit(FLAG_IS_OUT,
 				   &desc->flags, !gc->direction_input);
@@ -2728,13 +2731,18 @@ int gpiod_direction_input_nonotify(struc
 	if (guard.gc->direction_input) {
 		ret = guard.gc->direction_input(guard.gc,
 						gpio_chip_hwgpio(desc));
-	} else if (guard.gc->get_direction &&
-		  (guard.gc->get_direction(guard.gc,
-					   gpio_chip_hwgpio(desc)) != 1)) {
-		gpiod_warn(desc,
-			   "%s: missing direction_input() operation and line is output\n",
-			   __func__);
-		return -EIO;
+	} else if (guard.gc->get_direction) {
+		ret = guard.gc->get_direction(guard.gc,
+					      gpio_chip_hwgpio(desc));
+		if (ret < 0)
+			return ret;
+
+		if (ret != GPIO_LINE_DIRECTION_IN) {
+			gpiod_warn(desc,
+				   "%s: missing direction_input() operation and line is output\n",
+				    __func__);
+			return -EIO;
+		}
 	}
 	if (ret == 0) {
 		clear_bit(FLAG_IS_OUT, &desc->flags);
@@ -2771,12 +2779,18 @@ static int gpiod_direction_output_raw_co
 						 gpio_chip_hwgpio(desc), val);
 	} else {
 		/* Check that we are in output mode if we can */
-		if (guard.gc->get_direction &&
-		    guard.gc->get_direction(guard.gc, gpio_chip_hwgpio(desc))) {
-			gpiod_warn(desc,
-				"%s: missing direction_output() operation\n",
-				__func__);
-			return -EIO;
+		if (guard.gc->get_direction) {
+			ret = guard.gc->get_direction(guard.gc,
+						      gpio_chip_hwgpio(desc));
+			if (ret < 0)
+				return ret;
+
+			if (ret != GPIO_LINE_DIRECTION_OUT) {
+				gpiod_warn(desc,
+					   "%s: missing direction_output() operation\n",
+					   __func__);
+				return -EIO;
+			}
 		}
 		/*
 		 * If we can't actively set the direction, we are some


