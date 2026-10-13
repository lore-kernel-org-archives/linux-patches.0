Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B15D4FDA59;
	Tue, 13 Oct 2026 12:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893443; cv=none; b=MNBP1fZAxzu62jLls4NY2F6QA1BwxTRO2cKG4YqcyAkSbXVc+pg00Y60MEwLdJ0mWSaNqyamfKF0yWZOZS8DW8WgLzK/prjP9vAymN6HY9uW0J88rG+/hjLrWBMoens/2E2mtth1c9xalYUkzA/Knl1df0otf1O7vKqc6heCTZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893443; c=relaxed/simple;
	bh=aUt0z/9VWpUgCpeI4rnQLlL6i5DwXY8ilWPD/Sw7KW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFTACn4wOjZY4paWr/OUKAZTm/jAkPhDekPqNO6fczKkKbH8xe0+LF1jWC1iZ506ALlhOCwW9rgnTYkF+1CIhknWecn1viPLt49MwVno/2J9xKtLG7KVEeRqZ3j8ur71Vm32VjiE6FFHxOWxz/Lsx8/iVmz3szwR2E4KDBp2Cew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UB+PWZS/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UB+PWZS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EBA1F000FF;
	Tue, 13 Oct 2026 12:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893441;
	bh=nyUdagB7Nous0AOuzybJeDJ/rlMny1B/Ap6ClX8Ov0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UB+PWZS/z6xBSi8pu1f/LqBZ6VTP6Tn+KA/o++AQPvqhT5oPaq8+vK1wL1ryKrxp1
	 E/AEY7ByTp83i0XO5WWSE5xxPtc5TysTVGMvwgdfRGpkEp78O7DLk7b3aphgyT52aD
	 XEwcGEeMiaM0ufEK+u3J1RfEuikrapyyEyOpqAuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 227/621] fbdev: omap2: fix inconsistent lock returns in omapfb_mmap
Date: Tue, 13 Oct 2026 13:33:42 +0200
Message-ID: <20261013112926.245393578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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



