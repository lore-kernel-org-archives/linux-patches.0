Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E786FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C657C433CD;
	Sun, 17 Sep 2023 20:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982690;
	bh=p0ZewTQoaaLjtbAlbhx/Izk4prT5Dxm9vyRoqQFEmCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cb1ePaz9x5knOoUS00tcgoS6DVXzuPAAL+JEYWXipJFf0IqTagfCG+reDpUgcdP74
	 nVOHDMRaOaHCkYNkI/K8h1S/0n/AnzYEhQStGZPn0y/heMnyv0vQ6Kvi33MFA1WhN+
	 7gPeBF6rIKPkdCkpkk9nCQ4y3ABx9hUwzSENNimw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/511] leds: multicolor: Use rounded division when calculating color components
Date: Sun, 17 Sep 2023 21:12:14 +0200
Message-ID: <20230917191121.241419653@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 065d099f1be58187e6629273c50b948a02b7e1bf ]

Given channel intensity, LED brightness and max LED brightness, the
multicolor LED framework helper led_mc_calc_color_components() computes
the color channel brightness as

    chan_brightness = brightness * chan_intensity / max_brightness

Consider the situation when (brightness, intensity, max_brightness) is
for example (16, 15, 255), then chan_brightness is computed to 0
although the fractional divison would give 0.94, which should be rounded
to 1.

Use DIV_ROUND_CLOSEST here for the division to give more realistic
component computation:

    chan_brightness = DIV_ROUND_CLOSEST(brightness * chan_intensity,
                                        max_brightness)

Fixes: 55d5d3b46b08 ("leds: multicolor: Introduce a multicolor class definition")
Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://lore.kernel.org/r/20230801124931.8661-1-kabel@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class-multicolor.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/led-class-multicolor.c b/drivers/leds/led-class-multicolor.c
index e317408583df9..ec62a48116135 100644
--- a/drivers/leds/led-class-multicolor.c
+++ b/drivers/leds/led-class-multicolor.c
@@ -6,6 +6,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/led-class-multicolor.h>
+#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -19,9 +20,10 @@ int led_mc_calc_color_components(struct led_classdev_mc *mcled_cdev,
 	int i;
 
 	for (i = 0; i < mcled_cdev->num_colors; i++)
-		mcled_cdev->subled_info[i].brightness = brightness *
-					mcled_cdev->subled_info[i].intensity /
-					led_cdev->max_brightness;
+		mcled_cdev->subled_info[i].brightness =
+			DIV_ROUND_CLOSEST(brightness *
+					  mcled_cdev->subled_info[i].intensity,
+					  led_cdev->max_brightness);
 
 	return 0;
 }
-- 
2.40.1



