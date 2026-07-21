Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB993C8716;
	Tue, 21 Jul 2026 20:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667045; cv=none; b=sjEQwEQNZpe58YnI66OXV198IzPcpYn5Jqg6GdS04lIxQNTJlyuDsDPVc12/NMyVgwklW1+zQ3+WvRMcYsEpDJPBSOAWN6GuyNBnvbV7+iUuHv5ia8I8wQ4JIaANcQCyB39vkIwddiluZ7r9cj8lxhgIQAbkRG2L982lwxXb2KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667045; c=relaxed/simple;
	bh=rSFNuPmPQM8wnIN+J9vJc+rfEbpqggv3xfZ4hlAO8WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTn7ygW9P/S3+1kcce60dkubQJtbVvEFzcTa/RaGofXVIHmwvSmEU2qjH/Uiirr6BsNw46aE+Qnfzol0ea7QWgEXQpJb3jJ61KRH0C124tJ7QJqpR239NyfVt06b8D6sBS77q8Wo5SYJiAzjWhbTI7b5az/N9WHRU3sr6YC03TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9cQ4Qu5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9cQ4Qu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9FD1F00A3A;
	Tue, 21 Jul 2026 20:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667043;
	bh=0FhoEw6d++UhZwcaQoKedekN26ca7kmUKq3YFdJyBMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9cQ4Qu5494YU4SBDaAo+1Pq8sgKCuY+GW2uY/Fwolo+0eplMrrRPM62HryeqvOdI
	 PVnMhGl4eER2MHHjhU/7ZXSYx50wGZYUgp+IuBUl3pzO/9FCjd600tsbqWdJ3JkY75
	 FLgOmx/qeZ6Hzq/3iHLKdOLzVfcNkQrDUqCdbp+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0911/1266] fbdev: s3fb: fix potential memory leak in s3_pci_probe()
Date: Tue, 21 Jul 2026 17:22:28 +0200
Message-ID: <20260721152502.230477529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


