Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341F154F92;
	Thu, 30 Nov 2023 16:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjxRz4XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55B6C433C8;
	Thu, 30 Nov 2023 16:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361650;
	bh=jQrM7E+O+PHHLrJr3Bjs2x+o+xcwd/CQzoWgCoHdtlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjxRz4XHfNh4bqwasjXwxhMcD3buAzSxXIB5tx5B9qem53khQN93WS1U53q+svFxj
	 FAHWr8cfToYEtO5OqIo+msx96u8luqV/ky2YoHh31JfY16ZcLERYiQG0ckGmjRtSwk
	 Yxq9Ko5eBP99VojHhkdLZKwGPkqkbuxfrk+uJa/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 082/112] platform/x86: ideapad-laptop: Set max_brightness before using it
Date: Thu, 30 Nov 2023 16:22:09 +0000
Message-ID: <20231130162142.920857227@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>

commit 7a3c36eef9a5d13b16aa954da54224c9c6bed339 upstream.

max_brightness is used in ideapad_kbd_bl_brightness_get() before it's set,
causing ideapad_kbd_bl_brightness_get() to return -EINVAL sometimes.

Fixes: ecaa1867b524 ("platform/x86: ideapad-laptop: Add support for keyboard backlights using KBLC ACPI symbol")
Signed-off-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20231114114055.6220-2-stuart.a.hayhurst@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index ac037540acfc..88eefccb6ed2 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1425,18 +1425,17 @@ static int ideapad_kbd_bl_init(struct ideapad_private *priv)
 	if (WARN_ON(priv->kbd_bl.initialized))
 		return -EEXIST;
 
-	brightness = ideapad_kbd_bl_brightness_get(priv);
-	if (brightness < 0)
-		return brightness;
-
-	priv->kbd_bl.last_brightness = brightness;
-
 	if (ideapad_kbd_bl_check_tristate(priv->kbd_bl.type)) {
 		priv->kbd_bl.led.max_brightness = 2;
 	} else {
 		priv->kbd_bl.led.max_brightness = 1;
 	}
 
+	brightness = ideapad_kbd_bl_brightness_get(priv);
+	if (brightness < 0)
+		return brightness;
+
+	priv->kbd_bl.last_brightness = brightness;
 	priv->kbd_bl.led.name                    = "platform::" LED_FUNCTION_KBD_BACKLIGHT;
 	priv->kbd_bl.led.brightness_get          = ideapad_kbd_bl_led_cdev_brightness_get;
 	priv->kbd_bl.led.brightness_set_blocking = ideapad_kbd_bl_led_cdev_brightness_set;
-- 
2.43.0



