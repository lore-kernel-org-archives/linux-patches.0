Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125002DA743;
	Tue, 11 Nov 2025 01:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824107; cv=none; b=IYo3GqXjKHGyvDvcxZ+PtQv/D95f1HLXw7+N4mnmuHgw/Bvwr9syVKn2mYe3fApqWZchu846uLCjFVKqTByG9yYf6ubk1Q79MbW4ENcDZktQsYr32XwaLd68Vq6dr7WaSPfQ+X/nGqcw+RP7kk42gxag+CVtEyCL0qhWsLEtmhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824107; c=relaxed/simple;
	bh=G/Zr4yifU8HQDRDZsEYzc8YZICeISSo/HYPbvaJFEU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVg1WTcqJmobcKVcOX6fzr4Y2dgMrlSxCLtwBpTavrEX+aB/DadABcTUjY7Rsn8zuutpmoImkM3txmSGTZmDsvpoWAdML2KfpRzwFICycr9i2l8UDV9SCe3CcPAY7pWnjt1UZH0F6ob2ZgTMcZ1cGq/N1XQQ99yjOAbyjxzX/5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5BGUO0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5BGUO0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD8AC16AAE;
	Tue, 11 Nov 2025 01:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824106;
	bh=G/Zr4yifU8HQDRDZsEYzc8YZICeISSo/HYPbvaJFEU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5BGUO0Yu/FNaMi55VGsJuHh0QCfrOj2+TuGUAoCKd7PC2j5bZ3G/w0aaE6V+0wgp
	 7sS6sJoW+h8cktLGeUINpK1qNgwHXcvtcoNUMDxEWxS4M90HRIjcKIszWDp42adYlK
	 jDUOBGXJKCRogk0DJrPLn9oVaL7rGf6yU6mz0ZbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 411/849] drm/st7571-i2c: add support for inverted pixel format
Date: Tue, 11 Nov 2025 09:39:41 +0900
Message-ID: <20251111004546.378760947@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit e61c35157d32b4b422f0a4cbc3c40d04d883a9c9 ]

Depending on which display that is connected to the controller, an
"1" means either a black or a white pixel.

The supported formats (R1/R2/XRGB8888) expects the pixels
to map against (4bit):
    00 => Black
    01 => Dark Gray
    10 => Light Gray
    11 => White

If this is not what the display map against, make it possible to invert
the pixels.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://lore.kernel.org/r/20250721-st7571-format-v2-4-159f4134098c@gmail.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sitronix/st7571-i2c.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sitronix/st7571-i2c.c b/drivers/gpu/drm/sitronix/st7571-i2c.c
index 453eb7e045e5f..125e810df1391 100644
--- a/drivers/gpu/drm/sitronix/st7571-i2c.c
+++ b/drivers/gpu/drm/sitronix/st7571-i2c.c
@@ -151,6 +151,7 @@ struct st7571_device {
 	bool ignore_nak;
 
 	bool grayscale;
+	bool inverted;
 	u32 height_mm;
 	u32 width_mm;
 	u32 startline;
@@ -792,6 +793,7 @@ static int st7567_parse_dt(struct st7571_device *st7567)
 
 	of_property_read_u32(np, "width-mm", &st7567->width_mm);
 	of_property_read_u32(np, "height-mm", &st7567->height_mm);
+	st7567->inverted = of_property_read_bool(np, "sitronix,inverted");
 
 	st7567->pformat = &st7571_monochrome;
 	st7567->bpp = 1;
@@ -819,6 +821,7 @@ static int st7571_parse_dt(struct st7571_device *st7571)
 	of_property_read_u32(np, "width-mm", &st7571->width_mm);
 	of_property_read_u32(np, "height-mm", &st7571->height_mm);
 	st7571->grayscale = of_property_read_bool(np, "sitronix,grayscale");
+	st7571->inverted = of_property_read_bool(np, "sitronix,inverted");
 
 	if (st7571->grayscale) {
 		st7571->pformat = &st7571_grayscale;
@@ -873,7 +876,7 @@ static int st7567_lcd_init(struct st7571_device *st7567)
 		ST7571_SET_POWER(0x6),	/* Power Control, VC: ON, VR: ON, VF: OFF */
 		ST7571_SET_POWER(0x7),	/* Power Control, VC: ON, VR: ON, VF: ON */
 
-		ST7571_SET_REVERSE(0),
+		ST7571_SET_REVERSE(st7567->inverted ? 1 : 0),
 		ST7571_SET_ENTIRE_DISPLAY_ON(0),
 	};
 
@@ -917,7 +920,7 @@ static int st7571_lcd_init(struct st7571_device *st7571)
 		ST7571_SET_COLOR_MODE(st7571->pformat->mode),
 		ST7571_COMMAND_SET_NORMAL,
 
-		ST7571_SET_REVERSE(0),
+		ST7571_SET_REVERSE(st7571->inverted ? 1 : 0),
 		ST7571_SET_ENTIRE_DISPLAY_ON(0),
 	};
 
-- 
2.51.0



