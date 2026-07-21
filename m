Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2DF4582F7;
	Tue, 21 Jul 2026 22:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672281; cv=none; b=hQrHF4ioOZvU9cet82gO/s1i9bzMjwSAhR07JtnL1qhudMwhszvGoHqFdgxQ5osi+IFSBW3XOhk5SsYVSXCztol3VjcU3ePNwR5tlCBpyrqRcjdo3rMkyFoynYGBngTTGim3f5os04qMhK4vTyuXZshQN4j49Z4qjQGA718AbgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672281; c=relaxed/simple;
	bh=Jz625oE/n9dqh3WLN1cYSbHaDwv5lBg0CcEXkJe13/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwvNZkz6s6PB9KuxwlK1BXapeEeiZe3r0b0Klib0X3G5qv1iAKFJ4l/y/6O8yLR8HGdn3L30OpRgmw0wexI9ifoPyi7xdHWezdjaSACjHxcWqSnWxla8dim4ySHSsu2QvKvTGhyVlScPEqUwH02/ZWI4KBHs8y2kJ/hEGYQrPdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TInig58r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TInig58r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A851F00A3A;
	Tue, 21 Jul 2026 22:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672280;
	bh=vzn8yR+dRI68I9OVgvAZkb93N9H8irvA0nfh+LdIHys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TInig58rAED1jhXingY2F3ZIyPsKKUPtn2DsIITa3YY7F/Nw046DCKSnd/MkttjbH
	 ah7uqcSbkSU4dFDvsLTv96uP0vxG+VWjEZMrE77CVFiaA/dEcX56bRydh7DDcH0xT/
	 5qCQq0l0Cj0qRLglbdMYlMYWuMXe96tefasglSOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 565/843] fbdev: i740fb: fix potential memory leak in i740fb_probe()
Date: Tue, 21 Jul 2026 17:23:20 +0200
Message-ID: <20260721152418.758796998@linuxfoundation.org>
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
@@ -1150,6 +1150,7 @@ err_reg_framebuffer:
 	fb_dealloc_cmap(&info->cmap);
 err_alloc_cmap:
 err_find_mode:
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	pci_iounmap(dev, par->regs);


