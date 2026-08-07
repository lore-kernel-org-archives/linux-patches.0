Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7AC359A89;
	Fri,  7 Aug 2026 15:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115942; cv=none; b=G4PJfrWFX/2tuY0lFa9BzEJkmzwuyF/nxCweVQv09pLPAaRNPBDxiCJ4iWegcBxHqhwLrD5z4aT/i13ZSv1yxNkzz2XdrvnwYoUO17llwGoF7iJ+TbwyhsTTiMt36J8BO/QFmddiuTfTvTGFSmJ8Uf5+ltVY0gnte+pF0zeBEo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115942; c=relaxed/simple;
	bh=Qvq+V7hQYTVx+BZsZXRA9P83/8o/rWggDcQI6j6kkUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNghJg9YiJF2Um2lSwx8NwCcM0oxarTHcRksBgh3aZ0IfRgYGGWQOAYlXRV/cdLAUm1hZzaC+qLD0a7rd34UWoaFCT2OCS34AyxIFAyLwhunYUDhdlYW5QliZ9cOTa5NXiYxRFipViRarzQz0ZoHNzHtXHQTHZd0eqI6fqdl+Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SA2WPJ7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SA2WPJ7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6351F01567;
	Fri,  7 Aug 2026 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115937;
	bh=F30wb2258ILKZlOHgE/GnPyeQzSw+EIYrSTVgweb6jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SA2WPJ7idUKngUqLVainXgMSQHTZ/FNHZ1vSsM7LNJMj+kwfD2ANoYmtgEGhrFQKM
	 OBDS9pLq7vwWyZPJHZe7aN6m+XUnGTTpLJg13DWv7zJ25I8L/7WSjkAzIUjs3COUp9
	 ii7KqGMQDPCDLWg+EPEJapL+YGnZ7jBCkAMxeQ1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/261] hwmon: (adt7470) Fix swapped PWM3 and PWM4 auto mode masks
Date: Fri,  7 Aug 2026 16:36:51 +0200
Message-ID: <20260807143416.551534877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit a3850231521b06bbbb18c8ebea100320c14a08be ]

The ADT7470_PWM3_AUTO_MASK and ADT7470_PWM4_AUTO_MASK macros are
currently defined with swapped bit values.

According to Table 22 of the ADT7470 datasheet, the Fan Control Mode
Configuration for register 0x69 follows the exact same bit position
layout as register 0x68:
- 0x68 Bit[7] corresponds to BHVR1 (PWM1) -> 0x80
- 0x68 Bit[6] corresponds to BHVR2 (PWM2) -> 0x40
- 0x69 Bit[7] corresponds to BHVR3 (PWM3) -> 0x80
- 0x69 Bit[6] corresponds to BHVR4 (PWM4) -> 0x40

Consequently, PWM3 should use mask 0x80 and PWM4 should use 0x40.

This typo did not cause any functional bugs because these specific
macros are never referenced in the driver code. Instead, the driver
correctly applies the configuration by relying on the modulo parity of
the channel index (e.g., `channel % 2`) to selectively apply either
ADT7470_PWM1_AUTO_MASK (0x80) or ADT7470_PWM2_AUTO_MASK (0x40).
Since the bit layout is identical between the two configuration
registers, the hardware is currently configured correctly.

Fix the macro definitions to reflect the datasheet accurately and
prevent future bugs or confusion during code review and refactoring.
As this is a purely cosmetic fix with no functional impact, a backport
to stable kernels is not necessary.

Fixes: 6f9703d0be16 ("hwmon: add support for adt7470")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20260727-adt7470_fixes-v2-4-598e38a46ba6@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index b63e3a0f6c135..76f7efae54e07 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -70,8 +70,8 @@ static const unsigned short normal_i2c[] = { 0x2C, 0x2E, 0x2F, I2C_CLIENT_END };
 #define		ADT7470_PWM1_AUTO_MASK		0x80
 #define		ADT7470_PWM_AUTO_MASK		0xC0
 #define ADT7470_REG_PWM34_CFG			0x69
-#define		ADT7470_PWM3_AUTO_MASK		0x40
-#define		ADT7470_PWM4_AUTO_MASK		0x80
+#define		ADT7470_PWM4_AUTO_MASK		0x40
+#define		ADT7470_PWM3_AUTO_MASK		0x80
 #define	ADT7470_REG_PWM_MIN_BASE_ADDR		0x6A
 #define ADT7470_REG_PWM_MIN_MAX_ADDR		0x6D
 #define ADT7470_REG_PWM_TEMP_MIN_BASE_ADDR	0x6E
-- 
2.53.0



