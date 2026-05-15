Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C86280035;
	Fri, 15 May 2026 16:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861608; cv=none; b=eA3SpChQp2H7LqYdOrPjdlFXNEIXQrFfaE15RE4OdIDyGJynqZ5wEPonq2QDSJ/3cqgTh1nrMKNjb2LhPOg8UfgJRpj51X8VVdaXjuAOPNWdqggCWCQTw3bjeasNNaE8JRAa4OCgXq561vsMtYiqr7thh5FLc6xeOUqf9yNI2oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861608; c=relaxed/simple;
	bh=K//Kw4tO7eUvcykpXn+WzuXGhlwcZVGOUUAzD/U161k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTDpydL/D1WbahpzYPn2Qaw+6MILQTF2bi54g83XXVNAZN8+Q2cSKC5GvWRcEDCB+1n5JorV8RFdHTrp4xWqG93HzyRd0BlUn4bBEoBuMzAzNUxFNs1356uKOi4EVTRJPu1vA3HAKYTRajmk4IozLWgSr7KaSFlb0Wl7Vvhaf6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6fVYy9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6fVYy9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B2FC2BCF5;
	Fri, 15 May 2026 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861608;
	bh=K//Kw4tO7eUvcykpXn+WzuXGhlwcZVGOUUAzD/U161k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6fVYy9t07Oh1mhGzQgyIc9y39vBULfKLgdNPDU1W6lWWXEYyMHdGs6LfCnmWWtOe
	 kEn8UiXaGbtg20IEORq254+DaqvvreBvh7KHGv0PQA4NZ+IrI+kXtuzEBal8dY6HxL
	 Jc6+/ANGkPxMXgcQ0auZQhzOase1BlZ0s7lalWRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Julius Werner <jwerner@chromium.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Hans de Goede <hansg@kernel.org>,
	linux-fbdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 395/474] firmware: google: framebuffer: Do not unregister platform device
Date: Fri, 15 May 2026 17:48:24 +0200
Message-ID: <20260515154723.590815875@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 5cd28bd28c8ce426b56ce4230dbd17537181d5ad ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/google/framebuffer-coreboot.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/firmware/google/framebuffer-coreboot.c
+++ b/drivers/firmware/google/framebuffer-coreboot.c
@@ -64,22 +64,12 @@ static int framebuffer_probe(struct core
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
 static struct coreboot_driver framebuffer_driver = {
 	.probe = framebuffer_probe,
-	.remove = framebuffer_remove,
 	.drv = {
 		.name = "framebuffer",
 	},


