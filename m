Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831015;
	b=AiBDcinlGANPgkpV7ocl9wQsC6ahdVv8xyrywcRLdu3xtMojLU9k1kZHnMt2Az0qxuGg
	 wh1O7yyelPbcpwBUUCpyV86Ne4RRYP6j6HGCGZaHse6hu0b48Cp+M8bYEJiMVTYOE1KXP
	 sd3eKNQpV2jx1HiXOgPOjxHv7B0NMb9W7LhhpQEC73aTCcVVmJLX911SxXMEjskRd6O/Q
	 j7IEp+U4Ht5Hztj3I5Xt/54qetDXm/t3/FBjcFQg8qJP+pW2PVR1FaXrtxHBCbE23wye0
	 spZM1krMAiIa8VsU/IbTVQQVfWYn4V5H+bcSo/+PDkzSEVrFUkRTRnwUtXKnjh01VjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=stmRyUunT3K0FSL09sh0Jh5SA2K869AEY2BmGJW2LgA=;
	b=HWBs78ZtHiKcNiwRzHjWpDkzW/qM+yVDdVzeccHS61lvMxlQNNExr73jqNOrY4JW5BL0
	 cqDto5G9onALkutVUpUUYe7rpCdWzVDP7SIrN12P85KtUFQxiOyERtgfDVyHiF1xczmVb
	 GDOXeCGx1jihwlN6cXHL8CgBfNylaXOYSUn4qZXdZUxG/HbMk1KMmv5S94v2HRhNL2OvS
	 Z+pZwW/Pi2cKCEOlZsDdon2d86XLOTPwDnPYIPHJAhkcOfjHJfIMv9MKHe5UEr9ppAwiO
	 Q/06yXmdEQannHkslOrQTz1yuK/VTVqQaXZwPUnlOaZO6vsmD4eqGA0R9wHZBPA/J3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TplYjT/E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91B46070327;
	Wed,  4 Nov 2026 22:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TplYjT/E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B9F1F000C1;
	Wed,  4 Nov 2026 22:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831014;
	bh=stmRyUunT3K0FSL09sh0Jh5SA2K869AEY2BmGJW2LgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TplYjT/E1obNKd2A4R5HUpItAK38dOH8SF6FaaZpfq+loAaLEkJo0zSFcdrVz8Bot
	 pdOSH7MSzpxsQsKHkP22RRec1N+0/6UrQhMfko4eeF+ksaFdJZWeeuP9J9OCi/1Fyy
	 CIWykiYX9/Xctl1DeLYqwzrUbbVfd3Ke915qlwhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0457/1005] fbcon: Fix KASAN slab-out-of-bounds Read in fbcon_prepare_logo
Date: Wed,  4 Nov 2026 16:03:10 -0500
Message-ID: <20261104211056.840049845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 532522c2aed05..903823c9ce567 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -600,6 +600,13 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
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



