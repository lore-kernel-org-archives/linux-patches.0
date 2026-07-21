Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F021470435;
	Tue, 21 Jul 2026 19:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663495; cv=none; b=QGOYEKftzODs9r95X30Caj+lTDYzGnh4qNK3gaX0iQYcBnRGd9Ebg460aLbzW1VjVk57L7ItttuS3U7jgXnnA1EppdazxxeMuO6CsQ6jbRTezbSUD92p1AW66oGnJbHY6SiCIepolncM7uMheZlhSCW4oxdjXkwD/Yp9V0SCTLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663495; c=relaxed/simple;
	bh=O2a90vGqamHqLQIFlKm8Pp84ciPFdu5sPoKX53EhkGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k89qtObC4RoLnDvaCJElfslGUmIKbb9NkqtDsWDLMOn7yj7I+LJXOvwRhwentL9BeKZOkvTJ284T9lDCa1pvl8NcoaYxbIUsWSaSo/sX/e2OZnN22OVS3jGaEp6NET1PAWYPjmE2tFDckCuQrszIVExDdHQTvQbJ3r2dK30/vFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pweyZPQG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pweyZPQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320AB1F000E9;
	Tue, 21 Jul 2026 19:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663493;
	bh=mUJYc1VWXkWijIQrdMphwQwp13k4PdPVUcKKw8h1klQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pweyZPQGaWhqf3hPkS0YdUqIW8sUZ0JpRJEfC257qHcNmIgPmSDFFPO+FMP9O5zp8
	 4T2NSq27WqJck6/sWvKpaULBsbnJ1iLZu8C/4z+UBX/1dax257DLdUeTPEMhEVJGLK
	 RIt+6Ontro0pqTxmfL1SaME6RbPLtidhI8j8Y3fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0845/1276] fbdev: s3fb: fix potential memory leak in s3_pci_probe()
Date: Tue, 21 Jul 2026 17:21:28 +0200
Message-ID: <20260721152504.964274404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1382,6 +1382,7 @@ err_reg_fb:
 err_alloc_cmap:
 err_find_mode:
 #ifdef CONFIG_FB_S3_DDC
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	if (par->mmio)


