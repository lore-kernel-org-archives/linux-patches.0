Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D885A1DEFE0;
	Tue,  8 Oct 2024 13:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393435; cv=none; b=CLigGaZ4/4kU0Gwr2lJc4G8S0xN2brfvHrULY3HTlz1mKN4xUH8ubaLJ3OST+5IqEQBkwlNaNpcgyrXhjvoO0PKEFQ3c9hxqLrt3h2iYTJTAN/uL/hwKYh93hEEVTiYoHN0EqV071YIpG/8ShuNjWsQtqQPot1K47Td8uWBE4r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393435; c=relaxed/simple;
	bh=kAjB9ZP45U9VMyCrRHJVDZD8riw+f/vGKGMr43ypEZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wq5ExJQfITR1PUjZazYVYkJUYXusSf32xTUREVjOU37z473+gjwk6bapj7xPvg0ZzCIX7MIxxH1GmELoems+DrMgPsaK+UG5pidOyyFF9BLhjq3QhkIf7uDq5zuqxxlHaBbuBkmEbjGNeh2fyJGYcnMhHgbVrPwZQxQ0FMG9shs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sspZznBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sspZznBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475F4C4CEC7;
	Tue,  8 Oct 2024 13:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393435;
	bh=kAjB9ZP45U9VMyCrRHJVDZD8riw+f/vGKGMr43ypEZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sspZznBVb2OV5rvioEoAkI7yQvVQD8KlG4OJ33OytoxILEfm/tTNB5SQjtfbCsQER
	 Wdqeke9JdiALde3PJtgMsBx9Tn9MpXPxysnB945AfnEYxFQL0pgAwYNtDy9gBcRzZV
	 3i8qKIi/+InS/3+TTVk7Dj70oymQfp8Q80fWIvwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/386] fbdev: efifb: Register sysfs groups through driver core
Date: Tue,  8 Oct 2024 14:06:09 +0200
Message-ID: <20241008115634.316716051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f9b4ddd592ce4..88ac24202a1ff 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -571,15 +571,10 @@ static int efifb_probe(struct platform_device *dev)
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
@@ -603,8 +598,6 @@ static int efifb_probe(struct platform_device *dev)
 		pm_runtime_put(&efifb_pci_dev->dev);
 
 	fb_dealloc_cmap(&info->cmap);
-err_groups:
-	sysfs_remove_groups(&dev->dev.kobj, efifb_groups);
 err_unmap:
 	if (mem_flags & (EFI_MEMORY_UC | EFI_MEMORY_WC))
 		iounmap(info->screen_base);
@@ -624,12 +617,12 @@ static void efifb_remove(struct platform_device *pdev)
 
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



