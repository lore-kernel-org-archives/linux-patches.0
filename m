Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7C7157485;
	Tue,  9 Jul 2024 11:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524371; cv=none; b=glnAzMUTWmR6rkT7IZNMEDTRb/vSpE/kh8FJNHLtp3da1Df6PJ6SPu5HLrAxulgcyoXGPRLGlKIaRPc/q99jRzVW6rBb4nYKlOBxJOSZDRCyEEu49ws6VkpKLz3MGfZkqb1hygJRRCP7vKVawTMwmjGieP53swII5SqyJkodA1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524371; c=relaxed/simple;
	bh=2qeb+/QfyZvvpBlIUqmsKn4BE079jFkmZogL/IqjtL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yw7ppKby4wCfOKpM10MsK9ZrBAQUhT4IZDFk0V4ZZZLYVZFb6YM3Ily7BTdl1IojiSLC7amVn7p6UruTtKakGSFBsieYvUcMollEs086cUpMnMGIbMdus8wz6m321MvIdUQpjpTM3LUlX0jfFj4yEZsihJDU5L2cwohGBV/tOCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLmN6c36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLmN6c36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7823AC3277B;
	Tue,  9 Jul 2024 11:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524370;
	bh=2qeb+/QfyZvvpBlIUqmsKn4BE079jFkmZogL/IqjtL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLmN6c36vpASVxg5VJjxkphZwWJwCHYyY/Bx0ff5pK2dlZH6LLtGbK+byGU5vSM0o
	 FuVnrCgOjbc1hF4aMo3wFEDdmOBTuSzuNtzxjVKgT1tV2YSBTC4Dlh1X13SUlIbMaX
	 Cww/yLyGwm0YlyqcIBfG9ICB47j6/qKTu92K/VOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sui Jingfeng <suijingfeng@loongson.cn>
Subject: [PATCH 6.9 158/197] firmware: sysfb: Fix reference count of sysfb parent device
Date: Tue,  9 Jul 2024 13:10:12 +0200
Message-ID: <20240709110715.068886270@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 3285d8f0a2ede604c368155c9c0921e16d41f70a upstream.

Retrieving the system framebuffer's parent device in sysfb_init()
increments the parent device's reference count. Hence release the
reference before leaving the init function.

Adding the sysfb platform device acquires and additional reference
for the parent. This keeps the parent device around while the system
framebuffer is in use.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 9eac534db001 ("firmware/sysfb: Set firmware-framebuffer parent device")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sui Jingfeng <suijingfeng@loongson.cn>
Cc: <stable@vger.kernel.org> # v6.9+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240625081818.15696-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/sysfb.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -101,8 +101,10 @@ static __init struct device *sysfb_paren
 	if (IS_ERR(pdev)) {
 		return ERR_CAST(pdev);
 	} else if (pdev) {
-		if (!sysfb_pci_dev_is_enabled(pdev))
+		if (!sysfb_pci_dev_is_enabled(pdev)) {
+			pci_dev_put(pdev);
 			return ERR_PTR(-ENODEV);
+		}
 		return &pdev->dev;
 	}
 
@@ -137,7 +139,7 @@ static __init int sysfb_init(void)
 	if (compatible) {
 		pd = sysfb_create_simplefb(si, &mode, parent);
 		if (!IS_ERR(pd))
-			goto unlock_mutex;
+			goto put_device;
 	}
 
 	/* if the FB is incompatible, create a legacy framebuffer device */
@@ -155,7 +157,7 @@ static __init int sysfb_init(void)
 	pd = platform_device_alloc(name, 0);
 	if (!pd) {
 		ret = -ENOMEM;
-		goto unlock_mutex;
+		goto put_device;
 	}
 
 	pd->dev.parent = parent;
@@ -170,9 +172,11 @@ static __init int sysfb_init(void)
 	if (ret)
 		goto err;
 
-	goto unlock_mutex;
+	goto put_device;
 err:
 	platform_device_put(pd);
+put_device:
+	put_device(parent);
 unlock_mutex:
 	mutex_unlock(&disable_lock);
 	return ret;


