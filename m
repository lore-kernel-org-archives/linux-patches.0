Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA201B394F;
	Wed, 16 Jul 2025 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752686949; cv=none; b=tsZmQa+amtscHp+2I1qlzZdbfoZ/duwgG5jf123M8pBtAhck19vQY2596OdGgtxhJYrl6jBB3HKVBSEtr/fXPpfU3CqELCbqit1aNEt81yYExGJfbatCGFtjJ1fXvj3yzNzQFHs/pnt/TUwmI50x9SseiZ8UbAqFrm73KsPa8iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752686949; c=relaxed/simple;
	bh=KHDb6zLjjtYFaNSljcLcDdVYJjrz/+7K9CdTKJIJZCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khoWAioU2vW3UFxyf4fVtNTsVcpHVofu4FloCHpEISn9yZ5x8q7I9ptJeY9x8ls/x3jyS3gfX95FI8QaJwlEDpyaNeVfkqsyl0GlROwsDMhvBGPQlV3hlVEm5QnchaGsYy8ChEIGIgTbHG0gld3HDPTCUuJBZwZJCuGGZaVIgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dI/JKJXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dI/JKJXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ED8C4CEF0;
	Wed, 16 Jul 2025 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752686948;
	bh=KHDb6zLjjtYFaNSljcLcDdVYJjrz/+7K9CdTKJIJZCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dI/JKJXCmO+Pyr3Elw7DSpoQlcTCYMnr0rc3yH6THY6UyLB+XrdW65rTqw7eu20Go
	 gKlTqw8J7X19DhS/mm7N1aplLiXHN9SWDAKsV+PelUtfIf9Og1ixB/m5wXLZ/Tozpz
	 Tyn9m0vrIIZbvBDAFtUBz3pOYxIMSFMzkiBHA4l7NVNl3H6TDvheKKDR4cuZiwOios
	 /2E5LqD6DUaON2CDVPaArWh8GdFp63FYkFVEn1u5nx7xLsosjbnicB3BdpWWWvg8/E
	 7yqOxc/RGbg+Q7t1U3CgqVzaffddzzFVDIbUq1PLdCEoDl4MLMfLgGB1LM/rJLcEzw
	 rvTfSIANukWug==
Date: Wed, 16 Jul 2025 11:29:03 -0600
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: accessrunner-general@lists.sourceforge.net, linux-usb@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] usb: atm: cxacru: Zero initialize bp in
 cxacru_heavy_init()
Message-ID: <20250716172903.GA4010969@ax162>
References: <20250715-usb-cxacru-fix-clang-21-uninit-warning-v1-1-de6c652c3079@kernel.org>
 <2025071618-jester-outing-7fed@gregkh>
 <20250716052450.GA1892301@ax162>
 <2025071616-flap-mundane-7627@gregkh>
 <20250716154304.GA2740255@ax162>
 <2025071648-punch-carrousel-2046@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025071648-punch-carrousel-2046@gregkh>

On Wed, Jul 16, 2025 at 06:08:47PM +0200, Greg Kroah-Hartman wrote:
> I have no idea what Android uses for their compiler.  Usually when they
> run into issues like this, for their 'allmodconfig' builds, they just
> apply a "CONFIG_BROKEN" patch to disable the old/unneeded driver
> entirely.

Well I can say for certain that they do use clang but if that's their
preferred solution to situations such as this, so be it.

> I'm really loath to take it, sorry.  I'd prefer that if the compiler
> can't figure it out, we should rewrite it to make it more "obvious" as
> to what is going on here so that both people, and the compiler, can
> understand it easier.
> 
> Just setting the variable to NULL does neither of those things, except
> to shut up a false-positive, not making it more obvious to the compiler
> as to what really is going on.

Alright. We could just manually inline cxacru_upload_firmware() into
cxacru_heavy_init() since that is the only place where it is called so
that clang can see via the control flow graph that bp is only
initialized and used under the same condition. This resolves the warning
for me as well.

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index a12ab90b3db7..68a8e9de8b4f 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -980,25 +980,60 @@ static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
 	return ret;
 }
 
-static void cxacru_upload_firmware(struct cxacru_data *instance,
-				   const struct firmware *fw,
-				   const struct firmware *bp)
+
+static int cxacru_find_firmware(struct cxacru_data *instance,
+				char *phase, const struct firmware **fw_p)
 {
-	int ret;
+	struct usbatm_data *usbatm = instance->usbatm;
+	struct device *dev = &usbatm->usb_intf->dev;
+	char buf[16];
+
+	sprintf(buf, "cxacru-%s.bin", phase);
+	usb_dbg(usbatm, "cxacru_find_firmware: looking for %s\n", buf);
+
+	if (request_firmware(fw_p, buf, dev)) {
+		usb_dbg(usbatm, "no stage %s firmware found\n", phase);
+		return -ENOENT;
+	}
+
+	usb_info(usbatm, "found firmware %s\n", buf);
+
+	return 0;
+}
+
+static int cxacru_heavy_init(struct usbatm_data *usbatm_instance,
+			     struct usb_interface *usb_intf)
+{
+	const struct firmware *fw, *bp;
+	struct cxacru_data *instance = usbatm_instance->driver_data;
 	struct usbatm_data *usbatm = instance->usbatm;
 	struct usb_device *usb_dev = usbatm->usb_dev;
 	__le16 signature[] = { usb_dev->descriptor.idVendor,
 			       usb_dev->descriptor.idProduct };
 	__le32 val;
+	int ret;
 
-	usb_dbg(usbatm, "%s\n", __func__);
+	ret = cxacru_find_firmware(instance, "fw", &fw);
+	if (ret) {
+		usb_warn(usbatm_instance, "firmware (cxacru-fw.bin) unavailable (system misconfigured?)\n");
+		return ret;
+	}
+
+	if (instance->modem_type->boot_rom_patch) {
+		ret = cxacru_find_firmware(instance, "bp", &bp);
+		if (ret) {
+			usb_warn(usbatm_instance, "boot ROM patch (cxacru-bp.bin) unavailable (system misconfigured?)\n");
+			release_firmware(fw);
+			return ret;
+		}
+	}
 
 	/* FirmwarePllFClkValue */
 	val = cpu_to_le32(instance->modem_type->pll_f_clk);
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, PLLFCLK_ADDR, (u8 *) &val, 4);
 	if (ret) {
 		usb_err(usbatm, "FirmwarePllFClkValue failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	/* FirmwarePllBClkValue */
@@ -1006,7 +1041,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, PLLBCLK_ADDR, (u8 *) &val, 4);
 	if (ret) {
 		usb_err(usbatm, "FirmwarePllBClkValue failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	/* Enable SDRAM */
@@ -1014,7 +1049,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, SDRAMEN_ADDR, (u8 *) &val, 4);
 	if (ret) {
 		usb_err(usbatm, "Enable SDRAM failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	/* Firmware */
@@ -1022,7 +1057,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, FW_ADDR, fw->data, fw->size);
 	if (ret) {
 		usb_err(usbatm, "Firmware upload failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	/* Boot ROM patch */
@@ -1031,7 +1066,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 		ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, BR_ADDR, bp->data, bp->size);
 		if (ret) {
 			usb_err(usbatm, "Boot ROM patching failed: %d\n", ret);
-			return;
+			goto done;
 		}
 	}
 
@@ -1039,7 +1074,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, SIG_ADDR, (u8 *) signature, 4);
 	if (ret) {
 		usb_err(usbatm, "Signature storing failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	usb_info(usbatm, "starting device\n");
@@ -1051,7 +1086,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	}
 	if (ret) {
 		usb_err(usbatm, "Passing control to firmware failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	/* Delay to allow firmware to start up. */
@@ -1065,53 +1100,10 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	ret = cxacru_cm(instance, CM_REQUEST_CARD_GET_STATUS, NULL, 0, NULL, 0);
 	if (ret < 0) {
 		usb_err(usbatm, "modem failed to initialize: %d\n", ret);
-		return;
-	}
-}
-
-static int cxacru_find_firmware(struct cxacru_data *instance,
-				char *phase, const struct firmware **fw_p)
-{
-	struct usbatm_data *usbatm = instance->usbatm;
-	struct device *dev = &usbatm->usb_intf->dev;
-	char buf[16];
-
-	sprintf(buf, "cxacru-%s.bin", phase);
-	usb_dbg(usbatm, "cxacru_find_firmware: looking for %s\n", buf);
-
-	if (request_firmware(fw_p, buf, dev)) {
-		usb_dbg(usbatm, "no stage %s firmware found\n", phase);
-		return -ENOENT;
-	}
-
-	usb_info(usbatm, "found firmware %s\n", buf);
-
-	return 0;
-}
-
-static int cxacru_heavy_init(struct usbatm_data *usbatm_instance,
-			     struct usb_interface *usb_intf)
-{
-	const struct firmware *fw, *bp;
-	struct cxacru_data *instance = usbatm_instance->driver_data;
-	int ret = cxacru_find_firmware(instance, "fw", &fw);
-
-	if (ret) {
-		usb_warn(usbatm_instance, "firmware (cxacru-fw.bin) unavailable (system misconfigured?)\n");
-		return ret;
+		goto done;
 	}
 
-	if (instance->modem_type->boot_rom_patch) {
-		ret = cxacru_find_firmware(instance, "bp", &bp);
-		if (ret) {
-			usb_warn(usbatm_instance, "boot ROM patch (cxacru-bp.bin) unavailable (system misconfigured?)\n");
-			release_firmware(fw);
-			return ret;
-		}
-	}
-
-	cxacru_upload_firmware(instance, fw, bp);
-
+done:
 	if (instance->modem_type->boot_rom_patch)
 		release_firmware(bp);
 	release_firmware(fw);
