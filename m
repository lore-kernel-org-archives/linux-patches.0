Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A0C439322;
	Tue, 21 Jul 2026 21:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669916; cv=none; b=TXJ31VhOjIeITSv8bq1qk3XOrKUqVpOb5hH9+W/hImMnpiODTYFQptqCtfXhfCs96K76Vlh1drGHUDEtht0dt9J0+nZ5HLDpmBdtRfjR8w72KfSsRE0Ti5JS/4pvt0yKj4m/HlNqgZzzoL8J6zx0vHU+ZiptYoz2slClnmA620U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669916; c=relaxed/simple;
	bh=Syy92KdNWTQ+zA0M5SpBc4tP4+1VT8JC/YA0dyDQAzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfXgOz5momzQUuR0+hDJMGEjxUCcgoIOB1r92lBE5GQH89zcbbuhYLc0lht/h7kvkUX3gB/mVXim32M7yTdtUqA4ZgFrm1h69EfTiDdKMaj0JCSgqYWylyLaEKzUSIiOSiBXpapqbFXOMfvK42POcijb8HK7BQaHkssNSqH/D/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtUZH/8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtUZH/8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C5A1F000E9;
	Tue, 21 Jul 2026 21:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669915;
	bh=5VOo/LKgb6iyP9eospFtxkWjT7PfnR7cmExd6+FoIv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtUZH/8s45eNeinukYD1YbTpTo1+fW6385omx9vMzmINTqcOC8ENvxmeBtMpZVo9v
	 Z7wABDHn0lXh1Tx9GjMo3gAo8GAL7Vk9A6OBZuBPCUmEC++5dES7GX00AAIVHceu9f
	 dju4I4JmPHrT7x+JnObeU1xK10ERAoNTECfgObNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0734/1067] fbdev: s3fb: fix potential memory leak in s3_pci_probe()
Date: Tue, 21 Jul 2026 17:22:15 +0200
Message-ID: <20260721152441.004045452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1374,6 +1374,7 @@ err_reg_fb:
 err_alloc_cmap:
 err_find_mode:
 #ifdef CONFIG_FB_S3_DDC
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	if (par->mmio)


