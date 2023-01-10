Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0608B6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F329C433EF;
	Tue, 10 Jan 2023 18:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374308;
	bh=R11KfLR/mtPLWUd51U0iVynTDRA3SeN70ZC8NXe3XSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIUDTyo7X9DxQz8mVYTYROtvo8LPOKWx91xzppNyVuq1/PSCk+E1h6OW9bk5OCj/J
	 l0YD4cenJHt6TaWM2mOfRfxNFDuOEzZOhsW79k2owNRaehRYMcWefF+A6lya4jBcEc
	 qS+dJpzWe/dBhylntdQj5N9sqrnkB54T61zx54OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	it+linux-fbdev@molgen.mpg.de,
	"Z. Liu" <liuzx@knownsec.com>,
	Rich Felker <dalias@libc.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.0 124/148] fbdev: matroxfb: G200eW: Increase max memory from 1 MB to 16 MB
Date: Tue, 10 Jan 2023 19:03:48 +0100
Message-Id: <20230110180021.123194464@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Menzel <pmenzel@molgen.mpg.de>

commit f685dd7a8025f2554f73748cfdb8143a21fb92c7 upstream.

Commit 62d89a7d49af ("video: fbdev: matroxfb: set maxvram of vbG200eW to
the same as vbG200 to avoid black screen") accidently decreases the
maximum memory size for the Matrox G200eW (102b:0532) from 8 MB to 1 MB
by missing one zero. This caused the driver initialization to fail with
the messages below, as the minimum required VRAM size is 2 MB:

     [    9.436420] matroxfb: Matrox MGA-G200eW (PCI) detected
     [    9.444502] matroxfb: cannot determine memory size
     [    9.449316] matroxfb: probe of 0000:0a:03.0 failed with error -1

So, add the missing 0 to make it the intended 16 MB. Successfully tested on
the Dell PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013, that the warning is
gone.

While at it, add a leading 0 to the maxdisplayable entry, so it’s aligned
properly. The value could probably also be increased from 8 MB to 16 MB, as
the G200 uses the same values, but I have not checked any datasheet.

Note, matroxfb is obsolete and superseded by the maintained DRM driver
mga200, which is used by default on most systems where both drivers are
available. Therefore, on most systems it was only a cosmetic issue.

Fixes: 62d89a7d49af ("video: fbdev: matroxfb: set maxvram of vbG200eW to the same as vbG200 to avoid black screen")
Link: https://lore.kernel.org/linux-fbdev/972999d3-b75d-5680-fcef-6e6905c52ac5@suse.de/T/#mb6953a9995ebd18acc8552f99d6db39787aec775
Cc: it+linux-fbdev@molgen.mpg.de
Cc: Z. Liu <liuzx@knownsec.com>
Cc: Rich Felker <dalias@libc.org>
Cc: stable@vger.kernel.org
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/matrox/matroxfb_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/matrox/matroxfb_base.c
+++ b/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -1377,8 +1377,8 @@ static struct video_board vbG200 = {
 	.lowlevel = &matrox_G100
 };
 static struct video_board vbG200eW = {
-	.maxvram = 0x100000,
-	.maxdisplayable = 0x800000,
+	.maxvram = 0x1000000,
+	.maxdisplayable = 0x0800000,
 	.accelID = FB_ACCEL_MATROX_MGAG200,
 	.lowlevel = &matrox_G100
 };


