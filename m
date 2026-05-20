Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EB3368968;
	Wed, 20 May 2026 18:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301124; cv=none; b=UPoHixIl3EmjvI86Grk4V8HYdtv4TVW6qigtwYwESPWjj9TbctYky7CC/cKo/hPX/POSylGCAchn/3H/cKQKAMW+hkddRTGrj8Os3+e3Lu1nKpiJrlViiAJYS/9v3rEDzuaFTqld1QRvF1YHnm9lQELrWTi7yLYEXWzu6cfZKo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301124; c=relaxed/simple;
	bh=bRwKmMn+0xCtFpJXSojiV1FMhUpojdIkp/dVO2gWONI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Am9Hk2A2Y0GYd4p3glaMSgbkgohm68eWsz+DhvcxNto2aB3atd/Mwgnxa/KbHRoX1ZPoeaGvIenlpP4lP33wiKNg4akVYhyA0rO/YTDTLF5/TEJ6Ix7rlBK/czi+iRPvFfeW7pEAqpS5j1wdhv1gZLwZ5V7UAafcngqsIWJZQ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QL6Gm9bU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QL6Gm9bU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439151F000E9;
	Wed, 20 May 2026 18:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301122;
	bh=r2F6ZSXGuXhwGhE/Ax2WzN3Lu2Iu3yrYczHKrobiiVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QL6Gm9bUus6k3b9cY9FcYF4Uq2JNYc+yFbGKIjIsgnoXw3rX78/KaX/NLG01CgtCn
	 pfb9k5iMt7U+tKZ98niMxSmdQKj1K8I1NJMBkIQ3/lf5FP386h9vRYhpTbImMtW8bN
	 rJ2oHkKF071KwZVQt0X7mp/WLBO9k39z/xDZJGWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Luke Jones <luke@ljones.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 393/666] platform/x86: asus-wmi: adjust screenpad power/brightness handling
Date: Wed, 20 May 2026 18:20:04 +0200
Message-ID: <20260520162119.775665898@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 130d29c5627cd50e786e926ad7ef66322c5a0c09 ]

Fix illogical screen off control by hardcoding 0 and 1 depending on the
requested brightness and also do not rely on the last screenpad power
state to issue screen brightness commands.

Fixes: 2c97d3e55b70 ("platform/x86: asus-wmi: add support for ASUS screenpad")
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Luke Jones <luke@ljones.dev>
Link: https://patch.msgid.link/20260302174431.349816-2-denis.benato@linux.dev
Link: https://patch.msgid.link/20260326231154.856729-2-ethantidmore06@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 34 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 92ce975d900d0..2e03d63708a7c 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -4130,32 +4130,24 @@ static int read_screenpad_brightness(struct backlight_device *bd)
 
 static int update_screenpad_bl_status(struct backlight_device *bd)
 {
-	struct asus_wmi *asus = bl_get_data(bd);
-	int power, err = 0;
-	u32 ctrl_param;
+	u32 ctrl_param = bd->props.brightness;
+	int err = 0;
 
-	power = read_screenpad_backlight_power(asus);
-	if (power < 0)
-		return power;
+	if (bd->props.power) {
+		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 1, NULL);
+		if (err < 0)
+			return err;
 
-	if (bd->props.power != power) {
-		if (power != BACKLIGHT_POWER_ON) {
-			/* Only brightness > 0 can power it back on */
-			ctrl_param = asus->driver->screenpad_brightness - ASUS_SCREENPAD_BRIGHT_MIN;
-			err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_LIGHT,
-						    ctrl_param, NULL);
-		} else {
-			err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 0, NULL);
-		}
-	} else if (power == BACKLIGHT_POWER_ON) {
-		/* Only set brightness if powered on or we get invalid/unsync state */
-		ctrl_param = bd->props.brightness + ASUS_SCREENPAD_BRIGHT_MIN;
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_LIGHT, ctrl_param, NULL);
+		if (err < 0)
+			return err;
 	}
 
-	/* Ensure brightness is stored to turn back on with */
-	if (err == 0)
-		asus->driver->screenpad_brightness = bd->props.brightness + ASUS_SCREENPAD_BRIGHT_MIN;
+	if (!bd->props.power) {
+		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 0, NULL);
+		if (err < 0)
+			return err;
+	}
 
 	return err;
 }
-- 
2.53.0



