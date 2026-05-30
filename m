Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A37F25B08A;
	Sat, 30 May 2026 18:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166497; cv=none; b=WKsge6GX8/Ve4xT1uKJwhqFy7wkcN9dQ+tx1go5JxxRqKp8dDaG/HEwo2BE0ATE9CjnlwQ3Qt4UHPCM+c3qlT0eox3OrIWu43Ei/ZhSBW4CJEEfFz4olf9aCLl8t7Es1eip/51BZ387tTgBt/xntMIWmzjSk7KXJdoVHeoUyIeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166497; c=relaxed/simple;
	bh=lP9Wc8jOZH430W48NJvmaA35igSMAMt6u9e8G1vrvUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJMnPyndlmIOVe9uwpv8WCPX84EyChj37cNWgvN4OMrurkJXriDJ6Br+wymYilLR8G3D5XZ7vkdwKPvsndgr8J1MB0lFWWdzfYnYcJjGYvAJPiQr0XIMeHG4cji59b/DumDNCROiSymIJE7ITa2YbL1GyVwi/s//EdOdPMABwEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3Lgx1sk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3Lgx1sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE0C1F00893;
	Sat, 30 May 2026 18:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166495;
	bh=iOeBCnKNXG3i6V+lkw1/rNP3IedkMN5byG4/oOezyv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3Lgx1skS3IjdyfWdw8ZE/GpkBWg2mEdyv91bqWr3KSLvgU8wDo5Ez65ljRgRt5qP
	 JFjuR7GJO5qzqfsEiPdaGwrdDsw43dEaCxA5rpfgvBoIHQhsrqqR7DLv7IVtkNbB3x
	 STFbcF2W85PZpl8Cfo+2qzdJnZSW7lZICQgys0lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 389/589] backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()
Date: Sat, 30 May 2026 18:04:30 +0200
Message-ID: <20260530160235.025264395@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 797cc011ae02bda26f93d25a4442d7a1a77d84df ]

The devm_gpiod_get_optional() function may return an ERR_PTR in case of
genuine GPIO acquisition errors, not just NULL which indicates the
legitimate absence of an optional GPIO.

Add an IS_ERR() check after the call in sky81452_bl_parse_dt(). On
error, return the error code to ensure proper failure handling rather
than proceeding with invalid pointers.

Fixes: e1915eec54a6 ("backlight: sky81452: Convert to GPIO descriptors")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260203021625.578678-1-nichen@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/sky81452-backlight.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/backlight/sky81452-backlight.c b/drivers/video/backlight/sky81452-backlight.c
index 8268ac43d54f7..5375dc7d7cd95 100644
--- a/drivers/video/backlight/sky81452-backlight.c
+++ b/drivers/video/backlight/sky81452-backlight.c
@@ -204,6 +204,9 @@ static struct sky81452_bl_platform_data *sky81452_bl_parse_dt(
 	pdata->dpwm_mode = of_property_read_bool(np, "skyworks,dpwm-mode");
 	pdata->phase_shift = of_property_read_bool(np, "skyworks,phase-shift");
 	pdata->gpiod_enable = devm_gpiod_get_optional(dev, NULL, GPIOD_OUT_HIGH);
+	if (IS_ERR(pdata->gpiod_enable))
+		return dev_err_cast_probe(dev, pdata->gpiod_enable,
+					  "failed to get gpio\n");
 
 	ret = of_property_count_u32_elems(np, "led-sources");
 	if (ret < 0) {
-- 
2.53.0



