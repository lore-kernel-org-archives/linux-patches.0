Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B614F6FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3C6C433F0;
	Mon, 19 Dec 2022 19:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477881;
	bh=EROIqoNGp8qilXmWfqLANzbdi0DpAOqVMO0exYXA7wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wv0IOltScDXkFiurCYpAcScWVtEIOxYBYGPHJJVCC/aox/OcHupvJgeY/TN4Gd7YB
	 VKvfle5eOBBRkYzYhOpxIGPmiOBwqzmU2dkJdd7qw9Jz4SjwdSW3DdI6dS6d9S5Edp
	 Eyr12tLfxDk1j3kLn4ZvmALna3/icptq7XwcArtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Martin Kaiser <martin@kaiser.cx>,
	Philipp Hortmann <philipp.g.hortmann@gmail.com>
Subject: [PATCH 6.1 19/25] staging: r8188eu: fix led register settings
Date: Mon, 19 Dec 2022 20:22:58 +0100
Message-Id: <20221219182944.226551878@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Kaiser <martin@kaiser.cx>

commit 12c6223fc1804fd9295dc50d358294539b4a4184 upstream.

Using an InterTech DMG-02 dongle, the led remains on when the system goes
into standby mode. After wakeup, it's no longer possible to control the
led.

It turned out that the register settings to enable or disable the led were
not correct. They worked for some dongles like the Edimax V2 but not for
others like the InterTech DMG-02.

This patch fixes the register settings. Bit 3 in the led_cfg2 register
controls the led status, bit 5 must always be set to be able to control
the led, bit 6 has no influence on the led. Setting the mac_pinmux_cfg
register is not necessary.

These settings were tested with Edimax V2 and InterTech DMG-02.

Cc: stable@vger.kernel.org
Fixes: 8cd574e6af54 ("staging: r8188eu: introduce new hal dir for RTL8188eu driver")
Suggested-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Tested-by: Michael Straube <straube.linux@gmail.com> # InterTech DMG-02,
Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com> # Edimax N150
Link: https://lore.kernel.org/r/20221015151115.232095-2-martin@kaiser.cx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/core/rtw_led.c |   25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

--- a/drivers/staging/r8188eu/core/rtw_led.c
+++ b/drivers/staging/r8188eu/core/rtw_led.c
@@ -32,40 +32,19 @@ static void ResetLedStatus(struct led_pr
 
 static void SwLedOn(struct adapter *padapter, struct led_priv *pLed)
 {
-	u8	LedCfg;
-	int res;
-
 	if (padapter->bDriverStopped)
 		return;
 
-	res = rtw_read8(padapter, REG_LEDCFG2, &LedCfg);
-	if (res)
-		return;
-
-	rtw_write8(padapter, REG_LEDCFG2, (LedCfg & 0xf0) | BIT(5) | BIT(6)); /*  SW control led0 on. */
+	rtw_write8(padapter, REG_LEDCFG2, BIT(5)); /*  SW control led0 on. */
 	pLed->bLedOn = true;
 }
 
 static void SwLedOff(struct adapter *padapter, struct led_priv *pLed)
 {
-	u8	LedCfg;
-	int res;
-
 	if (padapter->bDriverStopped)
 		goto exit;
 
-	res = rtw_read8(padapter, REG_LEDCFG2, &LedCfg);/* 0x4E */
-	if (res)
-		goto exit;
-
-	LedCfg &= 0x90; /*  Set to software control. */
-	rtw_write8(padapter, REG_LEDCFG2, (LedCfg | BIT(3)));
-	res = rtw_read8(padapter, REG_MAC_PINMUX_CFG, &LedCfg);
-	if (res)
-		goto exit;
-
-	LedCfg &= 0xFE;
-	rtw_write8(padapter, REG_MAC_PINMUX_CFG, LedCfg);
+	rtw_write8(padapter, REG_LEDCFG2, BIT(5) | BIT(3));
 exit:
 	pLed->bLedOn = false;
 }


