Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD40F24A066;
	Tue, 26 Aug 2025 13:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214540; cv=none; b=C/L7OvJ4ug5+Z79uuv8DR7Tvlv6CqQmAXRH0RPd9xg0V+PXuhslIMCUViMd1c2ir3Aq4gBYHNX+4Vl6NL7UfCcSJAZ5ExeSvb/Qy+XltZ3jNty0icmIm0pfR0Xg/AE8TW/ZGUSHahJDh0t7q8rhUrMj27At5RM55KySttB+luZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214540; c=relaxed/simple;
	bh=7vhrjCTcHCJQ+Jgb59b++lwWRCX7f2e6HmU2MWIjSko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkBjRxAeoU9ZFHCe9lyyUcUWc8aTBJ6tB6T5HrSjXf0Zqx8q5zoznDjDa6s3Mg0GC+TXMVKlXZvBRxbN3t6ly8Bj4LF+pfYWJdJzZlYzeAGVn0t2xbQH81tDKkD1E76LSp1KNNbVvTPr6goG3l/Lah3/TNBrJAAclWRzUO+AUKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKaqT+P0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKaqT+P0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47180C4CEF1;
	Tue, 26 Aug 2025 13:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214540;
	bh=7vhrjCTcHCJQ+Jgb59b++lwWRCX7f2e6HmU2MWIjSko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKaqT+P0Bp2WPyfmqdmaD4CvcphKoNYSQ6HN9POUk3ertiZjqF1UirzIrA2Fovpar
	 vefmdmaZ7B+nW61r4TN49MaPH/9+y61ULTPq32H1UkgANI5igw0ZZea6/KEM0IBWAs
	 nY5A4V0CGYpaAnkIMh6aBDu3/RwZGIqZsnJd4L9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongzhen Zhang <zhangyongzhen@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/482] fbdev: fix potential buffer overflow in do_register_framebuffer()
Date: Tue, 26 Aug 2025 13:07:09 +0200
Message-ID: <20250826110935.157154121@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f8c32c58b5b2..5128ffed6a23 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1549,6 +1549,9 @@ static int do_register_framebuffer(struct fb_info *fb_info)
 		if (!registered_fb[i])
 			break;
 
+	if (i >= FB_MAX)
+		return -ENXIO;
+
 	if (!fb_info->modelist.prev || !fb_info->modelist.next)
 		INIT_LIST_HEAD(&fb_info->modelist);
 
-- 
2.39.5



