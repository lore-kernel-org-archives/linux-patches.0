Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE39044102E;
	Tue, 21 Jul 2026 21:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669913; cv=none; b=PJiCG/HP7YJ01t/hI56HzY/GQo/bVC+wEUnOUkzRBwB9qoyE1grizNnuUb+QBq16qEkI1UWb6nplnzrnavRPSurJMRNit9qQWOKH7WyGmoUdbsMG+D9xbVRRr004Qyf/woHz9aM1wK96QoeNIH3qrcBhAY6k7Wb9VqD7RHuuPuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669913; c=relaxed/simple;
	bh=A2Emh8bf6xnItLAAKf5e6Uy3m0hkWEkRfsWHWkqZ9C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQvb2arbZEnOtFpSVzjT+D+dXgDu/AMKpy5lMzi9XlJGGpkLMqenRfsMFAkAFtzW8/bCpiGUq6dYJUXdhSIYXArG4+5fm2bUjixSrlNylS/BzAx9u5XS3yoBPhUBz4Fo5ZyOcQ6nMs6gcCcFNQ4ALI5Oo2YCWaj+Xu8yHWqYN1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tX7fp9g4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tX7fp9g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2100B1F00A3A;
	Tue, 21 Jul 2026 21:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669912;
	bh=6nE2dqsvpzXXJz8IT8V470KlQJl/E+crCjXs5L1gfI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tX7fp9g40CRxHW3uPVgc49wJCTiF05Ab1nL4hO8tXDRIr5i74jK0XJ/1hh7GZ6rZ1
	 qzWscmM5jRHOl2kzBTLEYyrjKifiORk1mLPS6HDe+mb9tEU5clmG3z2oZAHX91zLxI
	 jDnm74WA7OfG2Gmd3m2yAXoQcJdVisH1x1KWal6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0733/1067] fbdev: i740fb: fix potential memory leak in i740fb_probe()
Date: Tue, 21 Jul 2026 17:22:14 +0200
Message-ID: <20260721152440.982531232@linuxfoundation.org>
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
@@ -1155,6 +1155,7 @@ err_reg_framebuffer:
 	fb_dealloc_cmap(&info->cmap);
 err_alloc_cmap:
 err_find_mode:
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	pci_iounmap(dev, par->regs);


