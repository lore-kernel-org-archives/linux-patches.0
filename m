Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41E714B092;
	Thu, 17 Apr 2025 18:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915007; cv=none; b=XjmypKARXZu3v7Pxx79u6jJGYBOrzHu21FXkKEbz/YiYV/RGWxwi2xSRlstg5kl+tfj+yt1S1mEPiS1iLZqRWB2YTNL9l3U/tA8tuze8J3CiCqMcXL8EcGEkmmc8HGOGx1Vx3KeTWPoP/zGx56Yxdil7uRkYE4pxcn5F+GpJc+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915007; c=relaxed/simple;
	bh=0I1HML0aPwIseXLEKo2yrujIP2blfxvMyqIEt9jv8fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a11Q2PkpvrrToDoR9wM5QUrLBbAQqTE03CIPVpeyXkXC8iEf1GQG+N+1hxZT/UkzrGWZUHrK/s8aphENIlEdORs6eirXweaeXA/nfj+l6S3X5rqRYmNZ37E/FQ2sE3O+UtDX7j4ZQ38YD/lk9joMW8QZznpGRbXXpEsbsqpM424=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+GLgbcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+GLgbcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D43C4CEE4;
	Thu, 17 Apr 2025 18:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915007;
	bh=0I1HML0aPwIseXLEKo2yrujIP2blfxvMyqIEt9jv8fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+GLgbcWVpnOpOaBpHR9xewL4AosRFZydqVl7yvji49BZejiQ0pJHMKXDKlMvCY2q
	 tiz9WqX3pKScoV/NKf9jFR27e2sbfv3N2xoPuf4w5s8Gayn+ZdXgi772h0PMqOWWRE
	 916CGTb2+j6DC6bwl5CkR+MJMUd4Ukzte1KT3Rgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.13 402/414] thermal/drivers/mediatek/lvts: Disable monitor mode during suspend
Date: Thu, 17 Apr 2025 19:52:40 +0200
Message-ID: <20250417175127.649173910@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

commit 65594b3745024857f812145a58db3601d733676c upstream.

When configured in filtered mode, the LVTS thermal controller will
monitor the temperature from the sensors and trigger an interrupt once a
thermal threshold is crossed.

Currently this is true even during suspend and resume. The problem with
that is that when enabling the internal clock of the LVTS controller in
lvts_ctrl_set_enable() during resume, the temperature reading can glitch
and appear much higher than the real one, resulting in a spurious
interrupt getting generated.

Disable the temperature monitoring and give some time for the signals to
stabilize during suspend in order to prevent such spurious interrupts.

Cc: stable@vger.kernel.org
Reported-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Closes: https://lore.kernel.org/all/20241108-lvts-v1-1-eee339c6ca20@chromium.org/
Fixes: 8137bb90600d ("thermal/drivers/mediatek/lvts_thermal: Add suspend and resume")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20250113-mt8192-lvts-filtered-suspend-fix-v2-1-07a25200c7c6@collabora.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/mediatek/lvts_thermal.c |   36 ++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -860,6 +860,32 @@ static int lvts_ctrl_init(struct device
 	return 0;
 }
 
+static void lvts_ctrl_monitor_enable(struct device *dev, struct lvts_ctrl *lvts_ctrl, bool enable)
+{
+	/*
+	 * Bitmaps to enable each sensor on filtered mode in the MONCTL0
+	 * register.
+	 */
+	static const u8 sensor_filt_bitmap[] = { BIT(0), BIT(1), BIT(2), BIT(3) };
+	u32 sensor_map = 0;
+	int i;
+
+	if (lvts_ctrl->mode != LVTS_MSR_FILTERED_MODE)
+		return;
+
+	if (enable) {
+		lvts_for_each_valid_sensor(i, lvts_ctrl)
+			sensor_map |= sensor_filt_bitmap[i];
+	}
+
+	/*
+	 * Bits:
+	 *      9: Single point access flow
+	 *    0-3: Enable sensing point 0-3
+	 */
+	writel(sensor_map | BIT(9), LVTS_MONCTL0(lvts_ctrl->base));
+}
+
 /*
  * At this point the configuration register is the only place in the
  * driver where we write multiple values. Per hardware constraint,
@@ -1381,8 +1407,11 @@ static int lvts_suspend(struct device *d
 
 	lvts_td = dev_get_drvdata(dev);
 
-	for (i = 0; i < lvts_td->num_lvts_ctrl; i++)
+	for (i = 0; i < lvts_td->num_lvts_ctrl; i++) {
+		lvts_ctrl_monitor_enable(dev, &lvts_td->lvts_ctrl[i], false);
+		usleep_range(100, 200);
 		lvts_ctrl_set_enable(&lvts_td->lvts_ctrl[i], false);
+	}
 
 	clk_disable_unprepare(lvts_td->clk);
 
@@ -1400,8 +1429,11 @@ static int lvts_resume(struct device *de
 	if (ret)
 		return ret;
 
-	for (i = 0; i < lvts_td->num_lvts_ctrl; i++)
+	for (i = 0; i < lvts_td->num_lvts_ctrl; i++) {
 		lvts_ctrl_set_enable(&lvts_td->lvts_ctrl[i], true);
+		usleep_range(100, 200);
+		lvts_ctrl_monitor_enable(dev, &lvts_td->lvts_ctrl[i], true);
+	}
 
 	return 0;
 }


