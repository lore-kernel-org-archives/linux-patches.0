Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590706;
	b=TE34tA+6vGJAj/F0hgKIp7EIXFaX1z+s5TlXJXufqbqcXxypmvLZxa+DyQ7WeGTVvZCw
	 c4R8SmKb9/C/AlDWKdU1oJLP4Pge9yRBPL53lyt5ow3kNK0laNavjROoqQry0ca1hiSJ1
	 cQxIRZNFe1/WdpxngZ+3pKM6mKrsrV/oIMscy2KBQKxKPEWIY40Q54RqGxZeV0cq7MwmG
	 P0rFVajMSleIiGc1Kl6OLw5XZscPFUCpyBgaVVMTKfklJSWH9038iqNW3LVX5XOMyj0LY
	 EPTxmNL0J9oxfEVd6VDNRTu5vW0oQX+o4Ahnkl5QMh0egQP2eWF0LNnoq4yJUOENnZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3RChPlFnEzMnw6iLJ8Sb5vD3XNl0Ow3ruqsD2v77tKo=;
	b=nNreuedRWm7UOV6vEAaUe1Wdr182OngbXI6gkushzX42P8Lb4/oTGvxqFH3XI4UGAYon
	 LNRd/x9cmMcdSJqxbJkQAkSYMhlFkD7iRRkGKdHxIs19GTml+lZVz2EM5oI9blD5Lc61O
	 fkW5tfRKPQxjzH/Qq6iaJcHQfO/GnDLnhZshovWotJlaSr9L4vw+T93AThWbI7GR+HXt0
	 Wazi5c+ZOi0T2tFNm1C6OqCPihrwIcmiQbRAVgA17042l3uoaIVWdzYWxy4AoDpiy9xNY
	 0CqCcrayC5/MVw8Np/Rz/A0Jk6NddWN9lBICi4jhxZG5ve/0PjcM4wEA1woRKOyVM1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tu9ozofh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373A360A5BC5;
	Fri, 13 Nov 2026 17:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tu9ozofh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D141F000C4;
	Fri, 13 Nov 2026 17:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590706;
	bh=3RChPlFnEzMnw6iLJ8Sb5vD3XNl0Ow3ruqsD2v77tKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tu9ozofhw0hxjlf8t7fjg5JyLeRr+GkDyQPRxVjhe1TshYZDDVllmp2lsgRjJZbTF
	 HaV8z8DMc+gDfSWkjv6KkEBwNC+jYdp6SegMRueiNK8dTklTO7hfmC6fW3ulVHQnjP
	 OAxoBQ22nH6swZTQzfOaFVjYKq/i9V43v9khSxK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Yiqi <yaoyiqi3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 616/686] fbcon: Retry rotated font allocation after failure
Date: Fri, 13 Nov 2026 10:52:29 -0500
Message-ID: <20261113153842.753803551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the par->rotated.buf check to use par->fontbuffer in the existing cache condition. ]
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



