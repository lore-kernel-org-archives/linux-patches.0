Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038486;
	b=r7iA5apb2EIgRjkHhOrlH3b0cXw6LZQTRZia4kZ71dzxZaBjAvLVSVbuoDajQd6XpOIg
	 kWmxBXEUdAWAq/TzIny//oCVuMHirrHEWZ4srSsR2jo1uK9hAw/KqhF2WAxkhAjNGZ6Og
	 7JaJBcPwECZq3eWA0BDvCF7IyN0xCHgEyIUOWphm5mkSgl6R+M36O4w/DZ5GK7ZMQdrbY
	 XE+B01yBz9rK3yN+4YrR0sGz5JZGO3e4vMF0/PErijhFPUGJrDrn1kfLvfGBlmuKihU08
	 VX/kZxwyw4yKKzTzg5+XbaPUTSB+9ixi2lfRbVTFlvupmqPeukfn+N5wIxl3aHu3BIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nf4BCQBdg1rJsC5sdAn4hW8m9FeucQOverKufUXnbnQ=;
	b=DUGKjXrGWGNQSlAVBF6kC1iN88ZilnDx8FanEfK9o9W5RVfjEDBOvUsl9+dhjr+OaY6P
	 RLkmG/6Qw8y9bb+S/pg4IyrMvmiVl0yBmXVeorUJSkgP1KLtug/teoEoRAg030Kwy1IKH
	 Blv+lvTj4+9k6mVzgDrBVfGoA3P+7TYYOWW9MVss21yjCA65JHUSlDXofxdB1MhRPDc0V
	 X31yu4PxRcIpJsVhRZfm7uxdGtCmRJRFJVTcwXfXhal1RzsVWXDofBK+v/1XXljGhNtYM
	 KcjLbC+OeNhEwyNFMAJQNBgDZntm1wV3uPxhMLui4fFFASynlLq1Ic8utaqleHYIoYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dA1IPB7s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD8A606A31C;
	Wed, 18 Nov 2026 21:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dA1IPB7s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F0B1F000C4;
	Wed, 18 Nov 2026 21:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038486;
	bh=nf4BCQBdg1rJsC5sdAn4hW8m9FeucQOverKufUXnbnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dA1IPB7sPFENG21CtOP4BOIHRhlf7vtlAClYUUGbI6XA+6WAWQ8yCmGAtWYdA0SEs
	 kjnyYygNgLMh0ge0GpRu82RvLiVu0XnYaMWaopzWTHQxL802+LUmmNsBaZbLm+HISM
	 caLB5qmCvQFu6YMwREGwOh3TMw+eFyp3j8hJSMCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Yiqi <yaoyiqi3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1760/3318] fbcon: Retry rotated font allocation after failure
Date: Wed, 18 Nov 2026 15:39:42 +0100
Message-ID: <20261118150414.653787544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Yiqi <yaoyiqi3@huawei.com>

[ Upstream commit 7935db1a4a0f83a63590a222500e5016e2f6c85e ]

fbcon_rotate_font() records the font, its geometry and the rotation in
par->rotated before calling font_data_rotate(). If the allocation
fails, the error path clears par->rotated.buf, but the recorded key
already looks up to date, so the next call takes the early-out and
never retries. The rotated putcs/cursor ops keep returning early on
the NULL buffer, and the console stays blank even after memory is
available again.

Also test par->rotated.buf in the early-out, so a failed allocation
is retried on the next call: at the next fbcon_switch(),
fbcon_modechanged() or font change.

Fixes: e4ef723d8975 ("fbcon: Avoid OOB font access if console rotation fails")
Cc: stable@vger.kernel.org
Signed-off-by: Yao Yiqi <yaoyiqi3@huawei.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
[ sashal: adapted the buffer check to use par->fontbuffer in the existing font cache condition ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon_rotate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon_rotate.c b/drivers/video/fbdev/core/fbcon_rotate.c
index a3f507825eed8..3105682075c87 100644
--- a/drivers/video/fbdev/core/fbcon_rotate.c
+++ b/drivers/video/fbdev/core/fbcon_rotate.c
@@ -27,7 +27,8 @@ static int fbcon_rotate_font(struct fb_info *info, struct vc_data *vc)
 	u8 *dst;
 
 	if (vc->vc_font.data == par->fontdata &&
-	    par->p->con_rotate == par->cur_rotate)
+	    par->p->con_rotate == par->cur_rotate &&
+	    par->fontbuffer)
 		goto finished;
 
 	src = par->fontdata = vc->vc_font.data;
-- 
2.53.0



