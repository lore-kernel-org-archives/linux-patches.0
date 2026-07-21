Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B05B3C1400;
	Tue, 21 Jul 2026 22:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674175; cv=none; b=bw4Tl+fZBDGH77E7ug21/qsSuUSdCZ4hOc8h+HIBnYgbHULkeD4SaLZpv/EjjZOZ0RXs1zqvsVYHV+A0RgjWr97qfZw703Fe32WD+AswOcRmzcb/y17UHF8k3zoLVEEnKtgOyisaPnuskDR4gfXBTswauF0sVl5XSPKYj5wSI8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674175; c=relaxed/simple;
	bh=Tnxa1r7VweN5dThbVK/DTP0WVapbX/MkFIMbLwYwn0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCuPx7gi6PVIYBQY93gAXB9UCNsiYE1UyLlnC4/haHfIiyzgiDXXwaGLBWnTg/RZcQUVvVP43IK8BYXTxjwaS8pBAb1vdZBpzQBtI0Ml6riYiXKmDba4Xc1KTmyX7mt1X9M4W9alTGF+cNwgWu8xqVZogo2MC/clE418tvUSTVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YifW5yvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YifW5yvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2F11F000E9;
	Tue, 21 Jul 2026 22:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674173;
	bh=9aj9QCUKS3N+4X9iUqHUpEweMOD4+fUUcukM2l+2my8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YifW5yvBkFgqS8FTjgMsfQwhrV2MSMz7Vhj5s0S49C1tM/Ff9kuIuZFnrQ8wNXEc4
	 IvBwGXlMxtu6SBF0kAB4l2jtvy6bdq0JWESoj/+NOC+uO+ZuGtkAeNOk8PWPDvUlyz
	 l3rcGjtK5HI6RjHkSusyfJtG80WM5n87UTEwrKek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 440/699] fbdev: tdfxfb: fix potential memory leak in tdfxfb_probe()
Date: Tue, 21 Jul 2026 17:23:19 +0200
Message-ID: <20260721152405.623757894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit bb019d755366cc3e777a12d4bf457ff289837370 upstream.

In tdfxfb_probe(), the memory allocated for modelist using
fb_videomode_to_modelist() when CONFIG_FB_3DFX_I2C is defined, is not
freed in the subsequent error paths.
Fix that by calling fb_destroy_modelist().

Fixes: 215059d2421f ("tdfxfb: make use of DDC information about connected monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tdfxfb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1548,6 +1548,7 @@ static int tdfxfb_probe(struct pci_dev *
 
 out_err_iobase:
 #ifdef CONFIG_FB_3DFX_I2C
+	fb_destroy_modelist(&info->modelist);
 	tdfxfb_delete_i2c_busses(default_par);
 #endif
 	arch_phys_wc_del(default_par->wc_cookie);


