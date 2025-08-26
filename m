Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA31E20DD51;
	Tue, 26 Aug 2025 14:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218764; cv=none; b=NXkDn4BJ12KpY3AYp63sw+sYkRGChPNUMclOjPT2gyBQHJnQQfi29AvYlA8zc2ZqS7GsuHFxxonRynayKjsOmXV9AWVJlY7UdgdsDvq8eTSoRgs8pCyQzQj/JAsm2Tuaz5/OjKig7m/j7sZ2ZHvo9m6gv3iiO6yH0QlVfERr174=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218764; c=relaxed/simple;
	bh=rdrhy5eoI7fNBm/NMR1dK/g1TVOFmRt2WKYa7HHLF68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9F3hY7HDVpOKYww4abfYDMTFMCCsXhX+zm2fujDBlljV6Qtm6x9iLrkY3MYX3u+eLF1HdqCVB2VlADMnTtOYOT5ye3RrVJQTjOi5ZGDVph+R67jVeI1ER49IzDEaAUgugq20hUM/ZDOuIl6s5uKfZEd2WYPA1LQ6A7naOtzVWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NhxPzIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NhxPzIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECDDC4CEF1;
	Tue, 26 Aug 2025 14:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218764;
	bh=rdrhy5eoI7fNBm/NMR1dK/g1TVOFmRt2WKYa7HHLF68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NhxPzILJm1Wq9KCrNByVPJBu365WnIsQ6TgeNHohVifjkMOWFFC9YgZyCzL/nobX
	 fQzZLpGmZgJ+Hd2rFbOyICWl2nhAL3hUEHUe/xBbgt0elwX+N33m/18R2Fa+0rrGoo
	 W9RZXj4hQg5LTYxeTsy7CBQRXNTRDBnIG9dAg1gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/403] fbdev: imxfb: Check fb_add_videomode to prevent null-ptr-deref
Date: Tue, 26 Aug 2025 13:07:31 +0200
Message-ID: <20250826110910.191649924@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit da11e6a30e0bb8e911288bdc443b3dc8f6a7cac7 ]

fb_add_videomode() can fail with -ENOMEM when its internal kmalloc() cannot
allocate a struct fb_modelist.  If that happens, the modelist stays empty but
the driver continues to register.  Add a check for its return value to prevent
poteintial null-ptr-deref, which is similar to the commit 17186f1f90d3 ("fbdev:
Fix do_register_framebuffer to prevent null-ptr-deref in fb_videomode_to_var").

Fixes: 1b6c79361ba5 ("video: imxfb: Add DT support")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imxfb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/imxfb.c b/drivers/video/fbdev/imxfb.c
index dbc8808b093a..8dac15bf2b0c 100644
--- a/drivers/video/fbdev/imxfb.c
+++ b/drivers/video/fbdev/imxfb.c
@@ -992,8 +992,13 @@ static int imxfb_probe(struct platform_device *pdev)
 
 
 	INIT_LIST_HEAD(&info->modelist);
-	for (i = 0; i < fbi->num_modes; i++)
-		fb_add_videomode(&fbi->mode[i].mode, &info->modelist);
+	for (i = 0; i < fbi->num_modes; i++) {
+		ret = fb_add_videomode(&fbi->mode[i].mode, &info->modelist);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to add videomode\n");
+			goto failed_cmap;
+		}
+	}
 
 	/*
 	 * This makes sure that our colour bitfield
-- 
2.39.5



