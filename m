Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C241C8618;
	Wed, 19 Mar 2025 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395198; cv=none; b=jvzt1PR8VilqNgVJfMPm6qMKckO7FA2bjsRjtNi1amelgK2KArBu6CRAATbHS4PY3Ek/lti+sqnePaEs66xqCMejC8STW73YqU6UTiSZO5ggQMCsLFJqqIs5izsxC+oIp+o4MAKs2q0c7Q/AYy8fW6527+isJarRVcRmuubzDJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395198; c=relaxed/simple;
	bh=Qf6HPdgRJ+W2kYrSEZqBtIUWm50ct3mIroMgy7ZrfBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQnqdO+X+su+jWE3OTTTsd3hYMZARcGmowkalpirG4aENXoWxGYNqbjFKdO1i9GFp6eJst4jm75JolJ520aCBqOf+bk0qJ4sxhFElpxBgmt0F6icnMbJMOznB771G6lbXRlo4qPwqg3apJcU7+CO2GXp9C9FW3mU1/ctHfNVjj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxbtrV1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxbtrV1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074E0C4CEE4;
	Wed, 19 Mar 2025 14:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395198;
	bh=Qf6HPdgRJ+W2kYrSEZqBtIUWm50ct3mIroMgy7ZrfBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxbtrV1IJiC2y8aBY++FDxb638ObZPZDfLGBCpeDpaJolKAMihl5axTT15A0/X0F/
	 +/sNEVQSRMSS7CtjNQR1nYgCuMkekuYRB378kWIpZhc2xjN93/Te4MeCkNi8rVyG0S
	 cYKbMwGpNq15w+oDghQLd+Rop8jbTgrP4LipMElw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sybil Isabel Dorsett <sybdorsett@proton.me>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/166] platform/x86: thinkpad_acpi: Fix invalid fan speed on ThinkPad X120e
Date: Wed, 19 Mar 2025 07:30:30 -0700
Message-ID: <20250319143021.601938624@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 692bd6fea3744..b11f5ac658e01 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -7961,6 +7961,7 @@ static struct ibm_struct volume_driver_data = {
 
 #define FAN_NS_CTRL_STATUS	BIT(2)		/* Bit which determines control is enabled or not */
 #define FAN_NS_CTRL		BIT(4)		/* Bit which determines control is by host or EC */
+#define FAN_CLOCK_TPM		(22500*60)	/* Ticks per minute for a 22.5 kHz clock */
 
 enum {					/* Fan control constants */
 	fan_status_offset = 0x2f,	/* EC register 0x2f */
@@ -8014,6 +8015,7 @@ static int fan_watchdog_maxinterval;
 
 static bool fan_with_ns_addr;
 static bool ecfw_with_fan_dec_rpm;
+static bool fan_speed_in_tpr;
 
 static struct mutex fan_mutex;
 
@@ -8195,8 +8197,11 @@ static int fan_get_speed(unsigned int *speed)
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
@@ -8229,8 +8234,11 @@ static int fan2_get_speed(unsigned int *speed)
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
@@ -8758,6 +8766,7 @@ static const struct attribute_group fan_driver_attr_group = {
 #define TPACPI_FAN_NOFAN	0x0008		/* no fan available */
 #define TPACPI_FAN_NS		0x0010		/* For EC with non-Standard register addresses */
 #define TPACPI_FAN_DECRPM	0x0020		/* For ECFW's with RPM in register as decimal */
+#define TPACPI_FAN_TPR		0x0040		/* Fan speed is in Ticks Per Revolution */
 
 static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_QEC_IBM('1', 'Y', TPACPI_FAN_Q1),
@@ -8780,6 +8789,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('N', '2', 'U', TPACPI_FAN_NS),	/* X13 Yoga Gen 2*/
 	TPACPI_Q_LNV3('N', '1', 'O', TPACPI_FAN_NOFAN),	/* X1 Tablet (2nd gen) */
 	TPACPI_Q_LNV3('R', '0', 'Q', TPACPI_FAN_DECRPM),/* L480 */
+	TPACPI_Q_LNV('8', 'F', TPACPI_FAN_TPR),		/* ThinkPad x120e */
 };
 
 static int __init fan_init(struct ibm_init_struct *iibm)
@@ -8843,6 +8853,8 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 
 			if (quirks & TPACPI_FAN_Q1)
 				fan_quirk1_setup();
+			if (quirks & TPACPI_FAN_TPR)
+				fan_speed_in_tpr = true;
 			/* Try and probe the 2nd fan */
 			tp_features.second_fan = 1; /* needed for get_speed to work */
 			res = fan2_get_speed(&speed);
-- 
2.39.5



