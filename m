Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFD825EF8F;
	Tue, 11 Mar 2025 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705571; cv=none; b=mBliKV8Doa6w8z3dNaz4+pvMWAShsElKbwwen1xEyVl5uX74RGEOztZTYDSt0jZrlKcTLmD6UUMe9x/LwkfB1XG4yBvKyceRJyZ7YVyUkzRKB1J/CJhnCK3jSiBO8Ul117ygb0KAEmT+nManpb+RU2/k4LTFwE1Rnb5YN/UEJTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705571; c=relaxed/simple;
	bh=zBhdzl1Kdik27C1Rn1sJR0HViHEHpmXddO3myRRlOUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nH0fkFKJ5AacPqARi7LQn7oYIEroKSgGUSySdPhYnsONw6Iq2DgHYHbJ0pFPqqjP+nx4l5TA88fsHKjNjTIt8KTYwjZA8ZhqSPCuSfPs8N+Ejs3jaWYoqzXeA4yFlZ3A7GOtBRy2hjGDtnWdWZCj1gCLmyJiq+8R6VY6bIpAIBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1bQpfQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1bQpfQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D71C4CEED;
	Tue, 11 Mar 2025 15:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705570;
	bh=zBhdzl1Kdik27C1Rn1sJR0HViHEHpmXddO3myRRlOUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1bQpfQ/8478CSIJLXLI2U5m4O44mhbjAmeGOwfuM6f9bV10W7GtwzgGiyQI5ODMo
	 IudQOgMnnZ3dYIqeZxYy8Q57oeAWHztiVjnGO9p2uXISMJQvxhYLfpSN8oSmNZYJWW
	 4FMs0PuDTtq+texLNhVOj1a2ol1HVgwhxIryE9vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/328] rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read
Date: Tue, 11 Mar 2025 15:57:11 +0100
Message-ID: <20250311145717.320183631@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3e7ea5244562e..5251b6cc2def0 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -332,7 +332,16 @@ static const struct rtc_class_ops pcf85063_rtc_ops_alarm = {
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



