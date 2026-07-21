Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDC03DD870;
	Tue, 21 Jul 2026 18:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658456; cv=none; b=SQGKss/Gb6ru3Hc++RmMI9/EnlCqjqfddCWN5Yi+PzyiSdFxZUt7jWXIDtcsr/90gWQO86x0H2Pehw2UcVE3B5d3RgHAlqnYwii6H52cYVs1gdW/Q984X3M/lxDNgWBzDdSDsqb+rhIrhuIx0EkVTjP0amFiRAf+GJ5WpYJCdtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658456; c=relaxed/simple;
	bh=vPOwnqD0bsHiwP9FJy1x5QLoMDrFvla79xPTYh/VMB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBpPHWkb7fIym2XHxw4dfhuvvFSlfcnMlTdcTgeb4cVXhFstHBod/NVW9Aho4+bGgfbfndkLniJZNbptnBWftfxh7knrzh1HCja9OrDWsrmgagODc9sXzSDY3oAq5JaaFvJsGqbFfbfKC/0RDVr5QafrRXFqcaCXrbVAC/CnRkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6Fo2Ht6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6Fo2Ht6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14981F000E9;
	Tue, 21 Jul 2026 18:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658455;
	bh=gdLeImMXVj2qY9YlxpZn5WpCwK9bLbm4DK43wpxFAvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6Fo2Ht6h5QbI2/N5JNuNG4HGvDAEKAT4R2VKyiBdX1m15OmXLPUwH6qpCkhaZQpn
	 j0qPpWDjPNwhx+BHS/W4Fx+zj9otpZdM1VF5qNJ/U7RZdfsQfeIL88Egzdd2E2p4D5
	 r9T3eR8FEJZv4cFdMcMGjsKVJFBUR2EqlmJw1DpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1149/1611] fbdev: radeon: fix potential memory leak in radeonfb_pci_register()
Date: Tue, 21 Jul 2026 17:21:05 +0200
Message-ID: <20260721152541.263328429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit df8c1101c9a08859da612b5d0a08d55d475522c6 upstream.

The function radeonfb_pci_register() allocates memory for modelist
(by calling radeon_check_modes() which calls fb_add_videomode()).
The memory is appended to info->modelist, but is not freed in subsequent
error paths. Fix this by calling fb_destroy_modelist().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/aty/radeon_base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/aty/radeon_base.c
+++ b/drivers/video/fbdev/aty/radeon_base.c
@@ -2476,6 +2476,7 @@ static int radeonfb_pci_register(struct
 	return 0;
 err_unmap_fb:
 	iounmap(rinfo->fb_base);
+	fb_destroy_modelist(&info->modelist);
 err_unmap_rom:
 	kfree(rinfo->mon1_EDID);
 	kfree(rinfo->mon2_EDID);


