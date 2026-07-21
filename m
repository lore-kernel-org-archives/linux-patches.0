Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76483BED24;
	Tue, 21 Jul 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654124; cv=none; b=rgmTVMW5Fn30v5S31zeB28ocPM/DBQQhYCJSiSmO2BfO/z4sRLxwbTazMX56n+28eXCgzzm1knwyJr2oy9h6miPw7195eK4mAy8B1xgI/2KU9U+BUlRbtPsGsmstfAtbpotJFXp1XmJ86RSfGqjSmCQG0ixSv4SjA8RIaiAz8D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654124; c=relaxed/simple;
	bh=KIT061B68TM6nFfEG6bRdyHbx09I+G1b3otu1nPHOME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uk5AQU5h+aIf+ZpV/lMbXpr+pyOSnzNuXVvbpzlo1BxfYGmSZdYhM3TKj+9Jf3ePFXDC79cQqzxxLipgKA42HrLRKtcap9oBpSiZj15zuZGmAcxKG/dWDBmsmzwh2Xnnq5QaU6Co+O46oTUTwl/N07wm6MroEWp7Jbz8rPDwpEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrtFwH/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrtFwH/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFC31F000E9;
	Tue, 21 Jul 2026 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654123;
	bh=KPkngZmjHWinakRhZ9UHII5vSRSZ5CPOWc3jaKhQdAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrtFwH/WPUT68E4bnb3EcKngB0JdDb6Dkq7vbqWCh/lJ51/d2qrn29QC4jZs2xjy9
	 5W5dnHDa16cEfSORMe/+VJOtC8H1UHSDDZuxuHXj8UzBCHHXSScHPlcDVD5iiRJGg6
	 j0+IxMl0XM+/GxeEUNc1sw6nnd1iv5uid/rTkBV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1586/2077] fbdev: s3fb: fix potential memory leak in s3_pci_probe()
Date: Tue, 21 Jul 2026 17:20:59 +0200
Message-ID: <20260721152630.180244605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 3b0ed04bc852887a9164e1bbf521652e8ef3eb92 upstream.

In s3_pci_probe(), the memory allocated for modelist using
fb_videomode_to_modelist() is not freed in subsequent error paths.
Fix that by calling fb_destroy_modelist()

Fixes: 86c0f043a737 ("s3fb: add DDC support")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/s3fb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/s3fb.c
+++ b/drivers/video/fbdev/s3fb.c
@@ -1446,6 +1446,7 @@ err_reg_fb:
 err_alloc_cmap:
 err_find_mode:
 #ifdef CONFIG_FB_S3_DDC
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	if (par->mmio)


