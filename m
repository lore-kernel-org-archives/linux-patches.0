Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB721C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8668C433D2;
	Wed, 28 Dec 2022 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244914;
	bh=BZjUdV8g9ITNbOjMeEjDQ2DiJce3cLs90Dh2tVEvlU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoTMsrLCnFvKm+2OqqUWqOfRIyHra5coCxxOE+s43q0I0v5zF3U5ge+R7hgZ80XJQ
	 cmzswX2EM/DV8C3sv9zOl/IaTmuRR8eDxbrfX95Vj0/jFhoqkRBXIXkoS+1m3CHdv8
	 zlm+ndTFZixc9NmSFUM44sR3D7HtkcC8rWa5/1RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0761/1146] fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()
Date: Wed, 28 Dec 2022 15:38:20 +0100
Message-Id: <20221228144350.815083349@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a94371040712031ba129c7e9d8ff04a06a2f8207 ]

If an error occurs after a successful uvesafb_init_mtrr() call, it must be
undone by a corresponding arch_phys_wc_del() call, as already done in the
remove function.

This has been added in the remove function in commit 63e28a7a5ffc
("uvesafb: Clean up MTRR code")

Fixes: 8bdb3a2d7df4 ("uvesafb: the driver core")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/uvesafb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index 00d789b6c0fa..0e3cabbec4b4 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1758,6 +1758,7 @@ static int uvesafb_probe(struct platform_device *dev)
 out_unmap:
 	iounmap(info->screen_base);
 out_mem:
+	arch_phys_wc_del(par->mtrr_handle);
 	release_mem_region(info->fix.smem_start, info->fix.smem_len);
 out_reg:
 	release_region(0x3c0, 32);
-- 
2.35.1



