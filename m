Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849941170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C94C433C7;
	Mon, 11 Sep 2023 14:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442096;
	bh=3uRfiLvzK9UlwL4v893Kjlk4FgKq4mcqYCCZmQ3fSFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=koIbQ4T9vUfCbl3cuzSlDNB1nmrGxmzD+7h7JpFRkuzBCIM5zL87xsYKIvULtsKdh
	 QHCNJXIDHsy0SpUzZ5qqW6Sb/0/R7rVv4W1bAow4pZmVe5ZQ+K9+hIcwksn5phFwew
	 tY1LNaZoB2wxT/Dd9UDq1hWheGtzIMubyhptYUcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 608/739] thermal/drivers/mediatek/lvts_thermal: Dont leave threshold zeroed
Date: Mon, 11 Sep 2023 15:46:47 +0200
Message-ID: <20230911134708.081032429@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 77354eaef8218bc40d6b37e783b0b8dcca22a7d9 ]

The thermal framework might leave the low threshold unset if there
aren't any lower trip points. This leaves the register zeroed, which
translates to a very high temperature for the low threshold. The
interrupt for this threshold is then immediately triggered, and the
state machine gets stuck, preventing any other temperature monitoring
interrupts to ever trigger.

(The same happens by not setting the Cold or Hot to Normal thresholds
when using those)

Set the unused threshold to a valid low value. This value was chosen so
that for any valid golden temperature read from the efuse, when the
value is converted to raw and back again to milliCelsius, the result
doesn't underflow.

Fixes: f5f633b18234 ("thermal/drivers/mediatek: Add the Low Voltage Thermal Sensor driver")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230706153823.201943-6-nfraprado@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/lvts_thermal.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index 02e7af4619a2c..064269667fb89 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -83,6 +83,8 @@
 
 #define LVTS_HW_SHUTDOWN_MT8195		105000
 
+#define LVTS_MINIMUM_THRESHOLD		20000
+
 static int golden_temp = LVTS_GOLDEN_TEMP_DEFAULT;
 static int coeff_b = LVTS_COEFF_B;
 
@@ -294,7 +296,7 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 {
 	struct lvts_sensor *lvts_sensor = thermal_zone_device_priv(tz);
 	void __iomem *base = lvts_sensor->base;
-	u32 raw_low = lvts_temp_to_raw(low);
+	u32 raw_low = lvts_temp_to_raw(low != -INT_MAX ? low : LVTS_MINIMUM_THRESHOLD);
 	u32 raw_high = lvts_temp_to_raw(high);
 
 	/*
@@ -306,11 +308,9 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 	 *
 	 * 14-0 : Raw temperature for threshold
 	 */
-	if (low != -INT_MAX) {
-		pr_debug("%s: Setting low limit temperature interrupt: %d\n",
-			 thermal_zone_device_type(tz), low);
-		writel(raw_low, LVTS_OFFSETL(base));
-	}
+	pr_debug("%s: Setting low limit temperature interrupt: %d\n",
+		 thermal_zone_device_type(tz), low);
+	writel(raw_low, LVTS_OFFSETL(base));
 
 	/*
 	 * High offset temperature threshold
-- 
2.40.1



