Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046142;
	b=mVCSH72MlNrTC60kD0mj6aUCuL/0KEhYhjSEZmKlk/vjnVqfbiTbfXoXMuA5h6hudTFY
	 cn3TNSnW+TMAv1eQxz4GVnHihIwAOleThkI/N5Nin1g9fTY995tSfHBtx53QmCY8hYaOq
	 75a6asg/ECOKyAy0rz178EClM195ZrbBlFLsDKdyR5R01CT07kRQ88IGKwk7kC1QSYyhU
	 RG2uz8BRiuJRdnY5XgOqAcix57iJVVTCczNBHt51aqsEAoNF39QcVa+Y76H5WIWozrqgq
	 PiFw+dQsipK+hXMJLKxq0bGw9M8rHBJulxi/K+xqzkcYjjyYFnnrlPUR3ZcjC/fHJLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qvYZGzCgClxg9+/9CYZIiwBXy2k8vAFUouxKU4D/UKs=;
	b=Cenk2zQWMmWhPy6Knp+Zz0HgY88eL52lz1XzmfUKd3RCb1tzTJEuvwfwW8tNKw2+BOwu
	 gTK2HatVDgZYQ1vjVvmucadPviPZ0LlDO+PHbZzw5wGKADWjeQboRJgwbjh3VnejOFXbj
	 hOdMDTeCpIQ9WtzTJ3Ciwgj23CpEuB6RkDRKKCjglMBm2wYzagavsr3XE6BzOp/9LwQjE
	 03OjKlIWFmiUkr3gZw2/fgV0S2PigRzqxlUYBMHDLYeMNZP5EOgM262j+3CFs8mGrkMn0
	 yvyO7t3ZnXrjuIND4er6yYAPls1KhCPM6XtdvWps88o/SpE3MKE+3Zw8ZvOfpPfZpPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TN8eI7TT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1F9606A31C;
	Wed, 18 Nov 2026 23:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TN8eI7TT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6A61F000C5;
	Wed, 18 Nov 2026 23:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046142;
	bh=qvYZGzCgClxg9+/9CYZIiwBXy2k8vAFUouxKU4D/UKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TN8eI7TTfAxmmHoSeZXfV0RD19DulqKOuYp5QPiuv6RMeEM/+SeCLDX6fAntJV/Xd
	 VhEP8+VFqAa3c241DbENxjkGyp0dESjKXoJDOriec0ZdQw7nUkiR6YNqUSnxcUTH7r
	 52Sk8+m6kttj6Up2fL0SSXRlDwsF9Tk+KMm4laEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1176/2857] hwmon: (lm70) Fix rounding of negative temperatures
Date: Wed, 18 Nov 2026 15:36:50 +0100
Message-ID: <20261118150243.946714463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c20a749fc7f21..a3563fbaa5522 100644
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



