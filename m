Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AEE1FA859;
	Thu,  2 Jul 2026 17:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011771; cv=none; b=bhu9P4OOAc2RTlZzNPEAFkrpdVzXtK46sMGTNWMoTQDUvSUU1s1FQSB9YVVGGPR3B1IGLAKDvC5iKnqh/JlB2bHjMmrdIYz94Gy09undroaRrPnmrR+oxuiv9xbcBssrbnjIKpKE8UhIdt2iHZzRwz1Wc2sVff/KE26ne7fwMIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011771; c=relaxed/simple;
	bh=i3Ik+lgydzVTuSqhfBT0cyhfbAq8UOWbjuxzXUeMPyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpNA1Eq/WVI873PKLmabCEgFhdWIwlBCSrYVE8cGBURKeum18dxwroYt2c4Qns298yTkuetoqKlw8Mdd40cUfsdFU/9Gh5lckoBQMyOp2jrv2JyFwwVZTTLbl8HHGuPtgf0AaQLKCMXChj0afpV4qne4NVQ3/jxyIQ6HdMXIddg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQCGxUFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQCGxUFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4209F1F000E9;
	Thu,  2 Jul 2026 17:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011769;
	bh=RegXxqAF2RTpzkzPHmYDNOdYM21WvRJgQZg1UYfL9p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQCGxUFBURZOIrMmL3FQTHM9dfkYdv/VxTRWZmCy8mRqmtUZBD6Qcf4JD0nmQ1vmE
	 OYFQPZkz9TYxnGm/EeUWtcJsL01Pod8jpjlUD3SrQJe7BCQJiRwa9PEgLMYSyM4Q7o
	 TnqRAPrHRyl34i1+Z0x8hV62FkzYws4jbfTw6On8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 102/120] fbdev: modedb: fix a possible UAF in fb_find_mode()
Date: Thu,  2 Jul 2026 18:21:38 +0200
Message-ID: <20260702155115.068715960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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


