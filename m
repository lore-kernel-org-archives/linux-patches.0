Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C6930DEA3;
	Sat, 12 Sep 2026 14:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222788; cv=none; b=h/13xKJunkUyCAGGRgHq1xFvqxtRK3lOEsmMLZho4IvC4hilp0dO9gzUI+rbw5dWBCGljkOG+o+w0l98k9UbDDUog5CA+x5GlOa+4h5JssVW0JpDXeeEEAfRfZnh5EhOTPBrYyD3+5VsQ4xMialN0XsQwAYKwxZ8NHLJAuWYEP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222788; c=relaxed/simple;
	bh=ryHd85y2EmpbS2usUNLgHNTe1sF+jvxJo28fJdflWHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUFvbPc69VUDzMBL8cP/ixxs3r6Hv2ryD3sELtuIfsHxyj0KeZtZdSSqXVJncLZMY3i2UTQpiFm83WsCx7R/Z6z2AQ17Fbjg5WulrHGwpAMed7rd4EbL8Py2QCylNjLzQFzAHPaRmvcik9KWoYv7pqyyz+KdeRlk9xLgBYcxo58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRCsLxpt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRCsLxpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7213B1F000FF;
	Sat, 12 Sep 2026 14:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222787;
	bh=UiA1Ujrmufek7GJkN/EuEIouyRsHzbAnkpw8B+oloRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRCsLxptk52/oDRfk300ZLCXXcAFrVge5O23GpLKL3Cgjmd176SIwnpuh9dNefkdG
	 lAXx+D6HzoERYM/u7vjyLF3g+hlLthVyVCT6uZgR7grYUSWcX4KMO4I14/hcZ7K/xK
	 x0I/mkZO47xyoZLFF2gr3YNAyFEROMS+SEu8nO5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmet Sezgin Duran <ahmet@sezginduran.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0657/1424] staging: sm750fb: gate dualview dataflow using g_dualview
Date: Sat, 12 Sep 2026 08:51:29 +0200
Message-ID: <20260912065622.005956585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Ahmet Sezgin Duran <ahmet@sezginduran.net>

[ Upstream commit d352778979d2eed09e266ed0f3a5e3ccd3983940 ]

In sm750fb_setup and sm750fb_set_drv functions, the dualview
related code is guarded by `sm750_dev->fb_count > 1` condition.
That value is updated only after each framebuffer is registered,
while both guards are used before any increment.

Current flow:

  lynxfb_pci_probe()
    sm750fb_setup()                 // fb_count is 0
    for each fb:
      sm750fb_framebuffer_alloc()
        lynxfb_set_fbinfo()
          sm750fb_set_drv()         // fb_count is 0 or 1
        register_framebuffer()
        sm750_dev->fb_count++;      // fb_count is incremented

Thus even if `dualview=1` parameter is passed down to the driver,
fb_count is never > 1 at either check, so dualview dataflows are
not selected and crtc->vidmem_size is never halved.

Use `g_dualview` global variable instead of fb_count > 1 to correctly
enable dualview capabilities.

Fixes: a3f92cc94c61 ("staging: sm750fb: replace dual member of sm750_dev with fb_count")
Signed-off-by: Ahmet Sezgin Duran <ahmet@sezginduran.net>
Link: https://patch.msgid.link/20260521204425.82627-1-ahmet@sezginduran.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/sm750fb/sm750.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sm750fb/sm750.c b/drivers/staging/sm750fb/sm750.c
index 7d64ba7a4a054..86781bbd5ce05 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -599,7 +599,7 @@ static int sm750fb_set_drv(struct lynxfb_par *par)
 	crtc = &par->crtc;
 
 	crtc->vidmem_size = sm750_dev->vidmem_size;
-	if (sm750_dev->fb_count > 1)
+	if (g_dualview)
 		crtc->vidmem_size >>= 1;
 
 	/* setup crtc and output member */
@@ -927,7 +927,7 @@ static void sm750fb_setup(struct sm750_dev *sm750_dev, char *src)
 
 NO_PARAM:
 	if (sm750_dev->revid != SM750LE_REVISION_ID) {
-		if (sm750_dev->fb_count > 1) {
+		if (g_dualview) {
 			if (swap)
 				sm750_dev->dataflow = sm750_dual_swap;
 			else
-- 
2.53.0



