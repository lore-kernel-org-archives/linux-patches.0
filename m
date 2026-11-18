Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051508;
	b=XoDBocqnH4zP6VtlfWIN66UppOHd/tW4Gi0qNFDmRFipkx/aluRj393qASZ/0HomAETf
	 g/Jzw9x6ghFcRg+HlX1hePSwe9IuPhjJZyIW1mfD1i5psXkTB+lwWejuVKHHn2MkqboEW
	 zMjec6Kpy21ngufCmhGukzrrADWnvCrVS4eLieELZFW0WWqVmv5pHohcb2+H89LS6wjHl
	 SI21MR5H975D7TK5RUuxEBi29O1EO9yPDlQyN5ErRyrmDcpOY8eCTGKLr6bpsaoYg+Kbq
	 f1NvMQdtPZ56l2vzpBPRAWsiuKbKApeiZnwxyMnfiY4qbM7kPltX4BRjmdSAh4X+JUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7JLAO7zZY2L2AhmteteNwH+50TICfb3eS1467fIUt9A=;
	b=Ou/606l2RXKLcA4PxaCG16fZbV9aeMYgAV4bR5gWqdvRNORvJ0Gcah3jDRpyMtpFNAmS
	 +EtbBKMFyQACqB/1W7C6WS0m+hE1Fgq5Tjx2OPLEcJsxezgR+zV/QDZT6QedDj9DcKo6S
	 k+HC8wT0JzAcJd5k9BuvKcDbBoY0SQHHzJQq585ga8daM8YaVl/MlVa9+XoCtAh/O3qsE
	 Yx5luacCVt2rvJa8AZAV1/LaO0KMGPaigkl0zRh+AeJWwWNjmmkuPYcWHfoZmSv5ob+/K
	 +GNlyYQHEcbAptZAuATFkLYaILj1/mEhGWbxsOO36kR6uogD4I2ILWKaiZxE7HgCPZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJYqUIy8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892E1606A320;
	Thu, 19 Nov 2026 01:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJYqUIy8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AA61F000C5;
	Thu, 19 Nov 2026 01:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051508;
	bh=7JLAO7zZY2L2AhmteteNwH+50TICfb3eS1467fIUt9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJYqUIy8ZqMSPtr97HPbtcPFhrCLQCrhLC6MynvePfVnigY9DsghLXz8b22ljoHgh
	 h76tUf5gzFUGMYuAVe2tnfWVm1uu3xUwLvUkI8jeJYnkHrfU6P7QNVxeh+xDsenqkK
	 6dAi73qQroLpBLf7hdfHew0zdWgiTC08vPxo6S5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0233/2214] fbcon: Fix KASAN slab-out-of-bounds Read in fbcon_prepare_logo
Date: Wed, 18 Nov 2026 15:31:49 +0100
Message-ID: <20261118150019.541229826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1566275fd98cd..efefa73451a0b 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -565,6 +565,13 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
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



