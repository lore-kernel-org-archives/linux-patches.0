Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EB0387588;
	Tue, 21 Jul 2026 20:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667055; cv=none; b=B5sJTWaSXPRoKhXxyRPSQFnDMK7MfSjX20C6LoaPtf/a0tKvIlEVwbbLDX9i5x6PmDoOWRQ94Xlou6tPmNcSk96P+RrgQlwsiZPp+XmMyqYtYDToiWBWK5zb/+9qAf4lAK7RRetLkoKYJbHrCfalk/c/vTd0OnfsEzmvK/12iUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667055; c=relaxed/simple;
	bh=PGGsuZfeRHlfizAG9g0MU+K+Z6KMraYUjYRAiSzD5DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abt4pSqm/KG/UEFJSE5S0/nujW2gsiECE9wwWXkY2yqr5Dq0tHcLJNVw2nPUYZlpEkekDwpF8huR9KqbPndZyEUqAbTYzV8UweCqjlQH8OBS0eKtKp/9L1takuhk4hTVE/Mx1ok1qR7sxR+ub4OaYCyQUDbz+pG7n2KYsDM3Oow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBw3KOv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBw3KOv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FBF1F000E9;
	Tue, 21 Jul 2026 20:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667054;
	bh=bWayG/by6EvkrmpWXBmTJs7F0pjtIpuyYzOpkjT4v0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBw3KOv5umEIykbjwJaAUmQG/D2jcrAkUz2CdwCi9Kv3+Nbb1qpLeLGBe2a86dZ03
	 7iD3rfdUQip3CI8FT2PETlxH8vcsQjEGRBAeItM5nbGLbAhrql0JJQUyGEtk0aWieB
	 YzXA8+jzQE7GtYbrJ4l1j6kxGt2mvTXJ7ovIHqKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0914/1266] fbdev: carminefb: fix potential memory leak in alloc_carmine_fb()
Date: Tue, 21 Jul 2026 17:22:31 +0200
Message-ID: <20260721152502.297515234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


