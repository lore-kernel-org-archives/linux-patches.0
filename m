Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381161C695;
	Thu,  2 Jul 2026 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011400; cv=none; b=foaX5f/xavEejE21l2OLoaOKgeX44WRGTVk54UdHCy7YkfezUBAAb67xvEp/vehsAnTuTxzEs3UQHl021PZZ/52n48HRF3lzU3mgdwwGIJk2EXC9/tfIWfIvm+6bPs/xsDNhkIKvpPIDi94JuiVU2lRIOJfU1iSJ4f255zhLccY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011400; c=relaxed/simple;
	bh=VUT3FeGom1hfMRPPcvGfH9EgtBfblNaO5JVAW9E0Rr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiPgzmFmCL1Yo3jW+LXgkzNuZk6jstuSEYnQ5j7HR1e3X383l8Eypt5RH5Z/uexWeIG6cnE72dlkg49i5TT+4pJGEvEosnrwimixtjmEKiRDhn9HAc+qO0CmpmifDP9AaAeRBNuAUuD5NLXld78yDoaXf0xYtPirHWd5AwoGjjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzLn46FC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzLn46FC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDFB1F000E9;
	Thu,  2 Jul 2026 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011399;
	bh=RM25/WussVk1zgL2ffWj3jC2LXxni2281Bzyoct8YG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzLn46FC+cGniFHJvL9wfZL40TyqbDxGQJgM5KtkH5vhtVSv4k342+7PAFK4xfVib
	 mzQTy+r8f2hKlnbMcGG9xY6f9Fgs+pOXNxqpuOcQ8JCdczwKEE0a29GTYTCgNt9zWD
	 P2aBJTsOanjMV7YssqpirWpU2VhDfHYMyENZB0rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 092/108] fbdev: modedb: fix a possible UAF in fb_find_mode()
Date: Thu,  2 Jul 2026 18:21:29 +0200
Message-ID: <20260702155114.015356197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Tuo Li <islituo@gmail.com>

commit 85b6256469cebdac395e7447147e06b2e151014f upstream.

If mode_option is NULL, it is assigned from mode_option_buf:

  if (!mode_option) {
    fb_get_options(NULL, &mode_option_buf);
    mode_option = mode_option_buf;
  }

Later, name is assigned from mode_option:

  const char *name = mode_option;

However, mode_option_buf is freed before name is no longer used:

  kfree(mode_option_buf);

while name is still accessed by:

  if ((name_matches(db[i], name, namelen) ||

Since name aliases mode_option_buf, this may result in a
use-after-free.

Fix this by extending the lifetime of mode_option_buf until the end of the
function by using scope-based resource management for cleanup.

Signed-off-by: Tuo Li <islituo@gmail.com>
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/modedb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/modedb.c
+++ b/drivers/video/fbdev/core/modedb.c
@@ -626,7 +626,7 @@ int fb_find_mode(struct fb_var_screeninf
 		 const struct fb_videomode *default_mode,
 		 unsigned int default_bpp)
 {
-	char *mode_option_buf = NULL;
+	char *mode_option_buf __free(kfree) = NULL;
 	int i;
 
 	/* Set up defaults */
@@ -724,7 +724,6 @@ int fb_find_mode(struct fb_var_screeninf
 			res_specified = 1;
 		}
 done:
-		kfree(mode_option_buf);
 		if (cvt) {
 			struct fb_videomode cvt_mode;
 			int ret;


