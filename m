Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B97C4343F1;
	Tue, 21 Jul 2026 19:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663492; cv=none; b=ukMH+TgsivKitC8NZya08iby1C2eFeSpJI10kT/WPuiV48eUJuwVELi7v1VsgGN6G1CgPLvh6WCrnkBBGg15JW8dtLciSajtebznH9AL4GAN7gSviUJfF1f4VmoS6/DmBQ7hJmlA8yr5feOpVAclxEe8mfzuOsqXXsV54UQEVfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663492; c=relaxed/simple;
	bh=7mBe5xqlv6jA9l2d/sJfO1C2i75qGs+2YzmQc9zN4l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBWNr3u1h6wkJa9dH28wc1dn2ZafliOCWAsRkAuKCa1AEdWHcRVFoVe0mLT19pB9UmsW0pXZlD1NmQENSV2mfBO0kcdDQ9ywKoRF+RBejWbypiZiXcVR7y6aJQwbbhxUx4VPCabUUdbH027EBNgFJix4bwm1OJmQCG8RXVkcQOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euztCCAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euztCCAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844CE1F000E9;
	Tue, 21 Jul 2026 19:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663491;
	bh=f/2QBA4MWQ8ksSelT6tB6vgDaPcxZOxP81EA1f/FgA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=euztCCAJ/9JIDX6t87y7DAkFBRtAGvEXfAACO6gxh5EIdF/nSlKYIPRkHTfh3XmxY
	 3K4fMrnXM67SqeYU7n4eA7TDHUCZEmch6z9cx1ZlTtKD32az9V3KVWFHJ+Tpv/VfFu
	 uT0i79Jt74SjAiveDRHV9Y4c6C/3N34CnFzO15WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0844/1276] fbdev: i740fb: fix potential memory leak in i740fb_probe()
Date: Tue, 21 Jul 2026 17:21:27 +0200
Message-ID: <20260721152504.942554425@linuxfoundation.org>
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
@@ -1152,6 +1152,7 @@ err_reg_framebuffer:
 	fb_dealloc_cmap(&info->cmap);
 err_alloc_cmap:
 err_find_mode:
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	pci_iounmap(dev, par->regs);


