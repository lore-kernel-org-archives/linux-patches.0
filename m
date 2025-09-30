Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0342236EB;
	Tue, 30 Sep 2025 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244951; cv=none; b=ek6IHTepZetyBZb7d9EnLj19eejWBiVKoq7VSRusHpCixc29FQqeL9F3NbJwW4RoFekg6S0L3YCqQD7DPdji7GApnpooJgT4mqnTiwcV5pNg5r2Nuzvb7ldfIS7KEC4AJxXdD1YCLR4gPBlkFOisO8Pd6nfM6Xzb08Qqfn8nJI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244951; c=relaxed/simple;
	bh=f6Kkk6Unww2gEd6NQ+kWO+Z5YDGHy8GdGaqVtxQBCWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uEzT92br+by1AhJHzu4G6kyniocPztIhOwb5MqVbGD7I8iDz70573x1cb11jC0VFNW9H+crpLx76eyDjslLN1HA/gYrqBQXl8OK4vhQtY+JNvCF0SBw2xDRV6NcUif+M5MOIOEugLtV3GxRjR3SrZYi9WOtXi7VaUO3roJ0QkIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0BP72X2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0BP72X2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57074C4CEF0;
	Tue, 30 Sep 2025 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244951;
	bh=f6Kkk6Unww2gEd6NQ+kWO+Z5YDGHy8GdGaqVtxQBCWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0BP72X2EmWIXBQeq4JQZeKeIUlZHNgGuksyeqRDIQLaE85Gf9zh5yb1JOcBwJvpy
	 ac4zV39lG/lVf3jSVZIqlVOtpbCTnRt0KnKBzld5GnAr1+NnJvygBvO6AUV2OgIvq+
	 +VjvBHK1aH6Y4QJnhBbp+GpEIbKEi12roQm2OykY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/151] media: i2c: imx214: Fix link frequency validation
Date: Tue, 30 Sep 2025 16:45:36 +0200
Message-ID: <20250930143827.845344932@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Apitzsch <git@apitzsch.eu>

[ Upstream commit acc294519f1749041e1b8c74d46bbf6c57d8b061 ]

The driver defines IMX214_DEFAULT_LINK_FREQ 480000000, and then
IMX214_DEFAULT_PIXEL_RATE ((IMX214_DEFAULT_LINK_FREQ * 8LL) / 10),
which works out as 384MPix/s. (The 8 is 4 lanes and DDR.)

Parsing the PLL registers with the defined 24MHz input. We're in single
PLL mode, so MIPI frequency is directly linked to pixel rate.  VTCK ends
up being 1200MHz, and VTPXCK and OPPXCK both are 120MHz.  Section 5.3
"Frame rate calculation formula" says "Pixel rate
[pixels/s] = VTPXCK [MHz] * 4", so 120 * 4 = 480MPix/s, which basically
agrees with my number above.

3.1.4. MIPI global timing setting says "Output bitrate = OPPXCK * reg
0x113[7:0]", so 120MHz * 10, or 1200Mbit/s. That would be a link
frequency of 600MHz due to DDR.
That also matches to 480MPix/s * 10bpp / 4 lanes / 2 for DDR.

Keep the previous link frequency for backward compatibility.

Acked-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: André Apitzsch <git@apitzsch.eu>
Fixes: 436190596241 ("media: imx214: Add imx214 camera sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[ changed dev_err() to dev_err_probe() for the final error case ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx214.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/media/i2c/imx214.c
+++ b/drivers/media/i2c/imx214.c
@@ -20,7 +20,9 @@
 #include <media/v4l2-subdev.h>
 
 #define IMX214_DEFAULT_CLK_FREQ	24000000
-#define IMX214_DEFAULT_LINK_FREQ 480000000
+#define IMX214_DEFAULT_LINK_FREQ	600000000
+/* Keep wrong link frequency for backward compatibility */
+#define IMX214_DEFAULT_LINK_FREQ_LEGACY	480000000
 #define IMX214_DEFAULT_PIXEL_RATE ((IMX214_DEFAULT_LINK_FREQ * 8LL) / 10)
 #define IMX214_FPS 30
 #define IMX214_MBUS_CODE MEDIA_BUS_FMT_SRGGB10_1X10
@@ -892,17 +894,26 @@ static int imx214_parse_fwnode(struct de
 		goto done;
 	}
 
-	for (i = 0; i < bus_cfg.nr_of_link_frequencies; i++)
+	if (bus_cfg.nr_of_link_frequencies != 1)
+		dev_warn(dev, "Only one link-frequency supported, please review your DT. Continuing anyway\n");
+
+	for (i = 0; i < bus_cfg.nr_of_link_frequencies; i++) {
 		if (bus_cfg.link_frequencies[i] == IMX214_DEFAULT_LINK_FREQ)
 			break;
-
-	if (i == bus_cfg.nr_of_link_frequencies) {
-		dev_err(dev, "link-frequencies %d not supported, Please review your DT\n",
-			IMX214_DEFAULT_LINK_FREQ);
-		ret = -EINVAL;
-		goto done;
+		if (bus_cfg.link_frequencies[i] ==
+		    IMX214_DEFAULT_LINK_FREQ_LEGACY) {
+			dev_warn(dev,
+				 "link-frequencies %d not supported, please review your DT. Continuing anyway\n",
+				 IMX214_DEFAULT_LINK_FREQ);
+			break;
+		}
 	}
 
+	if (i == bus_cfg.nr_of_link_frequencies)
+		ret = dev_err_probe(dev, -EINVAL,
+				    "link-frequencies %d not supported, please review your DT\n",
+				    IMX214_DEFAULT_LINK_FREQ);
+
 done:
 	v4l2_fwnode_endpoint_free(&bus_cfg);
 	fwnode_handle_put(endpoint);


