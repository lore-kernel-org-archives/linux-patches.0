Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8453BA225;
	Tue, 21 Jul 2026 20:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667052; cv=none; b=pDYqEkWVHoUb2ZbXNDJuZrqNI65094JVX8k/Dvd8L0k1ofjGUAfQbpJfjBhZ2rkun68DwV2BxLBECCRI6WHTJ6w12PXTgbN5PNNTWiwMal4WAgtZydwdvQANMNOo98uDDS1uunNV5uIU8pMnEnPaRrLRdSq4X+K+HI9FIJrt8Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667052; c=relaxed/simple;
	bh=RVHLZi7xVwsAaeKQSzq31CEikKnOX08C4t1K+po7CLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hESR/QnCIcun2VsjmagCDtG4jDHEyXwOvBTlXUttPgRB1Yr+uVYHV4OlqMsWfnGVWZRe/LsV+vrykaNu/MoMfAZQb2xTBOKyhh4nmfZr+MweZRm6pdM1rqG3MgMpFTUt0xl8y6nMnpPah67TDceDWCqqBYmF1XazbmuIIEXp/A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcuIJPsl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcuIJPsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3D11F000E9;
	Tue, 21 Jul 2026 20:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667051;
	bh=TYIef3G1C3PK/J6IISmfJzEbcFoIOxsZU5vT2Fm8a5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcuIJPslYrTRAyH1jjG+mZC+2TGMkGXh0VP2Iv7RVR1bx1Cjpd0qBLZMuhHrDehAg
	 mJgSKbWCHTXuYURC4iWoWxxG7y+lB7bQZQ3aUDV31/ltOU/MhQ7PQlrxmPBC2u1Ljq
	 SnidKoxgJmnBiFfyYu9YIkdvhUCbzRkqgz96TUAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0913/1266] fbdev: tdfxfb: fix potential memory leak in tdfxfb_probe()
Date: Tue, 21 Jul 2026 17:22:30 +0200
Message-ID: <20260721152502.275342806@linuxfoundation.org>
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
@@ -1551,6 +1551,7 @@ static int tdfxfb_probe(struct pci_dev *
 
 out_err_iobase:
 #ifdef CONFIG_FB_3DFX_I2C
+	fb_destroy_modelist(&info->modelist);
 	tdfxfb_delete_i2c_busses(default_par);
 #endif
 	arch_phys_wc_del(default_par->wc_cookie);


