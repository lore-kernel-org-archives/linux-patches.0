Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9013438A7;
	Fri,  7 Aug 2026 15:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114909; cv=none; b=OhhONsCxNVo0oMBx3JB7oc2qa5lIQBHJJ0IYooU4jk6M8socX2fP8yTRbmniV0G3cZwDouPDTEsOlIf9eSKcR9tJgMlH4J11tEkfqjsMUHol9BhglQ+savA5yBc4oQ/SN1DkH39uk4XGE7uCBn9bhAN8s55tp34EMruQ9VgWFvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114909; c=relaxed/simple;
	bh=1iWJxcN6kG7RN9Wzsw4ADmvsBD6jfix5G81nS4uzzrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQj6DhgPafZiQZcm/uxIVgGcd/fiVO0h5FFGaZ6MMhN46RvkAopAreqedBSueZbOwOXi4cOckdFEiM3ELVYz5h98y9icwx9uUooblTdGj4oPIaMvGHn1lSJw0uq1Nl6o71Tw6+lUqXfxD2P8/iY05smwPDjPOTVVNvEul2v8qhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McARsURb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McARsURb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5ED1F000E9;
	Fri,  7 Aug 2026 15:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114908;
	bh=XC82kKueBfFTdqYKlOzXXlRFlBLskJF42mnY/r5r5BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McARsURbcoUkb6bv7mP8+p1dKqwxEPJW8DcTJSa4SnK4+cbUZXsxuOrvFXu0nJohE
	 ZbNOXF84r6tQLhd65kqPGxw7nZGVnpDlUy0FIHQhru4rOwG4sDqL8s4CPEn2g6KMXW
	 qcZydUjFBrZM2NJ+7h/ekGk697SX4MzHUeqF7+lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/396] hwmon: (adt7470) Fix swapped PWM3 and PWM4 auto mode masks
Date: Fri,  7 Aug 2026 16:34:08 +0200
Message-ID: <20260807143426.176637696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



