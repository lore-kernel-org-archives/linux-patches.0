Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2499384CD6;
	Tue, 21 Jul 2026 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654103; cv=none; b=VD1Y5khB1Vah0Gr5kgo5gX4NzPTnTV9Qe/Jkqono4yX+xbtZ1MCAT19B8JBU4It+MtFh8jrFEJ4JWr7cjdXPV0ruT9EfW7gajvhiNn2KsQnSJm39/Vmyxt2ytDN+UOGpGdqb5KIQG7iZgLepu31smPTs90aW0pQKwYnFAQab5ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654103; c=relaxed/simple;
	bh=SNUvDeRo7Gm9VdqRPRzdDufDR1kVo0bYe5P1yf65UGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkZSxHo8xSdSVh5PC37P4nYtfUr28Paf/mNJ7GavddV2/Sv12kpTl0FKNeI21GlUHbwgAkb8qDH1LVagfMaxYJOCrA2TmOX3QRQpvbJA04lMgpWQqxc378V0vB/S4KVKJMszu8AyMx+k2RJ3cyhZ7B0qvj9tCSj5Tk4SUJZ8t/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdLD2u3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdLD2u3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D591F000E9;
	Tue, 21 Jul 2026 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654102;
	bh=tt9qlnUYr0M0sodThjBzSFI9b1Higz8wYhCkmfSSba4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NdLD2u3her31SdM1MUwDgILgZBbKbZap8TwCr+Egrl87WsQDnS1ATMNBu/wPdeC22
	 cTkXxB45J7RzXn+L/Sb+ViLb2u4Waog2UrP4eTj7uWKqGw6wS+BKFBjhZ6k5Flagej
	 wJSAijTquLvLk0KOtsJzLPKjBbuCkmtfBTQ7gu7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1579/2077] fbdev: metronomefb: fix potential memory leak in metronomefb_probe()
Date: Tue, 21 Jul 2026 17:20:52 +0200
Message-ID: <20260721152630.021904960@linuxfoundation.org>
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

commit 894632b862a39b3fe1cb5de06fbae86225ea64de upstream.

The memory allocated for pagerefs in fb_deferred_io_init() is not freed
on the error path. Fix it by calling fb_deferred_io_cleanup().

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/metronomefb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/metronomefb.c
+++ b/drivers/video/fbdev/metronomefb.c
@@ -645,12 +645,14 @@ static int metronomefb_probe(struct plat
 	info->flags = FBINFO_VIRTFB;
 
 	info->fbdefio = &metronomefb_defio;
-	fb_deferred_io_init(info);
+	retval = fb_deferred_io_init(info);
+	if (retval)
+		goto err_free_irq;
 
 	retval = fb_alloc_cmap(&info->cmap, 8, 0);
 	if (retval < 0) {
 		dev_err(&dev->dev, "Failed to allocate colormap\n");
-		goto err_free_irq;
+		goto err_fbdefio;
 	}
 
 	/* set cmap */
@@ -673,6 +675,8 @@ static int metronomefb_probe(struct plat
 
 err_cmap:
 	fb_dealloc_cmap(&info->cmap);
+err_fbdefio:
+	fb_deferred_io_cleanup(info);
 err_free_irq:
 	board->cleanup(par);
 err_csum_table:


