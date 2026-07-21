Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32B0439345;
	Tue, 21 Jul 2026 21:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669905; cv=none; b=rST9I7C44MtyuTASGYhhye5dmtBKxN85iqOpmj9Wa7Zob72GobMtuTNuyur/7ltAvA0BYUPM/kjO7uBCr46sVcVMJAzCCzegnW/XdYJYPQFbETEEjt4Leabo/ZZOthOcF2TYFEzgto1nnsm+jV5Ekq3rVhXUU4QXXIaZslQrYDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669905; c=relaxed/simple;
	bh=68tL8H8uDZJSd7Byu+nUFZsBf5Lkp+l3e72fYf7GEiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbpHB72PqabcRQxBhlMJCwWt2hxvlENs25EWfl3E6XGSROE3BVWyNfmjOUAWjTXxnqTOJErWRyrGCpzR1kwUB/GXJPdQ5yKzAcplm70ee3p/BbU9om3QZ+N7Z9n1FCak6nw6ITcnEsh32Y0aJtviy42AIf6pGKyN5LDz/ADBs1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zl9319AN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zl9319AN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437DC1F000E9;
	Tue, 21 Jul 2026 21:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669904;
	bh=XDKPVCr84aQMew/YC7ii0rW+U3qNydJrdRWXTKhU9BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zl9319ANobgyecje3S72nSo1+XKlesTOe++2k2Jv7Q0WeVxhTR8baB5NyWZsZe9kG
	 cmLYlMamyE/nrod/Hd2xoGRRppN20oDy8rLP0pyRu08CHwgH501hdsLh4TvVkt2wdx
	 TMARcsZKycskSdidJS/gz4BCmQpgL/djwLWlwENo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0730/1067] fbdev: hecubafb: fix potential memory leak in hecubafb_probe()
Date: Tue, 21 Jul 2026 17:22:11 +0200
Message-ID: <20260721152440.916932075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit cbef2a305a8a72969b86f96b7c07b86edde61aff upstream.

The memory allocated for pagerefs in fb_deferred_io_init() is not freed
on the error path. Fix it by calling fb_deferred_io_cleanup().

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hecubafb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/hecubafb.c
+++ b/drivers/video/fbdev/hecubafb.c
@@ -254,7 +254,9 @@ static int hecubafb_probe(struct platfor
 	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
 
 	info->fbdefio = &hecubafb_defio;
-	fb_deferred_io_init(info);
+	retval = fb_deferred_io_init(info);
+	if (retval)
+		goto err_fbdefio;
 
 	retval = register_framebuffer(info);
 	if (retval < 0)
@@ -271,6 +273,8 @@ static int hecubafb_probe(struct platfor
 
 	return 0;
 err_fbreg:
+	fb_deferred_io_cleanup(info);
+err_fbdefio:
 	framebuffer_release(info);
 err_fballoc:
 	vfree(videomemory);


