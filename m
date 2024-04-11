Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC7D79FD;
	Thu, 11 Apr 2024 10:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832499; cv=none; b=H/DgNoyyFRyPFBlg6rclYopgVPdUep8oiVUdUd8AjXBE4Na3VnvS+KrbHihphAMAArK6lqnmDP7YMMiwL00YUFm1r1PtxNEzNbsl2mqh/k42S11/mSiUWfSeWbzxls7HzuqiOuKpLGsycQ+r18FFmUr0nYRmWD/0FD6EEPciCxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832499; c=relaxed/simple;
	bh=tAd04C3rjGp/G7xgbkAtRvldkigW7xW1tAzQ6ug9bC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWUPrstAgUbgepo6MOpzH+67SjZd/jPEksmpuN5KzroHuchlx3jPGbjs6TUokSy89POC24sCyesMY9sOFF48pXNCUM4r+gu6BS/33tSO8KHIcuLJGmcCrn53g8VZ3NW0OK72Id++goJP463BhurLQLHHYq6TYt7gI/hrIjtcCpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0wvmQ4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0wvmQ4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EBDC433F1;
	Thu, 11 Apr 2024 10:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832499;
	bh=tAd04C3rjGp/G7xgbkAtRvldkigW7xW1tAzQ6ug9bC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0wvmQ4yw6T8Ltsh1l11qDHJozfZZwtTOPkMxxWz6vdiAE44iAyvCzAT56qvrRpEj
	 bM4WphC0OWmvc6tQHF7UYlR4xqCbr0WtrLAIuJ9rp0ktj1BLkAmAbdy3Gn0VkvbJqm
	 ybw/7tIIQ9EXa3WoPEpmFxkaczcGQpt7GXQgM48M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 68/83] fbmon: prevent division by zero in fb_videomode_from_videomode()
Date: Thu, 11 Apr 2024 11:57:40 +0200
Message-ID: <20240411095414.731538013@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

[ Upstream commit c2d953276b8b27459baed1277a4fdd5dd9bd4126 ]

The expression htotal * vtotal can have a zero value on
overflow. It is necessary to prevent division by zero like in
fb_var_to_videomode().

Found by Linux Verification Center (linuxtesting.org) with Svace.

Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbmon.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/core/fbmon.c b/drivers/video/fbdev/core/fbmon.c
index b0e690f41025a..9ca99da3a56a0 100644
--- a/drivers/video/fbdev/core/fbmon.c
+++ b/drivers/video/fbdev/core/fbmon.c
@@ -1311,7 +1311,7 @@ int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var, struct fb_inf
 int fb_videomode_from_videomode(const struct videomode *vm,
 				struct fb_videomode *fbmode)
 {
-	unsigned int htotal, vtotal;
+	unsigned int htotal, vtotal, total;
 
 	fbmode->xres = vm->hactive;
 	fbmode->left_margin = vm->hback_porch;
@@ -1344,8 +1344,9 @@ int fb_videomode_from_videomode(const struct videomode *vm,
 	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
 		 vm->vsync_len;
 	/* prevent division by zero */
-	if (htotal && vtotal) {
-		fbmode->refresh = vm->pixelclock / (htotal * vtotal);
+	total = htotal * vtotal;
+	if (total) {
+		fbmode->refresh = vm->pixelclock / total;
 	/* a mode must have htotal and vtotal != 0 or it is invalid */
 	} else {
 		fbmode->refresh = 0;
-- 
2.43.0



