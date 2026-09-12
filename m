Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3171233F59A;
	Sat, 12 Sep 2026 12:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215155; cv=none; b=JvF4xWEl6S+rtHgqjyNBClkhQ1rIN5UAr4U+Z4OXCvL6rXW0iSfx3kSJPuuxYJBgEfoO5C9AGLyHTIuSZ9w77zdf5S9Gig5zI3dqU0bJN12Acqu+n4OTMKOYNR1a3Hi6Gb+kDZoDXMSZZ/rEoTqMm9yvGjAhqRimwD4YMvCz8yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215155; c=relaxed/simple;
	bh=JBFOrCb/JT9ScjJk8T0fhh9eYJP42ty7jP2+L1tk2gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shBzsjoj8CUKVC3bT6+H8cKSI4pYjp/TbKw91NxJBl9yvFslQQN+bXrbobYyQcBT9RCVVGL+N3K3z9A9c07YcrplvLYtlgaGt5L4YBsrPh5Avmj09nDv658WfmnsA1RJp6WAFRra1Di+Jbo5/0fq9urpMnnv0suCvntrns1ku/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvkKtdzH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvkKtdzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377461F000FF;
	Sat, 12 Sep 2026 12:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215154;
	bh=zwqNneSCRFk5hd6Ih0Ya+Tz1BmwtZvxp8VPin0dwTA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvkKtdzHss3RMB5X60+oIiw1e26BqKHQ48Te0X47AV7MlPvC52dVDGuFea1zuAarZ
	 qAicHucsqf0eLSlVCCeCTHI+1oKUwJSc3NjiTXK060Uf/yKfZTLJ8FkuJ/Y3YdIwmd
	 CjiSsv6XO1fiVPl/cXXc8MVfN4otgrjejjzwiQUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmet Sezgin Duran <ahmet@sezginduran.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0421/1376] staging: sm750fb: gate dualview dataflow using g_dualview
Date: Sat, 12 Sep 2026 08:47:27 +0200
Message-ID: <20260912065616.919793008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 94a83ec342827..1452edab96cc9 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -599,7 +599,7 @@ static int sm750fb_set_drv(struct lynxfb_par *par)
 	crtc = &par->crtc;
 
 	crtc->vidmem_size = sm750_dev->vidmem_size;
-	if (sm750_dev->fb_count > 1)
+	if (g_dualview)
 		crtc->vidmem_size >>= 1;
 
 	/* setup crtc and output member */
@@ -966,7 +966,7 @@ static void sm750fb_setup(struct sm750_dev *sm750_dev, char *src)
 
 NO_PARAM:
 	if (sm750_dev->revid != SM750LE_REVISION_ID) {
-		if (sm750_dev->fb_count > 1) {
+		if (g_dualview) {
 			if (swap)
 				sm750_dev->dataflow = sm750_dual_swap;
 			else
-- 
2.53.0



