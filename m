Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585721E98EF;
	Sun,  7 Jun 2026 10:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829088; cv=none; b=dgDE8J1D5aK2ptD9M8ECFN1qGcTANiT7m+MCeHaf9Mjwg1Af/bnlAkFXKOfWlQy1hSo6j5wisqtUPn8CaqLvdHABme1yN0kUyoFCwUNBuKvkNTC461Q+2+Vdx6mvWyBZmbzHVNYxzZmGLccmcxBehcoJiQO+etXk+hXVFS2D/6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829088; c=relaxed/simple;
	bh=bOuAjwc1l4WNJHd4Vza77QijxH0jiOstN9qjHI4UVEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLDN7Tz6AfPqv82WS8SN1uuORn4FQDHfgMyuWhSVcCFQk/y8spCY5KYTHJPJOVXH42eN5mE0euHG8Bz39FXvG9/1traX6RCeQz8/cbncCuezBkX+MHroVw4kcXzsNXH/sH7xhoe5HWMMJbvHvGKXPw8HBR5tezK3l+H40FLOmgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrmVt4Ba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrmVt4Ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957D51F00893;
	Sun,  7 Jun 2026 10:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829087;
	bh=uVBjch1I+AaNss7v2iyTNkbIats+EvSWneRGubj3VG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrmVt4BaqpAyWVXYFJ5ho39rLiMdU68qyyMoDMZqOLxpRqaaR/Iz+tD26/i38UqL0
	 M3glOGGK1fZtWeP29yd3vt299ptbu36X/b0tBPNmcfcMPSgwtrQprttyqDtnDD6lCJ
	 z34mMrLEsI1/V5xsrhg2srVIoWndjIXTwzkXQGi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 216/315] gpib: cb7210: Fix region leak when request_irq fails
Date: Sun,  7 Jun 2026 12:00:03 +0200
Message-ID: <20260607095735.498837600@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

commit 2eae90a457baa0048a96ed38ad93090ee38c8b2f upstream.

When request_irq() fails, the region allocated by request_region()
is not released. Fix this by adding an error handling path with
proper goto labels to release the region.

Fixes: e9dc69956d4d ("staging: gpib: Add Computer Boards GPIB driver")
Closes: https://lore.kernel.org/oe-kbuild-all/202605160620.ReBOadPX-lkp@intel.com/
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260518022939.16881-1-zenghongling@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gpib/cb7210/cb7210.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/staging/gpib/cb7210/cb7210.c
+++ b/drivers/staging/gpib/cb7210/cb7210.c
@@ -1048,7 +1048,8 @@ static int cb_isa_attach(struct gpib_boa
 	if (!request_region(config->ibbase, cb7210_iosize, DRV_NAME)) {
 		dev_err(board->gpib_dev, "ioports starting at 0x%x are already in use\n",
 			config->ibbase);
-		return -EBUSY;
+		retval = -EBUSY;
+		goto err_release_region;
 	}
 	nec_priv->iobase = config->ibbase;
 	cb_priv->fifo_iobase = nec7210_iobase(cb_priv);
@@ -1061,11 +1062,16 @@ static int cb_isa_attach(struct gpib_boa
 	// install interrupt handler
 	if (request_irq(config->ibirq, cb7210_interrupt, isr_flags, DRV_NAME, board)) {
 		dev_err(board->gpib_dev, "failed to obtain IRQ %d\n", config->ibirq);
-		return -EBUSY;
+		retval = -EBUSY;
+		goto err_release_region;
 	}
 	cb_priv->irq = config->ibirq;
 
 	return cb7210_init(cb_priv, board);
+
+err_release_region:
+	release_region(nec7210_iobase(cb_priv), cb7210_iosize);
+	return retval;
 }
 
 static void cb_isa_detach(struct gpib_board *board)


