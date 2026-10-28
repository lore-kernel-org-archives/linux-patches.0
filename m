Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215159;
	b=gyAtSFtbM/Sydz32cbsbS5NTMik1dAUqsoVNca+mI90dlvxip7tf3SbbgQXP3zS/aXNI
	 nO8TOF8GEjbF86gn77UwY69GRhxJzNti1YlUq9yNS5n8xrhszrJAzLcLCohVa9vlzp/QP
	 8Rx6C1+wwOAshaxZvw9cx4rePzrjVQLJr+O9IU0AlvpNCJGCa1sKsfRZs4DqLfsjFQ0XD
	 Nt19AeVOofxi5Gd36Kgt9FiaOefwpVoKRr3dAso00EGBu2x/94h5kRDVZTb44h+lM0uuH
	 WsbxQBBHfFNVVlPzWVTCLaQYVBuKjCHEbANTuOECE+fhl2QD2xGtXBMKGFCuFVxhK+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KoaUl61JQSx1ya2wHhNW/OmmBzGzQ/KSu9RuQLeVMUQ=;
	b=Cs7kL8Qd/t9B+Tu5vkeMB9HP9p/D93AEHTOeBZ7BNlIoxvbenjs5QKfYt5Krk8KXmCAg
	 nFF2mPKPeQCm20TAY2hgV2GgRuoiBbJKI5y2VblXhOeTTWgsLeSIC+DXUAnfQL/ls5Z5Y
	 qcY8Qsmjt7qklbYVl33jfYYOb52drW/eMfAZ+8/kgDMUqncRg6C7sCR202htYcMnXmoDS
	 Z6dyvMxlw7zBRzYeDFwMOyEG9eCgNoL8YIfWRXDFpEkrxwp3cpIHbvMK1skU/w8qtftGI
	 3Nh9Rwkw6TuQzjx3RQNbv4DOL68ZWJiMWDDCh4OMUqHowqtUWM+LC2FpFzsXbvDdJtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBnubqCg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABD8606A31A;
	Wed, 28 Oct 2026 19:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBnubqCg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7311F01825;
	Wed, 28 Oct 2026 19:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215158;
	bh=KoaUl61JQSx1ya2wHhNW/OmmBzGzQ/KSu9RuQLeVMUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBnubqCgG3vjWrmOmQf1L7HPboRP+erUoYuiuP1wHjgZyA+hibEuPSYSAcJOAlxt9
	 4B64cKKVTrzuKrl0qDiyK+tIT3Rl9HTxvGNkqpLfA2nf7LfyW56IBARcL5328kxbjq
	 L4amB2tW/ISjg6KfGUjqAzi8M9XyJgtB2sc3vMVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1113/1887] fbdev: omap2: fix inconsistent lock returns in omapfb_mmap
Date: Wed, 28 Oct 2026 17:53:29 +0100
Message-ID: <20261028170524.731939555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5ccddcfce7228..dc91d10209da2 100644
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1119,7 +1119,7 @@ static int omapfb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 	return 0;
 
 error:
-	omapfb_put_mem_region(ofbi->region);
+	omapfb_put_mem_region(rg);
 
 	return r;
 }
-- 
2.53.0



