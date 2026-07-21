Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A259F3191BD;
	Tue, 21 Jul 2026 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654127; cv=none; b=UaXOkUnjhqDnaJGDeoWsI7Xq4xh3vCTf0pUfXkxV8jvI4DFiORHpzaLcp63a5uYHSb1HQic6daG/cWp6GMerA88BXZv/q3cvQLY/rx9SvQrVQWlo9uWnrgR9y2/hzAO6oOxKX75sb6Nx3k4DK1sJiZeiQoxAhYYRzKCdUxsRrww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654127; c=relaxed/simple;
	bh=Jjb1SOnyE/t9t9jDLHuvOhfjQWdUO8ijJH+Z1K5Gjzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jukFcW10o+fZ42W2woRn6f8taVvzgyyxwgXenRwSzIicwZzov0JpCh1K/EhH00sh8/V8Shr+p4OCGGjh4XwKzwUxWnFm1nQme3HUolKvXZbdlrS/ATENz+bIRO5jnZ2wji9IdonMizzMOSO1Kh16T6YrsTxqWF4tQj/NFZZcIgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYM1ml2i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYM1ml2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DF31F000E9;
	Tue, 21 Jul 2026 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654126;
	bh=KDLbKiXuLLribkTA+cmRnhlJQAxFwcil5xYg2BZqoeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYM1ml2i0e6oS75psIg/ntl7B+ixczAosl32wrxOrJU1iqUgxkqek+zwR8H03qokn
	 XFnJyW0k8QDTO4tQxEibmGkfrZKRoGtP1r7ylOFxlgU9Cz/6vzYqtmBA+Wuwl5u+NS
	 FgrMwnFsVgLz8mmlvCmJLIKS1ipuDV+D5w/+0ztE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1587/2077] fbdev: uvesafb: fix potential memory leak in uvesafb_probe()
Date: Tue, 21 Jul 2026 17:21:00 +0200
Message-ID: <20260721152630.204635581@linuxfoundation.org>
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
@@ -1694,14 +1694,14 @@ static int uvesafb_probe(struct platform
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


