Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBB44195C9;
	Tue, 21 Jul 2026 20:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667046; cv=none; b=dNPNJrNUWboQGK5beG8L3IQRgaoLZfQ1zsZmd8OR6LrVnKV+2iPi3lSBHDUuKH73cXk7pDwyHk/EcCMoBSd8VwiPYL/17+ZKecuTUBOxbjevdfgaI0Uuhw2ogVb0iSppZ5R5uXS0UO8QdYzHIZz5tPlkmHqtQ0QIkwau0W0sLSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667046; c=relaxed/simple;
	bh=6flZKGriRDzqaa/5Pnce8rzlVoPgW/KR4JgGv9j8h9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpbl5kxQwpm9AEkl4Z4Zw+YvUeNf7kcYO34TOHoG3bvcH1wOhEWI39BmiauvIOVrGnSvQtleddfjsNyMlw57GQ6DfM5W5Lun+WGqRiuwYqvkij2Fadh+9VzjipKdYPjAt3gFR7i8rsZOP1c9ujaDdiPWh+iHFIOO6JAKd0bTxns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXGy3yhK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXGy3yhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15101F000E9;
	Tue, 21 Jul 2026 20:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667041;
	bh=uq1KrzHhacyrcx0JmIXIGoTQck/EfQ7CX+Og94W8zxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXGy3yhKIqbqrPYJBcAK+eufHnzyFoG6vjLKLRsgvpd3Rlb0DGNV1v5Tqr4BGClHZ
	 dbGa3ezpIHdANvYeNUHd+yLicYK33ctmnnpLLO5BXsKBBXb2ngIElTHyeQf+rYXY7U
	 n7S31jKxwR9DNekQ+mVbVLg0+YIgZ5GLdQ5alApM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0910/1266] fbdev: i740fb: fix potential memory leak in i740fb_probe()
Date: Tue, 21 Jul 2026 17:22:27 +0200
Message-ID: <20260721152502.207733053@linuxfoundation.org>
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

commit 5936063409af230a2c88b8700c47b89a19fd70b5 upstream.

In i740fb_probe(), the memory allocated in fb_videomode_to_modelist()
for modelist is not freed in the error paths. Fix that by calling
fb_destroy_modelist().

Fixes: 5350c65f4f15 ("Resurrect Intel740 driver: i740fb")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/i740fb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/i740fb.c
+++ b/drivers/video/fbdev/i740fb.c
@@ -1153,6 +1153,7 @@ err_reg_framebuffer:
 	fb_dealloc_cmap(&info->cmap);
 err_alloc_cmap:
 err_find_mode:
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	pci_iounmap(dev, par->regs);


