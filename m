Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95B9223DC6;
	Sat, 30 May 2026 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163135; cv=none; b=RS+WzK/Q+1mQNyQpS5a8jBpaNq5LXjrL36HxY8uik6mGgH2dXZ8zrMUITqCIEhHgJnvg5uqZ9yYc47dt8D8hy2AoFtQoq4elwu5Bwj4G4iC8TRAHR1Cn+plMe08QvXCQagC2gbJSaawpEcR7dc5+B+tUOyMWsOYxFxM4TaSUsHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163135; c=relaxed/simple;
	bh=a4CnjwZxbEFxJn8ih2EEyyLSFWSw4B7jegeDukiLCsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XzUreCFPTZjrWf3QIxjqroqF/C+kG+9r2Beowm5jh5RAA0l+UTXO+U8CZQy3Lv2v+hqEwA/QD0lu/9Cfygac3+m1J7Tt9aFep8zIRpq/a6GHFOuJx5fF77N5zTTlxBr8EHqXPkrURTEV5ntO6CJV4QwayvtUi6iczSQlAGmR12w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WC0+ch6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WC0+ch6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0E51F00893;
	Sat, 30 May 2026 17:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163134;
	bh=oRrmiD3gZRG3M57E264QpdPDvwICyqBsjFKXP3gaoXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WC0+ch6c5EPv/TqKbnwzlOqkERLCkiPNseC0vdFzjXK2Lvix63Jixz6fivFY49cO
	 dWayoRBMe3g0YKweVKIPx3yDWGXMaGB/VxygH3JWwkxekj4PyBLXzP5sbeYNEk+kal
	 h9vuiOgQHJBNFF4ttAe0ruktNUltN0efUGX1v9TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Helge Deller <deller@gmx.de>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 5.15 160/776] fbdev: efifb: Register sysfs groups through driver core
Date: Sat, 30 May 2026 17:57:54 +0200
Message-ID: <20260530160244.609439249@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Minor context conflict resolved. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/efifb.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -581,15 +581,10 @@ static int efifb_probe(struct platform_d
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
 
 	if (efifb_pci_dev)
@@ -608,8 +603,6 @@ err_put_rpm_ref:
 		pm_runtime_put(&efifb_pci_dev->dev);
 
 	fb_dealloc_cmap(&info->cmap);
-err_groups:
-	sysfs_remove_groups(&dev->dev.kobj, efifb_groups);
 err_unmap:
 	if (mem_flags & (EFI_MEMORY_UC | EFI_MEMORY_WC))
 		iounmap(info->screen_base);
@@ -629,7 +622,6 @@ static int efifb_remove(struct platform_
 
 	/* efifb_destroy takes care of info cleanup */
 	unregister_framebuffer(info);
-	sysfs_remove_groups(&pdev->dev.kobj, efifb_groups);
 
 	return 0;
 }
@@ -637,6 +629,7 @@ static int efifb_remove(struct platform_
 static struct platform_driver efifb_driver = {
 	.driver = {
 		.name = "efi-framebuffer",
+		.dev_groups = efifb_groups,
 	},
 	.probe = efifb_probe,
 	.remove = efifb_remove,


