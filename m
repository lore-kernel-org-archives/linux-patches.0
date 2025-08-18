Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B40C3074AE;
	Mon, 18 Aug 2025 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522311; cv=none; b=G/sNiQlFCEM43ZlhEyupo2F/gLfoIGMEgHUNec4CUmPHPTN+bapZQFblqJN2esMy3zyvxgB8C4KfmW1waPs6vpTQNEiEK8eUeJkJm0Fxg3+pbvpb+Nmv1t1OscY3ZlA/ZUMtlYZNaMXMoI0R4i7If7ZMoSJoxJGJlJ+bIgz9pe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522311; c=relaxed/simple;
	bh=C4pROU8YVTLfVQSfgA09UPmMNH9m3qqw5LCnzk+HssY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay8P8IvuWpxqMwe5jYQuDgpNrxervNQUNClwTZppRqIOQkoDuEZAmuAjHT3WEtMLonDfLw5KhzOdV2RCu7+vEVIVjFeT1YIFfm64SmDzL49fxHB/a9JdT0n0QDPTxLTsP3mL0zPGeWPXP6Jbqy0c+e7Sjj7GsIqsJvKaxDY8MiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wc4Quvht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wc4Quvht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA3BC4CEEB;
	Mon, 18 Aug 2025 13:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522311;
	bh=C4pROU8YVTLfVQSfgA09UPmMNH9m3qqw5LCnzk+HssY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wc4QuvhtQqapvt7W2bRaKOfUGpcFBPhDY5EJBzHzB+zSfGjlTvQm7GJucFdDVlCxG
	 uBzajh8vw70mg56FXajsV9UmLDpQANA6/GZyp5iYSZVom6OVeliEF83E2G3HCySlt6
	 sx4AbEIQiovKnbpyFITCO5PheBb0uPtqpgVtOUVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongzhen Zhang <zhangyongzhen@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/444] fbdev: fix potential buffer overflow in do_register_framebuffer()
Date: Mon, 18 Aug 2025 14:45:04 +0200
Message-ID: <20250818124459.392857528@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



