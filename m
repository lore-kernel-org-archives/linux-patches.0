Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892D14418DB;
	Tue, 21 Jul 2026 22:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672270; cv=none; b=RVIBrwjdFUeXYp4ZzN8jbgo6Pi9OwbayVSZ/HNo1Ly6RJjbOkU2nSMkSRYuTNEEfyrptc71d3r36C83Nt06euOfVrWrH6h3VZZJrYY1K818wZ+k7klN8sHQY+2YnxEGemHJf3oScRM59vuQ2xIrp1POwvon1NGFAYvvyZ4Phx80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672270; c=relaxed/simple;
	bh=xflnWLQd3T/gTsTzZda0oRi+GTxRIO1K8MkuTBmkJ40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4n1U5X5vG+n9hfoVZvs1VYaEbWNO7TlkaMj4Bt3JS9BQtq4URqLVOCxZuxjAwM9dFCcObX/2yK4SH6UuGQNtqgFugEJvkDCgzoxgo+EZ2MH7Rvzu9MsJsDQ82wfERFDcnDKUsFRoqWBPZyoVyM3B2rYjuUAD8k0oDsBExXQE+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfeQyx5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfeQyx5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708AA1F000E9;
	Tue, 21 Jul 2026 22:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672266;
	bh=K0IKgKOSig2/8q9zDIAoHZIscQx6Z72NYoRCBTSWIUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZfeQyx5pm1UH7rMCbMbxSVTmIj/PSC7ODym1kzrRLkkAlRgCpt8wr/nJSQ5TiSr7o
	 ePhanRcJFB7epY6hwaKROwdae25p2mL7KRIhTMBB0zrv84+87sRx2NGHtXsF1lYsmz
	 KPiIjmwfrCJR+LwszDQ1/a94eMOuf4l0+0zOr9JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 560/843] fbdev: metronomefb: fix potential memory leak in metronomefb_probe()
Date: Tue, 21 Jul 2026 17:23:15 +0200
Message-ID: <20260721152418.647262979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 894632b862a39b3fe1cb5de06fbae86225ea64de upstream.

The memory allocated for pagerefs in fb_deferred_io_init() is not freed
on the error path. Fix it by calling fb_deferred_io_cleanup().

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/metronomefb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/metronomefb.c
+++ b/drivers/video/fbdev/metronomefb.c
@@ -703,12 +703,14 @@ static int metronomefb_probe(struct plat
 	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
 
 	info->fbdefio = &metronomefb_defio;
-	fb_deferred_io_init(info);
+	retval = fb_deferred_io_init(info);
+	if (retval)
+		goto err_free_irq;
 
 	retval = fb_alloc_cmap(&info->cmap, 8, 0);
 	if (retval < 0) {
 		dev_err(&dev->dev, "Failed to allocate colormap\n");
-		goto err_free_irq;
+		goto err_fbdefio;
 	}
 
 	/* set cmap */
@@ -731,6 +733,8 @@ static int metronomefb_probe(struct plat
 
 err_cmap:
 	fb_dealloc_cmap(&info->cmap);
+err_fbdefio:
+	fb_deferred_io_cleanup(info);
 err_free_irq:
 	board->cleanup(par);
 err_csum_table:


