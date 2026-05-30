Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2CA1DE4EF;
	Sat, 30 May 2026 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158709; cv=none; b=NyUN2GTSTvBOqEDGIYATsa6VcQpcBKf77YyfbYhsRlt0JTDPvilbVShMiKaYzQ8/zaEdkJ9qn5gTikKM9BBvOsqyjHbSWQmt0KtA6hyAMPZCdbdhXVr5SVaFL22vuymJL7y+LGGBPj8+R6LsTRmxuxDNxwDl4eoyACQ/GPxO3z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158709; c=relaxed/simple;
	bh=7JJ3HnbcrI9jmnQHx3x9zEja3Kg0kAiBwUHtPnFbqRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6nbN8q8qmgLz1jtTjpneAHi/gexzSSzjs+CK7a2LowOI95y6d1Y1PGZKTqZ6KGGT4bJM+kfX6bsbjEBQu+LTOTQKXCnpPbIB1eiOSsbLGN/wVkzUM+w2JNRWaEKuEl+Gs0an5/vjQ9NJTydzijxdcDjAYnzOHYiZIMa20E0Nqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EM4BOecS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EM4BOecS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3391F00893;
	Sat, 30 May 2026 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158707;
	bh=s7wTAe/eevVspyWd5pr65A/Cic2ebrrRotZL0VY24XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EM4BOecS+dredBJESvPchLg9brySqI7wLxtXBuCSBVDMBHeuLdbZkGpJCa0zRVgVo
	 QKMNrYITzQ5Ij8rZgr/b7v2ZEqi+0/wMllHitgp0TnyR/Sh3MW3Me8upiPbmzeCo4J
	 R3dbmgS/5s6QIOMboB+xUCmlsFf3O1fNJdl2XalI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernie Thompson <bernie@plugable.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 076/969] fbdev: udlfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Sat, 30 May 2026 17:53:20 +0200
Message-ID: <20260530160302.451649957@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1078,6 +1078,9 @@ static int dlfb_ops_check_var(struct fb_
 	struct fb_videomode mode;
 	struct dlfb_data *dlfb = info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* set device-specific elements of var unrelated to mode */
 	dlfb_var_color_format(var);
 


