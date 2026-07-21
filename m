Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC5145A282;
	Tue, 21 Jul 2026 22:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672289; cv=none; b=KE40fgMl8t81wPluS8Pr+8gkGfdiYu7mGtmnls/weeiyeLpnfzIA5IjgEDTd2Xv5gLScb3t0aUG1fKh6vtMgIG1AU50ZfRGVUxjLzhBh8z6tW+dmuziSlHCJc97CdRVZQR4xtWW/F7oXA1OLwv6q8k0GI200L8BXaEO8JOJ1qRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672289; c=relaxed/simple;
	bh=VNWsLA5xvj09xHw9zrx6RKWKj4Y4jVPSXzBlC0u3K8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQJLG0oa2R17qxe0xKTIBgloVu7SeTFf+N2eb79U+sz9cWIYxPo5oMuyRUhqAOQ8XhMa0VLmbcVPOIYthNOboG8IylW6xxmQa3FZLaFnsYM+rAOrxGZm9OlTuWG3mXCb0Tak1HLyfAYTIwZfP2v6RMX5HDzu1chbZMlG8Jzo5eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgbsbWzL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgbsbWzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48BA1F000E9;
	Tue, 21 Jul 2026 22:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672285;
	bh=F3nAM8vdg72/HYPTg+GWf3yacqJdrHvvOESP8lDJsOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgbsbWzLVoJ+nXOiMzpd1oM69G9o+xIN/LWgXo5u2L05SZyg0kXTt8DL66lmBaiRL
	 D5uMZ2ftpQhbEXC8/nlT84+CYCiXZU0FVLlW1edsv9A3fMiDOHbsCbqAEp0KiCJEFC
	 cH9o3GPsQaGSO4TtXPn+cJQhoxNN9YRu+7nKV+Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 567/843] fbdev: uvesafb: fix potential memory leak in uvesafb_probe()
Date: Tue, 21 Jul 2026 17:23:22 +0200
Message-ID: <20260721152418.802372910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 033e56fed09047ee63072e9f58789f40c1c7079d upstream.

Due to an incorrect goto label, memory allocated for modedb and modelist
in uvesafb_vbe_init() is not freed in some error paths. Fix this by
updating the goto label.

Fixes: 8bdb3a2d7df4 ("uvesafb: the driver core")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/uvesafb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1700,14 +1700,14 @@ static int uvesafb_probe(struct platform
 	i = uvesafb_vbe_init_mode(info);
 	if (i < 0) {
 		err = -EINVAL;
-		goto out;
+		goto out_mode;
 	} else {
 		mode = &par->vbe_modes[i];
 	}
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
 		err = -ENXIO;
-		goto out;
+		goto out_mode;
 	}
 
 	uvesafb_init_info(info, mode);


