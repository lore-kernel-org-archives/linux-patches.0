Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C965D6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B7AC433EF;
	Mon, 16 Jan 2023 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888987;
	bh=HLo7MG3Ktut3qX2NhsnLxeVq2ENHynRJhwAX68w5pvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FvGToHrOvNR+gfcVzdm81daoKXYIvGC2AaaY+KYw2GKvhg99OvkE/tLeEfy8Udxb
	 An6yeRcl2U9ebFyKUgutTk8R4hrwvL/2lkl3C6AGECnLu7tDEJpkFTrzTUr5d4oRMg
	 cRKuWHpoxJtOgYg5WCJKLgtUFWffCJkhI24x7u60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 185/338] fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()
Date: Mon, 16 Jan 2023 16:50:58 +0100
Message-Id: <20230116154828.999119137@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index c592ca513115..ee86c62e3672 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1754,6 +1754,7 @@ static int uvesafb_probe(struct platform_device *dev)
 out_unmap:
 	iounmap(info->screen_base);
 out_mem:
+	arch_phys_wc_del(par->mtrr_handle);
 	release_mem_region(info->fix.smem_start, info->fix.smem_len);
 out_reg:
 	release_region(0x3c0, 32);
-- 
2.35.1



