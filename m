Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A992770825;
	Wed,  5 Feb 2025 14:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766000; cv=none; b=Mh2h0yARoi4VZwsA9+t72inT0kHYYoAk984WUxYY1vqNWTzuQUCUddDg9xyt6k4MixvLBTlgyeZ2MmxjAyhiE39vWipTKtJGfKD5cc1iaYKy297N/ZUf1AZer7IqNWg3S/LgAgch7ii7aYhjsoG3EAxNP0V85QESl9Pcr9B42rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766000; c=relaxed/simple;
	bh=/nBCFJa1Bu3RhnJFo8ZYiMy9wO8V5gpR9A5ZnOO1IVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n++s3F0cSZMWuNC9eBoOP8fDLdLB3GjQCk4bZE+0+r9e6tj3L+qkTFh2RTXFDQnmE6+ia9bwG8yd/r5QS+2DJwH8kZjPt4QxfE9jm1L+yZs3Q/As39j/Sqc7wSmQVc2SIfRGuh36EFjY08s32OedjIgwNglxK5hO9EJsLJskjrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lz6Q/+JQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lz6Q/+JQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A60CC4CED1;
	Wed,  5 Feb 2025 14:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766000;
	bh=/nBCFJa1Bu3RhnJFo8ZYiMy9wO8V5gpR9A5ZnOO1IVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lz6Q/+JQtAFhHYeuL0VQiEjSnM+vhWdXvFzx/R542uL6L1UZ8TCivbAfX8zI0sHy4
	 C/pknf4dJ7xSxhvF51IBoDbO7FxLJtylxoMMiBvF6iRsaF2nK4oVbTJ29Q4EMzSgPU
	 lERR0l+Irwk5ew2BW2w5Xvlj2HrVcNocPczdOnko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 319/393] rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read
Date: Wed,  5 Feb 2025 14:43:58 +0100
Message-ID: <20250205134432.518750279@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



