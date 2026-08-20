Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616A2381E95;
	Thu, 20 Aug 2026 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239178; cv=none; b=YCSxyO2wNl6fEdzXAydrgssf+dtl/9LdT3+jyJPPto6T2Z/aXrDDkYRK7JEOjyrjE0dcayJ6s+IQK3bsmfWLjdTGu3O02nSp1F/4MOvDnhWIJnqHGQPXRPaeSoXsV8HW7dSxLZ9U+4aqxCIeGfmt8kNue5O387c2Jzr1uq0dByU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239178; c=relaxed/simple;
	bh=pTZ6GOTkRZvfRBezoAXXa+S6tzeJIux1jd83Qm3xF24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO3isJmHULSIuy63wyQAMEk/PPMQnUDj+0N8L9NJLf/JEdmL4ISXXR0l6xgshp7hqdkOhGkccCSa2BFPEyM2kGPmzYQxGw9IX4JOwtohsMP0xAO7J0DEsIH6UK/CyU0uQoG/3mtO2kkoToI+8Y09N/9SAvApmp+NDFKF5QN7y0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcsOsSkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcsOsSkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7DB1F00A3A;
	Thu, 20 Aug 2026 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239177;
	bh=csO+g8cBv7F8PdhWUz5Z0SpaZkwVEkmvxCLanCZZjr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcsOsSkp61UkbrrxwncC+J+Sr4TB0YYq3Xxe8123y8UbYUdnkwMFzIdbu7KrIAt0B
	 8Js2yoiG+0BiSXDiCUjXPjURHcOHVfMR2ZRZWxAaVUzHKBqDcOibCxeeHdp5dRdQbK
	 hiRuv5OwWu4HF8ngOjnAJkLhzaqe/IurIb1f0FNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/217] ASoC: tas2781: fix clang build error for goto bypassing cleanup variable
Date: Thu, 20 Aug 2026 16:55:45 +0200
Message-ID: <20260820145243.061166731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 566fec6a33075a0ea5c441c26571221f17f4ed98 ]

Remove invalid goto exit paths that jump across guard(mutex) cleanup
variable initialization, replace them with direct kfree(src) and return,
to fix the s390 clang build error in acoustic_ctl_write().

Fixes: d75d38dc4604 ("ASoC: tas2781: Add a debugfs node for acoustic tuning")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20260807000304.826-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-i2c.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 0b83446da45ea..58f8ae016dac0 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1533,8 +1533,8 @@ static ssize_t acoustic_ctl_write(struct file *file,
 	if (src[0] > max_pkg_len && src[0] != count) {
 		dev_err(priv->dev, "pkg(%u), max(%u), count(%u) mismatch.\n",
 			src[0], max_pkg_len, (unsigned int)count);
-		ret = 0;
-		goto exit;
+		kfree(src);
+		return 0;
 	}
 
 	switch (src[1]) {
@@ -1548,14 +1548,14 @@ static ssize_t acoustic_ctl_write(struct file *file,
 		break;
 	default:
 		dev_err(priv->dev, "%s Wrong code %02x.\n", __func__, src[1]);
-		ret = 0;
-		goto exit;
+		kfree(src);
+		return 0;
 	}
 
 	if (len < 1) {
 		dev_err(priv->dev, "pkg fmt invalid %02x.\n", len);
-		ret = 0;
-		goto exit;
+		kfree(src);
+		return 0;
 	}
 
 	for (j = 0; j < priv->ndev; j++)
@@ -1565,8 +1565,8 @@ static ssize_t acoustic_ctl_write(struct file *file,
 		}
 	if (j >= priv->ndev) {
 		dev_err(priv->dev, "no such device 0x%02x.\n", src[2]);
-		ret = 0;
-		goto exit;
+		kfree(src);
+		return 0;
 	}
 
 	reg = TASDEVICE_REG(src[3], src[4], src[5]);
@@ -1597,7 +1597,7 @@ static ssize_t acoustic_ctl_write(struct file *file,
 		dev_err(priv->dev, "i2c communication error.\n");
 	else
 		ret = count;
-exit:
+
 	kfree(src);
 	return ret;
 }
-- 
2.53.0



