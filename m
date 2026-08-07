Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340F74052CF;
	Fri,  7 Aug 2026 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114049; cv=none; b=Lfq0zS6h5M2FN82DKGBSDV1frKFX2kZTOnlGVPBfVaKGuSwFvL8wyN3SRlzAoTypRXR7h3bXUTmWW6qMpL1nOaGEyE1HBIoqPc5DZfWEPYDuH3cWZpmI6l3jMSetGIlzBKM5jySi8MnQsBuu0Qul+4M+13Xm9oBlZFWeW4ng4qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114049; c=relaxed/simple;
	bh=587R8M/K+Wt6nUuASC/5BrMmY3oOOc1SddI9bf4KoVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLq5Jyyi9ZTt8T6vXSabyEM4sqchIzB9PTPXjlyn9491aQQPAI5OFJV19GQbwat6H4ZA3KCsHfhWHw/vqQJezK+me4tD5T8XqFeZi0R5xImuoosb5g4vbLeUCh649lONlRllKg8+CgH5Y8C4EU86lWO5P8IP8/V4Oxu+kctzk7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzRwEmRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzRwEmRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1671F000E9;
	Fri,  7 Aug 2026 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114045;
	bh=j2aqFoGKzRK1s13uJGjBOZj7nQFDT3lXbXlbH0h43yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzRwEmRNMFGRb7mXG0w8bBXQMjAkqYNlphBZ/9SJNiSeG1MmvTnXjynZVHN/lGTSN
	 OCAHsyjmWIrbrGTfrJaeRQqZiV/HC3i1P3jnOYcWgdH2aoD+RW8yi87lTsiFsFKWgn
	 arwcCKZANybCR2HRe0JEKWZAl3Lg+B2RGsVTLB74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/337] hwmon: (adt7470) Fix swapped PWM3 and PWM4 auto mode masks
Date: Fri,  7 Aug 2026 16:34:43 +0200
Message-ID: <20260807143420.249066841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 41fa6a0e8b937..f0a45538ded6d 100644
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



