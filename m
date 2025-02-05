Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47F91E89C;
	Wed,  5 Feb 2025 14:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767528; cv=none; b=KezsOcm9AGRl2EZfjSUmWWFteCoy/5q9JPnOHR4iIm3czGo7HxAqT0NrUeNlvUvEGvE8JnmbCciYkMQEgWkqwOK85GnO8LHlV+Ih1jAuUSR8g8X7WZSMjdD9z+gVUhZlCyknJs3o7PZ1GyLmmSIlx3fcbchzQTdIxjFAxeu7vQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767528; c=relaxed/simple;
	bh=gm3vKusvIEWKzdsrZXFXaNnaroxPsMLr/7L4Xyt0d5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZsDMM87Hs76QEaWrtjkDrx9O9Qh46NnwTYoEntufY6cv5p7fUa8i1RmxIRlcNnDXw/0q52WrD7YAFQgjGTBbjwffXWRO3JxIgfiUYk03RPTVfkHfiGDd7Yawsywiecu46Nwbh9QNacemIzhuNeLiT6OveIP8s42xNcCm/5rHyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7tL4MyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7tL4MyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109A2C4CED1;
	Wed,  5 Feb 2025 14:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767528;
	bh=gm3vKusvIEWKzdsrZXFXaNnaroxPsMLr/7L4Xyt0d5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7tL4MySgsE/5OhYxGharzVgDrFK2m1Fny64J7oVlC4Gu55/XnIVeDI5l4lik9z4t
	 f0bJI8psQS374iXaj6uxjpZcJBVR84+LBdS9AmyQFaxAUTRS04EiZl8UKV6pVYQ1P9
	 IoCJzKrCVAosCSyC/6tVDEefVgK2Eymi9FDLPAFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 469/590] rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read
Date: Wed,  5 Feb 2025 14:43:44 +0100
Message-ID: <20250205134513.203003106@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 3ab8c5ed4f84fa20cd16794fe8dc31f633fbc70c ]

The nvmem interface supports variable buffer sizes, while the regmap
interface operates with fixed-size storage. If an nvmem client uses a
buffer size less than 4 bytes, regmap_read will write out of bounds
as it expects the buffer to point at an unsigned int.

Fix this by using an intermediary unsigned int to hold the value.

Fixes: fadfd092ee91 ("rtc: pcf85063: add nvram support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20241218-rtc-pcf85063-stack-corruption-v1-1-12fd0ee0f046@pengutronix.de
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85063.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf85063.c b/drivers/rtc/rtc-pcf85063.c
index fdbc07f14036a..905986c616559 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -322,7 +322,16 @@ static const struct rtc_class_ops pcf85063_rtc_ops = {
 static int pcf85063_nvmem_read(void *priv, unsigned int offset,
 			       void *val, size_t bytes)
 {
-	return regmap_read(priv, PCF85063_REG_RAM, val);
+	unsigned int tmp;
+	int ret;
+
+	ret = regmap_read(priv, PCF85063_REG_RAM, &tmp);
+	if (ret < 0)
+		return ret;
+
+	*(u8 *)val = tmp;
+
+	return 0;
 }
 
 static int pcf85063_nvmem_write(void *priv, unsigned int offset,
-- 
2.39.5



