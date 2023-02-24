Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBC4AD27;
	Fri, 24 Feb 2023 17:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECF0C433D2;
	Fri, 24 Feb 2023 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677259544;
	bh=1Jc9vNwUR+XMeD7GpSkEAOSGynbA0xd2bpZpKVdTI9Y=;
	h=From:Date:Subject:To:Cc:From;
	b=qEpRUW3Ilrs60YRelMRzQFPfBQ5k6v53s3ZljgkcdP7ijeleRN916L15HSgUJY7HC
	 Xm6uFUg5fatX5FEPhFmCCh7rLp/apjRyghiiw+Dh65FSeeEkROKOlv7til8Q8g3K8X
	 0/aXvXoaqYxk1gIzJ54VMMZ2hgNxdWKWbReQ7c0KH4/sy2JAPKncgBACw9GdRfhQl3
	 38zHJ6SIZn9CYlyqGurK77IZTTYVs5x7cg/3i/xeoIFUku8FfH/BIXByjjPTF66rMZ
	 CDjFY5v6FDMaX1H/mXFJGOogvx+eHrTTGSrHjY88WQZjHLPIYKacccif9gY1Dzygzm
	 djBie254KO8QA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 24 Feb 2023 10:25:12 -0700
Subject: [PATCH] drm: omapdrm: Do not use helper unininitialized in
 omap_fbdev_init()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-omapdrm-wsometimes-uninitialized-v1-1-3fec8906ee3a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPfy+GMC/x2NSQrDMAwAvxJ0rsFRN9qvlBzsWG4EtR0kd6Ehf
 6/T4zAws4CSMClcuwWEXqxccoN+18E4uXwnw6ExoMW9RTyYktwcJJm3lkSVE6l5Zs5c2T34S8H
 YHo/xfLpg9B5axjsl48XlcdpCyWkl2cQsFPnzf9+Gdf0Bz9WWKYsAAAA=
To: tomba@kernel.org, airlied@gmail.com, daniel@ffwll.ch, 
 javierm@redhat.com, tzimmermann@suse.de
Cc: ndesaulniers@google.com, trix@redhat.com, 
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2255; i=nathan@kernel.org;
 h=from:subject:message-id; bh=1Jc9vNwUR+XMeD7GpSkEAOSGynbA0xd2bpZpKVdTI9Y=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDMk/PosrTJlsFrnQpEPC7cOEO8f8ivZavhKWy98hGiB3t
 tJz5svujlIWBjEOBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRo50MfyX8GIxNTdInH3/f
 LaKV1S9d80X+RPpUP3nFPpuOK11s/Az/Myr/up88mLCb4Z8xZ8i/8lnvfrmrC/efXFfA2L9FVD2
 JGQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR):

  ../drivers/gpu/drm/omapdrm/omap_fbdev.c:235:6: error: variable 'helper' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
          if (!fbdev)
              ^~~~~~
  ../drivers/gpu/drm/omapdrm/omap_fbdev.c:259:26: note: uninitialized use occurs here
          drm_fb_helper_unprepare(helper);
                                  ^~~~~~
  ../drivers/gpu/drm/omapdrm/omap_fbdev.c:235:2: note: remove the 'if' if its condition is always false
          if (!fbdev)
          ^~~~~~~~~~~
  ../drivers/gpu/drm/omapdrm/omap_fbdev.c:228:30: note: initialize the variable 'helper' to silence this warning
          struct drm_fb_helper *helper;
                                      ^
                                       = NULL
  1 error generated.

Return early, as there is nothing for the function to do if memory
cannot be allocated. There is no point in adding another label to just
emit the warning at the end of the function in this case, as memory
allocation failures are already logged.

Fixes: 3fb1f62f80a1 ("drm/fb-helper: Remove drm_fb_helper_unprepare() from drm_fb_helper_fini()")
Link: https://github.com/ClangBuiltLinux/linux/issues/1809
Link: https://lore.kernel.org/oe-kbuild-all/202302250058.fYTe9aTP-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
This is currently showing in mainline so I believe this should go to
drm-misc-next-fixes.
---
 drivers/gpu/drm/omapdrm/omap_fbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_fbdev.c b/drivers/gpu/drm/omapdrm/omap_fbdev.c
index 84429728347f..a6c8542087ec 100644
--- a/drivers/gpu/drm/omapdrm/omap_fbdev.c
+++ b/drivers/gpu/drm/omapdrm/omap_fbdev.c
@@ -233,7 +233,7 @@ void omap_fbdev_init(struct drm_device *dev)
 
 	fbdev = kzalloc(sizeof(*fbdev), GFP_KERNEL);
 	if (!fbdev)
-		goto fail;
+		return;
 
 	INIT_WORK(&fbdev->work, pan_worker);
 

---
base-commit: e034b8a18d4badceecb672c58b488bad1e901d95
change-id: 20230224-omapdrm-wsometimes-uninitialized-0125f7692fbb

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

