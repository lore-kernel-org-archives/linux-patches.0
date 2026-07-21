Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB8E3B47E2;
	Tue, 21 Jul 2026 20:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667058; cv=none; b=HfcswSlUf61aOBJ7rI6tJktzdaWQOUyy4ry7odgtvHhGW0dE+dIthel0zZq0sQahEmABzFV7cIkaac9/s4V2WexFMfS2dpZSLBl1K8m8kDjp8/o+ELM/shkwF90C53KTXW860UxM9pg4T3Im/KKZX712up1hkhTK25SBg14BksU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667058; c=relaxed/simple;
	bh=VPcBmxGBzlC2abhsO8/HRwbQPqzL/5DVOHWckqw3/8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoKAJldtx+Za69RVsSEFygO0JOpKmE+HpsPZuQ7I+eelwCh4JOEQ/gn8dk+6Rn8f2gAeAyg76rKU0irPKL8zVv3UC9K0V7wxYVw8Z1b97zegop9TG0WS6c4sOgSPipsZXxzaQHJl3CGy82v/3cH1birAlRDWvqjD0b28O70JDfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNSh88v/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNSh88v/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838761F000E9;
	Tue, 21 Jul 2026 20:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667057;
	bh=Z8Qv65GiH0Aavc+6fGzIubOW1+OX2c5pdce3FZe4cYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNSh88v/qA9evhuX21YyDn2Ite7VUpHVcaX+GDq5bk2ZhcmX31tdiV4gnPiEiTHOJ
	 YmdsmBmDiiJ/oCPBBs2rkb2n/9/roZs0EOwscZ9ThJju4GZTBc2d+1n/q2S3ExXhn0
	 xcXVTLGgmobSbMC/gUEAysY1h9K2hKqJPAECMsrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0915/1266] fbdev: vesafb: fix memory leak in vesafb_probe()
Date: Tue, 21 Jul 2026 17:22:32 +0200
Message-ID: <20260721152502.318984307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit b15d708995c01bbffe7dcd634a31959f6805bed3 upstream.

Since commit 73ce73c30ba9 ("fbdev: Transfer video= option strings to
caller; clarify ownership") the string returned from fb_get_options()
is expected to be freed by the caller. But the string is not freed in
vesafb_probe(). Fix that by freeing the option string after setup.

Fixes: 73ce73c30ba9 ("fbdev: Transfer video= option strings to caller; clarify ownership")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/vesafb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/vesafb.c
+++ b/drivers/video/fbdev/vesafb.c
@@ -255,6 +255,7 @@ static int vesafb_probe(struct platform_
 	/* ignore error return of fb_get_options */
 	fb_get_options("vesafb", &option);
 	vesafb_setup(option);
+	kfree(option);
 
 	if (si->orig_video_isVGA != VIDEO_TYPE_VLFB)
 		return -ENODEV;


