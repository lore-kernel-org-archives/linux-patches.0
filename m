Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE1A221DAB;
	Thu, 12 Dec 2024 15:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018809; cv=none; b=diOWIrbMZjIF1DQ/6ABdp6kr9vRR14KlyX2XgQRaacpp0ak7ogd+wJjthalXBZSjfxHyOy5pgIzGv1xJoLd1Z16bNzsmxPb8w97YSvr13o2YPSNF5qC9Mr8OOdG3Rta1kMVbNttnPWkdsJbJd1kkHwVftSolX/SobunNPUXaSiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018809; c=relaxed/simple;
	bh=t/4sBaNftY/XELasvTQJwhl3h3TfUVM8l1ZkoGLN5tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1MSTRpBqZjvZrxJ+X0G2lMtFmH0buvFwX2FXbjE9myjjcoqXYhj9+oPtHgWDdjzX49ynZe5F2Y3sCepzobPQ9W0sadaMJ0p8nbM9jjdtvxGUm9RyJptTcBvetPiU7iDx/WeqR0yfjbM9AA/ptDFaIK9KYglvBWLmgapS28M/TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQ8XkBnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQ8XkBnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30F9C4CECE;
	Thu, 12 Dec 2024 15:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018809;
	bh=t/4sBaNftY/XELasvTQJwhl3h3TfUVM8l1ZkoGLN5tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQ8XkBnlVvkgHxHhH22gVQ2Efat/AbSyceKnQhYe7vieeMTZ+xsTZ0kWSUl4n0c7K
	 33U3LDSM1J3mhc1UtgwzeSWIjvK8il6KM4CE3u5wwF4eiVse/Gt+F1s2kTVWZRUwr5
	 oWXeGfsP80tSLxNAnTWsYPmvFXGOyLelr8Led7co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 040/772] fbdev: efifb: Register sysfs groups through driver core
Date: Thu, 12 Dec 2024 15:49:45 +0100
Message-ID: <20241212144351.593432756@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/efifb.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 16c1aaae9afa4..53944bcc990c5 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -570,15 +570,10 @@ static int efifb_probe(struct platform_device *dev)
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
@@ -597,8 +592,6 @@ static int efifb_probe(struct platform_device *dev)
 		pm_runtime_put(&efifb_pci_dev->dev);
 
 	fb_dealloc_cmap(&info->cmap);
-err_groups:
-	sysfs_remove_groups(&dev->dev.kobj, efifb_groups);
 err_unmap:
 	if (mem_flags & (EFI_MEMORY_UC | EFI_MEMORY_WC))
 		iounmap(info->screen_base);
@@ -618,7 +611,6 @@ static int efifb_remove(struct platform_device *pdev)
 
 	/* efifb_destroy takes care of info cleanup */
 	unregister_framebuffer(info);
-	sysfs_remove_groups(&pdev->dev.kobj, efifb_groups);
 
 	return 0;
 }
@@ -626,6 +618,7 @@ static int efifb_remove(struct platform_device *pdev)
 static struct platform_driver efifb_driver = {
 	.driver = {
 		.name = "efi-framebuffer",
+		.dev_groups = efifb_groups,
 	},
 	.probe = efifb_probe,
 	.remove = efifb_remove,
-- 
2.43.0



