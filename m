Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBAB470111;
	Tue, 21 Jul 2026 19:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663489; cv=none; b=dEegeXsNb63O+UKxJlWkhyF3po1uddG/Nxp8ci6K/4odSkw/1AMpmJNNcvM+RpOpgCqKVgbQXU13MfLYExXsyCRzz38NtDdve5lej9F9Dcy/ngxr3SaJ7rSdVOlyVFkPVO7cyAje/FU7OKgy/UGIgpIJi3pBj3ixp12zMIPTcAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663489; c=relaxed/simple;
	bh=6dX08Kg3oFKU97IeX27zcd+jw0QIPc8nKWi5NcA/VI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQgHvENahtrEuFgj/nxKkOhoTKx3fgxSjsf3a9WQtEG//zwPSoyMeOCJuKZaFU5gVWOpGFNu85wjDBg6PL112X/773gQH7Z/L7Aft+j46cZeiFHKGWEYJBIGfRrTH96KKufOPLRT0rClxVLGoGTAUiawXxVojt7ueqFWQawF9ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWylySdj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWylySdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9BE1F000E9;
	Tue, 21 Jul 2026 19:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663488;
	bh=zS+Tj0dBbARYDxmBBHbaM+yppSQAAX6xdThHPTAGaiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWylySdjXk2BYx9sFqthSbwppBziyiAFc4aWKKNInlnEPwcsbe/SMolo5vUwgBl3G
	 e7xdV9MhlB1UzmIxjtd2GjdRwFJfBwk9bvvYyT3fmIUSr32lWvC6B6E/Tlqnf2CzUF
	 cE+yF9dUuEZu1kNEP17wjiLJ4uDoRTg66kf2e4DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0843/1276] fbdev: radeon: fix potential memory leak in radeonfb_pci_register()
Date: Tue, 21 Jul 2026 17:21:26 +0200
Message-ID: <20260721152504.920332953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit df8c1101c9a08859da612b5d0a08d55d475522c6 upstream.

The function radeonfb_pci_register() allocates memory for modelist
(by calling radeon_check_modes() which calls fb_add_videomode()).
The memory is appended to info->modelist, but is not freed in subsequent
error paths. Fix this by calling fb_destroy_modelist().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/aty/radeon_base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/aty/radeon_base.c
+++ b/drivers/video/fbdev/aty/radeon_base.c
@@ -2476,6 +2476,7 @@ static int radeonfb_pci_register(struct
 	return 0;
 err_unmap_fb:
 	iounmap(rinfo->fb_base);
+	fb_destroy_modelist(&info->modelist);
 err_unmap_rom:
 	kfree(rinfo->mon1_EDID);
 	kfree(rinfo->mon2_EDID);


