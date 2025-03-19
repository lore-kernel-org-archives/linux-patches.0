Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7001C2DC8;
	Wed, 19 Mar 2025 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394888; cv=none; b=GxUQR+a/qqSR4nTSNbN6j4t08XxgqaGOXzAg9oQ+rjEZPBCExAvgwk+Ivq+XTLc3Is5LvIQ8HJEt3qzM8AsknNqpcDOoVmDkwZk5JTIH4di12T/82ffVd6oaBlfXwKQM7Ja/wNIKV2esg3/+o+LD2SvsNLt3hfg33qfrtBDc+J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394888; c=relaxed/simple;
	bh=Wi/lsqP/+wB3lIAjMqQDNSfUlENtHhh+CZd7bfRZ4XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oy2KmB5XqjoKQ9xGa1lLymCVYoFggvJtJMkr8nq0/1YvPQy5gEhfLtMlBuihJfxaW6i0I0K+X/bblU/GXeGNhUSHeeXoYBJJ0b9jDlsfu5+CY2sNQ7OqnGKcIx+sHLgnYg4nsFtHZYnS9Jx3Zi8st3/jHzAR01oh7q3zFBkWOtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9+vd0nt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9+vd0nt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D8FC4CEE4;
	Wed, 19 Mar 2025 14:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394888;
	bh=Wi/lsqP/+wB3lIAjMqQDNSfUlENtHhh+CZd7bfRZ4XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9+vd0nt650tKPohHxTnxwO12k6H36rGxYVhZ4+cKzdvj5TJbnJFZJck6sOUKoHn3
	 JLn2A+Ni8vnySg/1cq+ZpvGoaZJD4oT4mZwQ9/wLu7yJCf2odGg7QX29IUrStomRcG
	 ccQSl3AAsvRdOv/NjxQNaoAx0oG3wciBmJ/fHcGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sybil Isabel Dorsett <sybdorsett@proton.me>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 090/241] platform/x86: thinkpad_acpi: Fix invalid fan speed on ThinkPad X120e
Date: Wed, 19 Mar 2025 07:29:20 -0700
Message-ID: <20250319143029.951596629@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

From: Sybil Isabel Dorsett <sybdorsett@proton.me>

[ Upstream commit 1046cac109225eda0973b898e053aeb3d6c10e1d ]

On ThinkPad X120e, fan speed is reported in ticks per revolution
rather than RPM.

Recalculate the fan speed value reported for ThinkPad X120e
to RPM based on a 22.5 kHz clock.

Based on the information on
https://www.thinkwiki.org/wiki/How_to_control_fan_speed,
the same problem is highly likely to be relevant to at least Edge11,
but Edge11 is not addressed in this patch.

Signed-off-by: Sybil Isabel Dorsett <sybdorsett@proton.me>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20250203163255.5525-1-sybdorsett@proton.me
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 84dcd7da7319e..21fecdf35cd0d 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -7883,6 +7883,7 @@ static struct ibm_struct volume_driver_data = {
 
 #define FAN_NS_CTRL_STATUS	BIT(2)		/* Bit which determines control is enabled or not */
 #define FAN_NS_CTRL		BIT(4)		/* Bit which determines control is by host or EC */
+#define FAN_CLOCK_TPM		(22500*60)	/* Ticks per minute for a 22.5 kHz clock */
 
 enum {					/* Fan control constants */
 	fan_status_offset = 0x2f,	/* EC register 0x2f */
@@ -7938,6 +7939,7 @@ static int fan_watchdog_maxinterval;
 
 static bool fan_with_ns_addr;
 static bool ecfw_with_fan_dec_rpm;
+static bool fan_speed_in_tpr;
 
 static struct mutex fan_mutex;
 
@@ -8140,8 +8142,11 @@ static int fan_get_speed(unsigned int *speed)
 			     !acpi_ec_read(fan_rpm_offset + 1, &hi)))
 			return -EIO;
 
-		if (likely(speed))
+		if (likely(speed)) {
 			*speed = (hi << 8) | lo;
+			if (fan_speed_in_tpr && *speed != 0)
+				*speed = FAN_CLOCK_TPM / *speed;
+		}
 		break;
 	case TPACPI_FAN_RD_TPEC_NS:
 		if (!acpi_ec_read(fan_rpm_status_ns, &lo))
@@ -8174,8 +8179,11 @@ static int fan2_get_speed(unsigned int *speed)
 		if (rc)
 			return -EIO;
 
-		if (likely(speed))
+		if (likely(speed)) {
 			*speed = (hi << 8) | lo;
+			if (fan_speed_in_tpr && *speed != 0)
+				*speed = FAN_CLOCK_TPM / *speed;
+		}
 		break;
 
 	case TPACPI_FAN_RD_TPEC_NS:
@@ -8786,6 +8794,7 @@ static const struct attribute_group fan_driver_attr_group = {
 #define TPACPI_FAN_NOFAN	0x0008		/* no fan available */
 #define TPACPI_FAN_NS		0x0010		/* For EC with non-Standard register addresses */
 #define TPACPI_FAN_DECRPM	0x0020		/* For ECFW's with RPM in register as decimal */
+#define TPACPI_FAN_TPR		0x0040		/* Fan speed is in Ticks Per Revolution */
 
 static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_QEC_IBM('1', 'Y', TPACPI_FAN_Q1),
@@ -8815,6 +8824,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('R', '0', 'V', TPACPI_FAN_NS),	/* 11e Gen5 KL-Y */
 	TPACPI_Q_LNV3('N', '1', 'O', TPACPI_FAN_NOFAN),	/* X1 Tablet (2nd gen) */
 	TPACPI_Q_LNV3('R', '0', 'Q', TPACPI_FAN_DECRPM),/* L480 */
+	TPACPI_Q_LNV('8', 'F', TPACPI_FAN_TPR),		/* ThinkPad x120e */
 };
 
 static int __init fan_init(struct ibm_init_struct *iibm)
@@ -8885,6 +8895,8 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 
 			if (quirks & TPACPI_FAN_Q1)
 				fan_quirk1_setup();
+			if (quirks & TPACPI_FAN_TPR)
+				fan_speed_in_tpr = true;
 			/* Try and probe the 2nd fan */
 			tp_features.second_fan = 1; /* needed for get_speed to work */
 			res = fan2_get_speed(&speed);
-- 
2.39.5



