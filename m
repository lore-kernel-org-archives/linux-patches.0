Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3DD63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365C4C433EF;
	Mon, 20 Feb 2023 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900260;
	bh=YOO3r9P01S6KEDPqSTcICQG15oAn0bWtpVziynhoghc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LoVyTBXQ0oCf52Nep2YUq0ffkDy/F6DsFkkZPkN6lblFdH3qwMcFHHutUov01XXgE
	 veli2tq1t20A1nNVgq9rX7FwULfHrLvs/e0+K64KpTkjgd3HGGkOLZH9quJUDPhXmd
	 JBSJvEKYL3CMIfJQ0Mgw+iAyel/G7Rgb9xkeN+Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Miko Larsson <mikoxyzzz@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 12/53] fbcon: Check font dimension limits
Date: Mon, 20 Feb 2023 14:35:38 +0100
Message-Id: <20230220133548.612096145@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 2b09d5d364986f724f17001ccfe4126b9b43a0be upstream.

blit_x and blit_y are u32, so fbcon currently cannot support fonts
larger than 32x32.

The 32x32 case also needs shifting an unsigned int, to properly set bit
31, otherwise we get "UBSAN: shift-out-of-bounds in fbcon_set_font",
as reported on:

http://lore.kernel.org/all/IA1PR07MB98308653E259A6F2CE94A4AFABCE9@IA1PR07MB9830.namprd07.prod.outlook.com
Kernel Branch: 6.2.0-rc5-next-20230124
Kernel config: https://drive.google.com/file/d/1F-LszDAizEEH0ZX0HcSR06v5q8FPl2Uv/view?usp=sharing
Reproducer: https://drive.google.com/file/d/1mP1jcLBY7vWCNM60OMf-ogw-urQRjNrm/view?usp=sharing

Reported-by: Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: 2d2699d98492 ("fbcon: font setting should check limitation of driver")
Cc: stable@vger.kernel.org
Tested-by: Miko Larsson <mikoxyzzz@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2450,9 +2450,12 @@ static int fbcon_set_font(struct vc_data
 	    h > FBCON_SWAP(info->var.rotate, info->var.yres, info->var.xres))
 		return -EINVAL;
 
+	if (font->width > 32 || font->height > 32)
+		return -EINVAL;
+
 	/* Make sure drawing engine can handle the font */
-	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
-	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
+	if (!(info->pixmap.blit_x & BIT(font->width - 1)) ||
+	    !(info->pixmap.blit_y & BIT(font->height - 1)))
 		return -EINVAL;
 
 	/* Make sure driver can handle the font length */


