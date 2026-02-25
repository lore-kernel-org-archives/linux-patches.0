Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9919720C012;
	Wed, 25 Feb 2026 01:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983333; cv=none; b=ClUtMe6ew2jO/I0sAMJ30ERfy/Nj/O6xc4cL9rlI2nKz652K9+zgzpGxucTEyPuKDwbURxSuFC3caqBzOEhp2OEL2DdrHQtmPEHWxVFiDMWQcV3uGZ9a4cpuHk1JBSyv1Oz5j9kTxVKA5hDpKkj3DTzI2Qy6MBpZjM1pwq9H5fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983333; c=relaxed/simple;
	bh=96Y5d4h+MGCnWOlTTlF0wwHB8+wQFafKF+LKlTc5qkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kAxqnIuhVr+q+jXCPqBTRTtNQAE1hjcFXOW6FdXT8h5Wxys/FNZy/h4CZG2ENHjsXFUELwjy4d7GzLUAwYbHNZKYt8g3FylP4XAjTMRW1riQOjI5cucdX8NbjfmeYIGfaRohYgAX3rCFSulSxxiqQRsuDfy4sl4+onLqdvLdOHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pziYPYvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pziYPYvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFABC116D0;
	Wed, 25 Feb 2026 01:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983333;
	bh=96Y5d4h+MGCnWOlTTlF0wwHB8+wQFafKF+LKlTc5qkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pziYPYvXcSk/c+oPEUSVa92gMBoXDDHjDSBQY0roJz+8sNWcCsac4Ger/cSHv7wG5
	 kd2+rstuTnVpmQJFRX4WPjmL6UOVRs2QB/Bp+8VMGNFEfMH/oznHZcQLXEFH4bIWKP
	 YAJm1YU3cp11KB29FnBdVM5fR1NjqUTyimwyxKmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 464/781] platform/x86: hp-wmi: fix platform profile values for Omen 16-wf1xxx
Date: Tue, 24 Feb 2026 17:19:33 -0800
Message-ID: <20260225012411.201873760@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Chomal <krishna.chomal108@gmail.com>

[ Upstream commit 8ca7515d3c76a8b629f703ff8301a75f503bcc50 ]

HP Omen 16-wf1xxx (board ID 8C78) currently sends the incorrect
Victus-specific thermal profile values via WMI, leading to a logical
inconsistency when switching between platform profiles.

The driver currently uses Victus S values:
0x00 => Balanced / Low-Power
0x01 => Performance

However, Omen Gaming Hub logs / EC register inspection on Windows shows
that this board is intended to use:
0x30 => Balanced / Low-Power
0x31 => Performance

This patch corrects the thermal profile command values to match the
values observed from Omen Gaming Hub logs. The performance benchmarks
and peak power draw (from both CPU and GPU) show no observable change
with this correction (suggesting that the firmware is currently tolerant
of the incorrect values). However sending the correct values prevents
potential regressions after future firmware updates.

Refactor victus_s_thermal_profile_boards from a list of strings to a
dmi_system_id table and move the lookup to module init. The new struct
thermal_profile_params is used to store board-specific WMI parameters,
allowing the driver to cache these values in a static pointer. This
avoids repeated DMI string comparisons and allows marking of DMI table as
__initconst.

Testing on HP Omen 16-wf1xxx (board 8C78) confirmed WMI codes 0x30/0x31
are now sent, resolving the logical inconsistency and ensuring the value
visible in EC registers match the Windows state for this profile.

Fixes: fb146a38cb11 ("platform/x86: hp-wmi: Add Omen 16-wf1xxx fan support")
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260113182604.115211-2-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 179 ++++++++++++++++++++++---------
 1 file changed, 127 insertions(+), 52 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index f4ea1ea05997b..24d065ddfc6ae 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -53,6 +53,66 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45E9-BE91-3D44E2C707E4");
 
 #define zero_if_sup(tmp) (zero_insize_support?0:sizeof(tmp)) // use when zero insize is required
 
+enum hp_thermal_profile_omen_v0 {
+	HP_OMEN_V0_THERMAL_PROFILE_DEFAULT		= 0x00,
+	HP_OMEN_V0_THERMAL_PROFILE_PERFORMANCE		= 0x01,
+	HP_OMEN_V0_THERMAL_PROFILE_COOL			= 0x02,
+};
+
+enum hp_thermal_profile_omen_v1 {
+	HP_OMEN_V1_THERMAL_PROFILE_DEFAULT		= 0x30,
+	HP_OMEN_V1_THERMAL_PROFILE_PERFORMANCE		= 0x31,
+	HP_OMEN_V1_THERMAL_PROFILE_COOL			= 0x50,
+};
+
+enum hp_thermal_profile_omen_flags {
+	HP_OMEN_EC_FLAGS_TURBO				= 0x04,
+	HP_OMEN_EC_FLAGS_NOTIMER			= 0x02,
+	HP_OMEN_EC_FLAGS_JUSTSET			= 0x01,
+};
+
+enum hp_thermal_profile_victus {
+	HP_VICTUS_THERMAL_PROFILE_DEFAULT		= 0x00,
+	HP_VICTUS_THERMAL_PROFILE_PERFORMANCE		= 0x01,
+	HP_VICTUS_THERMAL_PROFILE_QUIET			= 0x03,
+};
+
+enum hp_thermal_profile_victus_s {
+	HP_VICTUS_S_THERMAL_PROFILE_DEFAULT		= 0x00,
+	HP_VICTUS_S_THERMAL_PROFILE_PERFORMANCE		= 0x01,
+};
+
+enum hp_thermal_profile {
+	HP_THERMAL_PROFILE_PERFORMANCE			= 0x00,
+	HP_THERMAL_PROFILE_DEFAULT			= 0x01,
+	HP_THERMAL_PROFILE_COOL				= 0x02,
+	HP_THERMAL_PROFILE_QUIET			= 0x03,
+};
+
+struct thermal_profile_params {
+	u8 performance;
+	u8 balanced;
+	u8 low_power;
+};
+
+static const struct thermal_profile_params victus_s_thermal_params = {
+	.performance	= HP_VICTUS_S_THERMAL_PROFILE_PERFORMANCE,
+	.balanced	= HP_VICTUS_S_THERMAL_PROFILE_DEFAULT,
+	.low_power	= HP_VICTUS_S_THERMAL_PROFILE_DEFAULT,
+};
+
+static const struct thermal_profile_params omen_v1_thermal_params = {
+	.performance	= HP_OMEN_V1_THERMAL_PROFILE_PERFORMANCE,
+	.balanced	= HP_OMEN_V1_THERMAL_PROFILE_DEFAULT,
+	.low_power	= HP_OMEN_V1_THERMAL_PROFILE_DEFAULT,
+};
+
+/*
+ * A generic pointer for the currently-active board's thermal profile
+ * parameters.
+ */
+static struct thermal_profile_params *active_thermal_profile_params;
+
 /* DMI board names of devices that should use the omen specific path for
  * thermal profiles.
  * This was obtained by taking a look in the windows omen command center
@@ -99,12 +159,40 @@ static const char * const victus_thermal_profile_boards[] = {
 };
 
 /* DMI Board names of Victus 16-r and Victus 16-s laptops */
-static const char * const victus_s_thermal_profile_boards[] = {
-	"8BBE", "8BD4", "8BD5",
-	"8C78", "8C99", "8C9C",
-	"8D41",
+static const struct dmi_system_id victus_s_thermal_profile_boards[] __initconst = {
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BBE") },
+		.driver_data = (void *)&victus_s_thermal_params,
+	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BD4") },
+		.driver_data = (void *)&victus_s_thermal_params,
+	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BD5") },
+		.driver_data = (void *)&victus_s_thermal_params,
+	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8C78") },
+		.driver_data = (void *)&omen_v1_thermal_params,
+	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8C99") },
+		.driver_data = (void *)&victus_s_thermal_params,
+	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8C9C") },
+		.driver_data = (void *)&victus_s_thermal_params,
+	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8D41") },
+		.driver_data = (void *)&victus_s_thermal_params,
+	},
+	{},
 };
 
+static bool is_victus_s_board;
+
 enum hp_wmi_radio {
 	HPWMI_WIFI	= 0x0,
 	HPWMI_BLUETOOTH	= 0x1,
@@ -225,42 +313,6 @@ enum hp_wireless2_bits {
 	HPWMI_POWER_FW_OR_HW	= HPWMI_POWER_BIOS | HPWMI_POWER_HARD,
 };
 
-enum hp_thermal_profile_omen_v0 {
-	HP_OMEN_V0_THERMAL_PROFILE_DEFAULT     = 0x00,
-	HP_OMEN_V0_THERMAL_PROFILE_PERFORMANCE = 0x01,
-	HP_OMEN_V0_THERMAL_PROFILE_COOL        = 0x02,
-};
-
-enum hp_thermal_profile_omen_v1 {
-	HP_OMEN_V1_THERMAL_PROFILE_DEFAULT	= 0x30,
-	HP_OMEN_V1_THERMAL_PROFILE_PERFORMANCE	= 0x31,
-	HP_OMEN_V1_THERMAL_PROFILE_COOL		= 0x50,
-};
-
-enum hp_thermal_profile_omen_flags {
-	HP_OMEN_EC_FLAGS_TURBO		= 0x04,
-	HP_OMEN_EC_FLAGS_NOTIMER	= 0x02,
-	HP_OMEN_EC_FLAGS_JUSTSET	= 0x01,
-};
-
-enum hp_thermal_profile_victus {
-	HP_VICTUS_THERMAL_PROFILE_DEFAULT		= 0x00,
-	HP_VICTUS_THERMAL_PROFILE_PERFORMANCE		= 0x01,
-	HP_VICTUS_THERMAL_PROFILE_QUIET			= 0x03,
-};
-
-enum hp_thermal_profile_victus_s {
-	HP_VICTUS_S_THERMAL_PROFILE_DEFAULT		= 0x00,
-	HP_VICTUS_S_THERMAL_PROFILE_PERFORMANCE		= 0x01,
-};
-
-enum hp_thermal_profile {
-	HP_THERMAL_PROFILE_PERFORMANCE	= 0x00,
-	HP_THERMAL_PROFILE_DEFAULT		= 0x01,
-	HP_THERMAL_PROFILE_COOL			= 0x02,
-	HP_THERMAL_PROFILE_QUIET		= 0x03,
-};
-
 #define IS_HWBLOCKED(x) ((x & HPWMI_POWER_FW_OR_HW) != HPWMI_POWER_FW_OR_HW)
 #define IS_SWBLOCKED(x) !(x & HPWMI_POWER_SOFT)
 
@@ -1581,15 +1633,8 @@ static int platform_profile_victus_set_ec(enum platform_profile_option profile)
 
 static bool is_victus_s_thermal_profile(void)
 {
-	const char *board_name;
-
-	board_name = dmi_get_system_info(DMI_BOARD_NAME);
-	if (!board_name)
-		return false;
-
-	return match_string(victus_s_thermal_profile_boards,
-			    ARRAY_SIZE(victus_s_thermal_profile_boards),
-			    board_name) >= 0;
+	/* Initialised in driver init, hence safe to use here */
+	return is_victus_s_board;
 }
 
 static int victus_s_gpu_thermal_profile_get(bool *ctgp_enable,
@@ -1672,25 +1717,30 @@ static int victus_s_set_cpu_pl1_pl2(u8 pl1, u8 pl2)
 
 static int platform_profile_victus_s_set_ec(enum platform_profile_option profile)
 {
+	struct thermal_profile_params *params;
 	bool gpu_ctgp_enable, gpu_ppab_enable;
 	u8 gpu_dstate; /* Test shows 1 = 100%, 2 = 50%, 3 = 25%, 4 = 12.5% */
 	int err, tp;
 
+	params = active_thermal_profile_params;
+	if (!params)
+		return -ENODEV;
+
 	switch (profile) {
 	case PLATFORM_PROFILE_PERFORMANCE:
-		tp = HP_VICTUS_S_THERMAL_PROFILE_PERFORMANCE;
+		tp = params->performance;
 		gpu_ctgp_enable = true;
 		gpu_ppab_enable = true;
 		gpu_dstate = 1;
 		break;
 	case PLATFORM_PROFILE_BALANCED:
-		tp = HP_VICTUS_S_THERMAL_PROFILE_DEFAULT;
+		tp = params->balanced;
 		gpu_ctgp_enable = false;
 		gpu_ppab_enable = true;
 		gpu_dstate = 1;
 		break;
 	case PLATFORM_PROFILE_LOW_POWER:
-		tp = HP_VICTUS_S_THERMAL_PROFILE_DEFAULT;
+		tp = params->low_power;
 		gpu_ctgp_enable = false;
 		gpu_ppab_enable = false;
 		gpu_dstate = 1;
@@ -2227,6 +2277,26 @@ static int hp_wmi_hwmon_init(void)
 	return 0;
 }
 
+static void __init setup_active_thermal_profile_params(void)
+{
+	const struct dmi_system_id *id;
+
+	/*
+	 * Currently only victus_s devices use the
+	 * active_thermal_profile_params
+	 */
+	id = dmi_first_match(victus_s_thermal_profile_boards);
+	if (id) {
+		/*
+		 * Marking this boolean is required to ensure that
+		 * is_victus_s_thermal_profile() behaves like a valid
+		 * wrapper.
+		 */
+		is_victus_s_board = true;
+		active_thermal_profile_params = id->driver_data;
+	}
+}
+
 static int __init hp_wmi_init(void)
 {
 	int event_capable = wmi_has_guid(HPWMI_EVENT_GUID);
@@ -2254,6 +2324,11 @@ static int __init hp_wmi_init(void)
 			goto err_destroy_input;
 		}
 
+		/*
+		 * Setup active board's thermal profile parameters before
+		 * starting platform driver probe.
+		 */
+		setup_active_thermal_profile_params();
 		err = platform_driver_probe(&hp_wmi_driver, hp_wmi_bios_setup);
 		if (err)
 			goto err_unregister_device;
-- 
2.51.0



