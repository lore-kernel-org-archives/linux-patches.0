Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585423AA4F8;
	Mon,  4 May 2026 14:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904018; cv=none; b=mY1j5UKe08gaJc/Bgmqw/M9hpwOWfXTGSA1CeeaCRn0Uxl58gb9KwmD0WhGOypib2x8kfjJvil//2/zf4hQTWJHuBret5RMXpInVVsPIfWaYFtE5FQhr+dsOdR0k1F5gRx+wKhNKyDGmt5lW7BLqYqKLS7AFUyMGJU6fmE6dVU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904018; c=relaxed/simple;
	bh=hLcl7R2ZTtN05pxwCmIHLdmy6ua4QQmzONOfisUhQWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxs8q//FbE1/QcYm8ahp71/2LiSXWxT38ORbOthuwYWewTG2YU6UYzaGryObqJhlM1XzncAiKq8DIYtksJe7M0JO3b/Yw76433o+liUhRTil3FtPAJv3cbyfDYrBUiBJ0H4RfTg7JZoabWlHJ2ea2ztkWVERkZT4d+wu5BXx2mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/9Fchfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/9Fchfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2747C2BCB8;
	Mon,  4 May 2026 14:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904018;
	bh=hLcl7R2ZTtN05pxwCmIHLdmy6ua4QQmzONOfisUhQWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/9Fchfn5RboHx4j++HtfDna6g2ZgXEcqbqkDTa4oByl/oFg6B+mdaLKbF4qebwCX
	 5e+V3/PHkC9nP5CyCS1EjudPwcRGyv1pVFue1RA3U10DnxuTN1FAwZxO/6X9AiGvVY
	 AVLIam1gQ1vX+zfUB89T7X7ZzQgpWt2My5MEiP9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Julius Werner <jwerner@chromium.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Hans de Goede <hansg@kernel.org>,
	linux-fbdev@vger.kernel.org
Subject: [PATCH 6.18 151/275] firmware: google: framebuffer: Do not unregister platform device
Date: Mon,  4 May 2026 15:51:31 +0200
Message-ID: <20260504135148.546551690@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 5cd28bd28c8ce426b56ce4230dbd17537181d5ad upstream.

The native driver takes over the framebuffer aperture by removing the
system- framebuffer platform device. Afterwards the pointer in drvdata
is dangling. Remove the entire logic around drvdata and let the kernel's
aperture helpers handle this. The platform device depends on the native
hardware device instead of the coreboot device anyway.

When commit 851b4c14532d ("firmware: coreboot: Add coreboot framebuffer
driver") added the coreboot framebuffer code, the kernel did not support
device-based aperture management. Instead native driviers only removed
the conflicting fbdev device. At that point, unregistering the framebuffer
device most likely worked correctly. It was definitely broken after
commit d9702b2a2171 ("fbdev/simplefb: Do not use struct
fb_info.apertures"). So take this commit for the Fixes tag. Earlier
releases might work depending on the native hardware driver.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: d9702b2a2171 ("fbdev/simplefb: Do not use struct fb_info.apertures")
Acked-by: Tzung-Bi Shih <tzungbi@kernel.org>
Acked-by: Julius Werner <jwerner@chromium.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Hans de Goede <hansg@kernel.org>
Cc: linux-fbdev@vger.kernel.org
Cc: <stable@vger.kernel.org> # v6.3+
Link: https://patch.msgid.link/20260217155836.96267-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/google/framebuffer-coreboot.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/firmware/google/framebuffer-coreboot.c
+++ b/drivers/firmware/google/framebuffer-coreboot.c
@@ -81,19 +81,10 @@ static int framebuffer_probe(struct core
 						 sizeof(pdata));
 	if (IS_ERR(pdev))
 		pr_warn("coreboot: could not register framebuffer\n");
-	else
-		dev_set_drvdata(&dev->dev, pdev);
 
 	return PTR_ERR_OR_ZERO(pdev);
 }
 
-static void framebuffer_remove(struct coreboot_device *dev)
-{
-	struct platform_device *pdev = dev_get_drvdata(&dev->dev);
-
-	platform_device_unregister(pdev);
-}
-
 static const struct coreboot_device_id framebuffer_ids[] = {
 	{ .tag = CB_TAG_FRAMEBUFFER },
 	{ /* sentinel */ }
@@ -102,7 +93,6 @@ MODULE_DEVICE_TABLE(coreboot, framebuffe
 
 static struct coreboot_driver framebuffer_driver = {
 	.probe = framebuffer_probe,
-	.remove = framebuffer_remove,
 	.drv = {
 		.name = "framebuffer",
 	},


