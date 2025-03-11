Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3AB1925AF;
	Tue, 11 Mar 2025 15:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706585; cv=none; b=MJhYZDRb2PehTPOQ4aN0ePKDB3nN6ZkHvrNpsyU/jPLa9tnYLgetZ/FZcf7pkF5Q6E6fqkVw3g2VASS9rQfVOv84vNJBUjT7v6bYfJgVqPL7FgyYyjXqarYMS2LhGkq479PfCAVQd1bcjrF1u8/4HzVVOtZAlbqV2lieyxxotIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706585; c=relaxed/simple;
	bh=HJahDTO8uG/erwfKL5CwgZ9EoISXPuRHAPnJoIu/nOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwmeZhxKgp7KGruxVxo21CXtIz6hnlfsaaT55OaVXz5dRiWXNGMhGdpkw4Qa9iKUCIaJ4RSnlJ7hOATjfmIXQj2eWYvVL0rhl1E96W3Krz/yK1s/LE9CDziIXhltdb3euLaFq+QL4uXpD70xKv9GAZbn7TbpzwxQpVXJIG03y8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EH2QXdHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EH2QXdHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A0EC4CEE9;
	Tue, 11 Mar 2025 15:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706585;
	bh=HJahDTO8uG/erwfKL5CwgZ9EoISXPuRHAPnJoIu/nOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EH2QXdHdDOZiLID7cp5C4+5uptnzd+ZZNx7k+ktThm7BbEO7UMtdyXpGSYg6bVF/u
	 ENGLEKkJbOz1qy16R9Pbof1G9bCPeMIRf1GzS7FdXOnLzXy4iepLkBPMrOxK/VCtL3
	 RGkkw+qzd4gEpCTpyNg7pzgZJyq81NDnl3vh5LNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/462] rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read
Date: Tue, 11 Mar 2025 15:56:04 +0100
Message-ID: <20250311145802.230546440@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 449204d84c61d..dd3336cbb7921 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -328,7 +328,16 @@ static const struct rtc_class_ops pcf85063_rtc_ops_alarm = {
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



