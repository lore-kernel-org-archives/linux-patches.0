Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D51E1A9F89;
	Tue, 12 Aug 2025 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023599; cv=none; b=TkNvJJRT6sbN9dpgfjD6iTKj5I+u2soQR49gzeSSPoXefuO7cfQ93slQ8Z8hgd8aLUEFJEbxwnAqaG+gqVgA23eiWPnWNXAeosFHPxBRTXxHxamTZh42IzzXIgfhMPMVQZ2YxA16Ne5drgjYV+y8f5AlHKcgGpQcm0Fu/TI9BWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023599; c=relaxed/simple;
	bh=1HMe36xwIi61NDC8EbteIqDaUdRC1Ks3OpRQ+oYeSvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I+tYEMTP6axOzC/BQ6P86EbPH8bYOXQRalPfiQtWU5X+YZGkkT32LWtPNj1YLf8n1YWCUEiLQ4caXGbthgokOmp4zM6TiOCM75WjDMjDpMSvfNP5QCkOkLCNhTga4qta/DcxzVh6lEe9OGGvOOxfZkfzggVSNFR2NPDpPLvJjXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoeuG6ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoeuG6ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EACC4CEF1;
	Tue, 12 Aug 2025 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023597;
	bh=1HMe36xwIi61NDC8EbteIqDaUdRC1Ks3OpRQ+oYeSvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoeuG6ss0qaFNNXHlTbG8ZHKLJor5Vq1/Tyl4MlD05RtVudih8NgZaWkJn1RZDF54
	 7PnHQ4SgbM+KuCFUa1HHCNoi6ZQ4HktMibRfTFlYKSglrT3xXTmY3Wy8Y+5fKM6+5a
	 vBWfR1YdeG0VDnKNTMkSitedCp3LRAeVzBmXUOyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 125/627] platform/x86: oxpec: Fix turbo register for G1 AMD
Date: Tue, 12 Aug 2025 19:27:00 +0200
Message-ID: <20250812173424.072449444@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 232b41d3c2ce8cf4641a174416676458bf0de5b2 ]

Turns out that the AMD variant of the G1 uses different EC registers
than the Intel variant. Differentiate them and apply the correct ones
to the AMD variant.

Fixes: b369395c895b ("platform/x86: oxpec: Add support for the OneXPlayer G1")
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250718163305.159232-1-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 37 +++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index 06759036945d..9839e8cb82ce 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -58,7 +58,8 @@ enum oxp_board {
 	oxp_mini_amd_a07,
 	oxp_mini_amd_pro,
 	oxp_x1,
-	oxp_g1,
+	oxp_g1_i,
+	oxp_g1_a,
 };
 
 static enum oxp_board board;
@@ -247,14 +248,14 @@ static const struct dmi_system_id dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER G1 A"),
 		},
-		.driver_data = (void *)oxp_g1,
+		.driver_data = (void *)oxp_g1_a,
 	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER G1 i"),
 		},
-		.driver_data = (void *)oxp_g1,
+		.driver_data = (void *)oxp_g1_i,
 	},
 	{
 		.matches = {
@@ -352,7 +353,8 @@ static umode_t tt_toggle_is_visible(struct kobject *kobj,
 	case oxp_mini_amd_a07:
 	case oxp_mini_amd_pro:
 	case oxp_x1:
-	case oxp_g1:
+	case oxp_g1_i:
+	case oxp_g1_a:
 		return attr->mode;
 	default:
 		break;
@@ -381,12 +383,13 @@ static ssize_t tt_toggle_store(struct device *dev,
 	case aok_zoe_a1:
 	case oxp_fly:
 	case oxp_mini_amd_pro:
+	case oxp_g1_a:
 		reg = OXP_TURBO_SWITCH_REG;
 		mask = OXP_TURBO_TAKE_VAL;
 		break;
 	case oxp_2:
 	case oxp_x1:
-	case oxp_g1:
+	case oxp_g1_i:
 		reg = OXP_2_TURBO_SWITCH_REG;
 		mask = OXP_TURBO_TAKE_VAL;
 		break;
@@ -426,12 +429,13 @@ static ssize_t tt_toggle_show(struct device *dev,
 	case aok_zoe_a1:
 	case oxp_fly:
 	case oxp_mini_amd_pro:
+	case oxp_g1_a:
 		reg = OXP_TURBO_SWITCH_REG;
 		mask = OXP_TURBO_TAKE_VAL;
 		break;
 	case oxp_2:
 	case oxp_x1:
-	case oxp_g1:
+	case oxp_g1_i:
 		reg = OXP_2_TURBO_SWITCH_REG;
 		mask = OXP_TURBO_TAKE_VAL;
 		break;
@@ -520,7 +524,8 @@ static bool oxp_psy_ext_supported(void)
 {
 	switch (board) {
 	case oxp_x1:
-	case oxp_g1:
+	case oxp_g1_i:
+	case oxp_g1_a:
 	case oxp_fly:
 		return true;
 	default:
@@ -659,7 +664,8 @@ static int oxp_pwm_enable(void)
 	case oxp_mini_amd_a07:
 	case oxp_mini_amd_pro:
 	case oxp_x1:
-	case oxp_g1:
+	case oxp_g1_i:
+	case oxp_g1_a:
 		return write_to_ec(OXP_SENSOR_PWM_ENABLE_REG, PWM_MODE_MANUAL);
 	default:
 		return -EINVAL;
@@ -686,7 +692,8 @@ static int oxp_pwm_disable(void)
 	case oxp_mini_amd_a07:
 	case oxp_mini_amd_pro:
 	case oxp_x1:
-	case oxp_g1:
+	case oxp_g1_i:
+	case oxp_g1_a:
 		return write_to_ec(OXP_SENSOR_PWM_ENABLE_REG, PWM_MODE_AUTO);
 	default:
 		return -EINVAL;
@@ -713,7 +720,8 @@ static int oxp_pwm_read(long *val)
 	case oxp_mini_amd_a07:
 	case oxp_mini_amd_pro:
 	case oxp_x1:
-	case oxp_g1:
+	case oxp_g1_i:
+	case oxp_g1_a:
 		return read_from_ec(OXP_SENSOR_PWM_ENABLE_REG, 1, val);
 	default:
 		return -EOPNOTSUPP;
@@ -742,7 +750,7 @@ static int oxp_pwm_fan_speed(long *val)
 		return read_from_ec(ORANGEPI_SENSOR_FAN_REG, 2, val);
 	case oxp_2:
 	case oxp_x1:
-	case oxp_g1:
+	case oxp_g1_i:
 		return read_from_ec(OXP_2_SENSOR_FAN_REG, 2, val);
 	case aok_zoe_a1:
 	case aya_neo_2:
@@ -757,6 +765,7 @@ static int oxp_pwm_fan_speed(long *val)
 	case oxp_mini_amd:
 	case oxp_mini_amd_a07:
 	case oxp_mini_amd_pro:
+	case oxp_g1_a:
 		return read_from_ec(OXP_SENSOR_FAN_REG, 2, val);
 	default:
 		return -EOPNOTSUPP;
@@ -776,7 +785,7 @@ static int oxp_pwm_input_write(long val)
 		return write_to_ec(ORANGEPI_SENSOR_PWM_REG, val);
 	case oxp_2:
 	case oxp_x1:
-	case oxp_g1:
+	case oxp_g1_i:
 		/* scale to range [0-184] */
 		val = (val * 184) / 255;
 		return write_to_ec(OXP_SENSOR_PWM_REG, val);
@@ -796,6 +805,7 @@ static int oxp_pwm_input_write(long val)
 	case aok_zoe_a1:
 	case oxp_fly:
 	case oxp_mini_amd_pro:
+	case oxp_g1_a:
 		return write_to_ec(OXP_SENSOR_PWM_REG, val);
 	default:
 		return -EOPNOTSUPP;
@@ -816,7 +826,7 @@ static int oxp_pwm_input_read(long *val)
 		break;
 	case oxp_2:
 	case oxp_x1:
-	case oxp_g1:
+	case oxp_g1_i:
 		ret = read_from_ec(OXP_SENSOR_PWM_REG, 1, val);
 		if (ret)
 			return ret;
@@ -842,6 +852,7 @@ static int oxp_pwm_input_read(long *val)
 	case aok_zoe_a1:
 	case oxp_fly:
 	case oxp_mini_amd_pro:
+	case oxp_g1_a:
 	default:
 		ret = read_from_ec(OXP_SENSOR_PWM_REG, 1, val);
 		if (ret)
-- 
2.39.5



