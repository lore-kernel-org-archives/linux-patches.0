Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1772C45A28C;
	Tue, 21 Jul 2026 22:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672284; cv=none; b=gw/hCDehmEi/Lq1w/Vqglktqn6bI/gS44FpE7B63jUbUN5Aem8lkTXFft9cbs49Y5iqGwxgYgXzy5I1vBw7gLLDMb5UptgUkZsN3LFgdW6+65SGg14CTQryo9q64zxOcRJjGj89tV+DGnWiprOZtEmfJI879L5BkMPxxHjdD1xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672284; c=relaxed/simple;
	bh=shkRAxOZwTrgj+1WvAjLRK55nawecaAtj79aapvJ0TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPAea3BWkEQ9eIAzIy+OjfaTT8SHC6ssTPVyMc7hgQXYzZZdXpcqTzVIlqGVTn6SLJfVboPB3lPvTf+KyfzTmt7HMoamaiGeepHgGJxBnbpa80SuL9RHBRnO9eJrCC4tRno+Ge8qFX7SMEuvHb+1dOrrqIA2JHTDcRqkNQYhOzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCG4ddTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCG4ddTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578881F00A3A;
	Tue, 21 Jul 2026 22:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672282;
	bh=PHx/TwYGJuxVsXwREXjs6JngFJk1Mh8b1t74/xS5Ynk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCG4ddTdVoUPuCOsNdbF3xyZG/ndV1ukgPDLLwXSQDxuh4Gsn3mKe1H/Hb6b4Hx4f
	 Y7HYWAcclfC29afGXCbJozIC3PpG0qqymC4SH2+DY+BsN8TpUj7BmLKQVaLssk9Dd1
	 4vSmaRXDnLvE/qev7i3/J5EMn9Tl9gUZkRI76mxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 566/843] fbdev: s3fb: fix potential memory leak in s3_pci_probe()
Date: Tue, 21 Jul 2026 17:23:21 +0200
Message-ID: <20260721152418.781306742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


