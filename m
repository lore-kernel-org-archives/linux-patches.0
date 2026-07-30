Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1824052DC;
	Thu, 30 Jul 2026 15:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423848; cv=none; b=dHimBpJboctHR/1iFOj/qrkOeXbsNp91LZ3VJumQpRPCzgPB+Cgn5EnZNLR6Knz5sUwpS/xCHT9/5gvNjWtxl6gkDimajRv2QMMudWTjeuyOoYOhZpxHCZ/a0zd6tL+6nkhYJgdXUKKXpvLnHrN3L3D7HlqLRnPGZiL/2ugzXR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423848; c=relaxed/simple;
	bh=4HkNW2UxFaTh4B5AtSW6JnBJC+4hNKuu0ETGmhsHDkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMBoVpgeG8etCwTekmz+IQPEt4VHUq6YWPnoet6B6wCusWZAwrkPebTIUG9Oi1uBqdrfaus3Dd+LmdZUBlzaLatFyBmSvz0WJqrjDbkEDlxmoWGuUfb/JKtPWM41VFHduYJWb2uS3A/KZ4awnHqHE04QrJOqA20hbIc1avdxcOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TQ9YmBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TQ9YmBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BE51F000E9;
	Thu, 30 Jul 2026 15:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423847;
	bh=oXznNc1Uqh8icfnj6LHPVUFhqtGi8TImt4Ec1Uq3Qds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TQ9YmBSeDdjLcB2WFhqxLEV1UszmyCpYZiL+qa7lncv9VSTl5H8dqcdFrkiHDZSz
	 CA8QYXdNTD1tBfUDfRiLFlk3rmQ9AAK6Zb/oD0620QFnc5D9ZScECWC+R3O37hWCmN
	 F/xF9gXKmmLpB3QwMDmlgnkqL1H/nEXCpUgk+pv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/675] ASoC: tas2781: bound firmware description string parsing
Date: Thu, 30 Jul 2026 16:08:38 +0200
Message-ID: <20260730141449.141139554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit bc889dfcea9294a1eae7f8e2f3573a90764ae4d0 ]

The TAS2781 firmware parser reads several variable-length description
strings with strlen() before checking that the string terminator is
present inside the firmware blob. A malformed firmware image without a
NUL terminator can therefore make the parser walk past the end of the
firmware buffer before the later size checks run.

Add a small bounded string-length helper and use it for all description
fields that are parsed from the firmware buffer. Keep the existing size
checks for the fixed bytes that follow each string.

Fixes: 915f5eadebd2 ("ASoC: tas2781: firmware lib")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706144540.93929-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 63 ++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 78fd0a5dc6f22e..2f6522f76df9b3 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -12,6 +12,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
@@ -1082,13 +1083,42 @@ static int tasdevice_load_block_kernel(
 	return 0;
 }
 
+static int tasdevice_fw_strnlen(const struct firmware *fmw, int offset)
+{
+	const u8 *start;
+	const u8 *nul;
+	size_t remaining;
+	size_t len;
+
+	if (offset < 0 || offset >= fmw->size)
+		return -EINVAL;
+
+	start = fmw->data + offset;
+	remaining = fmw->size - offset;
+	nul = memchr(start, '\0', remaining);
+	if (!nul)
+		return -EINVAL;
+
+	len = nul - start;
+	if (len > INT_MAX)
+		return -EOVERFLOW;
+
+	return len;
+}
+
 static int fw_parse_variable_hdr(struct tasdevice_priv
 	*tas_priv, struct tasdevice_dspfw_hdr *fw_hdr,
 	const struct firmware *fmw, int offset)
 {
 	const unsigned char *buf = fmw->data;
-	int len = strlen((char *)&buf[offset]);
+	int len;
 
+	len = tasdevice_fw_strnlen(fmw, offset);
+	if (len < 0) {
+		dev_err(tas_priv->dev, "%s: Description error\n", __func__);
+		offset = len;
+		goto out;
+	}
 	len++;
 
 	if (offset + len + 8 > fmw->size) {
@@ -1220,7 +1250,12 @@ static int fw_parse_data(struct tasdevice_fw *tas_fmw,
 	memcpy(img_data->name, &data[offset], 64);
 	offset += 64;
 
-	n = strlen((char *)&data[offset]);
+	n = tasdevice_fw_strnlen(fmw, offset);
+	if (n < 0) {
+		dev_err(tas_fmw->dev, "%s: Description error\n", __func__);
+		offset = n;
+		goto out;
+	}
 	n++;
 	if (offset + n + 2 > fmw->size) {
 		dev_err(tas_fmw->dev, "%s: Description error\n", __func__);
@@ -1293,7 +1328,12 @@ static int fw_parse_program_data(struct tasdevice_priv *tas_priv,
 		}
 		offset += 64;
 
-		n = strlen((char *)&buf[offset]);
+		n = tasdevice_fw_strnlen(fmw, offset);
+		if (n < 0) {
+			dev_err(tas_priv->dev, "Description err\n");
+			offset = n;
+			goto out;
+		}
 		/* skip '\0' and 5 unused bytes */
 		n += 6;
 		if (offset + n > fmw->size) {
@@ -1356,7 +1396,12 @@ static int fw_parse_configuration_data(
 		memcpy(config->name, &data[offset], 64);
 		offset += 64;
 
-		n = strlen((char *)&data[offset]);
+		n = tasdevice_fw_strnlen(fmw, offset);
+		if (n < 0) {
+			dev_err(tas_priv->dev, "Description err\n");
+			offset = n;
+			goto out;
+		}
 		n += 15;
 		if (offset + n > fmw->size) {
 			dev_err(tas_priv->dev, "Description err\n");
@@ -2038,7 +2083,8 @@ static int fw_parse_calibration_data(struct tasdevice_priv *tas_priv,
 {
 	struct tasdevice_calibration *calibration;
 	unsigned char *data = (unsigned char *)fmw->data;
-	unsigned int i, n;
+	unsigned int i;
+	int n;
 
 	if (offset + 2 > fmw->size) {
 		dev_err(tas_priv->dev, "%s: Calibrations error\n", __func__);
@@ -2070,7 +2116,12 @@ static int fw_parse_calibration_data(struct tasdevice_priv *tas_priv,
 		calibration = &(tas_fmw->calibrations[i]);
 		offset += 64;
 
-		n = strlen((char *)&data[offset]);
+		n = tasdevice_fw_strnlen(fmw, offset);
+		if (n < 0) {
+			dev_err(tas_priv->dev, "Description err\n");
+			offset = n;
+			goto out;
+		}
 		/* skip '\0' and 2 unused bytes */
 		n += 3;
 		if (offset + n > fmw->size) {
-- 
2.53.0



