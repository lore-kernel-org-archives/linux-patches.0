Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70D8528447;
	Thu, 17 Sep 2026 17:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664426; cv=none; b=XrVULAjpotf9DbPX/eD0/yTfHg6rbLNbK1b/7EWBHPfpWf/d6R2yNMjHN/u2Dlh+SbZQiw4wB9sPM6XZ1QmQglLVw+4WK8lUp5nERIrwccXIbPFh95ovlZdw/EgZ0v8Z8Mq+M1i7M6tp25+hpA5zvOMyxo69DytH/+sFpm4SWak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664426; c=relaxed/simple;
	bh=ipaaZ2fNwm21u2IAK6beaapOWGsh+AMa/Wao8VV3bPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBPUpkONF8+/iWzebXjCv/1dhswy4rtqn43UvaHNJLmKvHACfTRIx4BOpaLHWpTB2V7TJmU366kBh2YIrUcZXJv+pbCNq5wLoLSYMHC0aW3BbuOKTMres0ltF1qcG2JASaEMZ1ExNAz+AnVVGDNp5Io2CuFoDfZyq67Pc9xhAzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0/ZEmxI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0/ZEmxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A14B1F000FF;
	Thu, 17 Sep 2026 17:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664425;
	bh=p9QhutJLSuUq0KgyOTkJpC+maQTOM30LV5oVJlg+iKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0/ZEmxIf9BNxp0glYAadzk8TTI1nwk9MbD5MUKzN48smuqgavaqnw+6A2uWy9HNn
	 dPgffAIjefgrX0/o5009cAYqJ1QNAc6DZ2CAoCE0PJjPwic1cWRzGDSxUJ3JAL5sPI
	 OihkwWxX4QGngh30vu/UEHa2MEse2gp/3YHoREPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0369/1250] fbcon: dont suspend/resume when vc is graphics mode
Date: Thu, 17 Sep 2026 16:02:44 +0100
Message-ID: <20260917151602.058588299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit 70d9d5f5fcd940f627bd403aaa6f65de724eef6b ]

Don't need to do suspend/resume for fbcon in graphic mode.

Doing this may cause error, eg:
  At the beginning, starting the Xorg with single screen and then an
  external screen was plugged in. After logging out in Xorg, fbdev
  info may using screen which is connected later on for info always
  using first connected connector in list in func 'drm_setup_crtcs_fb'.
  Then, S3 executed, fbcon found that the information did not match
  and do atomic to switch fb. However, Xorg will not re-bind the crtc
  fb but continues doing ioctl. At this time, the fb is incorrect.

With some modifications by Helge Deller.

Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index df1ecbf3f5d02..32d3940357625 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2657,8 +2657,9 @@ void fbcon_suspended(struct fb_info *info)
 		return;
 	vc = vc_cons[par->currcon].d;
 
-	/* Clear cursor, restore saved data */
-	fbcon_cursor(vc, false);
+	/* Clear cursor, restore saved data when in text mode */
+	if ((vc->vc_mode == KD_TEXT) && con_is_visible(vc))
+		fbcon_cursor(vc, false);
 }
 
 void fbcon_resumed(struct fb_info *info)
@@ -2670,7 +2671,9 @@ void fbcon_resumed(struct fb_info *info)
 		return;
 	vc = vc_cons[par->currcon].d;
 
-	update_screen(vc);
+	/* Update screen when in text mode only */
+	if ((vc->vc_mode == KD_TEXT) && con_is_visible(vc))
+		update_screen(vc);
 }
 
 static void fbcon_modechanged(struct fb_info *info)
-- 
2.53.0



