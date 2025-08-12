Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBBA2FE564;
	Tue, 12 Aug 2025 17:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021572; cv=none; b=f+CTcibDqIYyUbRYV0dWMMoax2ZSVsODfjwiAArHUO0LTmqmvHMVnjEErJy56AVkv/Ahh1f30C6whqK24w42rfxiwfTqNgnZLWn6uN81B2irHsTlc6ed12uLSIjrNAQF+uTofuU9ZsFMUEd73EtFjCif9DfEhPJUx7iad3hxQ58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021572; c=relaxed/simple;
	bh=uKtymRXumZS32ukWrzLH5zzyPsbIMkiQrdnupBfi+2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qahaSu5rnYh0pZmJnFzHHkMEIfAymbpvIBxH1wJcaqsXSIoznTP1YCi9rhxXwUjvM3nczzODzcgZPkieupKI07ftVd1grXujuvsIXvpwdrW9Wtg4BcT7z1pb2dKnKRDktCmWWULqBLTMZrs7bON/ir+0z2EDpH6OD/rLSBPIiwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGiHWL1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGiHWL1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3EFC4CEF1;
	Tue, 12 Aug 2025 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021572;
	bh=uKtymRXumZS32ukWrzLH5zzyPsbIMkiQrdnupBfi+2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGiHWL1h0Ingk74pbliniiICFjiovYCebgy7UxtGSq/awi+EeDZTE7Gx9beGfWUXN
	 aK9xrGezeSeUdTQ+Lyax1IGwSt2mC9rTSU2MhLINWrUWgOaoo7TDK9RFoqsZLgt/Hu
	 Ps8I9RioLlFzd9rsF6rOE1sHCKH2FYVmtEjSz7cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/262] fbdev: imxfb: Check fb_add_videomode to prevent null-ptr-deref
Date: Tue, 12 Aug 2025 19:29:02 +0200
Message-ID: <20250812172959.659768444@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit da11e6a30e0bb8e911288bdc443b3dc8f6a7cac7 ]

fb_add_videomode() can fail with -ENOMEM when its internal kmalloc() cannot
allocate a struct fb_modelist.  If that happens, the modelist stays empty but
the driver continues to register.  Add a check for its return value to prevent
poteintial null-ptr-deref, which is similar to the commit 17186f1f90d3 ("fbdev:
Fix do_register_framebuffer to prevent null-ptr-deref in fb_videomode_to_var").

Fixes: 1b6c79361ba5 ("video: imxfb: Add DT support")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imxfb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/imxfb.c b/drivers/video/fbdev/imxfb.c
index 7042a43b81d8..5f9e98423d65 100644
--- a/drivers/video/fbdev/imxfb.c
+++ b/drivers/video/fbdev/imxfb.c
@@ -1004,8 +1004,13 @@ static int imxfb_probe(struct platform_device *pdev)
 	info->fix.smem_start = fbi->map_dma;
 
 	INIT_LIST_HEAD(&info->modelist);
-	for (i = 0; i < fbi->num_modes; i++)
-		fb_add_videomode(&fbi->mode[i].mode, &info->modelist);
+	for (i = 0; i < fbi->num_modes; i++) {
+		ret = fb_add_videomode(&fbi->mode[i].mode, &info->modelist);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to add videomode\n");
+			goto failed_cmap;
+		}
+	}
 
 	/*
 	 * This makes sure that our colour bitfield
-- 
2.39.5



