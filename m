Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C775320A05;
	Mon, 27 Oct 2025 18:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590631; cv=none; b=qY0TUYqreAh7+lPwXQ07WhUww9GkSja/Sfbj+50s+RIuWWQ+W5T2sdJe3FdUMtmOqZzCEosgDPFqE41iPQ/3c/fQ+IWcACMJSlSvOS7CDe7LBXnUxgSL8y3kCDsoCGxWeRZ8dZIrhnj+LJ/41IPVDDIhE7y9HUgcaeCngPDkju0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590631; c=relaxed/simple;
	bh=slX0OXxwuU+0C1/5N0Xf1sZ/EXHWFRK3jGmz2VMK6mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTqR25VFIEc546hIuymT+W69db/rd5PABOX7W3UUTNTIAULdiMFaagIOeR4xKJ/PyDM7/8oeg5Y79+exfC6SBHpiR6YrNQ22fZiXo5xnfshMTg+TtLZ1rhhp4JFd36hypnmD2upjcAcXSRZUrsQQIJ/0+jDZs4c2TrdoeOYPF1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=164Fkaik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="164Fkaik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F2BC4CEF1;
	Mon, 27 Oct 2025 18:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590631;
	bh=slX0OXxwuU+0C1/5N0Xf1sZ/EXHWFRK3jGmz2VMK6mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=164Fkaikj7FBmfDi1uI2vlKkmr9+ImbKrv8XY2gDQzT8aK23rjQ9BFxoB2K/NhiI3
	 2jicwye9jMB+uojpv8Cs/+aN8sGh/sd5DJPeQmiUVX1w2GWImYUT75HxMG9nogE4OY
	 S0qcmDW/qsoQjLjJ5cwVRppg/a4chG1S3CEOBBuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 118/224] mtd: rawnand: fsmc: Default to autodetect buswidth
Date: Mon, 27 Oct 2025 19:34:24 +0100
Message-ID: <20251027183512.142973974@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit b8df622cf7f6808c85764e681847150ed6d85f3d upstream.

If you don't specify buswidth 2 (16 bits) in the device
tree, FSMC doesn't even probe anymore:

fsmc-nand 10100000.flash: FSMC device partno 090,
  manufacturer 80, revision 00, config 00
nand: device found, Manufacturer ID: 0x20, Chip ID: 0xb1
nand: ST Micro 10100000.flash
nand: bus width 8 instead of 16 bits
nand: No NAND device found
fsmc-nand 10100000.flash: probe with driver fsmc-nand failed
  with error -22

With this patch to use autodetection unless buswidth is
specified, the device is properly detected again:

fsmc-nand 10100000.flash: FSMC device partno 090,
  manufacturer 80, revision 00, config 00
nand: device found, Manufacturer ID: 0x20, Chip ID: 0xb1
nand: ST Micro NAND 128MiB 1,8V 16-bit
nand: 128 MiB, SLC, erase size: 128 KiB, page size: 2048, OOB size: 64
fsmc-nand 10100000.flash: Using 1-bit HW ECC scheme
Scanning device for bad blocks

I don't know where or how this happened, I think some change
in the nand core.

Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -861,10 +861,14 @@ static int fsmc_nand_probe_config_dt(str
 	if (!of_property_read_u32(np, "bank-width", &val)) {
 		if (val == 2) {
 			nand->options |= NAND_BUSWIDTH_16;
-		} else if (val != 1) {
+		} else if (val == 1) {
+			nand->options |= NAND_BUSWIDTH_AUTO;
+		} else {
 			dev_err(&pdev->dev, "invalid bank-width %u\n", val);
 			return -EINVAL;
 		}
+	} else {
+		nand->options |= NAND_BUSWIDTH_AUTO;
 	}
 
 	if (of_get_property(np, "nand-skip-bbtscan", NULL))


