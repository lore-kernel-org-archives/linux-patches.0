Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E167B1D54D1;
	Tue,  8 Oct 2024 12:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391680; cv=none; b=MiFCYGsq1Jeqz3yQ35NymdTVJ7StQCnIDQxMPTOXp8jakf3jAOowNkJzTCjuMda6Y7xkCskkbZVNVgg08kyHXpyRknsVLIXMyjxZNAdRzLifUBIfx2Hp9P2ON2xyrhW7sOZt8fcnDWV8UsrldYtLcWih7evPPzSDSBZg/dTjMVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391680; c=relaxed/simple;
	bh=y+ZSUq5wDfJQd6EIA8yCjoQQBAVimKB07uiF2rdjYTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aImdXLNejcvKlSBq1gjWcrVM0giabKRtlt+zk1C3p0h6O3GWF+Zsj2S8KNyBqHjRS2yiXpITbRymKX2J5/Rn+ygeyDsCLF2D1BzS55OLY2UCE7StNgiBeeBnxJuKYWtHVg1y4WC17DTWqz46C2Rgra13ZltFi/nbD3ubB27tbpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiJgN3l6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiJgN3l6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E06AC4CEC7;
	Tue,  8 Oct 2024 12:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391679;
	bh=y+ZSUq5wDfJQd6EIA8yCjoQQBAVimKB07uiF2rdjYTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiJgN3l6Yp5c4LS5EZBhKKCnj09HdxgnN1gW7vhCxXtk6I6VHECy87cveLCf254/x
	 fEowBS9fHJS2unhbrekcOLpfugHfj9DHV9FRMdq1QKU1G/ghk8dMUj9+QMksjB1qda
	 T1GIuYVBbz7qykLrjNG8WchAwZjStjSdzi9H+eTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 190/558] fbdev: efifb: Register sysfs groups through driver core
Date: Tue,  8 Oct 2024 14:03:40 +0200
Message-ID: <20241008115709.825874787@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 95cdd538e0e5677efbdf8aade04ec098ab98f457 ]

The driver core can register and cleanup sysfs groups already.
Make use of that functionality to simplify the error handling and
cleanup.

Also avoid a UAF race during unregistering where the sysctl attributes
were usable after the info struct was freed.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/efifb.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 8dd82afb3452b..595b8e27bea66 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -561,15 +561,10 @@ static int efifb_probe(struct platform_device *dev)
 		break;
 	}
 
-	err = sysfs_create_groups(&dev->dev.kobj, efifb_groups);
-	if (err) {
-		pr_err("efifb: cannot add sysfs attrs\n");
-		goto err_unmap;
-	}
 	err = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (err < 0) {
 		pr_err("efifb: cannot allocate colormap\n");
-		goto err_groups;
+		goto err_unmap;
 	}
 
 	err = devm_aperture_acquire_for_platform_device(dev, par->base, par->size);
@@ -587,8 +582,6 @@ static int efifb_probe(struct platform_device *dev)
 
 err_fb_dealloc_cmap:
 	fb_dealloc_cmap(&info->cmap);
-err_groups:
-	sysfs_remove_groups(&dev->dev.kobj, efifb_groups);
 err_unmap:
 	if (mem_flags & (EFI_MEMORY_UC | EFI_MEMORY_WC))
 		iounmap(info->screen_base);
@@ -608,12 +601,12 @@ static void efifb_remove(struct platform_device *pdev)
 
 	/* efifb_destroy takes care of info cleanup */
 	unregister_framebuffer(info);
-	sysfs_remove_groups(&pdev->dev.kobj, efifb_groups);
 }
 
 static struct platform_driver efifb_driver = {
 	.driver = {
 		.name = "efi-framebuffer",
+		.dev_groups = efifb_groups,
 	},
 	.probe = efifb_probe,
 	.remove_new = efifb_remove,
-- 
2.43.0



