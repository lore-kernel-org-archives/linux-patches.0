Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4537E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA15CC433D7;
	Wed,  2 Nov 2022 02:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356735;
	bh=+hfvyKi5N180oQ54BjCvZNQRNkkZq+Rxdwv/dumIUwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSY4DOLhXf0NMpawblASL3kzg+vr4Bz97uml9RONCQZ8T2W/NuYuUOfuaSGyo5HGy
	 F8Y+PqJKLox78QUPtFjxxB9ULpNtsnwj7jNX5w8/l7P3X3aYxmXoiytDjE89IcMyRX
	 pyXECaPL5rL9ueMGln0vZFTwGEejgvypXoJgWurE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.0 050/240] fbdev: stifb: Fall back to cfb_fillrect() on 32-bit HCRX cards
Date: Wed,  2 Nov 2022 03:30:25 +0100
Message-Id: <20221102022112.532391799@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 776d875fd4cbb3884860ea7f63c3958f02b0c80e upstream.

When the text console is scrolling text upwards it calls the fillrect()
function to empty the new line. The current implementation doesn't seem
to work correctly on HCRX cards in 32-bit mode and leave garbage in that
line instead. Fix it by falling back to standard cfb_fillrect() in that
case.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/stifb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1055,7 +1055,8 @@ stifb_fillrect(struct fb_info *info, con
 {
 	struct stifb_info *fb = container_of(info, struct stifb_info, info);
 
-	if (rect->rop != ROP_COPY)
+	if (rect->rop != ROP_COPY ||
+	    (fb->id == S9000_ID_HCRX && fb->info.var.bits_per_pixel == 32))
 		return cfb_fillrect(info, rect);
 
 	SETUP_HW(fb);


