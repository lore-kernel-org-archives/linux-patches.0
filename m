Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC3C3C9ED9;
	Tue, 21 Jul 2026 18:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658448; cv=none; b=Osyd5RAhYW2s9hEAtK0mWhCMGPyApfOOCzRg6Qh84zod38x3EBbE7G2jJdckbFMtOY/I42Ge2uu4hHpGcBFt9COTANWg+CuU9mX0qrRNkmW8qafWdecWDzdYdN8tS8tDmEJMHCtytkZCC/GILcJIIR0BnfmomP+1SEOUmVWjHrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658448; c=relaxed/simple;
	bh=LFshqUwMLUkOoOWBoZtJbK6m9q9gObc+L3tnPiy2ZwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4CC0UHwfDI+ZNspSdxpJ8Vi1JOjVAifJNEFaP8a7M1qOqL7ROtzSTKkEOpH1n3W07L3slTr1D4JVMLzmgzAUegEGua6G9NKAXQZ5Qrtli7X+BAvcvuBTbnx2Mw8o5qG+H2zLLsfxGeQJyPhM7dgw96KIyKAEmQdoSfWnvyxTe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POsPSWi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POsPSWi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9761F000E9;
	Tue, 21 Jul 2026 18:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658447;
	bh=RMQ3/B3qoG3byYvzC91qN3Y3g+/i6+SAyKVBejM4nS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POsPSWi/GtVi4ifFyHq5Tka2Ay+GPO1SUurAFM1aDui+OYh9TWzZenzvVKe3G9rg9
	 Dv9zM2sN1Bob4U6BSh8cSXLwvGFUjfmadZj+eT+i7+TFonnYKoummq4G4aFFHbzCf4
	 k6c0qZWTu10ylwL05HglWHqp6JlO5IrDWf0GSLE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1146/1611] fbdev: hecubafb: fix potential memory leak in hecubafb_probe()
Date: Tue, 21 Jul 2026 17:21:02 +0200
Message-ID: <20260721152541.195735732@linuxfoundation.org>
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

commit cbef2a305a8a72969b86f96b7c07b86edde61aff upstream.

The memory allocated for pagerefs in fb_deferred_io_init() is not freed
on the error path. Fix it by calling fb_deferred_io_cleanup().

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hecubafb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/hecubafb.c
+++ b/drivers/video/fbdev/hecubafb.c
@@ -192,7 +192,9 @@ static int hecubafb_probe(struct platfor
 	info->flags = FBINFO_VIRTFB;
 
 	info->fbdefio = &hecubafb_defio;
-	fb_deferred_io_init(info);
+	retval = fb_deferred_io_init(info);
+	if (retval)
+		goto err_fbdefio;
 
 	retval = register_framebuffer(info);
 	if (retval < 0)
@@ -209,6 +211,8 @@ static int hecubafb_probe(struct platfor
 
 	return 0;
 err_fbreg:
+	fb_deferred_io_cleanup(info);
+err_fbdefio:
 	framebuffer_release(info);
 err_fballoc:
 	vfree(videomemory);


