Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C13C17CA12;
	Mon, 10 Mar 2025 17:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629047; cv=none; b=geOhIun3dHYk5bBirKmh+01T6rcsPF0/v96WzDJqg07YaCiXupzjoCzRrp6lJgwHtYqK92Jkt0hdf4BFNhcacWWVT4UuukTYXrGazixUjyElBob9s7s1274Avh/3dNrNltWiuvw6qPZ0GwttSxWIhcJlfGAzOEXp4hLVREsud04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629047; c=relaxed/simple;
	bh=SYH7yvVBBOp0vs3f05oia5/DMwj/hYfi/PROwd0UnOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKNaehY/ajbsrEB3kgLpkKdPJizGYFByu618wfMk67T0/kKK9kERI6qqZH0sfLXxX3l01RPlvdD+8eVvS7s455lSI0jyqi0bqYvFK0CtIMnuEHawr2hYYLVoBsPiS2WCFapN2hyOiugCzNubT/ailxmwvO2LQXWMIwDlZw9qcpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEwKVP8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEwKVP8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12942C4CEE5;
	Mon, 10 Mar 2025 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629046;
	bh=SYH7yvVBBOp0vs3f05oia5/DMwj/hYfi/PROwd0UnOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEwKVP8kASALnz4UNPszfvJ8Pl+vHB91uF6muAcx0MVzt1SzpHnuWmrH0jC/qdN4B
	 AWkX1yMMbfbWebsNk9Cu1gRf9rb7wKUoSe2Xxz9Ky3Yz3ugPcAWtK1E6T0DXB9EsJF
	 py/LM5i7izOvZzMlztAI1BsnNw50P42kKADs3y/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/620] rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read
Date: Mon, 10 Mar 2025 18:00:05 +0100
Message-ID: <20250310170551.891626447@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bf2e370907b73..89e080798e03f 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -320,7 +320,16 @@ static const struct rtc_class_ops pcf85063_rtc_ops = {
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



