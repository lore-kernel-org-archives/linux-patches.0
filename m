Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0E222A4EE;
	Tue, 26 Aug 2025 13:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213212; cv=none; b=SfO2DuXRB5eMdvhuBB6kDFVtR39LIHGUEBQZVh1dO1IhPKLNOPnSbWNTQx38cbVQDDBiPS03CmDBX6rdVej0/mJai6HPE2J1hzFSf4YevTMHPWB6QLM9JmfCtLUOKUNRmTyGIoXYBS93cHbbHkjWK46fit9UFYgsYlJzcxE+s0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213212; c=relaxed/simple;
	bh=lMGBQNwLdG3+T1N2Wn6QJ7yXauxDufGTSx0KTB7PXPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEd/EvjFVpv4x5jGqjkkRz9XDaIKEqwiSDue0TYTwg1Q6PszFgcRb7WwG3Ehin4y8BVAhS6tgDHyZS+X+mY2rqvZBVZp1+ugoHyXa50naWFVx+WH6E8wWYh8HU5UZVDuX3LsJmYCdL/es0NMumbNbVisZGVb7alsn35PIRPKnkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00rXSDZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00rXSDZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702FBC4CEF4;
	Tue, 26 Aug 2025 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213211;
	bh=lMGBQNwLdG3+T1N2Wn6QJ7yXauxDufGTSx0KTB7PXPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00rXSDZsFf4BVT4BiB6LXHDCzPhSYHCJHG5hD00inLA2rSQ1fdpuMWCyn5cFASwGG
	 HoC3zBf6//oD16FD+93GueXeb2/ju9cw/SCreMdulIZV3Tm0ihlUCfN00vGfU2ux87
	 EddKBjOmwh+ALazhbEFHCBQZFhHnyQPLmDyUYGqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongzhen Zhang <zhangyongzhen@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/587] fbdev: fix potential buffer overflow in do_register_framebuffer()
Date: Tue, 26 Aug 2025 13:06:10 +0200
Message-ID: <20250826110958.560164512@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 52bd3af54369..942b942f6bf9 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -943,6 +943,9 @@ static int do_register_framebuffer(struct fb_info *fb_info)
 		if (!registered_fb[i])
 			break;
 
+	if (i >= FB_MAX)
+		return -ENXIO;
+
 	if (!fb_info->modelist.prev || !fb_info->modelist.next)
 		INIT_LIST_HEAD(&fb_info->modelist);
 
-- 
2.39.5



