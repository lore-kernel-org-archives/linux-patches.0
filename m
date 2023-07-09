Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D84522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55983C433C7;
	Sun,  9 Jul 2023 11:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901543;
	bh=DciJENi3dglHLvzcjr6bGR66q3MgAb7fsNDspxBgaOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXeN8GlVFdGoOl8nC1GaxYCNeCoMjncLp2rUtN0kXKDNSbzYEBYkfzm6GKHN6YH2S
	 A0LEIV1Pqoktss5KfZL03TRRHHG3BhhxB5k3/2Ssp+Z1kunVwGsUkH/XSwZf97O9iK
	 tf/r8PHQWJkRJ0x8ONrA+9NjEmhOclSqZc2AdxqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 057/431] thermal/drivers/qoriq: Only enable supported sensors
Date: Sun,  9 Jul 2023 13:10:05 +0200
Message-ID: <20230709111452.458508978@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 9301575df2509ecf8bd66f601046afaff606b1d5 ]

There are MAX 16 sensors, but not all of them supported. Such as
i.MX8MQ, there are only 3 sensors. Enabling all 16 sensors will
touch reserved bits from i.MX8MQ reference mannual, and TMU will stuck,
temperature will not update anymore.

Fixes: 45038e03d633 ("thermal: qoriq: Enable all sensors before registering them")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230516083746.63436-3-peng.fan@oss.nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qoriq_thermal.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/qoriq_thermal.c b/drivers/thermal/qoriq_thermal.c
index 5c9205fe30733..dec66cf3eba2c 100644
--- a/drivers/thermal/qoriq_thermal.c
+++ b/drivers/thermal/qoriq_thermal.c
@@ -31,7 +31,6 @@
 #define TMR_DISABLE	0x0
 #define TMR_ME		0x80000000
 #define TMR_ALPF	0x0c000000
-#define TMR_MSITE_ALL	GENMASK(15, 0)
 
 #define REGS_TMTMIR	0x008	/* Temperature measurement interval Register */
 #define TMTMIR_DEFAULT	0x0000000f
@@ -105,6 +104,11 @@ static int tmu_get_temp(struct thermal_zone_device *tz, int *temp)
 	 * within sensor range. TEMP is an 9 bit value representing
 	 * temperature in KelVin.
 	 */
+
+	regmap_read(qdata->regmap, REGS_TMR, &val);
+	if (!(val & TMR_ME))
+		return -EAGAIN;
+
 	if (regmap_read_poll_timeout(qdata->regmap,
 				     REGS_TRITSR(qsensor->id),
 				     val,
@@ -128,15 +132,7 @@ static const struct thermal_zone_device_ops tmu_tz_ops = {
 static int qoriq_tmu_register_tmu_zone(struct device *dev,
 				       struct qoriq_tmu_data *qdata)
 {
-	int id;
-
-	if (qdata->ver == TMU_VER1) {
-		regmap_write(qdata->regmap, REGS_TMR,
-			     TMR_MSITE_ALL | TMR_ME | TMR_ALPF);
-	} else {
-		regmap_write(qdata->regmap, REGS_V2_TMSR, TMR_MSITE_ALL);
-		regmap_write(qdata->regmap, REGS_TMR, TMR_ME | TMR_ALPF_V2);
-	}
+	int id, sites = 0;
 
 	for (id = 0; id < SITES_MAX; id++) {
 		struct thermal_zone_device *tzd;
@@ -153,14 +149,26 @@ static int qoriq_tmu_register_tmu_zone(struct device *dev,
 			if (ret == -ENODEV)
 				continue;
 
-			regmap_write(qdata->regmap, REGS_TMR, TMR_DISABLE);
 			return ret;
 		}
 
+		if (qdata->ver == TMU_VER1)
+			sites |= 0x1 << (15 - id);
+		else
+			sites |= 0x1 << id;
+
 		if (devm_thermal_add_hwmon_sysfs(dev, tzd))
 			dev_warn(dev,
 				 "Failed to add hwmon sysfs attributes\n");
+	}
 
+	if (sites) {
+		if (qdata->ver == TMU_VER1) {
+			regmap_write(qdata->regmap, REGS_TMR, TMR_ME | TMR_ALPF | sites);
+		} else {
+			regmap_write(qdata->regmap, REGS_V2_TMSR, sites);
+			regmap_write(qdata->regmap, REGS_TMR, TMR_ME | TMR_ALPF_V2);
+		}
 	}
 
 	return 0;
-- 
2.39.2



