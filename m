Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034302;
	b=mKboKvBCFsTPhQynwqCksCT4Mx+ZwN4QOJYiFEB3CD+ziM8G+07Hmd+Nu8gOcziS6KFN
	 9JLzBCRUY77Pv0/ekCGO03iAh5QzBLt+E5OrSxXUiHqUJoUpEjZfG/YxqiDfyk/G+vftj
	 9OsDkO0zl9n40aKx3iO0wdf3o9YScyQ3X0blmI3UBGdogLf/fFjOfjIuVwN0C6LCm79Uh
	 faoGaC0wBFSpQtV4K+mkTHyDibM0R5IWQZgXv4Bg4eVvDr6DxEjYUCgNbG8klAU7Bj0U0
	 dwtW81cUX7sBZ9142dRMoBoqab1fLGoSXkHh9JS45oTpAKram+VYr7UloNoTJz+pwdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pZ8CGzRG2pWLy5/CdH90uYQG+sCD6+vGqnF/0H0CCD4=;
	b=ZERy46t16VBFegPuKEa7+FN0gp9lC16M2jYLOSzyKCFuOODs2eyoBIHHsroys6vG/qfF
	 topZyi0Inm3U5tOoQU5h4R7Z2H4IOGrhiwQ1iNEQ+befXH3qT52XpfMMjUVZAF4L0V67H
	 SDBxTq+rJWXpDwLiI7E0tZu+Kcjh1XEIzEGue82mewl1Qkr093jVqx8cGb0vLTMODZQVs
	 5sJNSmgYiSBR/dUMgy3ueOhMilrGzqW5Dt29sQWe2rHkZlcIEi2x830kV4CT26a1k3mUa
	 GUgtFMVn38/0AAo61J3GDLdOuL5BP4J5Sy1hDdcbRztTVPEdR/Sb3Jnob4okkPtPOTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNS47Xt1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99664606A320;
	Wed, 18 Nov 2026 20:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNS47Xt1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F881F000C4;
	Wed, 18 Nov 2026 20:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034302;
	bh=pZ8CGzRG2pWLy5/CdH90uYQG+sCD6+vGqnF/0H0CCD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNS47Xt14lgFt99NmphXrFPPwJ09UtlF8uCh8kYCuQRKadLaTl66iUvvI6znviMmW
	 qgUIkU1p8852htbN+wfxhVGiEmR8D7FI5InViaogcFWWSP8RXDrueu0hZdVbtOX6ae
	 9jwP6OgJ3JfYCcPRHP7MZj6rkVh64uzC9DlH1kEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0320/3318] fbcon: Fix KASAN slab-out-of-bounds Read in fbcon_prepare_logo
Date: Wed, 18 Nov 2026 15:15:42 +0100
Message-ID: <20261118150325.454448394@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit 94e6a058b16820e02f25e1221a4c4e713ba23550 ]

Ensure the logo will not exceed the screen size, which then should
fix a reported KASAN: slab-out-of-bounds Read in fbcon_prepare_logo.

Reported-by: syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 97642a95faa78..59851d0c50b0a 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -577,6 +577,13 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
 		erase &= ~0x400;
 	logo_height = fb_prepare_logo(info, par->rotate);
 	logo_lines = DIV_ROUND_UP(logo_height, vc->vc_font.height);
+	logo_lines = min(logo_lines, rows);
+	logo_lines = min(logo_lines, new_rows - 1);
+	if (logo_lines <= 0) {
+		logo_lines = 0;
+		logo_shown = FBCON_LOGO_DONTSHOW;
+		return;
+	}
 	q = (unsigned short *) (vc->vc_origin +
 				vc->vc_size_row * rows);
 	step = logo_lines * cols;
-- 
2.53.0



