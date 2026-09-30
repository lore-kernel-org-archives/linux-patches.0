Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D536F51FCB2;
	Wed, 30 Sep 2026 18:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791213; cv=none; b=U8Esksi6yPAfJe+mcNLFhJPO3miHBxypBIPHz5NO5+Z1urSSr4vkl10DuFsRy8nuoQKVW5YfU6oJJQN++aZMPsgjOPQj4IV74f97gHORygauzIeJ7lixGSIeFDwK5shOFXkDo6pUhPVQym6sZ7znmDJPVizD/70WmOZjl2F4C+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791213; c=relaxed/simple;
	bh=Nifxr5nBiuengXe8HzxeHDC3iQonp2nY2kZmkTTzMsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+xbMkv2R8Wa5PzWrWZkGZZCWCgb61bpRgC8FCE8piQzN2cCJF/q6vDx2bq4J0nJXN3xpRB6agstFZgXQ06IvvjNvbdVl8/MIDVLY7AWrhRgURObtB+O4toBpAVApX1EG9D3vfm3rwR8OTbs94Vs9XAw/TVERY21Ap1uXOeD5NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=af0JgI5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="af0JgI5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319A81F000FF;
	Wed, 30 Sep 2026 18:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791212;
	bh=uhSHO3stdGnIMSZintNOr5hSL0STATysmzOOy18015Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=af0JgI5TFcQite9Beiy3JBjLkjr8lwmK98oBfPuBKwelTuWdaq6rcmtqC5+aBfFS3
	 N9t22QxtC09n/ZumZZfv8LFHUpeWTOlNPGQ4X+r4+CCPkeLY+WkOyhNsWtdhhQNobc
	 j/UCznm4JfQU7mStRQ+r/gRg/AoTCZpy1szFDwYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/752] fbdev: pm2fb: unwind WC setup on probe failure
Date: Wed, 30 Sep 2026 17:20:48 +0200
Message-ID: <20260930152402.056435554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index e8690f7aea050..572669b3ae3fd 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1707,6 +1707,7 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  err_exit_both:
 	kfree(info->pixmap.addr);
  err_exit_pixmap:
+	arch_phys_wc_del(default_par->wc_cookie);
 	iounmap(info->screen_base);
 	release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
  err_exit_mmio:
-- 
2.53.0



