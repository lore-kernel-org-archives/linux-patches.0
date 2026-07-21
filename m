Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C32140315F;
	Tue, 21 Jul 2026 22:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674169; cv=none; b=ZQJXzoN2N7w7UXscs2ipBLISPER3I5HGU4YVWFHTf27VW8rkemCOVBqMuAIZzwmoXttA3evSsV/sZUpve2RYE7njgWWgF5BJYUkMK3Du4KlwJefpndoblokeQCLKqvLmVY+QsQnU5jCeITQ2xAXrRT8Joq2v/tIFP38K2zz7Azo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674169; c=relaxed/simple;
	bh=CeVCkvbmdFo2m3Y9jCznrKJKfrM6FEu9L5qE7iTsIco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGUk1EzPXl6oZ2LVqnrl5Xu+JnUefO7vpjfp/0JpDrxGTi9bTZ8VlV9IFnu9Sxvf3/FEvJBfWx/hEPO5KZoR6EXZ/ZJPjDK8QVy5/Y/RR0qpir2mFlk7vuRPlvDlTbhNs9BOfodMFgPNugXzF8DD1akTUKOeDss0FgOXhdNIqLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpTJyl5a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpTJyl5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E111F000E9;
	Tue, 21 Jul 2026 22:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674168;
	bh=t8uAeTCIkThUbCqvHFpaFSlsgDt1zGIleOzwtvGV5YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpTJyl5aSVwOoUw+lsxeMR6WUQpj94n951IFAMMdX1ba13KKBTzAh4ZAUuzL6VBgb
	 MTflb+VGDZf7lZE7KjI3CaGUBrpq4lZklUEdESU9tExH5xVQMQrJ37UAMopPJSajKw
	 tC9LKe4vV+HDFRC86akGdjb1stCL4L5SP/SmA62c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 438/699] fbdev: s3fb: fix potential memory leak in s3_pci_probe()
Date: Tue, 21 Jul 2026 17:23:17 +0200
Message-ID: <20260721152405.576755301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1366,6 +1366,7 @@ err_reg_fb:
 err_alloc_cmap:
 err_find_mode:
 #ifdef CONFIG_FB_S3_DDC
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	if (par->mmio)


