Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9ED2566;
	Thu, 13 Jun 2024 12:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282996; cv=none; b=por9c0v5m7rLUXjH1Xrw0jgMWGDHZ0rur9w2JJkU2rJDVTY+dzsHie8Yxj68zpNbtkAZLw1r5lgQVYea6lQqrrLJXPLsi6ISm5DCvYXTvEi6rc7IVK9wrmv8ljwBbKdKfsdlB6xOQHPLCzL1XtFxqL7sNnSZdGdVVhra3ti8aoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282996; c=relaxed/simple;
	bh=CsV2aKm0CM/UzxeVu5o9SvsoXBMJYK0bkVtIjUONR5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1C6CmRSouxcdMePZkjycasma+VRjlv+VHbv+3C8fEzoJ6gjUdsgVrAhOb6rK9tVVKvRhHjsFv3rr/0Ab3cRc2qAMkEfN9PZf4cISf9PEdj1aLrqPobvx1K5WKBDRQNOLqv4X0EWWsFzi0nuSptFrnvxgK1cQJP3okPHyog4tuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebvBPmwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebvBPmwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8489C2BBFC;
	Thu, 13 Jun 2024 12:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282996;
	bh=CsV2aKm0CM/UzxeVu5o9SvsoXBMJYK0bkVtIjUONR5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebvBPmwPykEO8DHivCRpBqCiX1tl5K49gmeQNzT7kOd/iHGb7b+m1x9xJ8Va5G85E
	 Sg6ll/JUFYuE8M7t+24rMNPon4AoGSXau/PQxQSQSqxstdRJUlayMU+RfgcvjTarHS
	 +tJhuTT32UD7gK6ZbM/Nv3JbPAYBQwrMxRfKhMJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 6.1 64/85] watchdog: rti_wdt: Set min_hw_heartbeat_ms to accommodate a safety margin
Date: Thu, 13 Jun 2024 13:36:02 +0200
Message-ID: <20240613113216.608088401@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit cae58516534e110f4a8558d48aa4435e15519121 upstream.

On AM62x, the watchdog is pet before the valid window is open. Fix
min_hw_heartbeat and accommodate a 2% + static offset safety margin.
The static offset accounts for max hardware error.

Remove the hack in the driver which shifts the open window boundary,
since it is no longer necessary due to the fix mentioned above.

cc: stable@vger.kernel.org
Fixes: 5527483f8f7c ("watchdog: rti-wdt: attach to running watchdog during probe")
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240417205700.3947408-1-jm@ti.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/rti_wdt.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -52,6 +52,8 @@
 
 #define DWDST			BIT(1)
 
+#define MAX_HW_ERROR		250
+
 static int heartbeat = DEFAULT_HEARTBEAT;
 
 /*
@@ -90,7 +92,7 @@ static int rti_wdt_start(struct watchdog
 	 * to be 50% or less than that; we obviouly want to configure the open
 	 * window as large as possible so we select the 50% option.
 	 */
-	wdd->min_hw_heartbeat_ms = 500 * wdd->timeout;
+	wdd->min_hw_heartbeat_ms = 520 * wdd->timeout + MAX_HW_ERROR;
 
 	/* Generate NMI when wdt expires */
 	writel_relaxed(RTIWWDRX_NMI, wdt->base + RTIWWDRXCTRL);
@@ -124,31 +126,33 @@ static int rti_wdt_setup_hw_hb(struct wa
 	 * be petted during the open window; not too early or not too late.
 	 * The HW configuration options only allow for the open window size
 	 * to be 50% or less than that.
+	 * To avoid any glitches, we accommodate 2% + max hardware error
+	 * safety margin.
 	 */
 	switch (wsize) {
 	case RTIWWDSIZE_50P:
-		/* 50% open window => 50% min heartbeat */
-		wdd->min_hw_heartbeat_ms = 500 * heartbeat;
+		/* 50% open window => 52% min heartbeat */
+		wdd->min_hw_heartbeat_ms = 520 * heartbeat + MAX_HW_ERROR;
 		break;
 
 	case RTIWWDSIZE_25P:
-		/* 25% open window => 75% min heartbeat */
-		wdd->min_hw_heartbeat_ms = 750 * heartbeat;
+		/* 25% open window => 77% min heartbeat */
+		wdd->min_hw_heartbeat_ms = 770 * heartbeat + MAX_HW_ERROR;
 		break;
 
 	case RTIWWDSIZE_12P5:
-		/* 12.5% open window => 87.5% min heartbeat */
-		wdd->min_hw_heartbeat_ms = 875 * heartbeat;
+		/* 12.5% open window => 89.5% min heartbeat */
+		wdd->min_hw_heartbeat_ms = 895 * heartbeat + MAX_HW_ERROR;
 		break;
 
 	case RTIWWDSIZE_6P25:
-		/* 6.5% open window => 93.5% min heartbeat */
-		wdd->min_hw_heartbeat_ms = 935 * heartbeat;
+		/* 6.5% open window => 95.5% min heartbeat */
+		wdd->min_hw_heartbeat_ms = 955 * heartbeat + MAX_HW_ERROR;
 		break;
 
 	case RTIWWDSIZE_3P125:
-		/* 3.125% open window => 96.9% min heartbeat */
-		wdd->min_hw_heartbeat_ms = 969 * heartbeat;
+		/* 3.125% open window => 98.9% min heartbeat */
+		wdd->min_hw_heartbeat_ms = 989 * heartbeat + MAX_HW_ERROR;
 		break;
 
 	default:
@@ -221,14 +225,6 @@ static int rti_wdt_probe(struct platform
 		return -EINVAL;
 	}
 
-	/*
-	 * If watchdog is running at 32k clock, it is not accurate.
-	 * Adjust frequency down in this case so that we don't pet
-	 * the watchdog too often.
-	 */
-	if (wdt->freq < 32768)
-		wdt->freq = wdt->freq * 9 / 10;
-
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {


