Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EC2145B26;
	Thu, 11 Apr 2024 10:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831028; cv=none; b=df/lyfVUO+j64QI3TpGHBRZaQ0cFeiO08lLWJCcihDD4B8KOxQMnAgY+GLHWnoaq+yibNH93hQOLazc45dOWLnBC7PxN695UmLB4nhzJlRcHVBqUeak9xo61uxBiBVlZbMn4iJCyvFnazpSGUsOpfiXnyJgmJdtaNMxQxrzGpo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831028; c=relaxed/simple;
	bh=qQ1WfQKhsoLRs4vf2mDKOgMTfTr/+kEbdYvSJ62jBds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTYuqRi+G19IoW24DLg6K3OrIiCzc3wM/cSBoVFInioJNa5c2BAgYZEDYcY7xAKL1No37A9T/QUbq6jkdnGJGJAWjD5qzBeBMggPwQSpsH/HicEm+oWh9yebo5uRMjnRRpP5+0kWog3+3JYTxORxzkgTWMBJueQYWrkruCx/mUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkdtKo3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkdtKo3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8E9C433C7;
	Thu, 11 Apr 2024 10:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831028;
	bh=qQ1WfQKhsoLRs4vf2mDKOgMTfTr/+kEbdYvSJ62jBds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkdtKo3HISyf7MSdwvLRn7VWy2HhI2XtUTBZJMC/ll2tA+AdOmUUWULcWaoOzHT7k
	 0HLQgBzOUEyy8QZSefzm8IvSAATSf3IOq2oz4h7eylDrUCrAEyHW9RZmTkowvPhj2f
	 DHHIztY6ATVnmD50I9INgaBP3IpdLwiDMf/sfbfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/215] fbmon: prevent division by zero in fb_videomode_from_videomode()
Date: Thu, 11 Apr 2024 11:56:49 +0200
Message-ID: <20240411095430.869659572@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8e2e19f3bf441..dab5fdeafa97d 100644
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



