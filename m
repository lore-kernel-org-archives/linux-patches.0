Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FEB45BE3;
	Fri,  6 Dec 2024 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496500; cv=none; b=Q9eiz1Z0mq/MNwh3OZHlOK46E/PK2Tgmy2qcRws7WN84cjLHkpRLZOC3eTBR4+ATBSwdrJFbwXWBV6lxKwYMz1/HsSAb/oYBNKHpT5dQ5wwtfMp8AFzNCsTb1h8TH/mJxzpuEJyAPJV9Qe2/ddajn4D3BHtegDBOKmXUXji7Z84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496500; c=relaxed/simple;
	bh=tAxu6kmpW8A8QWxcmJ+4/5DJVxWKriLESWMNh3i7tnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJhRgpIFtDOt6aGuhiQ3IQWRWFWl9S/1rRVzkQ777X298ABa3C/3M/b2ZAHxEcVScJd4uTLoDPyZFUXgeIQYzeOPeqpmPtRt13CBpR5SCE0hWRpEw3kVQEaGRg/DLROQhZCRcLXWQZkqBDB5eDy+szY5VKFVyh9X2rE8j3uLmhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUViMhgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUViMhgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF12DC4CED1;
	Fri,  6 Dec 2024 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496500;
	bh=tAxu6kmpW8A8QWxcmJ+4/5DJVxWKriLESWMNh3i7tnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUViMhgHB2HzRfp/FLokPEFHmWYsuHuaR6+f1HCenaBUah9y8nJePxmayaJkNOizZ
	 a6zhhCfWqGbnyGEeROCBN+VYPD8YuXjLUD4x/12AR99feUG3yIpQsGAZCkUsLi01Gh
	 5bgYbJV8f1F09goWoMVcy3rNB4KOMRm8q3yeiv+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Sankar <vishnuocv@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/676] platform/x86: thinkpad_acpi: Fix for ThinkPads with ECFW showing incorrect fan speed
Date: Fri,  6 Dec 2024 15:27:22 +0100
Message-ID: <20241206143654.265168868@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishnu Sankar <vishnuocv@gmail.com>

[ Upstream commit 1be765b292577c752e0b87bf8c0e92aff6699d8e ]

Fix for Thinkpad's with ECFW showing incorrect fan speed. Some models use
decimal instead of hexadecimal for the speed stored in the EC registers.
For example the rpm register will have 0x4200 instead of 0x1068, here
the actual RPM is "4200" in decimal.

Add a quirk to handle this.

Signed-off-by: Vishnu Sankar <vishnuocv@gmail.com>
Suggested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20241105235505.8493-1-vishnuocv@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 5b1f08eabd923..964670d4ca1e2 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8013,6 +8013,7 @@ static u8 fan_control_resume_level;
 static int fan_watchdog_maxinterval;
 
 static bool fan_with_ns_addr;
+static bool ecfw_with_fan_dec_rpm;
 
 static struct mutex fan_mutex;
 
@@ -8655,7 +8656,11 @@ static ssize_t fan_fan1_input_show(struct device *dev,
 	if (res < 0)
 		return res;
 
-	return sysfs_emit(buf, "%u\n", speed);
+	/* Check for fan speeds displayed in hexadecimal */
+	if (!ecfw_with_fan_dec_rpm)
+		return sysfs_emit(buf, "%u\n", speed);
+	else
+		return sysfs_emit(buf, "%x\n", speed);
 }
 
 static DEVICE_ATTR(fan1_input, S_IRUGO, fan_fan1_input_show, NULL);
@@ -8672,7 +8677,11 @@ static ssize_t fan_fan2_input_show(struct device *dev,
 	if (res < 0)
 		return res;
 
-	return sysfs_emit(buf, "%u\n", speed);
+	/* Check for fan speeds displayed in hexadecimal */
+	if (!ecfw_with_fan_dec_rpm)
+		return sysfs_emit(buf, "%u\n", speed);
+	else
+		return sysfs_emit(buf, "%x\n", speed);
 }
 
 static DEVICE_ATTR(fan2_input, S_IRUGO, fan_fan2_input_show, NULL);
@@ -8748,6 +8757,7 @@ static const struct attribute_group fan_driver_attr_group = {
 #define TPACPI_FAN_2CTL		0x0004		/* selects fan2 control */
 #define TPACPI_FAN_NOFAN	0x0008		/* no fan available */
 #define TPACPI_FAN_NS		0x0010		/* For EC with non-Standard register addresses */
+#define TPACPI_FAN_DECRPM	0x0020		/* For ECFW's with RPM in register as decimal */
 
 static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_QEC_IBM('1', 'Y', TPACPI_FAN_Q1),
@@ -8769,6 +8779,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('R', '1', 'F', TPACPI_FAN_NS),	/* L13 Yoga Gen 2 */
 	TPACPI_Q_LNV3('N', '2', 'U', TPACPI_FAN_NS),	/* X13 Yoga Gen 2*/
 	TPACPI_Q_LNV3('N', '1', 'O', TPACPI_FAN_NOFAN),	/* X1 Tablet (2nd gen) */
+	TPACPI_Q_LNV3('R', '0', 'Q', TPACPI_FAN_DECRPM),/* L480 */
 };
 
 static int __init fan_init(struct ibm_init_struct *iibm)
@@ -8809,6 +8820,13 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 		tp_features.fan_ctrl_status_undef = 1;
 	}
 
+	/* Check for the EC/BIOS with RPM reported in decimal*/
+	if (quirks & TPACPI_FAN_DECRPM) {
+		pr_info("ECFW with fan RPM as decimal in EC register\n");
+		ecfw_with_fan_dec_rpm = 1;
+		tp_features.fan_ctrl_status_undef = 1;
+	}
+
 	if (gfan_handle) {
 		/* 570, 600e/x, 770e, 770x */
 		fan_status_access_mode = TPACPI_FAN_RD_ACPI_GFAN;
@@ -9020,7 +9038,11 @@ static int fan_read(struct seq_file *m)
 		if (rc < 0)
 			return rc;
 
-		seq_printf(m, "speed:\t\t%d\n", speed);
+		/* Check for fan speeds displayed in hexadecimal */
+		if (!ecfw_with_fan_dec_rpm)
+			seq_printf(m, "speed:\t\t%d\n", speed);
+		else
+			seq_printf(m, "speed:\t\t%x\n", speed);
 
 		if (fan_status_access_mode == TPACPI_FAN_RD_TPEC_NS) {
 			/*
-- 
2.43.0



