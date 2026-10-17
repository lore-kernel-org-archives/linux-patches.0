Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A27832E151;
	Sat, 17 Oct 2026 17:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257011; cv=none; b=E0pq5YYeXUgfqhnUoxhJ9vjjjYFnhxGk7U5OcfNmF//rCp0VLp/XM69YSC8H8lj/En048o02KeH46vaVIMs16Q4dc+/+ajwGRs7J/LSD9FYIatcHII2d5JBKWKkDwH2wq/7VntFL3xmM3zUQlhnr9w8jnRZXIMKMpvJj0dokPnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257011; c=relaxed/simple;
	bh=A7BkRodpzh0NGER+ATZOvTqJRlsGpYos6pXGpzXUx/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm2iw2dr+G/A8qXkiNa1IxCGyynbO6rhuNGC8HVmrWQa8z91JSoZOcW6/K2IM62fAJEvm+zawBq1LvGUVdKIBCofGO+mM3HqIym4K1kBtW9F6hAJb+XrV41PTLP73Rjlxx36pONiLgRgnFT0yB78R0R00Lw6sXs5aZSV0PnuBXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7tJHEH7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7tJHEH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B151F000C4;
	Sat, 17 Oct 2026 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257010;
	bh=EGWo9qbHyOAisdrcM8SPJfSGcli5t2/2fbZp78Ko6Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7tJHEH7Z5K3EuoLrPDJCFdNlBZzyqoK3J6IzIhunb36n+zt0zEAyl4CYyhqPH5LA
	 R1EGOFPeWeyWdKGJs54GG29vLdUL43Dybxjyo3rUiyr/7PYZrF+H5fbrIWrkP5MH8J
	 aqItHsfETP5g3ZSL6jLG5gHM5Q97AWt8Yqp8m4+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0422/1674] fbdev: hyperv_fb: Allow graceful removal of framebuffer
Date: Sat, 17 Oct 2026 17:44:54 +0200
Message-ID: <20261017160441.961795984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Saurabh Sengar <ssengar@linux.microsoft.com>

[ Upstream commit ea2f45ab0e53b255f72c85ccd99e2b394fc5fceb ]

When a Hyper-V framebuffer device is unbind, hyperv_fb driver tries to
release the framebuffer forcefully. If this framebuffer is in use it
produce the following WARN and hence this framebuffer is never released.

[   44.111220] WARNING: CPU: 35 PID: 1882 at drivers/video/fbdev/core/fb_info.c:70 framebuffer_release+0x2c/0x40
< snip >
[   44.111289] Call Trace:
[   44.111290]  <TASK>
[   44.111291]  ? show_regs+0x6c/0x80
[   44.111295]  ? __warn+0x8d/0x150
[   44.111298]  ? framebuffer_release+0x2c/0x40
[   44.111300]  ? report_bug+0x182/0x1b0
[   44.111303]  ? handle_bug+0x6e/0xb0
[   44.111306]  ? exc_invalid_op+0x18/0x80
[   44.111308]  ? asm_exc_invalid_op+0x1b/0x20
[   44.111311]  ? framebuffer_release+0x2c/0x40
[   44.111313]  ? hvfb_remove+0x86/0xa0 [hyperv_fb]
[   44.111315]  vmbus_remove+0x24/0x40 [hv_vmbus]
[   44.111323]  device_remove+0x40/0x80
[   44.111325]  device_release_driver_internal+0x20b/0x270
[   44.111327]  ? bus_find_device+0xb3/0xf0

Fix this by moving the release of framebuffer and assosiated memory
to fb_ops.fb_destroy function, so that framebuffer framework handles
it gracefully.

While we fix this, also replace manual registrations/unregistration of
framebuffer with devm_register_framebuffer.

[ Backport to 6.6.y: retain explicit unregister_framebuffer(), but call it
  only after delayed work and the VMBus channel are shut down; defer
  hvfb_putmem()/framebuffer_release() to fb_destroy. This preserves the
  upstream teardown order without requiring devm_register_framebuffer(). ]

Fixes: 68a2d20b79b1 ("drivers/video: add Hyper-V Synthetic Video Frame Buffer Driver")

Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/1740845791-19977-3-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <1740845791-19977-3-git-send-email-ssengar@linux.microsoft.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 80e6d96821795..e0d68953aa1ac 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -283,6 +283,8 @@ static uint screen_depth;
 static uint screen_fb_size;
 static uint dio_fb_size; /* FB size for deferred IO */
 
+static void hvfb_putmem(struct fb_info *info);
+
 /* Send message to Hyper-V host */
 static inline int synthvid_send(struct hv_device *hdev,
 				struct synthvid_msg *msg)
@@ -887,6 +889,17 @@ static void hvfb_cfb_imageblit(struct fb_info *p,
 					       image->width, image->height);
 }
 
+/*
+ * fb_ops.fb_destroy is called by the last put_fb_info() call at the end
+ * of unregister_framebuffer() or fb_release(). Do any cleanup related to
+ * framebuffer here.
+ */
+static void hvfb_destroy(struct fb_info *info)
+{
+	hvfb_putmem(info);
+	framebuffer_release(info);
+}
+
 static const struct fb_ops hvfb_ops = {
 	.owner = THIS_MODULE,
 	.fb_check_var = hvfb_check_var,
@@ -897,6 +910,7 @@ static const struct fb_ops hvfb_ops = {
 	.fb_imageblit = hvfb_cfb_imageblit,
 	.fb_blank = hvfb_blank,
 	.fb_mmap = fb_deferred_io_mmap,
+	.fb_destroy = hvfb_destroy,
 };
 
 
@@ -1246,14 +1260,11 @@ static void hvfb_remove(struct hv_device *hdev)
 
 	fb_deferred_io_cleanup(info);
 
-	unregister_framebuffer(info);
 	cancel_delayed_work_sync(&par->dwork);
 
 	vmbus_close(hdev->channel);
 	hv_set_drvdata(hdev, NULL);
-
-	hvfb_putmem(info);
-	framebuffer_release(info);
+	unregister_framebuffer(info);
 }
 
 static int hvfb_suspend(struct hv_device *hdev)
-- 
2.53.0



