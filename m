Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591001;
	b=H0f1GcRl8E3R2RkPmjVfRWvNyQcvRxnKfI4D9EfldbYy1QmuCRMlR+jaeXpU4Brq/yE3
	 XczLAI3zAvlIw/RghCUHs26DrodtWMv91Cht+ezW3kgSWS98MVFAtiO0RKKNh/bkMtzzT
	 PrBdiZ2rbI64Gl6ceev47ZDeRKIsJQki8Xs6AmKnWByS5Og4W5q+xTGx9a55ewDmIXGZp
	 WV0KUZeQkgHCkaqI7R405FpU5BxWkJJt4MZLPphZZMZ/JS9SMXa0LA61pAJFDcAPZS9+F
	 ikgZ4KglxJJOLpYw68cCY2oIP5b/5EsbQR7DKRb+HSh8G0FTanYe9n2NA6olFwMPJgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UwPyAr7s19nJKB8ruvWMMeEZbwAhogbW/jwCvMrHzXs=;
	b=dkMm7sLl8EGAWpqyigFfKFUmJUcpfdftohEPJ+ci/ok272hlLVg1Gobj38Y1Jdro/Df0
	 k03bED9C76Ny94I+8PduKFQiAfj/E+erDujqBwHO3o63kspcfTYC9HpkXiBnb6By2a321
	 X8bY8LkWduujfZfUAB3m2uuAwmdDuwK3JUBzlIoQVFTzNTGqiM6t/4v/cufvRMr10bzhI
	 Ml+h6ZIJpLRK/04fiel9z5z6TGx7/IjBISFjVPm2EuHiILXMjSATge03QQx+xOUOhdgbQ
	 ix8xaVP8IC2OW3tkBYj7GIzOu6xSUQiewe+7mwfleOKV0pPw5MtilaaB5esgMYRYOLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNOhAIEk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AEE6070F0D;
	Fri, 13 Nov 2026 17:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNOhAIEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F4C1F000C4;
	Fri, 13 Nov 2026 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591000;
	bh=UwPyAr7s19nJKB8ruvWMMeEZbwAhogbW/jwCvMrHzXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNOhAIEk69uQox3IR09AwNErL9temO+8xlwdkKShIaXynhhIglomJzOgkRXTdv0a0
	 Df4PMFDmyc1JlkQeA77wubVMLqQsfaO9vR2dcoyGd+YCO+ef3efD99zQFb3XAt5/uR
	 ScHP5DLvJCPp8HEv7dc6G3vcs5OnTTrCQbknPKUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/670] hwmon: (lm70) Fix rounding of negative temperatures
Date: Fri, 13 Nov 2026 10:45:10 -0500
Message-ID: <20261113153816.883611905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ridham Khurana <khurana.ridham222@gmail.com>

[ Upstream commit eddb0aaacce4baa9d8176eb2f4bd9e99e867f8fc ]

temp1_input_show() drops the low bits of the temperature register by
dividing the raw value (raw / 32 on the LM70). These bits are not part
of the temperature: the LM70, LM71, LM74 and TMP122/TMP124 always
return some of them as 1, and the TMP125 fills them with copies of the
temperature LSB. Division rounds toward zero, so a negative temperature
with any of these bits set is reported one LSB too high.

For example, the TMP122 returns 0xffff for -0.0625 degrees C, which the
driver reports as 0. The LM70 returns 0xf39f for -25 degrees C, which
the driver reports as -24750.

Use an arithmetic right shift instead, which drops the low bits and
rounds down.

Fixes: e1a8e913f97e ("[PATCH] lm70: New hardware monitoring driver")
Fixes: a86e94dc946d ("hwmon: (lm70) Add support for LM71 and LM74")
Fixes: cd929672a9ef ("hwmon: (lm70) Add ti,tmp125 support")
Cc: stable@vger.kernel.org
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260924205326.1739229-1-khurana.ridham222@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm70.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index 0d5a250cb6722..ee06c5641870a 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -97,21 +97,21 @@ static ssize_t temp1_input_show(struct device *dev,
 	 */
 	switch (p_lm70->chip) {
 	case LM70_CHIP_LM70:
-		val = ((int)raw / 32) * 250;
+		val = ((int)raw >> 5) * 250;
 		break;
 
 	case LM70_CHIP_TMP121:
 	case LM70_CHIP_TMP122:
 	case LM70_CHIP_LM74:
-		val = ((int)raw / 8) * 625 / 10;
+		val = ((int)raw >> 3) * 625 / 10;
 		break;
 
 	case LM70_CHIP_LM71:
-		val = ((int)raw / 4) * 3125 / 100;
+		val = ((int)raw >> 2) * 3125 / 100;
 		break;
 
 	case LM70_CHIP_TMP125:
-		val = (sign_extend32(raw, 14) / 32) * 250;
+		val = (sign_extend32(raw, 14) >> 5) * 250;
 		break;
 	}
 
-- 
2.53.0



