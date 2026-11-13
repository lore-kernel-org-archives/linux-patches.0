Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591529;
	b=KLB6Yp50YXQTaYcnDT2H00p6ModSz6VnDbaLysttkecaFbqXB5qW5N2VGTdCCfZkyP7A
	 tZjWoaeHL3g71577274OUpHuUSYcUyrpK6Pol/gZlxPwFCeQRSvAR6KGTh3ekSPWljCyf
	 +NcEzUMCImMb+TIVTj6CQuYFgMz56H2SlENYsug6jKg4alR9483aT26FaQCFVx6rGEP/V
	 czdTqOvOsj7EoMlbg08YjjH0N4gsADbrNxPG5Wy3+PDZtDBtrgin8vppWJZMZM27DXdPA
	 mPvjVoQb29z9aaHBwlr+SNYfM8CPuxpx1icZeE+XQSW4BinH6NISr5BoiZ0Gjvn4IXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WdyIJJiQWj1CwAsVsBPEvIQ1ykIHlWGTEQ9bKVK/cvg=;
	b=com33G1k/p+uN2Ro9zP0/1o+yRT9uFzi/xEQYvHjYcfYvjW5oWqRq5Qm3M4m7d/htVmO
	 FkIqiRN9ap5e2Qlx6Zd0hKWOHIZNmSQAKfLYbnjSaZuEBkrBuu+NAwdelBvn+L0rgcWUF
	 7oWpmWhYf+cEmd7AjJjzuJ5uufCin8sZiyO8o4MdNYOIR/YoCffi3Ng4myFyq0EJPIQq9
	 szaON5BB9k8xLNGCfIHisqSo9cFdmQIZa1vwwKPAV8Qw3AU3+OU8JPWeXralpOXJ6LOvK
	 6Mavipy6jaet69byfIcNnx1g9G/GLzTGrlttyVCVN9hirLMx4Vyq8hzpz44dIXk3nxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZH49ffwN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3396A606D857;
	Fri, 13 Nov 2026 17:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZH49ffwN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43351F000C6;
	Fri, 13 Nov 2026 17:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591529;
	bh=WdyIJJiQWj1CwAsVsBPEvIQ1ykIHlWGTEQ9bKVK/cvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZH49ffwNcOnHaNpvWMGDgiGKnaZ+obu9J+sQ+uDzXDH0PDYPPWYvv7/A+WNEiFIAd
	 Lmh9CK2QBN+PMdmPkFttImPV2nvLKDfpg1Vl/VjwIS4fLp5MBjfEXXzLOnvTUD/jQK
	 XERGEL0lAPPpedwSYdJGKrKsa4t4gzmqhB1ogRJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Yiqi <yaoyiqi3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 586/670] fbcon: Retry rotated font allocation after failure
Date: Fri, 13 Nov 2026 10:52:30 -0500
Message-ID: <20261113153831.696297380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: used par->fontbuffer instead of par->rotated.buf in the existing font cache check ]
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



