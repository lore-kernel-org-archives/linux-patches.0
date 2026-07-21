Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339AF3EDE79;
	Tue, 21 Jul 2026 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654117; cv=none; b=q5q06GgDKgcg2vcqkg1Jpx2Can0VTKAQ/QT2PvAgOz2IKcQreLg/USEK5VdxbAo0hggtGFsq5xeK7BOjIDOXU5i6cruYJ0aT73xph0kP2wccaUFIcQvsogGllgpvyoFR7kYoK+imx+vzNfs29zaKI1PAe4jZ3RfQGMCrQ1dv/8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654117; c=relaxed/simple;
	bh=wVq8IET/h7Jy/xmeIc3cg/K+fx8Gn1GAlQ+cE1F/sKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceXfZ+6TgWxK0SHJ06PZQk9RPIfI4t+B8Ef5l8QcCqw5Gq8AEl/qQfKvbPfkJN/eou5GCQVK/+YX7/Q/LIN08gu1yAi4YlOrLxOkR+leXATI29tdSo7YAKI2IHn+diC8Qn8sVuJRxxdW8WkQByLQxUKCdTdMHWpuCxbct1v/vb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dx5MN5l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dx5MN5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D721F000E9;
	Tue, 21 Jul 2026 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654115;
	bh=oLdnLEFZg6PNCQoypdAMWmwzoe6fzHeZxyymFQkTwq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dx5MN5ltp8ueDBGdAteqpzRcs0S4LhO9T+z4jTi48avaQcbIU1pOLuh8yo+mihK9
	 hFpHaNcb43UTCl2KIi6z7IzRjDdqs1Wc01FEfy7CyhYosjOq0ZgXEEnYthTdfCAAOE
	 0vOePRNTSUZd8E1omHt6nSbCLcuakS+FP4P6kIsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1584/2077] fbdev: radeon: fix potential memory leak in radeonfb_pci_register()
Date: Tue, 21 Jul 2026 17:20:57 +0200
Message-ID: <20260721152630.135552007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


