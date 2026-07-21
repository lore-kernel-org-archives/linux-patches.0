Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3379F3AFAEC;
	Tue, 21 Jul 2026 20:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667050; cv=none; b=IS0NqqxPdpqOnLxeRtEy1kx0sey4ibX4u+RlY2Ytiu0wqTtpkdUFFbQJrV0rXPwa2oXDpYkc69Q9GgvSBhjyKjNgMnvM5z3kWR4aiajmxKcbkHk21Em//h5v2vAR+2PE33UJQ39kkKRwSQVjCKmJIHiEB833nyN08MbQuX6IbK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667050; c=relaxed/simple;
	bh=DN3cogYXeSuzEbLTcv6nerbhbriI5uRSLqtC4L/OC5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPp2R0k7Cj2CMlOd0gWBOCcBuEgqbPIVpBAMDeCYE0BuYhcz5u7jNFi1cGXFGbFTSRlWkFxFMkJhuUdN3IC6SIh63/ceEzq2llRiAvWwFoSrhEy09EdlAl0txf2N1dijx18MKulRjPZkDIsEgQX5o85Q1qOHXj6PvlHNXSquX4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQt08syg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQt08syg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9910C1F000E9;
	Tue, 21 Jul 2026 20:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667049;
	bh=CeDqCzPIGLUCddq+7qFxsN+XuLn4ynY+UALtQeSWb1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQt08sygIe5mvgeGAIQWOx+doK3GJ9huN8+LYi+ECXrWuJTN6UV1pBIo1T/tkZOI9
	 p1GdvxtLMPh4QeppCD0oSTMD+gpvGHjBd7T/6Z1IfbNEc3IPcnUA2N6OSG+2kB4odi
	 sYkvSGDrP41ZaQISXRLMhYixN6uJHxwz8CcstPik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0912/1266] fbdev: uvesafb: fix potential memory leak in uvesafb_probe()
Date: Tue, 21 Jul 2026 17:22:29 +0200
Message-ID: <20260721152502.253605711@linuxfoundation.org>
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

commit 033e56fed09047ee63072e9f58789f40c1c7079d upstream.

Due to an incorrect goto label, memory allocated for modedb and modelist
in uvesafb_vbe_init() is not freed in some error paths. Fix this by
updating the goto label.

Fixes: 8bdb3a2d7df4 ("uvesafb: the driver core")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/uvesafb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1697,14 +1697,14 @@ static int uvesafb_probe(struct platform
 	i = uvesafb_vbe_init_mode(info);
 	if (i < 0) {
 		err = -EINVAL;
-		goto out;
+		goto out_mode;
 	} else {
 		mode = &par->vbe_modes[i];
 	}
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
 		err = -ENXIO;
-		goto out;
+		goto out_mode;
 	}
 
 	uvesafb_init_info(info, mode);


