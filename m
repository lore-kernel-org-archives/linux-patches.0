Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955C83E49EF;
	Tue, 21 Jul 2026 17:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655679; cv=none; b=CdcW1dEPRYE3d1rV1qyrieyBKTSvb3GUF2mo03NjSLurLjklVULAmBnp/odrg2AdT+o1vWqcvYTp9KMVZrIJOjDoRYROc8g4Pg3FRCBV/rtICRSruQq3RfjVuzHvKAln/uCb/PqMAS3qKa5WW1CGY+M8N1qzFWpU5u9LbpW1aPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655679; c=relaxed/simple;
	bh=FflgeVGteDQ4a4KClfdgUSmsYUtGhhtkfPul811lLs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKprWl3zl6M5DVtHveFlwm3rJ3iY182dKS0jpbyGsoi8SEbICROvlK4V8qOcGOV0ALpwTnYiLux0HMyXLql1YUuppaLPTr3i1fMLQ10xhkv9EppQx34BBfH/3/Hjbf2cJFzhceL9DYyYFJLg0g0mIXTSy+Xema1W3NAdEUAtazA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+TBVmhm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+TBVmhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC771F00A3A;
	Tue, 21 Jul 2026 17:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655678;
	bh=SWsamAXMAGEce1wy844Dx0Lwq4E4zAAIuS4Fc+Anomk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+TBVmhmR5DY9i7FVCgFU3VZLc+//BQZiUgSg/FeXGHhK4YCB/RgcIHOdw5VMsSCm
	 PzS2T+FycxAXgZcvbYn7BDuCcK9d93gzrDFVvCQyKw9ZEnNQeM1zBwD/gEG9cK92WP
	 NRZSu95e+adjTvVa/PUXo2H6DMWKbIWS4YkhDQaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 0056/1611] fbcon: Use correct type for vc_resize() return value
Date: Tue, 21 Jul 2026 17:02:52 +0200
Message-ID: <20260721152516.087816183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jiacheng Yu <yujiacheng3@huawei.com>

commit 84202754fb1727dc3ee87f47104e4162ecc8ba3a upstream.

The return value of vc_resize() is int, but fbcon_set_disp() stores it
in an unsigned long variable. While the !ret check happens to work
correctly by coincidence (negative values become large positive values),
the types should match. Use int instead.

Eliminates the following W=3 warning:

  drivers/video/fbdev/core/fbcon.c: In function 'fbcon_set_disp':
  drivers/video/fbdev/core/fbcon.c:1494:14: warning: implicit conversion from 'int' to 'unsigned long' [-Wconversion]

Fixes: af0db3c1f898 ("fbdev: Fix vmalloc out-of-bounds write in fast_imageblit")
Cc: stable@vger.kernel.org # v6.17+
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1371,8 +1371,7 @@ static void fbcon_set_disp(struct fb_inf
 	struct vc_data **default_mode, *vc;
 	struct vc_data *svc;
 	struct fbcon_par *par = info->fbcon_par;
-	int rows, cols;
-	unsigned long ret = 0;
+	int rows, cols, ret;
 
 	p = &fb_display[unit];
 


