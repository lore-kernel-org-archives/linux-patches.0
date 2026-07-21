Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E454B4582FF;
	Tue, 21 Jul 2026 22:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672279; cv=none; b=u1pIpqOwi35lU1itoC7egLYsMrcjMDgSDz+2756HM9TZJfgO2o7lIKxixKiTprBfR1oXxqAhF5D6F0pc1Yvbc+hk94Cyogz4VWcoy+BqrARSH2P9696mfxquy8y4ISdv7Nx1viMjkISQRTVbyveUaAFlI5X+b0josbSS0YHPNSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672279; c=relaxed/simple;
	bh=e+0GsK/1lsITQVGGBrDrxsdYemrT4hh+Puw2RMjM8tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtwbzVM2cvcYq1c2WwcrJSZ4WaUY8Sh6rc54B08Uhb9DdQ1LgtDoveSh+4b21Z6Z8Ybsm3kt5C+9ZkHurUYYzO1JP3/UXQjfkjDrGt+LPqa0XhRx9LYPx8sjxFOGsB4ImRX95mFJW3v/OOMj1QyUt9QdnfsE1o9hjQnjcSD/mX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrCqgNXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrCqgNXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3951F000E9;
	Tue, 21 Jul 2026 22:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672277;
	bh=LcmQBc9/cSUYZdWWiYycrMacWgpDZ/DvLfkHaABGppw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KrCqgNXeeBT+kKJk7Usr+00EQ81RrCi63OqyccvgmvxXuL1gJadsTudpsdOhk/xzG
	 eDpKe7LeQ6CBl16RgVQSQqp0PKwQw4k6GSzB96pVYyDxPKVAB7Gmpj/lvL5yn6BTQm
	 +XUSnvUc+W8uynLCHn1XeuTJLr0OyLyIW/MGkex0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 564/843] fbdev: radeon: fix potential memory leak in radeonfb_pci_register()
Date: Tue, 21 Jul 2026 17:23:19 +0200
Message-ID: <20260721152418.736771039@linuxfoundation.org>
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
@@ -2492,6 +2492,7 @@ static int radeonfb_pci_register(struct
 	return 0;
 err_unmap_fb:
 	iounmap(rinfo->fb_base);
+	fb_destroy_modelist(&info->modelist);
 err_unmap_rom:
 	kfree(rinfo->mon1_EDID);
 	kfree(rinfo->mon2_EDID);


