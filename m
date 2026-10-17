Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A8A36B93B;
	Sat, 17 Oct 2026 16:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254220; cv=none; b=eYcO7z7FKO2tQK0KM9LR6VM/tg2Az24vhBSXyz6cH9wGHdCLC9VEqH4oFrmGWbSezAax03Y0x5lO7pJIOcVGoEKaw4wQcMbWxJshzz8meuq8Utz53A9KlwpqPY/NLIL8QOyWo7rayU5sYhkNehXvEezPsdfhvtSfeI/PmisIJPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254220; c=relaxed/simple;
	bh=O9bBGB2xdjPruNj2nwlmdhjmbAQIVdmGXaw3euhtjIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pl0CYEOfbdXR0P22BpEBQNYErEoNtsfOIMgc1Jz5ta2qwzeDHAopZYTncM8Ne+qUunxsiqEjBEzFn0UkZbSr7Mzq5c4K9xSuRqkJDqqG7VIF+5VQuccazEcBPD+hi+KvmtfRgz4n0sE5OP2QSuq/NKYgg/0kMwnHC7xfAgMUxLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdrXwn9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdrXwn9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105EC1F000C4;
	Sat, 17 Oct 2026 16:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254219;
	bh=7gdFN4s9KJiLoYwEl2LvLGNOTg5IOopgJob4RR43nNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdrXwn9cI8bxNvDHlH55QWnVaZapq1+Hg8QG0ZnhV7GDTJaKpcDoQQCH0GFySJygS
	 uszOrVG/67WxXdKBioT/+3n4e3dobyYhzX7iuLOYtK7uHYQz6u5/mM9yMy5KrmXaYS
	 SqZBddnM1X7B0w6zYCxJ0PIKgBneQvJD11c4TFJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/869] fbdev: omap2: fix inconsistent lock returns in omapfb_mmap
Date: Sat, 17 Oct 2026 17:52:59 +0200
Message-ID: <20261017160045.747700201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 98cf7df6e0844f7076df1db690c1ede9d69b61ff ]

Fix the warning about inconsistent returns for '&rg->lock' in
omapfb_mmap() function. The warning arises because the error path
uses 'ofbi->region' while the normal path uses 'rg'.

smatch warnings:
drivers/video/fbdev/omap2/omapfb/omapfb-main.c:1126 omapfb_mmap()
warn: inconsistent returns '&rg->lock'.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 7958e67375aa ("fbdev: omap2: fix use-after-free in omapfb_mmap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
index 211f23648686c..79688c2cc6d68 100644
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1121,7 +1121,7 @@ static int omapfb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 	return 0;
 
 error:
-	omapfb_put_mem_region(ofbi->region);
+	omapfb_put_mem_region(rg);
 
 	return r;
 }
-- 
2.53.0



