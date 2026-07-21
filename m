Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE6D387588;
	Tue, 21 Jul 2026 20:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667060; cv=none; b=ePG3syd7NO8BrMH2+U9/RROVMN5zqKyjqk/bmL+1P8puCKyWlPd0U06aF0C6aZRftw/DpCcz9IN3p3uYwmkTFln7DRNvGLC7M7nSmvoj54QHGH1U6kvCkPvOank9gWCgodi0L5RV12H6f5eROgJCtWFk0sk3w16Rje+1kdMn3Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667060; c=relaxed/simple;
	bh=QSoyWeVZIZR/z2klT38hoj1oOeQvCzQ2PacF6D5YA30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhLn1/G760R+ZKPlbX+ZSsBLvOtE7i0ld+IQGDqD4Nvn6boI9rvyuhDcpEk9jhjC3MnEBaWaYGTD1DyI/xXV3ESBdQGVl3u9MCc6/PVeJjIqNF/0EL1APBi3SDAcxUbpNPlSyvdVoYJVNayHg2AbLUeHYsL0L74fJ6x4A+YD02U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUeEMgpm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUeEMgpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1D51F000E9;
	Tue, 21 Jul 2026 20:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667059;
	bh=z+fFvz/0ATVynR3Itq+AiuO2+5o3Xe/HH2EM0YDPwl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUeEMgpmQanWlsOUENWIm4CW7ws5DuwXKBCULyrRy81D6WBKqkyDSIcgUyqsCyh6Z
	 uUy5yM4P6sGL9Sq1Pp2/Y4D9rfLYbOBZYIaxqN0S4fr3vAjv+51cTV8LFH3+CK36xt
	 YLz6yNoq+QEitPrsB6bxOzFSlV5byEYUuQ1uH/hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0916/1266] fbdev: nvidia: fix potential memory leak in nvidiafb_probe()
Date: Tue, 21 Jul 2026 17:22:33 +0200
Message-ID: <20260721152502.339399259@linuxfoundation.org>
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

commit 85f5e38c162bdf9dbbe197275d416402712f3707 upstream.

In nvidiafb_probe(), the memory allocated for modelist in
nvidia_set_fbinfo() is not freed in the subsequent error paths.
Fix that by calling fb_destroy_modelist().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/nvidia/nvidia.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1418,6 +1418,7 @@ static int nvidiafb_probe(struct pci_dev
 
 err_out_iounmap_fb:
 	iounmap(info->screen_base);
+	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
 	nvidia_delete_i2c_busses(par);


