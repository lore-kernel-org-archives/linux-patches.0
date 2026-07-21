Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19C52E62A9;
	Tue, 21 Jul 2026 17:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654135; cv=none; b=aVFuETgnXxlnf/fNoHlQNkGTgbEXZtitN+DjWLUPFDPgc23XK72XIVOHQESUpvh50XraEe+DJPo/hgBd/YTcyckBwE2WESJYcKi2F/S5tgoDdpp0nnMFDhYcGKqYDBNKrpE7Bfnp0dy96pT61vcWfLLeVqSk5DR7FTYS3HicNcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654135; c=relaxed/simple;
	bh=ZxQXLk17FPZL0LEieNix6SRstqW9+8a8Xsm0DXt5+aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIr1sBZAAV6JFXwh4PLEjy+EzzkSgGD97+E94KrvQ7FkgaiEylfWC72V7wTIyPcq8UoCG/V3Ec1lE6FgLRLocZe/OXAY65VaN3k3I2FHGcgqdwUCMOY3JhxJOMhm8dniRQX6kboiYg3x3r+3dvF0mht4CEujgQbkmpxmnupWYIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh3X6vKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh3X6vKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AABA1F000E9;
	Tue, 21 Jul 2026 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654134;
	bh=nHs0xq6BaoheIkxDBNg4ZbS3iqkPbUl8MkcuxXLos/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gh3X6vKyJmZMQvlp430UxiscM2wxQQFL3s1d1jNqMDER5sm8gRlAs9UtkUD4YZDv1
	 XnHts9lyQgtdfiFlI8en9MtNtUKnzEm3i6Cfql/rwVp3c0dBYm3A69RKCjZeVORkyB
	 qC0VnaYzyV7qZXwHZNGf5P9OYI0D6/7XIbBOMMJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1590/2077] fbdev: vesafb: fix memory leak in vesafb_probe()
Date: Tue, 21 Jul 2026 17:21:03 +0200
Message-ID: <20260721152630.275044613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -269,6 +269,7 @@ static int vesafb_probe(struct platform_
 	/* ignore error return of fb_get_options */
 	fb_get_options("vesafb", &option);
 	vesafb_setup(option);
+	kfree(option);
 
 	if (si->orig_video_isVGA != VIDEO_TYPE_VLFB)
 		return -ENODEV;


