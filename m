Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AA138AC80;
	Thu, 30 Jul 2026 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427379; cv=none; b=RquipXW49kUyCDu1+Ma0/z3qXBCzpxnj+V9Pom3079dXq6eJzfAXy7awqmwQzCfMZEfKce4w6z/mME+TRyNoVkMY4KYxW62r7xYEcs3+TlwYANRWKctltKBaLngIfiWoFfK1xjgvRTVjBvG/tM12gFT/1QaTRArEBbVZZeQRQLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427379; c=relaxed/simple;
	bh=23j07rqDZ5pWj9vmAfT4W1k+evJUm4feLaxLQBUFWek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1/0q86Y7MAS92lpAsDIbA/StmvqtB3/J6/xrW7nBELFQ/hd5ZM7CC/u26kVr0sY7xmONQFlqvBnHxp0pIFwdiT6xL3Nl+QwhZ7cDfAcEKRB+daeafbcNt4yXbJiMFi/gMFUkGdrdkXWmlmNcBr4862GtTdzpmkBguQ71JqtiMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIftJ5bT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIftJ5bT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2741F000E9;
	Thu, 30 Jul 2026 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427377;
	bh=MyBJHr0hs7z1gBQZ4jwgT7LIlUI349BprgNbIsrPVzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oIftJ5bTqwNoqMt5UbBv4FDQ6mD1ZXs0NReOzJyojQGMImf1LqpjZ1kJ2mXkywauw
	 UyEsPrlFBdAAnCAT88RAA4D3LJhFmVO11RfL9JxrQsKoOaCyj3Hi7IrzL8GtuwY4Wr
	 ZsvD+vlVrWUR7AgVRwUL9p+ilY0ZdQZVWbmM5N04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/484] ASoC: tas2781: bound firmware description string parsing
Date: Thu, 30 Jul 2026 16:10:29 +0200
Message-ID: <20260730141426.326178064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1cc64ed8de6da8..4b6bed6bf11567 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -11,6 +11,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
@@ -921,13 +922,42 @@ static int tasdevice_load_block_kernel(
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
@@ -1059,7 +1089,12 @@ static int fw_parse_data(struct tasdevice_fw *tas_fmw,
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
@@ -1132,7 +1167,12 @@ static int fw_parse_program_data(struct tasdevice_priv *tas_priv,
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
@@ -1195,7 +1235,12 @@ static int fw_parse_configuration_data(
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
@@ -1849,7 +1894,8 @@ static int fw_parse_calibration_data(struct tasdevice_priv *tas_priv,
 {
 	struct tasdevice_calibration *calibration;
 	unsigned char *data = (unsigned char *)fmw->data;
-	unsigned int i, n;
+	unsigned int i;
+	int n;
 
 	if (offset + 2 > fmw->size) {
 		dev_err(tas_priv->dev, "%s: Calibrations error\n", __func__);
@@ -1881,7 +1927,12 @@ static int fw_parse_calibration_data(struct tasdevice_priv *tas_priv,
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



