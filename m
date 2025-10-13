Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6BB2EC574;
	Mon, 13 Oct 2025 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369391; cv=none; b=THJfWIfo0EY95gdzboHmPirXCow4KWgjwAuq2Q3WDf33oB0hQTiLIICJKJ5pZrvL2wiVV2UQWnJ2X3wJqrw/AlsSCyRfGwD+ovXYvsNZu6Aslrqq8/9vyrelFQEJHK/7Kj1iPqY/B9Lq/JnlpNrVFJgd8AjLmcdN487v7G8PCGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369391; c=relaxed/simple;
	bh=pwREantXKAnZTcXuW40by7AoC4n/imnMyjBNQK7w+q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Utv3u31Oe09zvWYVHSLO/By38vFeyY6QzjNZGqTDfuyTN8nYLp5eYEnNTqPXIC/8v/vp43mosZll+lLBBqHosq6WutENUOKlOsKhQB+wfERK9OTW14HPdIBWA2PKj8/xtAIkgnj7+RLT+a8itUsQ2SIVt6xPvnFdHm73yVrFF+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxM4z/C9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxM4z/C9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45791C4CEE7;
	Mon, 13 Oct 2025 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369390;
	bh=pwREantXKAnZTcXuW40by7AoC4n/imnMyjBNQK7w+q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxM4z/C9aa2W7Hgz625rnHN7OVmdMMkjh6FskB8Mv9fH9LBRTWiyT6HwKa3E53+Zg
	 DHeAjl1J325S7oKUXSubMRFS+7edj6DkPlbW16g4nISkG4EWT2UC6hKC/Y6Xve/y5Q
	 NCgSKmDeLoyTaRCkknLJL0DSWYtbnVno7XVUUgqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 228/563] wifi: rtw88: Lock rtwdev->mutex before setting the LED
Date: Mon, 13 Oct 2025 16:41:29 +0200
Message-ID: <20251013144419.540859561@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 26a8bf978ae9cd7688af1d08bc8760674d372e22 ]

Some users report that the LED blinking breaks AP mode somehow. Most
likely the LED code and the dynamic mechanism are trying to access the
hardware registers at the same time. Fix it by locking rtwdev->mutex
before setting the LED and unlocking it after.

Fixes: 4b6652bc6d8d ("wifi: rtw88: Add support for LED blinking")
Closes: https://github.com/lwfinger/rtw88/issues/305
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/ed69fa07-8678-4a40-af44-65e7b1862197@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/led.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/led.c b/drivers/net/wireless/realtek/rtw88/led.c
index 25aa6cbaa7286..7f9ace351a5b7 100644
--- a/drivers/net/wireless/realtek/rtw88/led.c
+++ b/drivers/net/wireless/realtek/rtw88/led.c
@@ -6,13 +6,23 @@
 #include "debug.h"
 #include "led.h"
 
-static int rtw_led_set_blocking(struct led_classdev *led,
-				enum led_brightness brightness)
+static void rtw_led_set(struct led_classdev *led,
+			enum led_brightness brightness)
 {
 	struct rtw_dev *rtwdev = container_of(led, struct rtw_dev, led_cdev);
 
+	mutex_lock(&rtwdev->mutex);
+
 	rtwdev->chip->ops->led_set(led, brightness);
 
+	mutex_unlock(&rtwdev->mutex);
+}
+
+static int rtw_led_set_blocking(struct led_classdev *led,
+				enum led_brightness brightness)
+{
+	rtw_led_set(led, brightness);
+
 	return 0;
 }
 
@@ -37,7 +47,7 @@ void rtw_led_init(struct rtw_dev *rtwdev)
 		return;
 
 	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE)
-		led->brightness_set = rtwdev->chip->ops->led_set;
+		led->brightness_set = rtw_led_set;
 	else
 		led->brightness_set_blocking = rtw_led_set_blocking;
 
-- 
2.51.0



