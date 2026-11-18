Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043619;
	b=tkQHXxOg+96p6334k6uMsQGuFlj/AroHf+be3LlprsRbzJhpYyUK1QDzwFX1HCQgAmzU
	 n98YgGvG1G29uofp363KdkpWTwz3khZ5tJZr3LctvnQI2oCN/DPbY+lLrzNtqTe/2iL5e
	 uqPawQfKoU8rHHdalDe86KFFdarCH+7jphGyhrwx3rIryowrxjhaN+b4cW0yTqG7YY5ir
	 GLXOm4E5Iet7T5Jt5VDVBDUJQ5rG5txWGVp52TNVEEpxKqO88K8al7rAY/psTcfi4Iclr
	 8KnP9rwvzOib/3kNv8pTP2Cjly2UL0v08Gt8lC69Qm7XTKxpAaUUapaY2zl+5KsghpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+4m95MkH+khfilO0EaWbN7GlawVs5uHzEb58Luoe1EM=;
	b=ffv6lyWZZ1SzWc2SO/ZpoOMeyeUfz7PMZDsFUXdR35wsizcJgujbb7MPxNa0rJSKf15Z
	 ITFwWoHMA2BVdWiJKHsowi2VcpQeWV9JxYrlmc+/RuLmTk0szEsyViDHsxPHOGlbYU1oh
	 hJ/C9gg4YVUKUpV8qusIhNMkCbqFQbyNk5e8+UqeRqyp2vtrw0KGZ9If2j14jbifcjG+j
	 CujB1gqgM/vBuhJYN71+9kr6S3S3kRtHI/XmKut30VN3nltQIdRTmQYzhLXNaEn+Vb1+o
	 9YrDTPlG9f8xW2vRgz3MsGmSO+hOFalAHWjgVI5432PJmNlYJtqwqfQwdQ5UZzvz3Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSh6ww6h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F76260A2601;
	Wed, 18 Nov 2026 23:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSh6ww6h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728A41F000C7;
	Wed, 18 Nov 2026 23:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043619;
	bh=+4m95MkH+khfilO0EaWbN7GlawVs5uHzEb58Luoe1EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSh6ww6h7ThfUqp7ACk41HxQVvTyTCKbfrqhniOu1toXCjswGMy3VgGXEQqHoXLpA
	 sfh5OSk5OtfPjsHwXIKbuQj7wucuv1/shvDDZq2vDCIQj/eQGbMbbdt5WO1siIUEkJ
	 q8u9lLzQ31ekFj+6M/8dowG7A/UECOK9RhNpFM0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0273/2857] fbcon: Fix KASAN slab-out-of-bounds Read in fbcon_prepare_logo
Date: Wed, 18 Nov 2026 15:21:47 +0100
Message-ID: <20261118150211.259077661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a0a9b0b933184..d6a728e0690d2 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -575,6 +575,13 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
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



