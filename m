Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A4B340D98;
	Mon, 18 Aug 2025 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525773; cv=none; b=BWTVZVH6qoUx2Fpf+gJ/+JZKCDa4rJtSizupNYrbcPdSADRKsUkIy2COw+zZC1TnJ6pzzcv8K1XsIadafkWWwWoD3nELmS/ksJRnNNopttQNq2YtfTjBxHdFDs5eOILCK3NE1+x+7164wtP3YsbWrpPqP7//37MTY8bBrQK2sBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525773; c=relaxed/simple;
	bh=willZGGSEIhZHdXCISANgxVZMBoGxQxm9C74TSXoYiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/pdifyk8fBfdKi+Mr3joOTGCD7pRVDBb4ItbmUd9ibs/jpJOoWEkTNYGYPPnR/WDrsuz/R1oOPNOF53kjs1ZaDh8wAWGsp76oiCjberwi2+ECxNr0wTd3ySkeN3MQ+PvGNOvAB6kT58fIhjeKV6s1ocV/4ADcYqgAsEVbEKP9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVv1zAtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVv1zAtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4D3C4CEEB;
	Mon, 18 Aug 2025 14:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525772;
	bh=willZGGSEIhZHdXCISANgxVZMBoGxQxm9C74TSXoYiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVv1zAtMQlSCYkSyfwLGbUS8SEy7IO99TQPqwv6Eg+gAzDGK4q/rtk/Ipp/P+bR2k
	 zp19uLJhDoYL19bd8ijmjA9vJ9hPfD10MeOgkHL8xrFK77zxkvgxsPjhE6h8k+hP/4
	 NWDflgqvaIXhKtznIbEjAStAeRIsbOLBb1HpLNX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongzhen Zhang <zhangyongzhen@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 362/570] fbdev: fix potential buffer overflow in do_register_framebuffer()
Date: Mon, 18 Aug 2025 14:45:49 +0200
Message-ID: <20250818124519.810624237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongzhen Zhang <zhangyongzhen@kylinos.cn>

[ Upstream commit 523b84dc7ccea9c4d79126d6ed1cf9033cf83b05 ]

The current implementation may lead to buffer overflow when:
1.  Unregistration creates NULL gaps in registered_fb[]
2.  All array slots become occupied despite num_registered_fb < FB_MAX
3.  The registration loop exceeds array bounds

Add boundary check to prevent registered_fb[FB_MAX] access.

Signed-off-by: Yongzhen Zhang <zhangyongzhen@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbmem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index dfcf5e4d1d4c..53f1719b1ae1 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -449,6 +449,9 @@ static int do_register_framebuffer(struct fb_info *fb_info)
 		if (!registered_fb[i])
 			break;
 
+	if (i >= FB_MAX)
+		return -ENXIO;
+
 	if (!fb_info->modelist.prev || !fb_info->modelist.next)
 		INIT_LIST_HEAD(&fb_info->modelist);
 
-- 
2.39.5



