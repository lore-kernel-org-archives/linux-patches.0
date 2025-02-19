Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8344176ADE;
	Wed, 19 Feb 2025 09:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956620; cv=none; b=QpyEbqQ09n+FsKyMJVA1EpWEta7yKhNpIGrc46GK01yE/W3fBGI7gpw1jFHz12mib+Iqm+eNFsZV+DekgzYvhS4uPTzSs3Hb8MswO8ReVwnnFUFnn85m8JfI3IELaRzyaThNUOOKU0Vn0EgdvjgmltoosQCnaZqenZaKJHXCCz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956620; c=relaxed/simple;
	bh=jyobTBlZrudfKyEFw7seZjeE86pZtXqUAJ3Xwk2Aq30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI5ZR8cekc54/HbaS/6yioiTT6z16Pjo73ajTG32kt3ndt3Mf8aRc/p8Y6qepuSLpG88oEjlF621f3L7LOopcisRxhQehDAL2vMBxopxWQseJopcFxYwF6LuPaX2npDHDB2PwTrVCP2WcV90171sVtZn5RMzBcNEdduTHkn8Lfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HirPEp8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HirPEp8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C51C4CED1;
	Wed, 19 Feb 2025 09:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956619;
	bh=jyobTBlZrudfKyEFw7seZjeE86pZtXqUAJ3Xwk2Aq30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HirPEp8fQL7b+Widn9ToSNURtnKKcvBHM7Z0GW6kCUtmXCE416ZouCxMf+Z9rjbYd
	 NqAVedsee6p8Nqp32Re6Wnhy/Z8uTzFPa/+BMfVkgFePq7+I5SXKep95rixeQ2J2er
	 kjdXQVC/ebCqYlnaKfPs5Te9ib9SZiyt+BvWY9+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 214/578] rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read
Date: Wed, 19 Feb 2025 09:23:38 +0100
Message-ID: <20250219082701.475794555@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 754e03984f986..6ffdc10b32d32 100644
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



