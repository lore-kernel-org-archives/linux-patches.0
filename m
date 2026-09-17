Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CEB53C3CC;
	Thu, 17 Sep 2026 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664760; cv=none; b=O/PNX4i7L799hExLhnRiY+4ozqd0EkCax6YrZccbkNdZZxlkaufI4xlbStkoHep//KFBbM26xXXGAf9vbk52Ja26RNwlIQXtZjOPgIYvZDED9UXSCpMF+Vtcpfd44Nxflm86nokeXzme2umQNc2m70E4hPWTO01X0GcIiPDzfJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664760; c=relaxed/simple;
	bh=hNkcGwAVCZ8Ij+6REGLRgoVIKnoqzF2/KgIxmX7iVC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xtun9pO7dwSG/xhsTVuWuKqyx3L7e8WHXCU54i55Wxn2o4AlKRnOVdUK6PfOB8YwjVC83LsBoWwQzg48emvo6GMnbJEPF2KFRkbScL+IN7uiFTD54jaRYOlkN0CLakrR3h7obZUEwrK/H1zVRXIJMEE4FqShdpFPa2vskiCNyQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2Jf5DGG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2Jf5DGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C871F000FF;
	Thu, 17 Sep 2026 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664758;
	bh=Yw5X1hGQzBx2jf3hZ8MlLZwWfdRjr0otvAwA2RqSvbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2Jf5DGGe/SKpHV1GW2GyR7rlkBLk+BU24+H1Nrd2741Y3uiFQpTR6Ux3gxOtayba
	 LKQse/4a1kmxYWrIqEdg5qYgoRlP41k12r2k2ZyvRW1uaFFPEILR/S5dbzv+V3xDtP
	 /qwsLxCoSXQGNpXT8oYR4gC9y9qDf/yC7sN0pfdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0472/1250] fbdev: pm2fb: unwind WC setup on probe failure
Date: Thu, 17 Sep 2026 16:04:27 +0100
Message-ID: <20260917151604.764262824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 16eb19f0c90af03bda6ba66586d7bb0e9cf85b43 ]

Add arch_phys_wc_del() on error path to keep the
write-combining setup balanced when later probe
steps fail.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pm2fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index f34429829b7d7..82408503c2812 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1711,6 +1711,7 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  err_exit_both:
 	kfree(info->pixmap.addr);
  err_exit_pixmap:
+	arch_phys_wc_del(default_par->wc_cookie);
 	iounmap(info->screen_base);
 	release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
  err_exit_mmio:
-- 
2.53.0



