Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB5A400981;
	Tue, 21 Jul 2026 17:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654106; cv=none; b=olv0OufR0uF8j+HghVt4d7HbhXeZpc6QzbwIza56ATGFTryaTmmGEayFTWS9C+yOJiXURSYSu2QgQkZG1RyJRDCq8WJXxCnTCdWCLLxYXzjuSoiAFZu7R7rgLD3ZqcXxjdpcNc1ZOVr/mAtEAcV/nYWmcxlv4smwt+bkVXzDL88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654106; c=relaxed/simple;
	bh=+jKF420d6Z5ymWdPTJw2ciIVLM+tRGKsViQBn6xbMfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtSBahbv54jDI0YU7sgVk9iCPjL6r/tn30X+1DpUCFk3H9WeZF/5fhDNmHNflbuHm6hJ+U10H6ZMRex029tlCPb6Lq+bfOVWXyjCJ84Q3snbTP1XiUx3ptgcIWQN5Tl8+NTEMUPZH64mK35G3vfFJzJVOBzoFd2KCu2cWzRkoAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAbFRaXV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAbFRaXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B651F000E9;
	Tue, 21 Jul 2026 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654105;
	bh=nRK+5zfRhQDBUxLS757xjEQs1fCZA27m1PBRRruCEfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tAbFRaXVTaIWDX6AWTeLMSHntqdcdsemBydz4mIxSccR17qn+epxa/eVx1TnBEpnd
	 LTmceS3dCmdHANmqSXbuvYknog7XLDnAUwDQHyK25SyuzrUzG7RwIHQxtXwIM3Vpqk
	 pDicDOduUNE/eBw5PmSDWN+/HExu3d6I0LJ4AZZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1580/2077] fbdev: broadsheetfb: fix potential memory leak in broadsheetfb_probe()
Date: Tue, 21 Jul 2026 17:20:53 +0200
Message-ID: <20260721152630.044525710@linuxfoundation.org>
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

commit 9d18a4e4234fd3ee0d0eed8ccbbb50cb76b2232c upstream.

The memory allocated for pagerefs in fb_deferred_io_init() is not freed
on the error path. Fix it by calling fb_deferred_io_cleanup().

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/broadsheetfb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/broadsheetfb.c
+++ b/drivers/video/fbdev/broadsheetfb.c
@@ -1072,12 +1072,14 @@ static int broadsheetfb_probe(struct pla
 	info->flags = FBINFO_VIRTFB;
 
 	info->fbdefio = &broadsheetfb_defio;
-	fb_deferred_io_init(info);
+	retval = fb_deferred_io_init(info);
+	if (retval)
+		goto err_vfree;
 
 	retval = fb_alloc_cmap(&info->cmap, 16, 0);
 	if (retval < 0) {
 		dev_err(&dev->dev, "Failed to allocate colormap\n");
-		goto err_vfree;
+		goto err_fbdefio;
 	}
 
 	/* set cmap */
@@ -1121,6 +1123,8 @@ err_free_irq:
 	board->cleanup(par);
 err_cmap:
 	fb_dealloc_cmap(&info->cmap);
+err_fbdefio:
+	fb_deferred_io_cleanup(info);
 err_vfree:
 	vfree(videomemory);
 err_fb_rel:


