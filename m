Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04095363C6F;
	Wed, 20 May 2026 17:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298776; cv=none; b=ckdaPvL5qKzNJKpZd3cImOTF28WilzEeIpEiBol7im7KRJq+1QyBtIcC/IeQuPCzKFmoIohjRjydP/EzmReXnR2W/USqH5HIUt7sEalg+y1NNOhrxE07gygZ/5MEHAbGblWJRd1Qi1luSRf7TNvGsJvO4aYHjP7f+bGprhKcgYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298776; c=relaxed/simple;
	bh=uXIArvkE/ZLW4+cOeQP6mDbH/f2bWqxovowTe/N0D+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bkWtNXw3I0w5eLc1BdcbdqHqxEvZTY+kHRR5Qv1aoxg59wr2oZdtGGVcgItD98i6ySGf4zRo/Id4jd9CWgV93iNuDA6rznK10ztUi8X7gA6VcVjyNRgajf+8poZMWp+kBBVMI54i2uhG92Id4R6NzJJNvTFoccoM+RrQ2ss5F00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3y1RTvQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3y1RTvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A16D1F000E9;
	Wed, 20 May 2026 17:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298774;
	bh=AxivU0wFHk9LcRdYZzO3i3cG/mh+H61dOhIQm+ZGVFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3y1RTvQpRZk0CwNuqO/e64M1A26s2AIMlviQ56HpfypsxyWLSPkpS7nTxVRW207B
	 uTBwXkbdS4Q2L3+NB8TA0klKWE8Bj3TPqNqs9kXoONbPE1Qz2BVYIgIREnBkYqkWO8
	 YQwNKED8o8i8O5/kcsXuH64ZcsOv3zGBia6sR9+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Luke Jones <luke@ljones.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 540/957] platform/x86: asus-wmi: adjust screenpad power/brightness handling
Date: Wed, 20 May 2026 18:17:03 +0200
Message-ID: <20260520162146.244633320@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8e3300f5c2943..e6fe6ed6a63da 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -4154,32 +4154,24 @@ static int read_screenpad_brightness(struct backlight_device *bd)
 
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



