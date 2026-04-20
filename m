Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6412DE6E3;
	Mon, 20 Apr 2026 16:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701103; cv=none; b=evktnG5fwuV0U44xSDCMso++WR4QYJrr9Vsa4iFK1VuA3c1lJMYzLtEAiqg3lTo+zbTphtm/ceHFUzXvKiUFrUPEFapq8GhNFky78PLddcKgWbHf+L2VWqGOUdYb/tqu7bPla0SaSw1XvvUHsf7KM6ofOmgxN0fkXJ9m/HI57Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701103; c=relaxed/simple;
	bh=WNXCNuscunH4a4TP6BLCMm3pVAiYd61llc2Ipx2i+1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaDwrCuGtzJPF4nCywZkqmV3V8M60Bi5xlHYIyOa5/P1ohEQQEHvwg5yLZlt31zshYCD7OiniaEOOAyTdcQkph3ucuVfMO83HvcxQ5h9l1f7aAjNrBmkoxEK1rNQ9iBOfmY1NUIMu/3ZFPEzl9KMv8JUNKoVXWn1IGkIMhZlZj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpZdrY6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpZdrY6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E944CC19425;
	Mon, 20 Apr 2026 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701103;
	bh=WNXCNuscunH4a4TP6BLCMm3pVAiYd61llc2Ipx2i+1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpZdrY6pBWnk0fUXsntTbLYHyllDgHNKBK+pjlhYYm9ZCIRbPPhQ0E84l6vnnnUdR
	 svPP9+1d8MWxBQra3vPxQZLPKIt4ln8a3VzyMe+hEkSLPKUF6Tu8u1uyMOgdo1GBAJ
	 hTexZsyWtVe+k5WZfWi/YMc88mB1t3QlgPRSfEN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernie Thompson <bernie@plugable.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 150/198] fbdev: udlfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Mon, 20 Apr 2026 17:42:09 +0200
Message-ID: <20260420153941.008914442@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit a31e4518bec70333a0a98f2946a12b53b45fe5b9 upstream.

Much like commit 19f953e74356 ("fbdev: fb_pm2fb: Avoid potential divide
by zero error"), we also need to prevent that same crash from happening
in the udlfb driver as it uses pixclock directly when dividing, which
will crash.

Cc: Bernie Thompson <bernie@plugable.com>
Cc: Helge Deller <deller@gmx.de>
Fixes: 59277b679f8b ("Staging: udlfb: add dynamic modeset support")
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/udlfb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1018,6 +1018,9 @@ static int dlfb_ops_check_var(struct fb_
 	struct fb_videomode mode;
 	struct dlfb_data *dlfb = info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* set device-specific elements of var unrelated to mode */
 	dlfb_var_color_format(var);
 


