Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32C43358C6;
	Tue, 21 Jul 2026 18:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658443; cv=none; b=SpSZDEu4n/fbjAuFmR1yMDhvwf/BgLIXMa4ZKRWb4OQCmoqz/nVSSd6Xc1vb5ku/8REOkMmV4wWorHU6ttuaCydZztZSvxX1ecN0OkCBlRgM+cvtVj1c2gj6lId3Hg/nt+oQcD0WhUKZ0IcbYsIUlz6TeY7LHkvJdnvomozukKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658443; c=relaxed/simple;
	bh=aeItQX9RI8t2B9Pq+z+cwUN7esVm5GDEDSmK5h2elWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkuQZNfRPf4k7uPIHkj5hmCr8f9r2Ts2iKuGYni6hHPvR6o+V7c/aM1pEFoIoXr9Gys+SJ36ECAFGNyb4AlT2JOqGImLou89bUKRAY7vI63BDLBoop4HSCDIv/fFXld0KzbZPD71XqM6qfzzNkAgDvEEUuh5wuhbodtYoWmJPy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjIRjLCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjIRjLCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563FE1F000E9;
	Tue, 21 Jul 2026 18:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658441;
	bh=KCEipqxEC/pmUahMB5VXxHxSd9zJTcilLthnKIXOBv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjIRjLCssARVftMCLHk9ZX1hmjyUaHLKZntLnlVf9NK5SGAsqnatezo70J51ibOi/
	 KjkiCX7A+NwhYWkts+iekkPZrMyuarhyGBEwz/70uq+G9ZlHx3cekeh70uabvNeN1M
	 4WIJ6EU7n16d/ibBFzFo1Wxyl0j8Mu3biNfptRXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1144/1611] fbdev: metronomefb: fix potential memory leak in metronomefb_probe()
Date: Tue, 21 Jul 2026 17:21:00 +0200
Message-ID: <20260721152541.152509333@linuxfoundation.org>
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


