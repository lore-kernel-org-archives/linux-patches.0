Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328DA4FC330;
	Thu, 17 Sep 2026 17:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667947; cv=none; b=ipRWv3KBabRne0+PLW2EmIoojWsNTgGOD4BmX2YY/peR95Rz1nXnrBbGzNr01jgMko1wD/cE4VCf/Jgrr6rb81f6hLPyxv1AaVOwo+ANedC5HXJNq5Y7L+y8iSTJ25DzUhQLSvbtxFqRma+V8mI3fqQhaQnZRuBFpdv3tunk0fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667947; c=relaxed/simple;
	bh=+4f1m8ATGOGhOJAscqtfbaLD/sDLbilvx3Ai5RovO3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwCh+2sVwzsy8jZlIx/aM+0j12E4XG7i6/2w0f8Nflh8qLfThjEEfa150UnkBCEXeoNLGma6CEYRd/vtbFw4OjeHnbEnKQ9VArVp7oKfYZkq/JjPoIQFAG5dg9kfEiWlOKJPzjwL+5BRFTmVVUhyeH9JIfPndJF41h2RAdPZZ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBEFrvOR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBEFrvOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DCF1F00893;
	Thu, 17 Sep 2026 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667946;
	bh=4pp504lCN93XE/Hh3PqmRMFc+Lbb0Jn47GYXWGLhk3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBEFrvORQqnJsnJamr6PxyC2ixJCRqf1nzOO7eorOBwMDTi3MIfPhkx/2amH1Sx3g
	 WfkAdIq9NZrygvOBFz4Zs0aU/EUKubZlqFNRGpY3kDbHlqt9BRYLEDv31vAut4a5qu
	 PfJsCwXGaHnSSBvkjjKNUBHQiSE8tqcjQET1rHdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0263/1102] fbcon: dont suspend/resume when vc is graphics mode
Date: Thu, 17 Sep 2026 16:03:26 +0100
Message-ID: <20260917151546.203831851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 01b6a03b80b09..024cad45af930 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2654,8 +2654,9 @@ void fbcon_suspended(struct fb_info *info)
 		return;
 	vc = vc_cons[par->currcon].d;
 
-	/* Clear cursor, restore saved data */
-	fbcon_cursor(vc, false);
+	/* Clear cursor, restore saved data when in text mode */
+	if ((vc->vc_mode == KD_TEXT) && con_is_visible(vc))
+		fbcon_cursor(vc, false);
 }
 
 void fbcon_resumed(struct fb_info *info)
@@ -2667,7 +2668,9 @@ void fbcon_resumed(struct fb_info *info)
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



