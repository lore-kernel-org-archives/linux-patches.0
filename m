Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09DA415F3A;
	Tue, 21 Jul 2026 20:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667039; cv=none; b=E8POyLgL2z5CP4rCDLZ54yYiOwyTWMSXO/x8zSSWBwOn48sb/Dk7RdVEq6kx5Se+aG63k4turFr/rixkUmoomLGZHAy9UuqwLuF/CVEXBgDkhMLsJ8B0yYNjKFrMpx+NhpCa1ZqdYLpod7jKRjpzEcBntkRK/IArXO37zGLNH2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667039; c=relaxed/simple;
	bh=o4YTCe/lBfBonA7btT5ZVbOxDV4Ids6cWt5JSGjogMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3s8DKOuuwr6l441XrIUFuakCq4z3MfLcSHx8T5ysGNtG5eHMwoo2lgMF1D8GVeqOOMw2OCEYTR8RdmaLDouOSQ6M90o6PC4tLK/n2zorC/vzmkSsly+mf68XwQtTNPEYNR5utrYEen2itIMzFYFTy1IAoaad39z2L4pCSGco4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIyPX8E8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIyPX8E8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132681F000E9;
	Tue, 21 Jul 2026 20:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667038;
	bh=M+CV1PlerBHpo5PWVag/CnoUMFdLPep61tqBfRymczw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIyPX8E8ZAjUZYEpUFaAWFHYzBdhjUrVQbUDrvPU1Xj4bDauI/bdCtb4NYSQvmUdu
	 6dFf3pDsXHmabNMk4FcxzwPDf+hD1Q7lI2JgeGTxyjcLeoluFisKAYA0yBzstAjKu2
	 PT0n5XjQKXYtiW6CAdUnWSvt5qhLSuPZeb4FeW4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0909/1266] fbdev: radeon: fix potential memory leak in radeonfb_pci_register()
Date: Tue, 21 Jul 2026 17:22:26 +0200
Message-ID: <20260721152502.186173604@linuxfoundation.org>
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
@@ -2474,6 +2474,7 @@ static int radeonfb_pci_register(struct
 	return 0;
 err_unmap_fb:
 	iounmap(rinfo->fb_base);
+	fb_destroy_modelist(&info->modelist);
 err_unmap_rom:
 	kfree(rinfo->mon1_EDID);
 	kfree(rinfo->mon2_EDID);


