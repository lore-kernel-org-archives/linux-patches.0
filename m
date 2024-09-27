Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE79718C009;
	Fri, 27 Sep 2024 12:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439989; cv=none; b=NKG3UZZO/zGSFfqnsFJTlg0DQKZdl1QUejCaG3jBkECyiNd0IcuqyasSGpMW5nR0XdpqL4LbfHHfuIi96AkW8PNYWN6DmMjEl+IcZGOcdP3oL4tL0ZPwXc9SSpTn6JN0wCqY5m2jb5QbBKBwLWX8t/6q/VezDuKG9b9TR6YUGbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439989; c=relaxed/simple;
	bh=7gGFpwwwQuGc/IOlQ5dGCVr8v6C/pkcTBLLeolsTda8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JftGAsTSKG5N/djjnmT4RT0FejYUa7TX8InI+UMCGUCFZBXYbc0YrT+mhq3yDBhxHBnrJ5WN6rhrmclfTJ0GKpiYG/yr3rOzZ4z3+Pa10wvRJn4YoVpEqw4iyOXIxajYFXBnKtNhw1RgzmTZODuz/twetwh72hR1OHG1UggjuNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3gp/v+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3gp/v+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCDFC4CEC4;
	Fri, 27 Sep 2024 12:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439989;
	bh=7gGFpwwwQuGc/IOlQ5dGCVr8v6C/pkcTBLLeolsTda8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3gp/v+hfweEFaUaZx4Ehd/TsTL+MhdBFzaPLqBo9dbBVO0OKB8UKDjVYQIBBRiPq
	 46BH9vuabKy6Fuo/sZnDbJOoCnUZl9zw4ba7Ys8epb1JSFM9FF0O9Boc1YTSf+I0ua
	 7bwAa/WsmjnTdL9MGjY7RuApoKy/cWIfXBbv3NBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 48/54] gpiolib: cdev: Ignore reconfiguration without direction
Date: Fri, 27 Sep 2024 14:23:40 +0200
Message-ID: <20240927121721.737636555@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

From: Kent Gibson <warthog618@gmail.com>

commit b440396387418fe2feaacd41ca16080e7a8bc9ad upstream.

linereq_set_config() behaves badly when direction is not set.
The configuration validation is borrowed from linereq_create(), where,
to verify the intent of the user, the direction must be set to in order to
effect a change to the electrical configuration of a line. But, when
applied to reconfiguration, that validation does not allow for the unset
direction case, making it possible to clear flags set previously without
specifying the line direction.

Adding to the inconsistency, those changes are not immediately applied by
linereq_set_config(), but will take effect when the line value is next get
or set.

For example, by requesting a configuration with no flags set, an output
line with GPIO_V2_LINE_FLAG_ACTIVE_LOW and GPIO_V2_LINE_FLAG_OPEN_DRAIN
set could have those flags cleared, inverting the sense of the line and
changing the line drive to push-pull on the next line value set.

Skip the reconfiguration of lines for which the direction is not set, and
only reconfigure the lines for which direction is set.

Fixes: a54756cb24ea ("gpiolib: cdev: support GPIO_V2_LINE_SET_CONFIG_IOCTL")
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Link: https://lore.kernel.org/r/20240626052925.174272-3-warthog618@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1565,12 +1565,14 @@ static long linereq_set_config_unlocked(
 		line = &lr->lines[i];
 		desc = lr->lines[i].desc;
 		flags = gpio_v2_line_config_flags(lc, i);
-		gpio_v2_line_config_flags_to_desc_flags(flags, &desc->flags);
-		edflags = flags & GPIO_V2_LINE_EDGE_DETECTOR_FLAGS;
 		/*
-		 * Lines have to be requested explicitly for input
-		 * or output, else the line will be treated "as is".
+		 * Lines not explicitly reconfigured as input or output
+		 * are left unchanged.
 		 */
+		if (!(flags & GPIO_V2_LINE_DIRECTION_FLAGS))
+			continue;
+		gpio_v2_line_config_flags_to_desc_flags(flags, &desc->flags);
+		edflags = flags & GPIO_V2_LINE_EDGE_DETECTOR_FLAGS;
 		if (flags & GPIO_V2_LINE_FLAG_OUTPUT) {
 			int val = gpio_v2_line_config_output_value(lc, i);
 
@@ -1578,7 +1580,7 @@ static long linereq_set_config_unlocked(
 			ret = gpiod_direction_output(desc, val);
 			if (ret)
 				return ret;
-		} else if (flags & GPIO_V2_LINE_FLAG_INPUT) {
+		} else {
 			ret = gpiod_direction_input(desc);
 			if (ret)
 				return ret;


