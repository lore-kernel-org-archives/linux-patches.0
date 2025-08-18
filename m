Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A829335BC3;
	Mon, 18 Aug 2025 13:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523987; cv=none; b=Z4eMRaAhgVRPHM2U5fkhpxW98wpbwL0qCeePG/WzVTu6mKPnytJju9qHXFoXhS55YDEpk3huP9Ibj3xil2pyevCGtLqQcbR3B1QGl3e8bfkQXGQBvAn32OQSKzyfBUgzNEc1rakWyU07MiZfyWOehL8Me14VP4g6u8Y9X9aN5Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523987; c=relaxed/simple;
	bh=Yw9CGBWZlyS3lhZnBfKtAkfsAsdz8fWn+U6vn9Nz16M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crvOpHuKt/wz/ImSVf40RBGrOvF8TS6oG+rH/ZS3qkHXSwv/4pKME1x5fZ4PtIpSIUi09R+y0/CwbPke1cf+cNdru6rWzvL/dV+JuUNiSJJ+EdEadBX/Mycp9adEC6No2PAocbJ4Io9yyeW67kMEQOqBiAFsA7CnAMrNdnW9JF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOsePwfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOsePwfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2154EC4CEEB;
	Mon, 18 Aug 2025 13:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523986;
	bh=Yw9CGBWZlyS3lhZnBfKtAkfsAsdz8fWn+U6vn9Nz16M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOsePwfwEsE/Gea5I/HTBAruPTbRTopHH/bVexE+UG1oWF9AZ4gc+EX295Jpn0Pc1
	 gMilbwjmYzNHcj74tavyaUyRPXbn95jQrudBnv0soZ+LDAD0JiJwT48/nYhoG8nOjn
	 Togc+tdH9WgclblM9MoP/w2o9SvHbwuK1h9YK5yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongzhen Zhang <zhangyongzhen@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 334/515] fbdev: fix potential buffer overflow in do_register_framebuffer()
Date: Mon, 18 Aug 2025 14:45:20 +0200
Message-ID: <20250818124511.285232758@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index eca2498f2436..6a033bf17ab6 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -403,6 +403,9 @@ static int do_register_framebuffer(struct fb_info *fb_info)
 		if (!registered_fb[i])
 			break;
 
+	if (i >= FB_MAX)
+		return -ENXIO;
+
 	if (!fb_info->modelist.prev || !fb_info->modelist.next)
 		INIT_LIST_HEAD(&fb_info->modelist);
 
-- 
2.39.5



