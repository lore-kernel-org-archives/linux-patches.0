Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56251433BAC;
	Tue, 21 Jul 2026 19:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663505; cv=none; b=NYXjajBWf+nh2sCllsnVPAyNXFYM56HlHaaN6GA9bTeb/6+eNHwoNjgwPVO4FR9dP1mZGKJos1vfuqk1RpRunNPJztEfpG+4zcvHBQMaXiH5HvSrFLlXh1mu7KB/S2rhZw6XR5ud5PVwRVb/zPEwdaC0MPnnljYtmISGCwB1NEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663505; c=relaxed/simple;
	bh=B6QFViCJ2IbU1gdM+6HOHujDRFojfeM/BC0+H1c5oTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NN6rTgwQ7qo8fJ5AxaZvcqQC1fvWnFgF4iKShjIEP/f5N4CQuckm+/jQnclNGljsaQpVdE15lwOB2EGv9aneabMCtseT5zySYMwRPgfSbHNQ28JBy6OKlb2QBshTgc3eQbnlXCIYWq8wXJHKLm6mM91dKzNs6hBVkhhOy9C/Jjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGq8sg+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGq8sg+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD361F000E9;
	Tue, 21 Jul 2026 19:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663504;
	bh=E3Kflj0GqTA8KeGse3MWkk9AKM1vg+t/ubrO+xKChRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGq8sg+x1v1Ha9lzmP3PEkQWxha9hRX6YD+axpbL/QnB6wmiv2gIKL5hO6rhUhNht
	 ZNeXMh2qSR+3VCAUZvm4a6bC07PdSOhPBPYPJo4bKpP+aZq6vBToWBXBqTA4NAi2Tu
	 HqgLZj87HFjJO1FPpXFE+w8hUVtHbH6Y70Kju/tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0848/1276] fbdev: carminefb: fix potential memory leak in alloc_carmine_fb()
Date: Tue, 21 Jul 2026 17:21:31 +0200
Message-ID: <20260721152505.029851689@linuxfoundation.org>
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

commit 6fcca16a2b19c37f60693c56cbc0c923364ff3ef upstream.

The memory allocated for modelist in fb_videomode_to_modelist() is not
freed in the subsequent error path.
Fix that by calling fb_destroy_modelist()

Fixes: 2ece5f43b041 ("fbdev: add the carmine FB driver")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/carminefb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/carminefb.c
+++ b/drivers/video/fbdev/carminefb.c
@@ -589,6 +589,7 @@ static int alloc_carmine_fb(void __iomem
 	return 0;
 
 err_dealloc_cmap:
+	fb_destroy_modelist(&info->modelist);
 	fb_dealloc_cmap(&info->cmap);
 err_free_fb:
 	framebuffer_release(info);


