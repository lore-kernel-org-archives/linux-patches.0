Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590133;
	b=C0biD5BDSnFDlr+/QYYLctIBxn4tC68e15vi9ZhFqkL/8MD4JymFq8P6EkU5mQim/d2q
	 3VWo6IByNx2ouphy+jgMauXmiTdwDRK3bLdDqLS+ZWWBIuPZbJItWja4DchMVDNT8v/Bp
	 5sVOWf1R7XK+SqyXLP4xawUt9Cbzw17+RAUBcjvGKyN87PHegwUomLslC9AOsm4AvRRxl
	 9swndwG/mXhNk21UJ92gZg3c+v//ugubddYWtFnhr4tbR3cKfj6GxJ9qwnD4sSf9sBODd
	 rr0FW4kNhrPp1Kd92/mrQFMxRL4uNsEtyskHsBl0xAZ6aEdKzOztljZXig0lkfMNAGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=85zfZRb5+DRAa4lLZVg743/vK4diHAbW5mdfeH1V6G4=;
	b=CPKt3eiIWCaTo3h23IDD8fGkkgAiGIooo9Y3paxyoeR2rVB2HdfndIJPrMxgfEetZ1oM
	 UaOSgiXpYeEjAXZO8tjFIt5NQv+yryCRyZJNjpuwSvxwe3QaUgC28JJJUmNYMdkfKPt5g
	 a4KiHdGTsShaSdOp5XHo5+PRrVpgImJ8xqKXSbZu3obZBZW3MIOUWkEEO7B/iHzecjF/S
	 UWu0paJoeTtxJht/AflkKOO/Tz0crv0lZK9yDtCgXltOaB4lunAHCu5i/00mrIarK2i8x
	 2rzNTRoev+a6Jivf6VJlnqLeVxh5aniP5kodW+KJTmSgyIBwnIZdF3fE6C4S4dyrSXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wv9eYcRB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E336160A5BCE;
	Fri, 13 Nov 2026 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wv9eYcRB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6641F000C4;
	Fri, 13 Nov 2026 17:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590132;
	bh=85zfZRb5+DRAa4lLZVg743/vK4diHAbW5mdfeH1V6G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wv9eYcRBSQGrDOnntPtNN1z7BM55V993efiToxOqNFg0NawbleQY6WP5kEmFDqSk6
	 5YM4K8hKUqydq4ZyobN2NUiwt8YByRssWhMTbdSx+I8KiEFAzZblBYmvRcwDwH5eaa
	 bkaTVUXl8kHx2+GI9lQMm/HlbhiwEiK79ZKu12E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/686] hwmon: (lm70) Fix rounding of negative temperatures
Date: Fri, 13 Nov 2026 10:44:45 -0500
Message-ID: <20261113153825.948055149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



